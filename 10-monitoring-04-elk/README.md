# Задание 1: Elastic Stack

Использована готовая связка из директории `help` репозитория.  
Запуск выполнен командой `docker-compose up -d`.  

Все пять обязательных контейнеров успешно запущены:
- `es-hot` (Elasticsearch hot node)
- `es-warm` (Elasticsearch warm node)
- `logstash`
- `kibana`
- `filebeat`

Кроме того, работает вспомогательный контейнер `some_app` для генерации логов.

Kibana доступна по адресу `http://localhost:5601`.

Примечание: собственные конфигурации не прилагаются, так как задание выполнено с использованием `help`.

## Скриншоты

### Статус контейнеров (docker-compose ps)

<img width="733" height="348" alt="image" src="https://github.com/user-attachments/assets/3249fd2c-2c7c-4fb6-b999-c7640c143dec" />

### Интерфейс Kibana

<img width="1648" height="1082" alt="image" src="https://github.com/user-attachments/assets/145334e9-c78e-4776-acb2-60c8015b9fe4" />
