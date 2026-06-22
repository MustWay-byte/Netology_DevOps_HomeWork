# Часть 1 — Основная часть

## Шаг 1. Создание модуля `my_own_module.py`

В каталоге коллекции `my_org.my_collection` создан файл модуля `my_own_module.py`.  

**Создание файла модуля**

<img width="1179" height="61" alt="image" src="https://github.com/user-attachments/assets/751632a4-e1b4-4e56-8b59-82b958da5cbe" />

## Шаг 2. Наполнение модуля содержимым

На этом шаге мы заполняем файл `my_own_module.py`, созданный ранее, реальным кодом модуля. Модуль принимает два параметра:
- `name` (обязательный) — строка, которую нужно обработать.
- `new` (опциональный, по умолчанию `false`) — флаг, при установке в `true` модуль регистрирует изменение.

В ответе возвращается исходное сообщение и сгенерированное сообщение `goodbye`. Поддерживается режим проверки (`check_mode`) и возможность вызова ошибки, если передано значение `fail me`.

**Наполнение кода модуля**

<img width="1834" height="960" alt="image" src="https://github.com/user-attachments/assets/19582e8c-b771-4d58-b02e-b174df539095" />

## Шаг 3. Наполнение модуля логикой создания файла

Заменяем содержимое `my_own_module.py` на модуль, который действительно создаёт текстовый файл на удалённом хосте.  
Модуль принимает обязательные параметры `path` и `content`, опциональный `force`.  
Поддерживает `check_mode` (возвращает `changed=True` без реальных изменений) и возвращает информативные сообщения.

**Создание кода модуля**

<img width="1831" height="890" alt="image" src="https://github.com/user-attachments/assets/de810c38-e333-48ce-80a1-6f7692799201" />

## Шаг 4. Проверка модуля локально

Модуль проверен **прямым запуском** — стандартным способом тестирования модулей Ansible.  
Аргументы переданы через `stdin` в формате JSON, модуль отработал корректно и создал файл.

**Проверка исполняемости скрипта**

<img width="1834" height="115" alt="image" src="https://github.com/user-attachments/assets/a7766ceb-197d-4905-9d0f-bd0d48c52222" />

## Шаг 5. Single-task playbook с использованием модуля

Создан playbook, состоящий из одной задачи, которая применяет модуль `my_own_module` для создания текстового файла.  
Playbook выполняется локально, путь к коллекции указан через переменную окружения.

**Запуск playbook**

<img width="1838" height="302" alt="image" src="https://github.com/user-attachments/assets/735e9335-a365-466c-9a60-d6106854452f" />

## Шаг 6. Проверка playbook на идемпотентность

Для проверки идемпотентности создан отдельный playbook без параметра force.
Первый запуск создаёт файл (т.к. его нет), а повторный запуск не вносит изменений, потому что файл уже существует.
Это подтверждает корректную обработку состояния модулем и отсутствие лишних изменений при повторном выполнении.

**Проверка на идемпотентность**

<img width="1839" height="297" alt="image" src="https://github.com/user-attachments/assets/4e32f318-ba5a-4697-85ab-dbf03657adae" />

## Шаг 7. Завершение работы с виртуальным окружением

После успешного выполнения всех операций (тестирование модуля, запуск playbook, проверка идемпотентности) виртуальное окружение разработки Ansible было деактивировано.  
Это стандартная практика, позволяющая вернуться к системному Python и избежать случайного использования изолированного окружения в других задачах.

**Завершение работы с виртуальным окружением**

<img width="564" height="43" alt="image" src="https://github.com/user-attachments/assets/4bb65ba3-294a-467c-98de-0e5c1b38a37e" />

## Шаг 8. Инициализация новой коллекции

Для создания структуры коллекции использовалась команда `ansible-galaxy collection init`, запущенная в виртуальном окружении разработки Ansible (Python 3.13). Это позволило избежать ошибок, связанных с устаревшим системным pip.

**Инициализация новой коллекции**

<img width="1842" height="79" alt="image" src="https://github.com/user-attachments/assets/1d709bb8-8249-4074-b74f-20ed8ed95316" />

## Шаг 9. Перенос модуля в новую коллекцию

Готовый модуль `my_own_module.py` перемещён из старой коллекции `my_org.my_collection` в соответствующую директорию новой коллекции `my_own_namespace.yandex_cloud_elk`, чтобы его можно было использовать вместе с ней.

**Перенос модуля в новую коллекцию**

<img width="1352" height="100" alt="image" src="https://github.com/user-attachments/assets/98fff39d-c490-46b7-9d8f-787140fa083a" />

## Шаг 10. Single-task role в коллекции

Роль `file_creator`, использующая модуль `my_own_module`, успешно создана и помещена в коллекцию `my_own_namespace.yandex_cloud_elk`.

Структура роли:
- `tasks/main.yml` – задача вызова модуля с параметрами `file_path`, `file_content` и `file_force`.
- `defaults/main.yml` – значения по умолчанию для этих параметров.

Теперь коллекция содержит и модуль, и роль, готовую к использованию в playbook.

**Создание роли**

<img width="1143" height="257" alt="image" src="https://github.com/user-attachments/assets/ab210291-2c08-4c5e-add3-e8c11ff8b33c" />

## Шаг 11. Playbook для использования роли `file_creator`

Создан playbook, который применяет роль `file_creator` из коллекции `my_own_namespace.yandex_cloud_elk`.  
Роль использует модуль `my_own_module` с переопределёнными параметрами.

**Запуск playbook**

<img width="1833" height="366" alt="image" src="https://github.com/user-attachments/assets/01b94790-c436-47b8-8893-b5037d9a78ef" />

## Шаг 12. Заполнение документации и публикация с тегом `1.0.0`

Для коллекции `my_own_namespace.yandex_cloud_elk` подготовлена полная документация:

- В корне репозитория размещён `README.md` с описанием проекта, установки, ссылками.
- В каталоге коллекции `ansible_collections/my_own_namespace/yandex_cloud_elk/README.md` приведено подробное описание модуля `my_own_module`, роли `file_creator`, параметров, примеров использования и лицензии.
- Плагины задокументированы в `plugins/README.md`.

Все файлы закоммичены в ветку `main`, на финальный коммит установлен аннотированный тег `1.0.0`. Репозиторий опубликован на GitHub.

**Ссылки:**
- Репозиторий: [https://github.com/MustWay-byte/my_own_collection](https://github.com/MustWay-byte/my_own_collection)
- Тег `1.0.0`: [https://github.com/MustWay-byte/my_own_collection/releases/tag/1.0.0](https://github.com/MustWay-byte/my_own_collection/releases/tag/1.0.0)

## Шаг 13. Сборка коллекции в `.tar.gz`

В корневом каталоге коллекции `ansible_collections/my_own_namespace/yandex_cloud_elk` выполнена команда `ansible-galaxy collection build`.  
Она создаёт архив `my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz`, который можно использовать для установки коллекции на других системах.

**Создание архива**

<img width="1833" height="114" alt="image" src="https://github.com/user-attachments/assets/ad3af514-d0e3-446c-8c12-d4e5d111bacb" />

## Шаг 14. Создание директории `dist` с playbook и архивом коллекции

Для финального удобства все артефакты проекта были собраны в отдельную директорию `dist`.  
В неё помещены:

- Архив коллекции `my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz`
- Single-task playbook `test_module.yml`, который демонстрирует использование модуля `my_own_module`.

Эти файлы можно передать другому пользователю или использовать для установки коллекции.

**Создание директории**

<img width="1451" height="169" alt="image" src="https://github.com/user-attachments/assets/a3045f37-dc97-483c-9ff8-fcf2e8d199b2" />

## Шаг 15. Установка коллекции из локального архива

Коллекция, собранная в предыдущем шаге, установлена локально из архива `my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz` с помощью `ansible-galaxy`.

**Установка коллекции из архива**

<img width="1840" height="165" alt="image" src="https://github.com/user-attachments/assets/520d2362-b548-449f-a69b-9459b4261b5e" />

## Шаг 16. Проверка работоспособности playbook с установленной коллекцией

Playbook успешно выполнен, модуль отработал и создал файл `/tmp/hello_from_playbook.txt`.

**Запуск playbook**

<img width="1843" height="292" alt="image" src="https://github.com/user-attachments/assets/a6d8e0e9-0432-4764-8d0d-e61825f4a843" />

## Шаг 17. Финальные ответы и скриншоты

Все шаги задания выполнены. Ниже приведены ссылки на репозиторий, архив коллекции, а также перечень скриншотов по запрошенным пунктам.

#### Ссылки
- **Репозиторий с коллекцией:**  
  [https://github.com/MustWay-byte/my_own_collection](https://github.com/MustWay-byte/my_own_collection)  
  Тег `1.0.0` ([релиз](https://github.com/MustWay-byte/my_own_collection/releases/tag/1.0.0))

- **Архив коллекции (`.tar.gz`):**  
  [my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz](https://github.com/MustWay-byte/my_own_collection/raw/main/dist/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz)

#### Скриншоты выполнения

- **Пункт 4** – Локальная проверка модуля

<img width="1834" height="115" alt="image" src="https://github.com/user-attachments/assets/a7766ceb-197d-4905-9d0f-bd0d48c52222" />

- **Пункт 6** – Проверка идемпотентности playbook
  
<img width="1839" height="297" alt="image" src="https://github.com/user-attachments/assets/4e32f318-ba5a-4697-85ab-dbf03657adae" />

- **Пункт 15** – Установка коллекции из архива (`ansible-galaxy collection install ...`)

<img width="1840" height="165" alt="image" src="https://github.com/user-attachments/assets/520d2362-b548-449f-a69b-9459b4261b5e" />

- **Пункт 16** – Запуск playbook с установленной коллекцией

<img width="1843" height="292" alt="image" src="https://github.com/user-attachments/assets/a6d8e0e9-0432-4764-8d0d-e61825f4a843" />

# Часть 2 — Необязательная часть

## Шаг 1. Реализация модуля `yc_compute_instance` для создания хостов в Yandex Cloud

Создан модуль `yc_compute_instance`, который позволяет создавать виртуальные машины в Yandex Cloud с помощью Yandex Cloud CLI (`yc`). Модуль размещён в коллекции `my_own_namespace.yandex_cloud_elk` в каталоге `plugins/modules/yc_compute_instance.py`.

**Основные возможности:**
- Создание ВМ с настраиваемыми параметрами: имя, зона доступности, платформа, количество vCPU, объём RAM, семейство образа, подсеть, идентификатор каталога.
- Проверка существования ВМ по имени (идемпотентность) – если ВМ уже существует, модуль не пытается создать новую.
- Поддержка `check_mode`.

**Параметры модуля:**
| Параметр        | Тип   | Обязательный | По умолчанию        | Описание                                                                 |
|-----------------|-------|--------------|---------------------|--------------------------------------------------------------------------|
| `name`          | `str` | да           | –                   | Имя создаваемой ВМ.                                                      |
| `folder_id`     | `str` | нет          | `""`                | Идентификатор каталога (если не указан, будет использоваться каталог по умолчанию). |
| `zone`          | `str` | нет          | `ru-central1-a`     | Зона доступности.                                                        |
| `platform`      | `str` | нет          | `standard-v2`       | Аппаратная платформа.                                                    |
| `cores`         | `int` | нет          | `2`                 | Количество vCPU.                                                         |
| `memory`        | `int` | нет          | `2`                 | Объём RAM в ГБ.                                                          |
| `image_family`  | `str` | нет          | `ubuntu-2204-lts`   | Семейство образов (например, `ubuntu-2204-lts`).                         |
| `image_folder_id`| `str`| нет          | `standard-images`   | Идентификатор папки с образами (по умолчанию публичные образы).          |
| `subnet_name`   | `str` | нет          | `default`           | Имя подсети, к которой будет подключена ВМ.                              |
| `state`         | `str` | нет          | `present`           | Желаемое состояние (только `present`).                                   |

**Тестирование модуля:**

Модуль был протестирован локально передачей JSON-аргументов через стандартный ввод. Для теста использовались реальные параметры облака:
- `folder_id`: `b1g5m6nu8f7nl3dmsjot`
- `zone`: `ru-central1-a`
- `subnet_name`: `default-ru-central1-a`
- `image_family`: `ubuntu-2204-lts`
- `image_folder_id`: `standard-images`

**Результат:**  
Виртуальная машина с именем `test-vm` была успешно создана. Модуль вернул JSON:
```json
{"changed": true, "vm_id": "fhmn1nqv3svn6ke0ejl5", "vm_name": "test-vm"}
```

**Реализация модуля**

<img width="1840" height="81" alt="image" src="https://github.com/user-attachments/assets/780ea68c-72d8-4498-99c0-fc57e7ab4947" />

## Шаг 2. Зависимость модуля и его основной функционал

Модуль `yc_compute_instance` реализует единственную задачу: **создание виртуальной машины с заданными характеристиками (сайзингом) и операционной системой** в Yandex Cloud.

**Зависимость:**  
Для работы модуля на управляемом хосте должен быть установлен и настроен `yc` (Yandex Cloud CLI).  
Модуль не использует дополнительные SDK или API‑обёртки — все действия выполняются вызовом команд `yc`.

**Основной функционал:**
- создание одной ВМ с указанием:
  - имени,
  - зоны доступности,
  - платформы,
  - количества vCPU и объёма RAM,
  - семейства образа ОС (например, `ubuntu-2204-lts`),
  - подсети,
  - идентификатора каталога.
- проверка существования ВМ по имени (если ВМ уже есть, создание не выполняется).
- поддержка режима `check_mode`.

Модуль **не реализует** создание кластеров ClickHouse, MySQL, Kubernetes и других PaaS‑сервисов — только базовая виртуальная машина.

Таким образом, модуль полностью соответствует заданию: **зависит от yc, создаёт ВМ с нужным сайзингом на основе нужной ОС**.

**Проверка параметров виртуальной машины в облаке Yandex Cloud**

<img width="811" height="816" alt="image" src="https://github.com/user-attachments/assets/4b7e96c4-db4f-498c-a65c-e66f126bb021" />

## Шаг 3. Динамическое inventory

Модуль `yc_compute_instance` расширен поддержкой состояния `state: list`.  
В этом режиме он не создаёт виртуальную машину, а возвращает список уже существующих ВМ в формате, совместимом с Ansible dynamic inventory.

**Получение inventory**

<img width="1845" height="96" alt="image" src="https://github.com/user-attachments/assets/d0734d01-9cb0-4ee7-97bd-7d5ea29b8519" />

## Шаг 4. Тестирование модуля и добавление в коллекцию

Модуль `yc_compute_instance` прошёл проверку на исполнимость и идемпотентность.

**Проверка на идемпотентность**

<img width="1839" height="79" alt="image" src="https://github.com/user-attachments/assets/16f24ee2-41e1-404a-8dd5-bc2e8941096b" />

## Шаг 5. Изменение playbook для создания инфраструктуры и настройки стека Observability

Playbook `deploy_stack.yml` был доработан и теперь выполняет полный цикл автоматизации:

1. **Создание трёх виртуальных машин** в Yandex Cloud с помощью модуля `yc_compute_instance`.  
   Для каждого компонента стека (ClickHouse, Vector, LightHouse) создаётся отдельная ВМ с параметрами:
   - зона `ru-central1-a`
   - платформа `standard-v2`
   - 2 vCPU, 2 ГБ RAM
   - образ `ubuntu-2204-lts`
   - подсеть `default-ru-central1-a`

2. **Генерация динамического inventory** на основе созданных машин.  
   Модуль `yc_compute_instance` с параметром `state: list` возвращает JSON с внешними IP-адресами и характеристиками хостов, который сохраняется в файл `inventory.yml`.

3. **Настройка стека Observability** на хостах из полученного inventory.  
   Используются роли `clickhouse`, `vector_role` и `lighthouse_role`. Применяются условия `when: "'clickhouse' in inventory_hostname"` и аналогичные для остальных, чтобы каждый компонент устанавливался только на предназначенную для него машину.

**Результат выполнения:**
- Playbook отработал без ошибок (`failed=0` для всех хостов).
- ClickHouse запущен и слушает порт 9000.
- Vector запущен (процесс `vector` активен).
- LightHouse (Nginx + статика) развёрнут и доступен по HTTP на порту 8686 (`http://93.77.191.123:8686`).

Таким образом, достигнута полная автоматизация: создание облачной инфраструктуры, формирование inventory и настройка всего стека Observability одной командой.

**Запуск playbook**

<img width="1844" height="992" alt="image" src="https://github.com/user-attachments/assets/eefc9951-f24c-4483-b7dd-be6ba3738345" />

