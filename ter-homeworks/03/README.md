# Задание 1

<img width="853" height="506" alt="image" src="https://github.com/user-attachments/assets/131fe773-2c39-46c8-a482-895103f6490e" />

**Инициализированная группа безопасности**

# Задание 2

<img width="1860" height="283" alt="image" src="https://github.com/user-attachments/assets/c02f49b6-37b7-460c-8063-cf1d7ebc04af" />

**Инициализированные виртуальные машины**

# Задание 3

<img width="1277" height="426" alt="image" src="https://github.com/user-attachments/assets/fbe78e74-a137-45c0-80b5-c1a8098b65d7" />

**Инициализированные диски**

<img width="1854" height="303" alt="image" src="https://github.com/user-attachments/assets/f85fc541-46a1-4f13-9c72-1a2a90b8d64f" />

**Инициализированная виртуальная машина**

# Задание 4

<img width="1428" height="129" alt="image" src="https://github.com/user-attachments/assets/e4aeeb2b-e655-4411-8209-1b29dd2b8922" />

**Содержимое файла "hosts.ini"**

# Задание 5

<img width="705" height="414" alt="image" src="https://github.com/user-attachments/assets/3cf15fd9-3177-4c1b-b788-626029bd4346" />

**Вывод команды "terraform output"**

# Задание 6

<img width="1443" height="638" alt="image" src="https://github.com/user-attachments/assets/eaf05e6b-9add-41aa-9d48-0dffdee90e0b" />

**Работа Ansible**

# Задание 7

<img width="627" height="346" alt="image" src="https://github.com/user-attachments/assets/17be155b-bd76-452e-a5bc-c0eefa055ccd" />

**Обработка выражений**

# Задание 8

Ошибка в шаблоне hosts.tftpl: пропущена закрывающая скобка } у выражения ${i["network_interface"][0]["nat_ip_address"], из-за чего Terraform пытается интерпретировать весь дальнейший текст как часть этого же выражения. Кроме того, в ключе "platform_id " присутствует лишний пробел, что также приведёт к ошибке или некорректному значению.

Исправленный шаблон:

hcl
[webservers]
%{~ for i in webservers ~}
${i["name"]} ansible_host=${i["network_interface"][0]["nat_ip_address"]} platform_id=${i["platform_id"]}
%{~ endfor ~}

Изменения:

1) Добавлена } после ["nat_ip_address"].

2) Убран пробел в ключе "platform_id".

# Задание 9

<img width="591" height="993" alt="image" src="https://github.com/user-attachments/assets/1fdef33f-bbaa-4878-a713-d5e341ee8066" />

**Выражение для формирования первого списка**

<img width="819" height="982" alt="image" src="https://github.com/user-attachments/assets/1d450b86-6b01-419f-b77c-1997d33f03c5" />

**Выражение для формирования второго списка**
