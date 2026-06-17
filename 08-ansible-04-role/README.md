# Задание 1 – Создание файла `requirements.yml`

Для использования готовой роли ClickHouse в новом playbook был создан файл `requirements.yml`.  
Он описывает внешнюю зависимость — роль `clickhouse` из репозитория [AlexeySetevoi/ansible-clickhouse](https://github.com/AlexeySetevoi/ansible-clickhouse) версии `1.13`.

## Содержимое `requirements.yml`

```yaml
---
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.13"
  name: clickhouse
```

**Содержимое `requirements.yml`**

<img width="905" height="110" alt="image" src="https://github.com/user-attachments/assets/a2b73d4f-2c53-496e-9f02-f5847eec5fb9" />

# Задание 2 – Загрузка роли ClickHouse через `ansible-galaxy`

Роль ClickHouse, указанная в `requirements.yml`, скачана командой:

```bash
ansible-galaxy install -r requirements.yml -p roles/
```

**Загрузка роли ClickHouse**

<img width="1833" height="170" alt="image" src="https://github.com/user-attachments/assets/eb590769-9d6f-4619-b873-337b85fb1268" />

# Задание 3 – Создание роли `vector-role` с помощью `ansible-galaxy init`

Для автоматизации развёртывания Vector создана новая роль `vector-role`.  
Использована команда `ansible-galaxy role init`, которая генерирует стандартную структуру роли.

```bash
ansible-galaxy role init vector-role --init-path roles/
```

**Создание роли `vector-role`**

<img width="1833" height="130" alt="image" src="https://github.com/user-attachments/assets/77865e92-88dc-4a64-b0d5-8ecee6888819" />

# Задание 4 – Наполнение роли `vector-role`

Роль `vector-role` создана на основе задач из старого playbook.  
Задачи перенесены в `tasks/main.yml`, обработчики – в `handlers/main.yml`,  
шаблон конфигурации – в `templates/vector.toml.j2`.  

Переменные разделены:
- `defaults/main.yml` – переменные с низким приоритетом (можно переопределить):  
  `vector_version: "0.42.0"`, `vector_config_dir: "/etc/vector"`.
- `vars/main.yml` – переменные с высоким приоритетом:  
  `vector_binary_path: "/usr/local/bin/vector"`.

**Структура роли `vector-role`**

<img width="1406" height="382" alt="image" src="https://github.com/user-attachments/assets/3803b176-5348-40e7-89c8-4a425429bd48" />

# Задание 5 – Перенос шаблонов конфигов в `templates`

В роли `vector-role` создан шаблон конфигурации Vector — `templates/vector.toml.j2`.  
Он определяет источник логов (файл ClickHouse) и вывод в консоль.

```toml
[sources.logs]
type = "file"
include = ["/var/log/clickhouse-server/clickhouse-server.log"]
read_from = "beginning"

[sinks.console]
type = "console"
inputs = ["logs"]
encoding.codec = "text"
```

**Содержимое `templates/vector.toml.j2`**

<img width="1840" height="201" alt="image" src="https://github.com/user-attachments/assets/55e1f479-ccde-4a10-ac85-29d6f2db76e7" />

# Задание 6 – Описание ролей и их параметров

Ниже представлены описания ролей, созданных для развёртывания Vector и LightHouse.

## Роль `vector-role`

Устанавливает [Vector](https://vector.dev/) — инструмент для сбора, преобразования и маршрутизации логов.

### Параметры

| Переменная          | По умолчанию            | Описание                                      |
|---------------------|-------------------------|-----------------------------------------------|
| `vector_version`    | `0.42.0`                | Версия Vector для загрузки                    |
| `vector_config_dir` | `/etc/vector`           | Каталог конфигурации                          |
| `vector_binary_path`| `/usr/local/bin/vector` | Путь установки исполняемого файла             |

- `vector_version` и `vector_config_dir` находятся в `defaults/main.yml` (низкий приоритет, переопределяемы).
- `vector_binary_path` задан в `vars/main.yml` (высокий приоритет).

## Роль `lighthouse-role`

Разворачивает веб-интерфейс [LightHouse](https://github.com/VKCOM/lighthouse) для ClickHouse с помощью Nginx.

### Параметры

| Переменная        | По умолчанию            | Описание                                          |
|-------------------|-------------------------|---------------------------------------------------|
| `lighthouse_port` | `8686`                  | Порт, на котором Nginx слушает LightHouse         |
| `lighthouse_root` | `/var/www/lighthouse`   | Корневая директория статики LightHouse            |

Обе переменные находятся в `defaults/main.yml` и могут быть переопределены.

