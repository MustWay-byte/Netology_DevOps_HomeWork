## Задание 1. Yandex Cloud.

Через Terraform в Yandex Cloud созданы следующие ресурсы.

**KMS-ключ шифрования.** Создан симметричный ключ `bucket-encryption-key` с алгоритмом `AES_256` и периодом ротации 1 год (`8760h`).

**Сервисный аккаунт `sa-storage`.** Создан для работы с Object Storage. Ему выданы роли:
- `storage.admin` — управление бакетами и объектами;
- `storage.configViewer` — чтение политик бакета (без этой роли Terraform не может создать бакет — возвращается `AccessDenied` на этапе проверки политики);
- `kms.keys.encrypterDecrypter` на KMS-ключ — право использовать ключ для шифрования и расшифровки объектов.

Для сервисного аккаунта выпущен статический ключ доступа (access key + secret key).

**Бакет с шифрованием.** Создан бакет `mustway-2026-task2-1791180069` с настройкой `server_side_encryption_configuration`:
- `kms_master_key_id` = ID KMS-ключа;
- `sse_algorithm` = `aws:kms`.

Бакет сделан публичным на чтение (`anonymous_access_flags`: read = true, list = true).

**Объект.** В бакет загружена картинка `images.jpeg` с типом содержимого `image/jpeg` и `acl = "public-read"`.

**Проверка шифрования и доступности**

<img width="727" height="551" alt="image" src="https://github.com/user-attachments/assets/e295e2dd-7598-48f4-9bf3-b5c92e213217" />

**Бакет.** Создан бакет `mustway-site-2026-10-06` в Object Storage Yandex Cloud.

**Статические файлы.** В бакет загружены три файла:
- `index.html` — главная страница сайта;
- `error.html` — страница ошибки (404);
- `images.jpeg` — картинка, отображаемая на главной странице.

**Публичный доступ.** На бакет включены флаги `public-read` и `public-list` — все файлы доступны из интернета без авторизации.

**Статический хостинг.** Через параметр `--website-settings` настроен режим веб-сайта: в качестве индексной страницы указан `index.html`, в качестве страницы ошибки — `error.html`.

**HTTPS.** Сайт работает по HTTPS на публичном адресе Yandex Cloud. Используется сертификат Yandex Cloud, покрывающий домен `*.website.yandexcloud.net`. Сертификат валиден, автоматически продлевается, отображается в браузере как замок без предупреждений.

При открытии в браузере отображается страница с заголовком «Статический сайт в Object Storage», текстом про HTTPS и картинкой из бакета.

В адресной строке браузера — замок. При клике на замок виден валидный сертификат Yandex Cloud на домен `*.website.yandexcloud.net`.

<img width="1189" height="774" alt="image" src="https://github.com/user-attachments/assets/022178f0-c119-41b3-978d-5094354af60a" />

