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

# Задание 2 – Загрузка роли ClickHouse через `ansible-galaxy`

Роль ClickHouse, указанная в `requirements.yml`, скачана командой:

```bash
ansible-galaxy install -r requirements.yml -p roles/
```

**Загрузка роли ClickHouse**
<img width="1833" height="170" alt="image" src="https://github.com/user-attachments/assets/eb590769-9d6f-4619-b873-337b85fb1268" />

