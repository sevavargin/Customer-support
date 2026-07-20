import re
from pathlib import Path

import joblib
import spacy
import streamlit as st

APP_DIR = Path(__file__).resolve().parent
PROJECT_ROOT = APP_DIR.parent
MODELS_DIR = PROJECT_ROOT / "ML" / "models"

VECTORIZER_PATH = MODELS_DIR / "vectorizer.joblib"
MODEL_PATH = MODELS_DIR / "classifier.joblib"

st.set_page_config(
    page_title="Complaint Classifier",
    page_icon="📋",
    layout="centered",
)

CLASS_LABELS = {
    "credit_card": "Кредитная карта",
    "credit_reporting": "Кредитная история / отчёт",
    "debt_collection": "Коллекторская задолженность",
    "mortgages_and_loans": "Ипотека / кредиты",
    "retail_banking": "Розничный банкинг",
}

EXAMPLE_TEXTS = {
    "Долг у коллекторов": (
        "They keep calling me every single day about a debt collector demanding "
        "payment for an account I do not even recognize"
    ),
    "Ошибка в кредитном отчёте": (
        "There is an incorrect late payment on my credit report from Equifax "
        "that I have disputed multiple times without any response"
    ),
    "Проблема с ипотекой": (
        "My mortgage servicer increased my monthly payment without any notice "
        "and refuses to explain the escrow adjustment"
    ),
}


@st.cache_resource
def load_artifacts():
    """Загружаем модель, векторайзер и spaCy-пайплайн один раз и кешируем их."""
    vectorizer = joblib.load(VECTORIZER_PATH)
    model = joblib.load(MODEL_PATH)
    nlp = spacy.load("en_core_web_sm", disable=["parser", "ner"])
    return vectorizer, model, nlp


def remove_mask(text: str) -> str:
    """Убирает xxxx-маскировку персональных данных (та же логика, что в обучении)."""
    text = re.sub(r"x{2,}", " ", text, flags=re.IGNORECASE)
    text = re.sub(r"\s+", " ", text).strip()
    return text


def preprocess(text: str, nlp) -> str:
    """Полный пайплайн предобработки, идентичен тому, что применялся к train-данным."""
    text_clean = remove_mask(text.lower())
    doc = nlp(text_clean)
    return " ".join(token.lemma_ for token in doc)


def main():
    vectorizer, model, nlp = load_artifacts()

    if "complaint_input" not in st.session_state:
        st.session_state["complaint_input"] = ""

    st.title("Consumer Complaint Classifier")
    st.write(
        "Определяет категорию финансового продукта по тексту жалобы потребителя "
        "— модель обучена на датасете CFPB Consumer Complaints (~124k жалоб, 5 категорий)."
    )

    with st.sidebar:
        st.header("Примеры")
        st.caption("Нажми, чтобы подставить готовый пример в поле ввода")
        for label, example in EXAMPLE_TEXTS.items():
            if st.button(label, use_container_width=True):
                st.session_state["complaint_input"] = example

        st.divider()
        st.caption(
            "**Модель:** TF-IDF (5000 признаков) + Logistic Regression  \n"
            "**Accuracy:** ≈ 0.85  \n"
            "**Macro F1:** ≈ 0.84"
        )

    text = st.text_area(
        "Текст жалобы (на английском):",
        height=150,
        placeholder=(
            "Например: I have been trying to reach my loan servicer for weeks "
            "about an incorrect balance on my account..."
        ),
        key="complaint_input",
    )

    predict_clicked = st.button("Определить категорию", type="primary")

    if predict_clicked:
        if not text.strip():
            st.warning("Сначала введи текст жалобы.")
        else:
            with st.spinner("Анализируем текст..."):
                processed = preprocess(text, nlp)
                text_vec = vectorizer.transform([processed])
                prediction = model.predict(text_vec)[0]
                proba = model.predict_proba(text_vec)[0]

            st.success(f"**Категория:** {CLASS_LABELS.get(prediction, prediction)}")

            st.subheader("Вероятности по классам")
            proba_sorted = sorted(zip(model.classes_, proba), key=lambda x: -x[1])
            for cls, p in proba_sorted:
                st.write(CLASS_LABELS.get(cls, cls))
                st.progress(float(p), text=f"{p:.1%}")

            if prediction in ("debt_collection", "credit_reporting"):
                top1, top2 = proba_sorted[0][1], proba_sorted[1][1]
                if top1 - top2 < 0.3:
                    st.info(
                        "Эта жалоба попадает в зону, где модель чаще всего "
                        "путает **debt_collection** и **credit_reporting** — эти "
                        "категории объективно пересекаются по содержанию "
                        "(коллекторские долги почти всегда упоминаются в "
                        "кредитном отчёте, и наоборот)."
                    )

            with st.expander("Показать текст после предобработки"):
                st.code(processed, language=None)

    st.divider()
    st.caption(
        "Демо-модель обучена на англоязычном датасете CFPB — качество на "
        "текстах, сильно отличающихся по стилю от исходных жалоб, не гарантируется."
    )


if __name__ == "__main__":
    main()