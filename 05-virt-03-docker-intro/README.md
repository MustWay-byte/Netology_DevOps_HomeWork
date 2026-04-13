# Задача 1

https://hub.docker.com/r/mustway/custom-nginx

<img width="1884" height="890" alt="image" src="https://github.com/user-attachments/assets/05650104-a05e-4382-9992-a4d194bb6128" />

**Создание образа в DockerHub**

# Задача 2

<img width="731" height="53" alt="image" src="https://github.com/user-attachments/assets/d0674271-8483-4f01-9b59-e82b0d9640e0" />

**Запуск контейнера**

<img width="730" height="36" alt="image" src="https://github.com/user-attachments/assets/44fe3edf-2f32-426a-9bcf-0004aa51fba5" />

**Переименование контейнера**

<img width="725" height="216" alt="image" src="https://github.com/user-attachments/assets/6fd2bb96-78f4-4b45-a883-3ec8343755f4" />

**Выполнение команды**

<img width="748" height="424" alt="image" src="https://github.com/user-attachments/assets/dc3d2d66-e7ee-4901-b76a-790ce54d78f4" />

**Доступность индекс страницы**

# Задача 3

<img width="663" height="617" alt="image" src="https://github.com/user-attachments/assets/72b32a78-0e2a-4887-ab44-36516fa07c0d" />

**Подключение к потоку и остановка контейнера**

<img width="1309" height="63" alt="image" src="https://github.com/user-attachments/assets/450be4ce-ada2-4bf5-be5d-9b382d2087c7" />

**Список контейнеров**

При нажатии Ctrl-C был отправлен сигнал "SIGINT", на который процесс nginx отреагировал корректным завершением. В колонке "STATUS" указан код возврата 0, что говорит о штатном, а не аварийном завершении.

<img width="610" height="39" alt="image" src="https://github.com/user-attachments/assets/0b5c2028-dc69-41af-8972-aa95438361bb" />

**Запуск контейнера**

<img width="729" height="42" alt="image" src="https://github.com/user-attachments/assets/c3720ec2-718c-4dbb-b6cf-9ff727aa01e1" />

**Запуск интерактивного терминала при помощи оболочки Bash**

<img width="1532" height="815" alt="image" src="https://github.com/user-attachments/assets/c5f5144d-417b-41bb-acc8-781c2c1a2cf4" />

**Установка текстового редактора nano**

<img width="668" height="822" alt="image" src="https://github.com/user-attachments/assets/f377026f-4656-4047-9760-b4f9aed47a87" />

**Изменение порта веб-сервера**

<img width="786" height="219" alt="image" src="https://github.com/user-attachments/assets/2641bbd6-235f-4020-83cb-fc7027c222b8" />

**Перезапуск контейнера и вывод содержимого индекс страницы**

<img width="201" height="41" alt="image" src="https://github.com/user-attachments/assets/c0f0d203-ed8c-4fa9-90b1-8c38133e01a2" />

**Выход из контейнера**

<img width="632" height="114" alt="image" src="https://github.com/user-attachments/assets/80e0f51e-ec22-4bec-b650-4cd8e9495e98" />

**Ввод команд**

Внутри контейнера были изменены настройки NGINX, и он перестал слушать порт 80, начав слушать порт 81. Проброс порта с хоста остался настроенным на старый порт, и, так как на порту 80 внутри контейнера никто не отвечает, соединение не устанавливается. Это наглядно демонстрирует, что проброс портов - это статическое правило, которое не меняется автоматически при изменении настроек внутри контейнера.

<img width="1189" height="26" alt="image" src="https://github.com/user-attachments/assets/78f8e11b-caec-482f-847c-6021430bc798" />

**Изменение правила маршрутизации для проброса порта**

<img width="617" height="44" alt="image" src="https://github.com/user-attachments/assets/f08e01ea-d39a-49f9-9736-21571f1514af" />

**Удаление запущенного контейнера**

# Задача 4

<img width="1240" height="127" alt="image" src="https://github.com/user-attachments/assets/2fb702e0-890c-4b15-b32a-4e9d74fb81e2" />

**Запуск контейнера CentOS**

<img width="1508" height="164" alt="image" src="https://github.com/user-attachments/assets/68eedbac-3b9f-4333-8771-a3f47c97c988" />

**Запуск контейнера Debian**

<img width="1171" height="27" alt="image" src="https://github.com/user-attachments/assets/dd4b3dc1-f512-4ead-9f92-898442d6d8fb" />

**Создание файла в контейнере**

<img width="739" height="22" alt="image" src="https://github.com/user-attachments/assets/04734b37-1e8c-4ed6-bf15-4ed195b59707" />

**Создание файла на хостовой машине**

<img width="1695" height="383" alt="image" src="https://github.com/user-attachments/assets/63092426-403b-4c8f-be8a-0547b22b0f38" />

**Отображение всех файлов**

# Задача 5

<img width="1401" height="361" alt="image" src="https://github.com/user-attachments/assets/d6fbb9a2-22b9-4d31-8380-18ffbe1cc89a" />

**Создание директории, файлов и запуск портейнера**

Согласно документации Docker Compose, если в директории присутствуют оба файла (compose.yaml и docker-compose.yaml), приоритет имеет compose.yaml. Это стандартное поведение инструмента.

<img width="449" height="214" alt="image" src="https://github.com/user-attachments/assets/8d351c79-d9f8-4d6c-b72e-aa7763b1a102" />

**Отредактированный файл compose.yaml для запуска двух файлов одновременно**

<img width="1123" height="20" alt="image" src="https://github.com/user-attachments/assets/19eb3475-1b22-4c04-bf21-18d61da86005" />

**Создание тега для локального реестра**

<img width="903" height="232" alt="image" src="https://github.com/user-attachments/assets/458e3f13-575b-479e-9210-3437b496525b" />

**Загрузка образа в локальный реестр**

<img width="1838" height="1012" alt="й" src="https://github.com/user-attachments/assets/2a6e670d-aaa5-4508-bdcb-c4fe250b3de4" />

**Создание аккаунта администратора**

<img width="1845" height="1028" alt="image" src="https://github.com/user-attachments/assets/53879b1a-17a2-4073-8580-b3e2f4a6bcd7" />

**Создание контейнера с созданной страницей при помощи портейнера**

<img width="648" height="938" alt="image" src="https://github.com/user-attachments/assets/edf66e73-279f-4a73-888b-67d9487227f8" />

**Информация о контейнере с Nginx**

<img width="1847" height="272" alt="image" src="https://github.com/user-attachments/assets/dc40c9dc-b7fd-4149-a7d3-be0ecdf27ba9" />

**Удаление манифеста и остановка контейнеров**

Ранее в этой директории существовал файл compose.yaml, в котором был описан сервис portainer. Docker Compose запустил контейнер task5-portainer-1 на основе этого описания. Docker Compose обнаружил, что есть запущенные контейнеры, которые не соответствуют ни одному сервису в текущем compose-файле. Такие контейнеры называются осиротевшими. Это предупреждение напоминает, что был случайно удален сервис из конфигурации, и предлагается убрать «осиротевшие» контейнеры с помощью флага --remove-orphans.
