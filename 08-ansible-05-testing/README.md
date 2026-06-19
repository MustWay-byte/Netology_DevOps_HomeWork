## Задание 1 – Знакомство с Molecule и успешный прогон vector_role

Был запущен `molecule test` для роли `clickhouse` (взятой из внешнего репозитория).  

Был создан и успешно пройден сценарий для `vector_role`:

```bash
cd roles/vector_role
molecule test
```

**Запуск команды `molecule test`**

<img width="1840" height="979" alt="image" src="https://github.com/user-attachments/assets/2e15d466-742a-4c26-a1fe-9d1940e907bd" />

## Задание 2 – Создание сценария Molecule для vector_role

Сценарий тестирования по умолчанию был создан командой `molecule init scenario` внутри каталога роли `vector_role`.  
Для этого мы сначала удалили старый каталог `molecule/default`, чтобы избежать конфликтов, а затем выполнили инициализацию.

```bash
cd ~/Netology_DevOps_HomeWork/08-ansible-04-role/playbook/roles/vector_role
rm -rf molecule/default
molecule init scenario default --driver-name docker
```

**Запуск команды `molecule init scenario default --driver-name docker`**

<img width="1845" height="113" alt="image" src="https://github.com/user-attachments/assets/d84f7485-0b16-48a9-8057-856f2f1bcfb2" />
