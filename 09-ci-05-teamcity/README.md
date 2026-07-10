## Задание 1 – Создание проекта в TeamCity на основе форка

В TeamCity был создан новый проект `example-teamcity` на основе форка репозитория [example-teamcity](https://github.com/MustWay-byte/example-teamcity).  
Подключение к GitHub выполнено через Personal Access Token (PAT), так как OAuth-авторизация требовала перенастройки Docker-контейнера.

TeamCity автоматически обнаружил систему сборки Maven (`pom.xml`) и предложил шаг с целями `clean test`.  
После подтверждения шага была запущена первая сборка.

**Результат:**  
- Сборка завершилась успешно (статус `Success`).  
- Пройдено 5 тестов.  
- Продолжительность: 32 секунды.  
- Сборка выполнена на агенте `ip_158.160.215.218`.

*Скриншот успешной сборки:*

<img width="1891" height="942" alt="image" src="https://github.com/user-attachments/assets/7727ed54-6af9-4872-b9a2-005e57647e37" />

## Задание 2 – Autodetect конфигурации

При создании конфигурации сборки TeamCity автоматически просканировал VCS-репозиторий и обнаружил файл `pom.xml`, определив систему сборки Maven.  
На основе этого был предложен готовый шаг сборки:

- **Build Step:** Maven  
- **Path to POM:** pom.xml  
- **Goals:** clean test

Автоопределение позволило без ручной настройки сразу получить рабочую конфигурацию.  
После подтверждения шага сборка была выполнена успешно (см. задание 1).

## Задание 3 – Сохранение шагов и запуск первой сборки master

После автоопределения конфигурации Maven шаг сборки (`clean test`) был подтверждён и сохранён.  
Для ветки `master` была запущена первая сборка.

**Результат:**
- Сборка прошла успешно (статус `Success`).
- Все 5 тестов пройдены.
- Продолжительность сборки: 32 секунды.
- Сборка выполнена на агенте `ip_158.160.215.218`.

## Задание 4 – Изменение условий сборки (условные шаги)

В конфигурацию сборки добавлены два шага Maven, которые выполняются в зависимости от ветки Git:

- **Для ветки `master`** → выполняется цель `clean deploy`.
- **Для всех остальных веток** → выполняется цель `clean test`.

### Как это было настроено

1. В проекте `example-teamcity` открыта конфигурация сборки `Build`.
2. В разделе **Build Steps** удалён исходный шаг Maven.
3. Создан новый шаг **Maven**:
   - **Goals:** `clean deploy`
   - **Execute step:** `If all conditions match`
   - **Условие:** `teamcity.build.branch` **equals** `master`
4. Создан второй шаг **Maven**:
   - **Goals:** `clean test`
   - **Execute step:** `If all conditions match`
   - **Условие:** `teamcity.build.branch` **does not equal** `master`

### Результат

При запуске сборки на ветке `master` выполняется `clean deploy`, на других ветках — `clean test`.

*Скриншот настроенных шагов с условиями:*

<img width="1889" height="922" alt="image" src="https://github.com/user-attachments/assets/9f2d9a84-7711-45bc-9994-2992cdbe5a0b" />

## Задание 5 – Загрузка settings.xml с кредами Nexus

Файл `settings.xml` (содержит логин/пароль `admin/admin123` и URL Nexus) загружен в **Maven Settings** проекта `example-teamcity`.  
В шаге `clean deploy` выбран этот файл через параметр **User settings selection**.

**Результат:**  
Maven использует креды из `settings.xml` при деплое артефактов в Nexus.

*Скриншот загруженного `settings.xml`:*  

<img width="1889" height="944" alt="image" src="https://github.com/user-attachments/assets/88b18fb9-76d4-4475-a11a-ea5cc5ab5f02" />

## Задание 6 – Изменение ссылок на репозиторий и Nexus в pom.xml

Файл `pom.xml` обновлён: URL репозитория Nexus заменён на `http://158.160.227.188:8081/repository/maven-releases` (IP-адрес моего TeamCity-сервера).  
Изменения закоммичены в ветку `master`, после чего сборка в TeamCity выполнила шаг `clean deploy`.

*Скриншот обновлённого pom.xml:*

<img width="1886" height="882" alt="image" src="https://github.com/user-attachments/assets/e9314a98-27db-4acd-8c90-41b6ff6d2685" />
