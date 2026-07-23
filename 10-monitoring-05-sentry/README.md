<img width="3770" height="1758" alt="image" src="https://github.com/user-attachments/assets/ce01173f-deb0-4974-b566-d753727e026b" /># Задание 1: Sentry (Free Cloud account)

Зарегистрирован бесплатный облачный аккаунт на [sentry.io](https://sentry.io) с использованием авторизации через GitHub.  
Создан тестовый проект. На скриншоте показан список проектов в интерфейсе Sentry (меню **Projects**).

## Скриншоты

### Меню Projects

<img width="3792" height="1774" alt="image" src="https://github.com/user-attachments/assets/7242566f-2302-4a51-8953-ba4606496bfb" />

# Задание 2: Генерация тестового события и работа с ним

В проекте Sentry сгенерировано тестовое событие «ZeroDivisionError».  
Изучена вкладка **Stack trace** с трассировкой ошибки.  
Событие переведено в статус **Resolved** через список Issues.

## Скриншоты

### Stack trace тестового события

<img width="3731" height="1771" alt="image" src="https://github.com/user-attachments/assets/3597319e-d61e-4ab4-aa98-74de44d83410" />

### Список событий после нажатия Resolved

<img width="3520" height="1756" alt="image" src="https://github.com/user-attachments/assets/87447ee2-8137-4ee6-9eba-a64e35a2ad5d" />

# Задание 3: Настройка алёртинга и получение оповещения

В проекте Sentry создано дефолтное правило алёртинга (без фильтрации по полям).  
После генерации тестового события на привязанную к GitHub-аккаунту почту пришло оповещение.

## Скриншоты

### Тело сообщения из оповещения на почте

<img width="3781" height="1524" alt="image" src="https://github.com/user-attachments/assets/38275dff-b363-4960-be39-37c6ea0b8434" />

# Задание повышенной сложности: Python проект с Sentry SDK

Создан скрипт на Python, который отправляет в Sentry несколько тестовых событий:
- обработанное исключение `ZeroDivisionError`;
- перехваченное исключение `ValueError` с дополнительным контекстом;
- предупреждение через `capture_message`;
- ошибка через стандартный логгер.

Код написан с учётом ограничений Free-аккаунта (не более 5000 ошибок).

## Код подключения SDK и отправки событий

```python
import sentry_sdk
import logging

sentry_sdk.init(
    dsn="<ваш_DSN>",
    traces_sample_rate=1.0,
    environment="development",
    send_default_pii=True,
)

# Обработанное исключение ZeroDivisionError
try:
    1 / 0
except ZeroDivisionError:
    sentry_sdk.capture_exception()

# Перехваченное исключение ValueError с контекстом
try:
    int("не число")
except ValueError as e:
    with sentry_sdk.push_scope() as scope:
        scope.set_tag("feature", "type_conversion")
        scope.set_extra("input_data", "не число")
        sentry_sdk.capture_exception(e)

# Сообщение-предупреждение
with sentry_sdk.push_scope() as scope:
    scope.set_tag("module", "billing")
    scope.set_extra("amount", 150.00)
    sentry_sdk.capture_message("Подозрительная транзакция", level="warning")

# Ошибка через логгер
logger = logging.getLogger("sentry_demo")
logger.error("Ошибка с логгером, отправленная в Sentry")
```

## Скриншоты

### Список Issues после отправки событий

<img width="3784" height="1726" alt="image" src="https://github.com/user-attachments/assets/f916ac4a-10cd-4558-b03a-3e5e847912bb" />

