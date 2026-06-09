# Playbook ClickHouse + Vector

Автоматическая установка и настройка [ClickHouse](https://clickhouse.com/) и [Vector](https://vector.dev/) на Rocky Linux.  
Плейбук идемпотентен, проходит `ansible-lint` без ошибок.

## Обзор

Плейбук выполняет два последовательных действия:
- Устанавливает **ClickHouse** (`clickhouse-server`, `clickhouse-client`) из официального репозитория и запускает сервер.
- Устанавливает **Vector** из бинарного архива, разворачивает конфигурацию через Jinja2-шаблон и запускает процесс.

При изменении конфигурации или бинарника Vector срабатывает handler `Restart Vector`, перезапускающий сервис.

## Параметры

| Переменная | По умолчанию | Описание |
|-----------|--------------|----------|
| `vector_version` | `0.42.0` | Версия Vector для загрузки |

Значение можно переопределить в инвентаре или через `--extra-vars`.

## Теги

По умолчанию теги не заданы, но их можно добавить в задачи, например:
```yaml
- name: Install Vector binary
  ansible.builtin.shell: ...
  tags: vector
```
# Задача 1

<img width="1632" height="428" alt="image" src="https://github.com/user-attachments/assets/71769ffe-ff7b-4fcd-9314-4a9988b8b536" />

**Запуск Playbook**

# Задача 2

<img width="1637" height="795" alt="image" src="https://github.com/user-attachments/assets/52e7a86e-d12d-493b-b8ce-f646c7a93c79" />

**Запуск Playbook**

# Задача 3

Использованы модули: yum_repository, dnf, get_url, unarchive, file, template, shell, copy.
Установка ClickHouse производится через dnf и репозиторий, Vector – через загрузку архива, распаковку и копирование бинарника. Конфигурация Vector генерируется из Jinja2-шаблона с помощью template.
Модули использованы.

# Задача 4

<img width="1632" height="1000" alt="image" src="https://github.com/user-attachments/assets/9854a753-a518-468a-8043-182adc07c1d6" />

**Запуск Playbook**

# Задача 5

<img width="1105" height="82" alt="image" src="https://github.com/user-attachments/assets/d1a6452d-c930-413a-8895-ee6ea9fc6c17" />

**Запуск Ansible-lint – пройден без ошибок (0 failure, 0 warning)**

# Задача 6

<img width="1411" height="890" alt="image" src="https://github.com/user-attachments/assets/0c4741a1-2b0d-4d68-b74c-476469dc1fd4" />

**Запуск Playbook с флагом --check – сухая проверка, ошибок нет**

# Задача 7

<img width="1046" height="998" alt="image" src="https://github.com/user-attachments/assets/ac11485f-409c-4f27-9a4d-3a36dfa32186" />

**Запуск Playbook с флагом --diff – отображены изменения в конфигурации Vector**

# Задача 8

<img width="1399" height="839" alt="image" src="https://github.com/user-attachments/assets/180c7ab0-a04c-4038-a657-091cab196936" />

**Запуск Playbook с флагом --diff (повторно) – изменений нет, подтверждена идемпотентность**

# Задача 9

Создан файл README.md, содержащий:

1) общее описание плейбука,

2) перечень параметров (vector_version),

3) инструкцию по добавлению тегов,

4) скриншоты выполнения заданий 5–8,

5) ссылку на финальный тег.

# Задача 10

Финальный коммит помечен тегом 08-ansible-02-playbook и запушен в репозиторий. Тег 08-ansible-02-playbook установлен.
