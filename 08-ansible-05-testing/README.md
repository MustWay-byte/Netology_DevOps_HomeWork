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
