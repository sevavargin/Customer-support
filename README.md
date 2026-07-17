
Проект по анализу системы поддержки клиентов (Customer Support). Включает работу с синтетическим датасетом тикетов поддержки, SQL-базой данных, EDA, базовыми и продвинутыми запросами, а также ML для классификации обращений.

## Структура проекта
Customer-support/
├── data/
│   ├── raw/                    # Исходные CSV-файлы
│   │   ├── customer_support_tickets.csv
│   │   └── complaints_processed.csv
│   └── processed/              # Обработанные данные и SQLite БД
│       └── customer_support.db
├── sql/                        # SQL-скрипты
│   ├── create_tables.sql
│   ├── basic_queries.sql
│   └── advanced_queries.sql
├── notebooks/                  # Jupyter Notebooks
│   ├── eda.ipynb              # Exploratory Data Analysis
│   ├── support.ipynb          # Загрузка и базовая обработка данных
│   ├── basic_queries.ipynb
│   └── advanced_queries.ipynb
├── ML/
│   └── ML.ipynb               # Машинное обучение (классификация обращений)
├── diagram.bpmn               # BPMN-диаграмма процесса поддержки (бизнес-процесс)
└── README.md
text## Описание данных

- **Основной датасет**: `customer_support_tickets.csv`
  - Информация о клиентах (имя, email, возраст, пол)
  - Продукты и типы тикетов
  - Метрики: приоритет, канал обращения, время первого ответа, время разрешения, удовлетворенность
  - Статусы и описания тикетов

- **Дополнительный датасет**: `complaints_processed.csv` — данные для задач NLP/ML (продукт + narrative).

## Основные возможности

### 1. База данных (SQLite)
- схема: `customers`, `products`, `ticket_types`, `tickets`
- Foreign keys для связей
- Готовые скрипты создания таблиц и наполнения данными

### 2. SQL-аналитика
- **Basic queries** — простые отчёты по каналам, приоритетам, продуктам, удовлетворенности
- **Advanced queries** — сложные аналитические запросы (оконные функции, CTE, агрегация и тд)

### 3. EDA
- Анализ распределений
- Временные метрики (resolution time)
- Взаимосвязи между продуктами, типами тикетов и удовлетворенностью
- Выявление аномалий в синтетических данных

### 4. Machine Learning
- Классификация обращений клиентов по продукту/категории (на основе `complaints_processed.csv`)
- Предобработка текста (очистка, токенизация)
- Обучение моделей (в ноутбуке `ML.ipynb`)
- Оценка качества

## Как запустить проект

1. **Клонируйте репозиторий**
   ```bash
   git clone https://github.com/sevavargin/Customer-support.git
   cd Customer-support

2. **Установите зависимости**
pip install pandas numpy matplotlib seaborn scikit-learn sqlite3 jupyter

3. **Создайте базу данных**
# Запустите notebook support.ipynb или выполните SQL-скрипты

4. **Запустите Juiter**


Цели проекта

Освоить полный цикл анализа данных на Customer Support
Практика SQL (от простых к сложным запросам)
Работа с временными рядами и метриками поддержки (CSAT, FRT, TTR)
NLP/ML для автоматической категоризации обращений
Документирование бизнес-процессов (BPMN)


Технологии

Python: pandas, scikit-learn, matplotlib, seaborn
SQL: SQLite
Jupyter Notebooks
BPMN: диаграмма процессов

