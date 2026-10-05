## Задание 1. Yandex Cloud.

Через Terraform в Yandex Cloud создан сервисный аккаунт `sa-storage` с ролью `storage.admin`, для него выпущен статический ключ доступа.

Создан бакет Object Storage с именем `mustway-2026-task2-1791180069`.

В бакет загружена картинка `images.jpeg` с типом содержимого `image/jpeg`.

Бакет сделан публичным на чтение (`anonymous_access_flags`: read = true, list = true), объекту выставлен `acl = "public-read"`, что делает файл доступным из интернета без авторизации.

**Картинка доступная из Интернета**

<img width="1203" height="761" alt="image" src="https://github.com/user-attachments/assets/5ad7d373-1fe6-4696-be88-4770ea6afe42" />

Через Terraform создана Instance Group `lamp-ig` фиксированного размера (3 ВМ) в зоне `ru-central1-a`, в публичной подсети `public`.

Каждая ВМ:
- создана из образа LAMP (`image_id = fd827b91d99psvq5fjit`);
- имеет публичный IP (`nat = true`);
- в `user-data` прописан `#cloud-config`, который пишет стартовую страницу `/var/www/html/index.html` с HTML-шаблоном и ссылкой на картинку из бакета Object Storage;
- входит в группу безопасности `lamp-sg` (SSH, HTTP, ICMP).

Три инстанса в статусе `RUNNING_ACTUAL`, группа — `ACTIVE`, target_size = running_actual_count = 3.

Страница доступна по публичным IP каждой ВМ — все отвечают `HTTP 200`:

**Доступность веб-страницы**
<img width="735" height="504" alt="image" src="https://github.com/user-attachments/assets/96f81f10-9bb0-4a06-a8d4-224c63ad6a3c" />
