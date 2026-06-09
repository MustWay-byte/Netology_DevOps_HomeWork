## Обзор playbook

Данный playbook автоматизирует развёртывание двух сервисов на хостах Rocky Linux:

- **ClickHouse** – столбцовая СУБД для аналитических запросов.
- **Vector** – легковесный сборщик и трансформатор логов, настраиваемый через шаблон Jinja2.

Playbook идемпотентен: повторные запуски не вносят изменений, если целевое состояние уже достигнуто.  
Все операции выполняются от имени привилегированного пользователя (`become: yes`).

## Параметры (Variables)

Основные параметры заданы в `group_vars/clickhouse/vars.yml` и могут быть переопределены в инвентаре или командной строке.

| Параметр         | Значение по умолчанию | Описание                                                                 |
|------------------|------------------------|---------------------------------------------------------------------------|
| `vector_version` | `0.42.0`               | Версия Vector, которая будет загружена из официального репозитория       |
| `clickhouse_packages` | `[clickhouse-server, clickhouse-client]` | Список пакетов ClickHouse для установки (на данный момент не используется в dnf, установка происходит по именам)  |

Дополнительные переменные (опционально) можно добавить в шаблон `templates/vector.toml.j2`, например пути к логам, буферы и т.д.

## Теги (Tags)

Playbook не содержит явно заданных тегов, однако вы можете легко добавить их в задачи для избирательного выполнения.  
Например, чтобы выполнить только установку и настройку Vector, достаточно расставить теги:

```yaml
- name: Install Vector binary
  ansible.builtin.shell: ...
  tags: vector

- name: Deploy Vector config
  ansible.builtin.template: ...
  tags: vector

# Задача 1

<img width="1632" height="428" alt="image" src="https://github.com/user-attachments/assets/71769ffe-ff7b-4fcd-9314-4a9988b8b536" />

**Запуск Playbook**

# Задача 2

<img width="1637" height="795" alt="image" src="https://github.com/user-attachments/assets/52e7a86e-d12d-493b-b8ce-f646c7a93c79" />

**Запуск Playbook**

# Задача 3

Модули использованы.

# Задача 4

<img width="1632" height="1000" alt="image" src="https://github.com/user-attachments/assets/9854a753-a518-468a-8043-182adc07c1d6" />

**Запуск Playbook**

# Задача 5

<img width="1105" height="82" alt="image" src="https://github.com/user-attachments/assets/d1a6452d-c930-413a-8895-ee6ea9fc6c17" />

**Запуск Ansible-lint**

# Задача 6

<img width="1411" height="890" alt="image" src="https://github.com/user-attachments/assets/0c4741a1-2b0d-4d68-b74c-476469dc1fd4" />

**Запуск Playbook**

# Задача 7

<img width="1046" height="998" alt="image" src="https://github.com/user-attachments/assets/ac11485f-409c-4f27-9a4d-3a36dfa32186" />

**Запуск Playbook**

# Задача 8

<img width="1399" height="839" alt="image" src="https://github.com/user-attachments/assets/180c7ab0-a04c-4038-a657-091cab196936" />

**Запуск Playbook**

# Задача 9

Сделано.

# Задача 10

Сделано.
