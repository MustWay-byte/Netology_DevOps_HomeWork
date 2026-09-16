# Задание 1: Сетевые политики в Kubernetes

## Цель

Развернуть приложения `frontend`, `backend`, `cache` в namespace `app` и настроить сетевые политики так, чтобы разрешён был только трафик `frontend → backend → cache`. Все остальные подключения должны блокироваться.

## Окружение

- Кластер Kubernetes, развёрнутый через **kind** (Kubernetes in Docker).
- CNI: **Calico v3.26.1** (обязателен, так как стандартный kindnet не поддерживает NetworkPolicy).
- Образ приложений: `wbitt/network-multitool`.
- Namespace: `app`.

**Правила трафика**

<img width="736" height="455" alt="image" src="https://github.com/user-attachments/assets/13fc8126-2c4e-4bee-99f3-dd11ca41f79a" />

## Вывод
Сетевые политики успешно ограничивают трафик: разрешена только цепочка frontend → backend → cache, всё остальное блокируется. Требование задания выполнено.
