# Задание 1. Подготовка Helm-чарта для приложения

## Цель

Создать Helm-чарт для развертывания приложения, состоящего из нескольких компонентов, в различные окружения. Каждый компонент разворачивается отдельным Deployment. Смена версии приложения выполняется изменением образа в переменных чарта.

## Структура чарта

Чарт создан в каталоге `~/myapp`. Основные файлы:

- `Chart.yaml` — метаданные чарта.
- `values.yaml` — переменные для настройки деплоя.
- `templates/_helpers.tpl` — вспомогательные шаблоны.
- `templates/frontend-deployment.yaml` — Deployment для frontend.
- `templates/frontend-service.yaml` — Service для frontend.
- `templates/backend-deployment.yaml` — Deployment для backend.
- `templates/backend-service.yaml` — Service для backend.

**Проверка работоспособности Helm и Pod**

<img width="1179" height="560" alt="image" src="https://github.com/user-attachments/assets/bd6e0ad5-7f8e-431f-a1ba-bbb57ad171d3" />

## Итог

Чарт успешно проходит проверку и генерирует манифесты для двух компонентов (frontend и backend). Версия приложения управляется через переменные image.tag. Возможно масштабирование за счёт параметра replicaCount. Чарт готов к использованию в CI/CD для развертывания в разные окружения.

