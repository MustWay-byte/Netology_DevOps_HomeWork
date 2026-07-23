# Задание 1: Подключение Prometheus как источника данных в Grafana

В рамках задания была развёрнута связка Prometheus + Grafana + Node Exporter с использованием готовой конфигурации из директории `help` репозитория [netology-code/mnt-homeworks](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-03-grafana/help).

## Выполненные шаги

1. Клонирован репозиторий, осуществлён переход в каталог `help`.
2. Запущены контейнеры командой `docker compose up -d`.
3. После указания URL `http://172.23.0.1:9090` и выполнения теста появилось подтверждение «Data source is working».

## Результат

Скриншот веб-интерфейса Grafana демонстрирует список подключённых источников данных (Data Sources). В списке присутствует **Prometheus** с отметкой об успешном подключении.

Data Sources в Grafana

<img width="1415" height="518" alt="image" src="https://github.com/user-attachments/assets/fe5fd1e4-f657-41a4-a038-6dbaf463d51b" />)
