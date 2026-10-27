## 1. Установка и настройка клиента

import os
import json
import time
from dotenv import load_dotenv
from openai import OpenAI  # Изменено: теперь используем библиотеку openai

load_dotenv()

api_key = os.getenv('GROQ_API_KEY')

# Изменено: создаем клиент для OpenRouter через библиотеку OpenAI
client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=api_key
)

print(f'Ключ загружен: {api_key[:7] if api_key else "Не найден"}...') 

## 2. Проблема: LLM возвращает неструктурированный текст

import json

resume_text = """
Привет! Меня зовут Анна Соколова, мне 28 лет. Последние 4 года работаю
бэкенд-разработчиком в финтех-компании. Основной стек: Python, FastAPI,
PostgreSQL, Redis. Есть опыт с Docker и Kubernetes. Закончила МГТУ им. Баумана
по специальности «Прикладная математика». Ищу позицию Senior Python Developer
с зарплатой от 300 000 рублей. Готова к удалённой работе или гибриду.
"""

# Обычный запрос без требования структуры
response = client.chat.completions.create(
    model='openrouter/free', # <--- ИЗМЕНЕНО: используем модель OpenRouter
    messages=[
        {'role': 'user', 'content': f'Извлеки основную информацию из резюме:\n{resume_text}'}
    ]
)

raw_output = response.choices[0].message.content
print('Вывод модели:')
print(raw_output)
print()

# Попытка использовать вывод в коде — неудача
print('Попытка получить зарплату из ответа:')
try:
    data = json.loads(raw_output)
    print(data['salary'])
except Exception as e:
    print(f'Ошибка: {e}')
    print('Неструктурированный текст нельзя напрямую использовать в коде!')

## 3. Решение: JSON-режим

system_prompt = """
Ты — HR-ассистент. Извлекай данные из резюме и возвращай строго в формате JSON.
Схема ответа:
{
  "name": string,
  "age": number или null,
  "experience_years": number,
  "current_position": string,
  "skills": [string],
  "education": string или null,
  "target_position": string,
  "salary_from": number или null,
  "work_format": string
}
"""

response = client.chat.completions.create(
    model='openrouter/free', # <--- ИЗМЕНЕНО: используем роутер OpenRouter
    messages=[
        {'role': 'system', 'content': system_prompt},
        {'role': 'user', 'content': f'Обработай резюме:\n{resume_text}'}
    ],
    response_format={'type': 'json_object'}
)

candidate = json.loads(response.choices[0].message.content)

print('Структурированный профиль кандидата:')
print(json.dumps(candidate, ensure_ascii=False, indent=2))
print()

# Теперь данные легко использовать в коде
print(f"Имя: {candidate['name']}")
print(f"Опыт: {candidate['experience_years']} лет")
print(f"Навыки: {', '.join(candidate['skills'])}")
print(f"Ожидаемая зарплата: {candidate['salary_from']:,} руб.".replace(',', ' '))

## 4. Пайплайн: обработка нескольких резюме

import json
import time
from openai import RateLimitError

def parse_resume(text: str, max_retries: int = 3) -> dict | None:
    """Извлекает структурированные данные из текста резюме с повторными попытками."""
    system_prompt = """
    Ты — HR-ассистент. Извлекай данные из резюме и возвращай строго в формате JSON.
    Схема: {"name": string, "experience_years": number, "skills": [string],
    "target_position": string, "salary_from": number или null, "work_format": string}
    """
    
    # Используем роутер OpenRouter, который сам выберет доступную бесплатную модель с JSON-режимом
    model_name = 'openrouter/free'
    
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model=model_name,
                messages=[
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': f'Обработай резюме:\n{text}'}
                ],
                response_format={'type': 'json_object'}
            )
            
            content = response.choices[0].message.content
            
            # Если ответ пустой — выбрасываем ошибку, чтобы сработал ретрай
            if not content:
                raise ValueError("Модель вернула пустой ответ")
                
            return json.loads(content)
            
        except RateLimitError:
            print(f'  [Лимит запросов] Ждём 10 сек...')
            time.sleep(10)
        except Exception as e:
            # Если это последняя попытка, выводим ошибку
            if attempt == max_retries - 1:
                print(f'  [Ошибка после {max_retries} попыток]: {e}')
                return None
            else:
                print(f'  [Сбой: {e}] Пробую еще раз (попытка {attempt + 2}/{max_retries})...')
                time.sleep(2) # Пауза перед повтором
    
    return None

# Список из 7 резюме
resumes = [
    """
    Иван Петров, 32 года. 7 лет в разработке игр на Unity и C#.
    Делал мобильные игры для iOS/Android, есть опыт с Blender.
    Ищу Lead Game Developer, готов к офису в Москве. Зарплата от 250 000.
    """,
    """
    Мария Иванова. Data Scientist с опытом 3 года.
    Стек: Python, pandas, scikit-learn, PyTorch, SQL.
    Работала в e-commerce над рекомендательными системами.
    Хочу ML Engineer, только удалёнка, зарплата не принципиальна.
    """,
    """
    Дмитрий Козлов, 25 лет, junior frontend. Знаю React, TypeScript, CSS.
    Полгода коммерческого опыта в веб-студии. Ищу работу в продуктовой компании.
    Рассматриваю от 120 000, гибрид или удалёнка.
    """,
    """
    Екатерина Смирнова, 29 лет. DevOps-инженер, 5 лет опыта.
    Умею: Kubernetes, Docker, Terraform, AWS, CI/CD (GitLab, GitHub Actions).
    Работала в банковском секторе, есть опыт с highload-системами.
    Ищу Senior DevOps, удалёнка обязательно. Зарплата от 300 000.
    """,
    """
    Алексей Новиков, 35 лет. Fullstack-разработчик, 10 лет опыта.
    Стек: Python (Django, FastAPI), Vue.js, PostgreSQL, Redis, Docker.
    Последние 3 года — тимлид команды из 6 человек в SaaS-компании.
    Рассматриваю роль Engineering Manager или Staff Engineer. От 400 000, гибрид.
    """,
    """
    Юлия Белова. QA Engineer, 4 года в тестировании.
    Автотесты на Python (pytest, Selenium, Playwright), API-тестирование (Postman, requests).
    Опыт в agile-командах, знакома с нагрузочным тестированием (Locust).
    Ищу Middle/Senior QA, гибрид, зарплата от 180 000.
    """,
    """
    Сергей Орлов, 27 лет. Android-разработчик, 3 года опыта.
    Kotlin, Jetpack Compose, Room, Retrofit, Coroutines. Публиковал 2 приложения в Google Play.
    Немного знаю iOS (Swift). Ищу Middle Android Developer в продуктовую компанию.
    Только удалёнка. Зарплата от 210 000.
    """
]

results = []
for i, resume in enumerate(resumes, 1):
    print(f'Обрабатываю резюме {i}/{len(resumes)}...')
    parsed = parse_resume(resume)
    if parsed:
        results.append(parsed)
    time.sleep(1) # Небольшая пауза между резюме, чтобы не злить лимиты

print(f'\nОбработано: {len(results)} из {len(resumes)} резюме')
print()

# Красивый вывод результатов
for r in results:
    salary = f"{r['salary_from']:,}".replace(',', ' ') + ' руб.' if r.get('salary_from') else 'не указана'
    print(f"• {r['name']} | {r['target_position']} | опыт {r['experience_years']} л. | зарплата: {salary}")

## 5. Фильтрация и анализ собранных данных

# Внимание: переменная results должна быть в памяти из Задания 4!

# Задание 1: удалёнщики с опытом 4+ лет
# Используем метод .lower() и срез 'удал', чтобы отловить и "удалёнка", и "удаленная"
remote_seniors = [
    r for r in results 
    if 'удал' in str(r.get('work_format', '')).lower() and r['experience_years'] >= 4
]

print("=== 1. Удалёнщики-синьоры (опыт 4+ лет) ===")
for r in remote_seniors:
    print(f"  → {r['name']} | {r['target_position']} | Формат: {r['work_format']}")
if not remote_seniors:
    print("  Не найдено.")

print("\n" + "="*40 + "\n")

# Задание 2: зарплатные ожидания <= 230 000 (или не указаны)
budget_hires = [
    r for r in results 
    if r['salary_from'] is None or r['salary_from'] <= 230_000
]

print("=== 2. Бюджетный найм (до 230 000 руб. или не указана) ===")
for r in budget_hires:
    salary = f"{r['salary_from']:,}".replace(',', ' ') + ' руб.' if r['salary_from'] else 'не указана'
    print(f"  → {r['name']} | Зарплата: {salary}")

print("\n" + "="*40 + "\n")

# Задание 3: кандидаты с Python в навыках
python_devs = [
    r for r in results 
    if 'Python' in r['skills']
]

print("=== 3. Python-разработчики ===")
for r in python_devs:
    print(f"  → {r['name']} | Навыки: {', '.join(r['skills'])}")

print("\n" + "="*40 + "\n")

# Задание 4: топ-3 по опыту
top_3_experience = sorted(results, key=lambda r: r['experience_years'], reverse=True)[:3]

print("=== 4. Топ-3 по опыту ===")
for i, r in enumerate(top_3_experience, 1):
    print(f"  {i}. {r['name']} | Опыт: {r['experience_years']} лет")

print("\n" + "="*40 + "\n")

# Задание 5: статистика зарплат
# Собираем зарплаты только тех, у кого они указаны
salaries = [r['salary_from'] for r in results if r['salary_from'] is not None]

print("=== 5. Статистика зарплат ===")
if salaries:
    avg_salary = sum(salaries) / len(salaries)
    min_salary = min(salaries)
    max_salary = max(salaries)
    
    print(f"  Кандидатов с указанной зарплатой: {len(salaries)}")
    print(f"  Средняя зарплата: {avg_salary:,.0f} руб.".replace(',', ' '))
    print(f"  Минимальная: {min_salary:,} руб.".replace(',', ' '))
    print(f"  Максимальная: {max_salary:,} руб.".replace(',', ' '))
else:
    print("  Нет данных о зарплатах.")

## 6. Сравнение моделей

import time
import json
from openai import RateLimitError

# Резюме для теста
test_resume = """
Андрей Захаров, 31 год. Backend-разработчик, 6 лет опыта.
Основной стек: Go, Python, gRPC, Kafka, PostgreSQL, Kubernetes.
Строил высоконагруженные сервисы в финтех и логистике.
Ищу Senior/Lead Backend Engineer. Удалёнка, зарплата от 380 000.
"""

system_prompt = """
Ты — HR-ассистент. Извлекай данные из резюме и возвращай строго в формате JSON.
Схема: {"name": string, "experience_years": number, "skills": [string],
"target_position": string, "salary_from": number или null, "work_format": string}
"""

models_to_compare = [
    'cohere/north-mini-code:free',
    'dots-studio/dots-3-note-preview:free',
    'nvidia/nemotron-3-ultra-550b-a55b:free',
    'poolside/laguna-s-2.1:free',
    'openrouter/free',
]

def query_model(model_name, max_retries=2):
    for attempt in range(max_retries):
        try:
            start = time.time()
            response = client.chat.completions.create(
                model=model_name,
                messages=[
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': f'Обработай резюме:\n{test_resume}'}
                ],
                response_format={'type': 'json_object'}
            )
            elapsed = time.time() - start
            content = response.choices[0].message.content
            if not content:
                raise ValueError("Пустой ответ")
            
            parsed = json.loads(content)
            if not isinstance(parsed, dict):
                raise ValueError(f"Ожидался dict, получен {type(parsed)}")
            
            return elapsed, response.usage, parsed, response.model
        except RateLimitError as e:
            if attempt == max_retries - 1:
                print(f'❌ ОШИБКА {model_name}: Исчерпан лимит запросов (429)')
                return None
            print(f'  [{model_name}] Лимит запросов, ждём 5 сек...')
            time.sleep(5)
        except Exception as e:
            if attempt == max_retries - 1:
                print(f'❌ ОШИБКА {model_name}: {e}')
                return None
            print(f'  [{model_name}] Сбой: {e}. Повтор...')
            time.sleep(2)
    return None

comparison_results = []

for model_name in models_to_compare:
    print(f'Запрос к {model_name}...')
    result = query_model(model_name)
    
    if result:
        elapsed, usage, parsed, actual_model = result
        comparison_results.append({
            'model': model_name,
            'actual_model': actual_model,
            'time_sec': round(elapsed, 2),
            'total_tokens': usage.total_tokens,
            'tokens_per_sec': round(usage.completion_tokens / elapsed) if elapsed > 0 else 0,
            'skills_found': len(parsed.get('skills', [])),
        })
        print(f'✅ OK {model_name} -> {actual_model}: {elapsed:.2f} с, {usage.total_tokens} токенов')
    time.sleep(2) # Пауза между разными моделями

print("\n" + "="*80)
header = f"{'Запрошенная модель':<40} {'Фактическая модель':<40} {'Время':>8} {'Ток/с':>8} {'Навыков':>9}"
print(header)
print('-' * 140)
for r in comparison_results:
    row = f"{r['model']:<40} {r['actual_model']:<40} {r['time_sec']:>7.2f}с {r['tokens_per_sec']:>8} {r['skills_found']:>9}"
    print(row)

## Самостоятельное задание: парсер вакансий

import time
import json
from openai import RateLimitError

def parse_vacancy(text: str, max_retries: int = 3) -> dict | None:
    system_prompt = """
    Ты — HR-ассистент. Извлекай данные из вакансии и возвращай строго в формате JSON.
    Схема ответа:
    {
      "position": "название должности",
      "company": "название компании или null",
      "required_skills": ["список обязательных навыков"],
      "nice_to_have": ["список желательных навыков"],
      "experience_required": "например '3-5 лет' или null",
      "salary_to": число (верхняя граница зарплаты) или null,
      "work_format": "офис / удалёнка / гибрид / офис / удалёнка"
    }
    
    ВАЖНО для work_format: 
    Если в тексте написано "офис ИЛИ удалёнка", возвращай строго "офис / удалёнка". 
    Не пиши "гибрид", если этого слова нет в тексте!
    """
    
    # Используем модель, которая хорошо себя показала
    model_name = 'cohere/north-mini-code:free' 
    
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model=model_name,
                messages=[
                    {'role': 'system', 'content': system_prompt},
                    {'role': 'user', 'content': f'Обработай вакансию:\n{text}'}
                ],
                response_format={'type': 'json_object'}
            )
            
            content = response.choices[0].message.content
            if not content:
                raise ValueError("Пустой ответ")
                
            parsed = json.loads(content)
            if not isinstance(parsed, dict):
                raise ValueError("Ожидался dict")
                
            return parsed
            
        except RateLimitError:
            print(f'  [Лимит 429] Ждём 5 сек...')
            time.sleep(5)
        except Exception as e:
            print(f'  [Сбой: {e}] Попытка {attempt+1}/{max_retries}...')
            time.sleep(2)
    return None

vacancy_1 = """
Компания TechFlow ищет Senior Python Developer.
Обязательно: Python 5+ лет, FastAPI или Django, PostgreSQL, Docker.
Желательно: Kubernetes, опыт с микросервисами, Redis.
Условия: гибрид (Москва), зарплата до 400 000 рублей, ДМС.
"""

vacancy_2 = """
Ищем Middle Data Scientist в e-commerce стартап.
Требования: Python, pandas, scikit-learn, опыт построения ML-моделей от 2 лет.
Плюсом будет: PyTorch, опыт с рекомендательными системами, A/B-тесты.
Полная удалёнка, зарплата до 220 000. Команда 5 человек.
"""

vacancy_3 = """
Frontend Developer (React) — продуктовая компания в сфере EdTech.
Must have: React, TypeScript, REST API, опыт от 1 года.
Nice to have: Next.js, тестирование (Jest), Storybook.
Офис в СПб или удалёнка, вилка 150 000 – 200 000.
"""

# Компактный тест без огромных JSON-дампов
for i, vacancy in enumerate([vacancy_1, vacancy_2, vacancy_3], 1):
    print('=' * 50)
    print(f'ВАКАНСИЯ {i}')
    result = parse_vacancy(vacancy)
    
    if result:
        # Выводим только самое главное, чтобы не было обрезания
        print(f"Должность: {result.get('position')}")
        print(f"Компания:  {result.get('company')}")
        print(f"Зарплата:  {result.get('salary_to')}")
        print(f"Формат:    {result.get('work_format')}") # <--- Проверяем именно это поле
        print(f"Обязательные: {result.get('required_skills')}")
    else:
        print("❌ НЕ УДАЛОСЬ РАСПАРСИТЬ ВАКАНСИЮ")
    print()
    time.sleep(1)


# Бонус: подбор кандидатов под вакансию
def match_candidates(vacancy: dict, candidates: list) -> list:
    """
    Подбирает кандидатов из списка по совпадению навыков.
    """
    if not vacancy or 'required_skills' not in vacancy:
        return []
        
    req_skills = set(vacancy['required_skills'])
    matched_candidates = []
    
    for candidate in candidates:
        # Приводим навыки к нижнему регистру для надежного сравнения
        cand_skills = set(skill.lower() for skill in candidate.get('skills', []))
        req_skills_lower = set(skill.lower() for skill in req_skills)
        
        # Ищем пересечение (совпавшие навыки)
        matched = cand_skills.intersection(req_skills_lower)
        
        if len(matched) >= 2:
            # Создаем копию кандидата и добавляем совпавшие навыки
            cand_copy = candidate.copy()
            cand_copy['matched_skills'] = list(matched)
            matched_candidates.append(cand_copy)
            
    return matched_candidates


print('=' * 55)
print('БОНУС: Подбор кандидатов под вакансию 1 (TechFlow)')
print('=' * 55)

# Внимание: переменная results должна быть в памяти из Задания 4!

try:
    parsed_vacancy_1 = parse_vacancy(vacancy_1)
    if parsed_vacancy_1:
        best_candidates = match_candidates(parsed_vacancy_1, results)
        
        print(f"Требуемые навыки: {', '.join(parsed_vacancy_1['required_skills'])}")
        print(f"Найдено подходящих кандидатов: {len(best_candidates)}\n")
        
        for c in best_candidates:
            print(f"• {c['name']} (опыт {c['experience_years']} лет)")
            print(f"  Совпавшие навыки: {', '.join(c['matched_skills'])}")
except NameError:
    print("⚠️ Список 'results' не найден в памяти. Запусти ячейку из Задания 4.")