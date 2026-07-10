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

<img width="1880" height="929" alt="image" src="https://github.com/user-attachments/assets/a7523f08-70df-4234-8472-57a2ad92428c" />

## Задание 6 – Изменение ссылок на репозиторий и Nexus в pom.xml

Файл `pom.xml` обновлён: URL репозитория Nexus заменён на `http://158.160.227.188:8081/repository/maven-releases` (IP-адрес моего TeamCity-сервера).  
Изменения закоммичены в ветку `master`, после чего сборка в TeamCity выполнила шаг `clean deploy`.

*Скриншот обновлённого pom.xml:*

<img width="1886" height="882" alt="image" src="https://github.com/user-attachments/assets/e9314a98-27db-4acd-8c90-41b6ff6d2685" />

## Задание 7 – Запуск сборки master и проверка артефакта в Nexus

После исправления URL деплоя в `pom.xml` (`localhost` заменён на `nexus`) сборка ветки `master` успешно выполнена.  
Шаг `clean deploy` отработал без ошибок: Maven загрузил артефакт `plaindoll-0.0.2.jar` в локальный Nexus.

### Ключевые действия
- В `pom.xml` форка `example-teamcity` указан корректный URL распространения:  
  `http://nexus:8081/repository/maven-releases`.
- TeamCity, агент и Nexus объединены в общую Docker-сеть `teamcity-net`, что позволяет агенту обращаться к Nexus по имени контейнера `nexus`.
- В настройках шага `clean deploy` используется файл `nexus-settings` с кредами `admin` / `admin123`.

### Результат
- Сборка master завершена со статусом `Success`.
- В логах шага `clean deploy` видна успешная загрузка артефакта в Nexus.
- В репозитории `maven-releases` (http://localhost:8081) появились файлы `plaindoll-0.0.2.pom` и `plaindoll-0.0.2.jar`.

*Скриншот артефакта в Nexus:*
  
<img width="1832" height="937" alt="image" src="https://github.com/user-attachments/assets/74124ee4-f1af-41d3-8aff-8b37f5a6ac40" />

## Задание 8 – Миграция build configuration в репозиторий

Настройки сборки проекта `example-teamcity` были перенесены в VCS (Git) с помощью механизма **Versioned Settings** TeamCity.  
Теперь конфигурация хранится в репозитории и может быть воспроизведена на любом сервере TeamCity.

### Что было сделано

1. В проекте `example-teamcity` включены Versioned Settings.
2. Выбран формат **XML**.
3. Настроен VCS Root на ваш форк: `https://github.com/MustWay-byte/example-teamcity`.
4. Параметры синхронизации:
   - **Default branch:** `master`
   - **Push mode:** автоматический коммит и пуш изменений.
5. После первой синхронизации в репозиторий был добавлен каталог `.teamcity`, содержащий все настройки сборки.

Синхронизация прошла успешно – изменения из репозитория применены к проекту.

### Результат

- В форке `example-teamcity` в ветке `master` появилась папка `.teamcity` с XML-файлами конфигурации.
- При изменении настроек в TeamCity они автоматически коммитятся в репозиторий.
- Сборка может быть развёрнута на другом сервере TeamCity простым клонированием репозитория и включением Versioned Settings.

*Скриншот страницы после успешной синхронизации*

<img width="1576" height="894" alt="image" src="https://github.com/user-attachments/assets/07a9bed2-242e-4b4e-b02a-a694cce6eba8" />

## Задание 9 – Создание feature-ветки `feature/add_reply`

Для демонстрации работы CI/CD на feature-ветках в репозитории `example-teamcity` создана новая ветка `feature/add_reply` из `master`.

### Что было сделано

- Ветка создана через веб-интерфейс GitHub от ветки `master`.
- В TeamCity настроены условные шаги сборки (задание 4), поэтому при запуске сборки на `feature/add_reply` будет выполнен шаг `clean test`, а `clean deploy` — пропущен.
- Это подтверждает корректную работу условий по веткам.

### Результат

- Ветка `feature/add_reply` доступна в репозитории:  
  [https://github.com/MustWay-byte/example-teamcity/tree/feature/add_reply](https://github.com/MustWay-byte/example-teamcity/tree/feature/add_reply)
- При необходимости можно запустить сборку на этой ветке в TeamCity и убедиться, что выполняется только `clean test`.

*Скриншот списка веток репозитория с выделенной `feature/add_reply`.*

<img width="1656" height="717" alt="image" src="https://github.com/user-attachments/assets/33a299c6-7a4e-40ab-b0ac-3325f2807437" />

## Задание 10 – Добавление метода `getHunterMessage()` в класс `Welcomer`

В ветке `feature/add_reply` репозитория `example-teamcity` реализован новый метод в классе `Welcomer`.  
Метод `getHunterMessage()` возвращает строку, содержащую слово **hunter**, как того требует условие.

### Внесённые изменения

В файл `src/main/java/plaindoll/Welcomer.java` добавлен следующий фрагмент:

```java
public String getHunterMessage() {
    return "The hunter is ready!";
}
```

*Скриншот добавления нового метода*

<img width="716" height="365" alt="image" src="https://github.com/user-attachments/assets/fc8f5ba5-db9e-46c3-80e7-167acbe46dc1" />

## Задание 11 – Дополнение теста для метода `getHunterMessage()`

Для нового метода `getHunterMessage()` класса `Welcomer` добавлен модульный тест, проверяющий, что возвращаемая строка содержит слово **hunter**. Тест написан с использованием JUnit и находится в файле `WelcomerTest.java`.

### Внесённые изменения

В класс `WelcomerTest` добавлен следующий метод:

```java
@Test
public void testGetHunterMessage() {
    Welcomer welcomer = new Welcomer();
    String message = welcomer.getHunterMessage();
    assertTrue("The message should contain 'hunter'",
               message.toLowerCase().contains("hunter"));
}
```

*Скриншот дополнения теста для метода*

<img width="597" height="158" alt="image" src="https://github.com/user-attachments/assets/90adbcc3-2368-4fec-a0bd-ce71ec413577" />

## Задание 12 – Push всех изменений в ветку `feature/add_reply`

После добавления нового метода `getHunterMessage()` и соответствующего теста все изменения были зафиксированы и отправлены в удалённый репозиторий.  
Ветка `feature/add_reply` теперь содержит актуальный код с новым функционалом и тестами.

### Выполненные действия

- Локальные коммиты:
  - `Add getHunterMessage() method` – добавление метода в `Welcomer.java`.
  - `Add test for getHunterMessage()` – добавление теста в `WelcomerTest.java`.
- Оба коммита отправлены в ветку `feature/add_reply` командой `git push origin feature/add_reply`.
- TeamCity автоматически запустил сборку на этой ветке, все тесты пройдены успешно.

### Результат

- Ветка `feature/add_reply` в репозитории [example-teamcity](https://github.com/MustWay-byte/example-teamcity/tree/feature/add_reply) содержит полный набор изменений.
- Сборка CI/CD (TeamCity) для этой ветки завершена успешно, что подтверждает корректность кода.

*Скриншот коммита в ветке `feature/add_reply` на GitHub*

<img width="835" height="254" alt="image" src="https://github.com/user-attachments/assets/e31c9a88-90bb-40e7-9a88-651b874c0c2a" />

## Задание 13 – Проверка автоматического запуска сборки и успешного прохождения тестов

После пуша изменений в ветку `feature/add_reply` TeamCity автоматически запустил сборку, так как в VCS-триггере настроено отслеживание изменений. Сборка выполнена успешно, все тесты (включая новый тест для метода `getHunterMessage()`) пройдены.

### Результат

- В TeamCity отображается автоматически запущенная сборка для ветки `feature/add_reply`.
- Статус сборки: **Success**.
- Количество пройденных тестов: **6** (включая `testGetHunterMessage()`).
- Шаг `clean test` выполнен в соответствии с условной конфигурацией (задание 4).

*Скриншот страницы сборки TeamCity с видимой веткой `feature/add_reply`, статусом `Success` и блоком `Tests passed: 6`.

<img width="1842" height="459" alt="image" src="https://github.com/user-attachments/assets/e2199df1-b50d-47cd-9066-0c193624ac0d" />

## Задание 14 – Merge ветки `feature/add_reply` в `master`

Изменения из ветки `feature/add_reply` (новый метод `getHunterMessage()` и тест для него) были перенесены в основную ветку `master` с помощью Pull Request на GitHub. После слияния TeamCity автоматически запустил сборку для `master` с шагом `clean deploy`, который успешно загрузил обновлённый артефакт в Nexus.

### Выполненные действия

1. На GitHub в репозитории `example-teamcity` создан Pull Request из `feature/add_reply` в `master`.
2. Pull Request принят и выполнен merge. Ветка `master` получила все коммиты с новым функционалом.
3. TeamCity обнаружил изменения в `master` и автоматически запустил сборку согласно настройкам триггера.
4. Для ветки `master` настроен условный шаг `clean deploy` (задание 4), поэтому после успешного прохождения тестов артефакт был опубликован в Nexus.

### Результат

- Ветка `master` теперь содержит актуальный код с методом `getHunterMessage()` и тестом.
- Сборка `master` прошла успешно (статус `Success`), тесты пройдены.
- В Nexus (репозиторий `maven-releases`) появился обновлённый артефакт `plaindoll-0.0.2.jar` с новой версией.

*Скриншот Pull Request на GitHub*

<img width="1228" height="829" alt="image" src="https://github.com/user-attachments/assets/27f16f88-ab3e-494e-822c-800e4dd25019" />

## Задание 15 – Проверка отсутствия собранного артефакта в сборке по ветке master

В результате успешного выполнения сборки ветки `master` с шагом `clean deploy` артефакт `plaindoll-0.0.2.jar` был опубликован в Nexus, но **не сохранён как артефакт самой сборки в TeamCity**. Это подтверждается пустым списком на вкладке **Artifacts** на странице сборки.

### Что было проверено

- В TeamCity открыта последняя успешная сборка ветки `master` проекта `example-teamcity`.
- На вкладке **Artifacts** отсутствуют какие-либо файлы (нет `.jar`, `.pom` и т.д.).
- При этом в Nexus (репозиторий `maven-releases`) артефакт присутствует и доступен для загрузки.

### Вывод

Настройки CI/CD корректны: артефакт не остаётся в сборке TeamCity, а публикуется только во внешний репозиторий Nexus, что соответствует ожидаемому поведению.

*Скриншот пустой вкладки Artifacts сборки master в TeamCity.

<img width="1084" height="286" alt="image" src="https://github.com/user-attachments/assets/c7db84f0-f401-4d62-9569-2569da4c302c" />

## Задание 16 – Сохранение `.jar` в артефактах сборки

В конфигурацию сборки `Build` добавлен путь к артефактам, чтобы TeamCity сохранял собранный `.jar`-файл и отображал его на вкладке **Artifacts**.  
Попутно устранена ошибка деплоя, связанная с запретом перезаписи артефактов в Nexus.

### Выполненные действия

1. **Настройка Artifact paths**  
   В разделе **General Settings** конфигурации `Build` в поле **Artifact paths** указано:  
   `target/*.jar => .`  
   Это сохраняет все `.jar`-файлы из папки `target` в корень артефактов сборки.

2. **Увеличение версии в `pom.xml`**  
   В репозитории `example-teamcity` изменена версия проекта с `0.0.2` на `0.0.3`, так как Nexus не позволяет повторно загружать уже существующий артефакт.  
   Изменения запушены в ветку `master`.

3. **Повторный запуск сборки**  
   Сборка `master` запущена снова. Шаг `clean deploy` выполнился успешно, новый артефакт `plaindoll-0.0.3.jar` загружен в Nexus.

### Результат

- В TeamCity на вкладке **Artifacts** успешной сборки отображается файл `plaindoll-0.0.3.jar`.
- В Nexus (репозиторий `maven-releases`) появилась новая версия артефакта.

*Скриншот успешной публикации артефактов*

<img width="1779" height="941" alt="image" src="https://github.com/user-attachments/assets/3cee299b-4013-4bfe-8f6f-e560ddcc5293" />
