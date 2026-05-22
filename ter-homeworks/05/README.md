# Задание 0

Идея успешно распространена.

# Задание 1

<img width="1183" height="669" alt="image" src="https://github.com/user-attachments/assets/481d1a22-a7a4-44aa-a856-2a37ef145850" />

**Проверка кода при помощи tflint**

<img width="1005" height="943" alt="image" src="https://github.com/user-attachments/assets/8f35c5d5-3bae-4215-a68e-1f321ccb48e5" />

**Проверка кода при помощи checkov**

Ошибки:

1) Отсутствие версионирования модулей (CKV_TF_1 / CKV_TF_2)
Модули test-vm и example-vm ссылаются на GitHub-репозиторий без указания конкретной версии (тега или коммит-хеша), а используют ветку main. Это делает сборку невоспроизводимой.
Обнаружено checkov в 04/demonstration1/vms/main.tf.

2) Отсутствие ограничения версии провайдера в required_providers
В 04/src/providers.tf для провайдера yandex не указана версия. Это может привести к установке непредвиденной версии и нарушению стабильности.
Обнаружено tflint (правило terraform_required_providers).

3) Объявленные, но неиспользуемые переменные
В 04/src/variables.tf определены переменные vms_ssh_root_key, vm_web_name и vm_db_name, которые нигде не используются в коде. Это «мёртвый код», усложняющий поддержку.
Обнаружено tflint (правило terraform_unused_declarations).

# Задание 2

<img width="1785" height="890" alt="image" src="https://github.com/user-attachments/assets/ef42ffb0-3564-4087-8b2c-bde09e1c25c4" />

**Процесс миграции**

<img width="1481" height="486" alt="image" src="https://github.com/user-attachments/assets/ecefc8ab-14a7-4657-8695-490fedbdf698" />

**Ошибка state lock**

<img width="731" height="255" alt="image" src="https://github.com/user-attachments/assets/0a2185bd-eb61-43d6-9865-289b34f2b872" />

**Освобождение state lock**

# Задание 3

Ссылка на Pull Request: https://github.com/MustWay-byte/Netology_DevOps_HomeWork/pull/2

# Задание 4

<img width="758" height="871" alt="image" src="https://github.com/user-attachments/assets/34874c16-4352-4d29-adee-c1f4c9213251" />

**Тестирование валидации**

# Задание 5

<img width="758" height="905" alt="image" src="https://github.com/user-attachments/assets/8c9d2b00-5d7c-462b-a385-f528e1006336" />

**Тестирование валидации**

# Задание 6
