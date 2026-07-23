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

# Задание 2: Создание Dashboard с системными метриками Node Exporter

Был создан новый дашборд в Grafana, содержащий четыре панели с основными метриками хоста, собираемыми Prometheus с Node Exporter.

## Инструкция по созданию дашборда

1. В Grafana перейти в **Dashboards** → **New** → **New Dashboard**.
2. Нажать **Add new panel**. Убедиться, что источник данных — Prometheus.
3. В поле запроса ввести один из приведённых ниже PromQL-запросов.
4. Настроить визуализацию (для графиков — **Time series**, для диска и памяти можно также использовать **Stat**).
5. Указать понятное название панели (поле **Title** справа).
6. При необходимости задать единицы измерения в **Standard options** (например, `percent`, `gigabytes`).
7. Нажать **Apply**, повторить для остальных метрик.
8. Сохранить дашборд (**Save dashboard**) с именем, например, «Node Exporter Overview».

## PromQL-запросы для каждой метрики

| Метрика | PromQL-запрос | Примечание |
|---------|---------------|------------|
| **Утилизация CPU (в %)** | `100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` | Средняя загрузка CPU за 5 минут, исключая idle. Результат — проценты использованного процессорного времени. |
| **Load Average (1/5/15 мин)** | `node_load1`<br>`node_load5`<br>`node_load15` | Три отдельных запроса в одной панели (через **+ Add query**). Показывают классический LA за 1, 5 и 15 минут. |
| **Свободная оперативная память** | `node_memory_MemAvailable_bytes / 1024 / 1024 / 1024` | Доступная память в гигабайтах (с учётом кэшей). Можно оставить в байтах и выставить Unit → Data → bytes. |
| **Свободное место на корневой ФС** | `node_filesystem_avail_bytes{mountpoint="/"} / 1024 / 1024 / 1024` | Свободное место на корневом разделе в гигабайтах. Альтернативно можно вычислить процент использования: `100 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"} * 100)` |

> **Важно:** для панели «Свободное место» дополнительно можно добавить расчёт процента занятого пространства, если это требуется условиями задания. Приведён альтернативный запрос.

## Результат

На скриншоте представлен итоговый дашборд с четырьмя панелями, демонстрирующими все запрошенные метрики в реальном времени.

Node Exporter Dashboard

<img width="1784" height="1559" alt="image" src="https://github.com/user-attachments/assets/822f4cbd-aa13-49aa-9c76-a157e82b6b3b" />

# Задание 3: Настройка канала нотификаций и создание алертов

В качестве канала уведомлений использован локальный почтовый сервер **MailHog**, который перехватывает все отправляемые Grafana письма.  

В Grafana созданы четыре правила алертов для метрик CPU, Load Average, свободной памяти и дискового пространства. Все алерты связаны с контактной точкой Email (MailHog), что позволяет видеть тестовые и боевые уведомления в веб-интерфейсе MailHog.  

На дашборд добавлена панель **Alert list**, отображающая текущее состояние всех алертов.

## Скриншоты

### Правило алерта для CPU

<img width="1789" height="1689" alt="image" src="https://github.com/user-attachments/assets/843ba148-e1e4-4b9a-a735-3240169ac141" />

### Почтовый ящик

<img width="1514" height="845" alt="image" src="https://github.com/user-attachments/assets/d4f5a02c-b507-4bb5-808d-5f9cc0d67dca" />

# Задание 4: JSON-модель дашборда

В соответствии с заданием была экспортирована JSON-модель итогового дашборда **Node Exporter Overview**, содержащего четыре панели метрик (CPU Usage, Load Average, Free Memory, Free Disk /) и настроенные правила алертов. Полученный файл сохранён и представлен ниже.

```json
{
  "annotations": {
    "list": [
      {
        "builtIn": 1,
        "datasource": "-- Grafana --",
        "enable": true,
        "hide": true,
        "iconColor": "rgba(0, 211, 255, 1)",
        "name": "Annotations & Alerts",
        "type": "dashboard"
      }
    ]
  },
  "editable": true,
  "gnetId": null,
  "graphTooltip": 0,
  "id": 2,
  "links": [],
  "panels": [
    {
      "alert": {
        "alertRuleTags": {},
        "conditions": [
          {
            "evaluator": {
              "params": [
                80
              ],
              "type": "gt"
            },
            "operator": {
              "type": "and"
            },
            "query": {
              "params": [
                "A",
                "5m",
                "now"
              ]
            },
            "reducer": {
              "params": [],
              "type": "avg"
            },
            "type": "query"
          }
        ],
        "executionErrorState": "alerting",
        "for": "0m",
        "frequency": "1m",
        "handler": 1,
        "message": "CPU usage is above 80%",
        "name": "Node Exporter Overview alert",
        "noDataState": "no_data",
        "notifications": [
          {
            "uid": "QQR0OdEDz"
          }
        ]
      },
      "aliasColors": {},
      "bars": false,
      "dashLength": 10,
      "dashes": false,
      "datasource": null,
      "description": "Node Exporter Overview",
      "fieldConfig": {
        "defaults": {
          "custom": {}
        },
        "overrides": []
      },
      "fill": 1,
      "fillGradient": 0,
      "gridPos": {
        "h": 9,
        "w": 12,
        "x": 0,
        "y": 0
      },
      "hiddenSeries": false,
      "id": 2,
      "legend": {
        "avg": false,
        "current": false,
        "max": false,
        "min": false,
        "show": true,
        "total": false,
        "values": false
      },
      "lines": true,
      "linewidth": 1,
      "nullPointMode": "null",
      "options": {
        "alertThreshold": true
      },
      "percentage": false,
      "pluginVersion": "7.4.0",
      "pointradius": 2,
      "points": false,
      "renderer": "flot",
      "seriesOverrides": [],
      "spaceLength": 10,
      "stack": false,
      "steppedLine": false,
      "targets": [
        {
          "expr": "100 - (avg(rate(node_cpu_seconds_total{mode=\"idle\"}[5m])) * 100)",
          "interval": "",
          "legendFormat": "CPU Usage",
          "refId": "A"
        },
        {
          "expr": "node_load15",
          "hide": false,
          "interval": "",
          "legendFormat": "Load Average",
          "refId": "B"
        },
        {
          "expr": "node_memory_MemAvailable_bytes / 1024 / 1024 / 1024",
          "hide": false,
          "interval": "",
          "legendFormat": "Free Memory",
          "refId": "C"
        },
        {
          "expr": "node_filesystem_avail_bytes{mountpoint=\"/\"} / 1024 / 1024 / 1024",
          "hide": false,
          "interval": "",
          "legendFormat": "Free Disk /",
          "refId": "D"
        }
      ],
      "thresholds": [
        {
          "colorMode": "critical",
          "fill": true,
          "line": true,
          "op": "gt",
          "value": 80,
          "visible": true
        }
      ],
      "timeFrom": null,
      "timeRegions": [],
      "timeShift": null,
      "title": "Node Exporter Overview",
      "tooltip": {
        "shared": true,
        "sort": 0,
        "value_type": "individual"
      },
      "type": "graph",
      "xaxis": {
        "buckets": null,
        "mode": "time",
        "name": null,
        "show": true,
        "values": []
      },
      "yaxes": [
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        },
        {
          "format": "short",
          "label": null,
          "logBase": 1,
          "max": null,
          "min": null,
          "show": true
        }
      ],
      "yaxis": {
        "align": false,
        "alignLevel": null
      }
    }
  ],
  "schemaVersion": 27,
  "style": "dark",
  "tags": [],
  "templating": {
    "list": []
  },
  "time": {
    "from": "now-6h",
    "to": "now"
  },
  "timepicker": {},
  "timezone": "",
  "title": "Node Exporter Overview",
  "uid": "JD8MFOEvz",
  "version": 4
}
```
