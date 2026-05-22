## Проверка установки Docker и Docker Compose

После создания виртуальной машины выполнен вход по SSH и проверено состояние cloud-init. Установка завершилась успешно.

Проверочные команды:

```bash
cloud-init status --wait
docker --version
docker compose version
groups ubuntu
```

Результат проверки:
- cloud-init завершил выполнение со статусом `done`;
- Docker установлен;
- Docker Compose установлен;
- пользователь `ubuntu` добавлен в группу `docker`.

<img width="792" height="155" alt="image" src="https://github.com/user-attachments/assets/2330ebc8-2cb3-4820-866e-ddd9a1b9f5f2" />

**Ввод команд в виртуальной машине**
