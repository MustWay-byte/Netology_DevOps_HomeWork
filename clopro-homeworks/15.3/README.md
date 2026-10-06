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

**Проверка шифрования**

<img width="728" height="550" alt="image" src="https://github.com/user-attachments/assets/4e5ae76c-53fc-4eab-87a1-d50ae799d3f4" />
