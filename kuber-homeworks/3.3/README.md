# Домашнее задание: Сетевые политики в Kubernetes

## Цель

Развернуть приложения `frontend`, `backend`, `cache` в namespace `app` и настроить сетевые политики так, чтобы разрешён был только трафик `frontend → backend → cache`. Все остальные подключения должны блокироваться.

## Окружение

- Кластер Kubernetes, развёрнутый через **kind** (Kubernetes in Docker).
- CNI: **Calico v3.26.1** (обязателен, так как стандартный kindnet не поддерживает NetworkPolicy).
- Образ приложений: `wbitt/network-multitool`.
- Namespace: `app`.

**Правила трафика**

<img width="721" height="399" alt="image" src="https://github.com/user-attachments/assets/977572b5-164e-4885-a527-ac5efeba8f0d" />

## Вывод
Сетевые политики успешно ограничивают трафик: разрешена только цепочка frontend → backend → cache, всё остальное блокируется. Требование задания выполнено.
