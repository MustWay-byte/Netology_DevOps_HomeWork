# Задание 1. Volume: обмен данными между контейнерами в поде

## Выполненные шаги

1. Создан Deployment `data-exchange` с одним подом, содержащим два контейнера:
   - `busybox-writer` — записывает текущую дату в файл `/shared/data.txt` каждые 5 секунд.
   - `multitool-reader` — читает этот файл с помощью `tail -f`.

2. Для обмена данными между контейнерами использован том `emptyDir`, смонтированный в обоих контейнерах по пути `/shared`.

3. Проверена работа пода: оба контейнера находятся в состоянии `Running` (2/2).  
   С помощью `kubectl describe pod` подтверждено наличие обоих контейнеров и корректное монтирование тома.
   
**Информация о поде**

<img width="1214" height="1703" alt="image" src="https://github.com/user-attachments/assets/91ebbd40-32ef-4500-a0ed-db91cd4f6e89" />

4. Через `kubectl exec` в контейнер `multitool-reader` выполнена команда `tail -f /shared/data.txt`. В выводе видно, что файл регулярно дополняется новыми строками с датами, что доказывает успешный обмен данными между контейнерами.

**Передача данных через контейнер**

<img width="1280" height="301" alt="image" src="https://github.com/user-attachments/assets/5fabd6df-e901-4106-9987-65bf4536ffe3" />

## Манифест

- `containers-data-exchange.yaml` — Deployment с двумя контейнерами и общим томом.

## Результат

Контейнеры успешно обмениваются данными через общий том

# Задание 2. PV, PVC

## Выполненные шаги

### 1. Создание локальной директории на ноде

На виртуальной машине (ноде MicroK8S) была создана директория `/tmp/data-exchange-pv`, которая будет использоваться в качестве `hostPath` для PersistentVolume.

### 2. Создание PV, PVC и Deployment

Создан манифест `pv-pvc.yaml`, включающий:

- **PersistentVolume** (`pv-data-exchange`) с локальным хранилищем `hostPath` и политикой `Retain`.
- **PersistentVolumeClaim** (`pvc-data-exchange`), привязанный к PV через `volumeName` и с `storageClassName: ""`.
- **Deployment** (`data-exchange-pvc`) с двумя контейнерами:
  - `busybox-writer` – записывает дату в файл `/mnt/data.txt` каждые 5 секунд.
  - `multitool-reader` – читает этот файл командой `tail -f`.

### 3. Проверка чтения данных

После запуска пода была выполнена команда чтения файла из контейнера `multitool-reader`. В выводе отображались строки с датами, что подтверждает обмен данными через PersistentVolume.

### 4. Удаление Deployment и PVC

Deployment и PVC были удалены. При проверке PV (`kubectl describe pv`) наблюдался статус `Released`. Это объясняется тем, что у PV задана `persistentVolumeReclaimPolicy: Retain`, поэтому после удаления PVC данные сохраняются и PV не удаляется автоматически.

### 5. Проверка сохранности файла на ноде и удаление PV

После удаления PVC файл `/tmp/data-exchange-pv/data.txt` остался на локальной ноде. Затем PV был удалён. Файл при этом также остался на диске, поскольку PV типа `hostPath` лишь ссылается на директорию, а не управляет её содержимым.

## Манифест

- `pv-pvc.yaml` – PV, PVC и Deployment с общим хранилищем.

**Вывод команд**

<img width="1433" height="1679" alt="image" src="https://github.com/user-attachments/assets/807c74b4-4449-4d0b-bd84-484639a03bb0" />

<img width="728" height="945" alt="image" src="https://github.com/user-attachments/assets/cf5cb936-2932-4d60-ac2a-c77d363c4d5d" />

Пояснение: PV переходит в статус Released. PV не удаляется, потому что reclaimPolicy: Retain сохраняет данные и требует ручного вмешательства. Файл остаётся на локальном диске после удаления PV, так как PV типа hostPath лишь указывает на директорию, а не управляет её содержимым. Удаление PV не затрагивает данные на ноде.

## Результат

1. PVC связан с PV — при проверке kubectl get pvc статус Bound, PV имеет статус Bound и указан том pv-data-exchange.

2. Под запущен — оба контейнера в состоянии Running, готовность 2/2.

3. Чтение файла из multitool-reader — команда tail -f /mnt/data.txt выводит строки с датами, которые записывает busybox-writer.

4. После удаления Deployment и PVC — PV переходит в статус Released (не удаляется автоматически из-за Retain).

5. Файл на ноде сохраняется — директория /tmp/data-exchange-pv/data.txt существует, после удаления PV файл остаётся на месте, так как hostPath PV не управляет данными.
