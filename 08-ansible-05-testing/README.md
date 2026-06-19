## Часть 1 – Molecule

## Задание 1 – Знакомство с Molecule и успешный прогон vector_role

Был запущен `molecule test` для роли `clickhouse` (взятой из внешнего репозитория).  

Был создан и успешно пройден сценарий для `vector_role`:

```bash
molecule test
```

**Запуск команды `molecule test`**

<img width="1840" height="979" alt="image" src="https://github.com/user-attachments/assets/2e15d466-742a-4c26-a1fe-9d1940e907bd" />

## Задание 2 – Создание сценария Molecule для vector_role

Сценарий тестирования по умолчанию был создан командой `molecule init scenario` внутри каталога роли `vector_role`.  
Для этого мы сначала удалили старый каталог `molecule/default`, чтобы избежать конфликтов, а затем выполнили инициализацию.

```bash
rm -rf molecule/default
molecule init scenario default --driver-name docker
```

**Запуск команды `molecule init scenario default --driver-name docker`**

<img width="1845" height="113" alt="image" src="https://github.com/user-attachments/assets/d84f7485-0b16-48a9-8057-856f2f1bcfb2" />

## Задание 3 – Тестирование роли на нескольких дистрибутивах

В сценарий Molecule добавлены две платформы:
- **Ubuntu 22.04** (`geerlingguy/docker-ubuntu2204-ansible`)
- **Rocky Linux 8** (`geerlingguy/docker-rockylinux8-ansible`)

Образ Oracle Linux 8 был заменён на Rocky Linux 8 ввиду его недоступности в Docker Hub. Rocky Linux полностью совместим с RHEL‑семейством и позволяет проверить работу роли на `dnf`.

### Внесённые изменения в роль
Для корректной работы на разных менеджерах пакетов модуль `apt` заменён на универсальный модуль `package`:

```yaml
- name: Install dependencies
  ansible.builtin.package:
    name: findutils
    state: present
```

**Запуск команды `molecule test`**

<img width="1848" height="985" alt="image" src="https://github.com/user-attachments/assets/7d254d26-e46f-4d4f-baa3-4e743f859482" />

## Задание 4 – Добавление проверок в verify.yml

В сценарий Molecule добавлен файл `molecule/default/verify.yml` с проверками (assertions), которые подтверждают корректную установку и запуск Vector:

- **Файл конфигурации `/etc/vector/vector.toml` существует и не пуст.**
- **Процесс Vector запущен** (определяется через `pgrep -x vector`).

### Содержимое `verify.yml`

```yaml
---
- name: Verify
  hosts: all
  tasks:
    - name: Check Vector config file exists
      ansible.builtin.stat:
        path: /etc/vector/vector.toml
      register: vector_config
      failed_when: not vector_config.stat.exists

    - name: Assert Vector config is not empty
      ansible.builtin.assert:
        that:
          - vector_config.stat.size > 0
        fail_msg: "Vector config file is empty"
        success_msg: "Vector config file is valid"

    - name: Check Vector process is running
      ansible.builtin.shell: pgrep -x vector
      register: vector_process
      changed_when: false
      failed_when: vector_process.rc != 0

    - name: Assert Vector process is running
      ansible.builtin.assert:
        that:
          - vector_process.rc == 0
        fail_msg: "Vector process not running"
        success_msg: "Vector process is running"
```

**Запуск команды `molecule test`**

<img width="1849" height="965" alt="image" src="https://github.com/user-attachments/assets/bc9401a2-16a2-4b39-8dce-8bea01e1c0b1" />

## Задание 5 – Повторное тестирование роли

После внесения всех изменений (универсальный модуль `package`, мультиплатформенный сценарий, `verify.yml` с проверками) было выполнено повторное тестирование роли.

```bash
molecule test
```

**Запуск команды `molecule test`**

<img width="1844" height="962" alt="image" src="https://github.com/user-attachments/assets/c2389441-b996-4a26-843c-566eaee3e518" />

## Задание 6 – Добавление нового тега с семантическим версионированием

После успешного создания и проверки Molecule-сценариев для роли `vector_role` был создан новый аннотированный тег `v1.1.0`, соответствующий принципам семантического версионирования (добавление функциональности тестирования без нарушения обратной совместимости).

```bash
git tag -a v1.1.0 -m "Add molecule tests for vector_role"
git push origin v1.1.0
```

Тег доступен по ссылке: [v1.1.0](https://github.com/MustWay-byte/vector-role/releases/tag/v1.1.0).

## Часть 2 – Tox

### Задание 1 – Добавление файлов конфигурации Tox

В корень роли `vector_role` скопированы файлы `tox.ini` и `tox-requirements.txt` из [примера](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-05-testing/example). Они нужны для запуска тестов и линтеров через Tox.

#### Команды для выполнения

```bash
# Клонируем репозиторий с примером во временную папку
git clone --depth 1 https://github.com/netology-code/mnt-homeworks.git /tmp/mnt-homeworks

# Копируем нужные файлы
cp /tmp/mnt-homeworks/08-ansible-05-testing/example/tox.ini .
cp /tmp/mnt-homeworks/08-ansible-05-testing/example/tox-requirements.txt .

# Удаляем временный клон
rm -rf /tmp/mnt-homeworks

# Проверяем наличие
ls -la tox.ini tox-requirements.txt
```

**Копирование файлов из папки `example`**

<img width="1812" height="163" alt="image" src="https://github.com/user-attachments/assets/bbf0b83c-e0f2-4a90-a7ea-14dfe16765e0" />

### Задание 2 – Запуск контейнера `aragast/netology:latest` с ролью

Для работы с Tox внутри контейнера используется образ `aragast/netology:latest`.  
Мы монтируем каталог с ролью `vector_role` внутрь контейнера и запускаем интерактивную оболочку.

#### Команда для выполнения

```bash
docker run --privileged=True \
  -v ~/Netology_DevOps_HomeWork/08-ansible-04-role/playbook/roles/vector_role:/opt/vector-role \
  -w /opt/vector-role \
  -it aragast/netology:latest /bin/bash
```

**Запуск контейнера с ролью**

<img width="1286" height="102" alt="image" src="https://github.com/user-attachments/assets/009a13fd-a7b0-47cb-b15a-d668722cdae4" />

### Задание 3 – Запуск Tox внутри контейнера

После входа в контейнер с примонтированной ролью `vector_role` была выполнена команда `tox`.  
Tox начал создавать виртуальные окружения (py37‑ansible210, py37‑ansible30, py39‑ansible210 и др.) и запускать тесты в соответствии с `tox.ini`.

**Команда в контейнере:**

```bash
tox
```

**Запуск команды `tox`**

<img width="1838" height="274" alt="image" src="https://github.com/user-attachments/assets/e43a1ef6-9c25-4809-ab78-5135849fdf8c" />

Наблюдение: для окружений py37-ansible210 и py37-ansible30 тесты завершились с ошибкой, потому что в роли отсутствует сценарий compatibility. Это ожидаемо, так как мы создавали только сценарий default. Остальные окружения ещё не завершились (вывод оборван).

Таким образом, видно что Tox корректно устанавливает зависимости и запускает molecule‑тесты. При необходимости можно расширить tox.ini, указав существующий сценарий, или создать недостающий сценарий compatibility.

### Задание 4 – Создание облегчённого сценария Molecule с драйвером `podman`

Был создан сценарий `podman` для тестирования роли `vector_role` в окружении Podman.  
Сценарий включает только стадии `create`, `converge` и `destroy`, что ускоряет проверку по сравнению с полным циклом Docker.

**Особенности:**
- Используется образ `geerlingguy/docker-ubuntu2204-ansible:latest` (совместим с Podman).
- Роль подключается через `include_role` с полным именем `mustway_byte.vector_role`.

**Результат запуска:**
- Контейнер Podman успешно создан.
- Все задачи роли выполнены, обработчик `Restart Vector` отработал.
- `PLAY RECAP`: `instance : ok=9 changed=6 … failed=0`.

**Запуск команды `molecule test -s podman`**

<img width="1842" height="917" alt="image" src="https://github.com/user-attachments/assets/4f6dfa33-03a9-4b54-8fdf-ad2cfabf4c6f" />

## Часть 2 – Tox

### Задание 5 – Настройка `tox.ini` для облегчённого сценария

Файл `tox.ini` в корне роли `vector_role` был модифицирован: в список окружений добавлен `podman`, а также появилась новая секция `[testenv:podman]`, запускающая облегчённый сценарий Molecule.

Ниже приведён **полный итоговый `tox.ini`** с отражением всех изменений.

```ini
[tox]
minversion = 3.24
envlist = podman, molecule, lint
skipsdist = true

[testenv:podman]
deps = -rtox-requirements.txt
commands = molecule test -s podman

[testenv:molecule]
deps = -rtox-requirements.txt
commands = molecule test --all

[testenv:lint]
deps = -rtox-requirements.txt
commands = molecule lint
```

Таким образом, теперь tox может запускать как полный набор тестов (molecule, lint), так и быстрый прогон в Podman через tox -e podman.

### Задание 6 – Запуск команды `tox`

В контейнере `aragast/netology:latest` с активированным виртуальным окружением `py37-ansible210` была выполнена команда:

```bash
tox -e podman
```

**Запуск команды `tox -e podman`**

<img width="1837" height="927" alt="image" src="https://github.com/user-attachments/assets/52958f67-1c9f-4438-8141-1d90230e879e" />

### Задание 7 – Финальный тег `v1.2.0`

Все изменения, связанные с добавлением Molecule-сценариев (`default`, `podman`) и конфигурации Tox, закоммичены в репозиторий `vector-role`.  
На финальный коммит установлен аннотированный тег `v1.2.0`, соответствующий принципам семантического версионирования (добавление нового функционала тестирования).

**Команды для фиксации и тегирования:**

```bash
# Добавляем все новые файлы (tox.ini, tox-requirements.txt, молекульные сценарии)
git add tox.ini tox-requirements.txt molecule/

# Создаём коммит
git commit -m "Add Molecule scenarios (default + podman) and Tox configuration"

# Ставим тег v1.2.0
git tag -a v1.2.0 -m "Add Molecule and Tox testing support"

# Отправляем в удалённый репозиторий
git push origin main
git push origin v1.2.0
```

Тег доступен по ссылке: [v1.2.0](https://github.com/MustWay-byte/vector-role/releases/tag/v1.2.0)

## Часть 3 – Необязательная часть

### Задание 1 – Создание сценариев Molecule для роли LightHouse

Для роли `lighthouse_role` создан сценарий `default` с драйвером Docker.  
Он проверяет установку Nginx, скачивание и развёртывание LightHouse, а также доступность веб-интерфейса.

**Результат:** тест `molecule test` пройден, все задачи выполнены (`failed=0`), проверки `verify.yml` подтвердили, что LightHouse отдаёт страницу через порт 8686.

**Запуск команды `molecule test`**

<img width="1841" height="964" alt="image" src="https://github.com/user-attachments/assets/858d6887-6983-4762-890a-46705053472f" />

### Задание 2 – Сценарий полного стека (`fullstack`)

Внутри роли `vector_role` создан сценарий `fullstack`, который одновременно разворачивает все три сервиса: ClickHouse, Vector и LightHouse.  
Для этого используются все три роли: `clickhouse`, `vector_role` и `lighthouse_role`.

**Особенности:**
- Сценарий запускается в Docker-контейнере (образ `geerlingguy/docker-ubuntu2204-ansible`).
- Роли подключаются через стандартный механизм Ansible (путь к ролям указан через переменную окружения `ANSIBLE_ROLES_PATH`).
- В `converge.yml` добавлены `pre_tasks` для установки необходимых зависимостей (python3, gpg, curl, unzip).
