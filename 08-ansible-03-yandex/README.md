# Задание 1 – Play для LightHouse

В файл `site.yml` добавлен третий play, который:

- Устанавливает **Nginx** и **unzip** на хост из группы `lighthouse`.
- Скачивает ZIP-архив с актуальной версией **LightHouse** (ветка `master`) из репозитория VKCOM.
- Распаковывает архив во временную папку и копирует файлы в `/var/www/lighthouse`.
- Настраивает Nginx через **Jinja2-шаблон** для отдачи LightHouse на порту `8686`.
- Активирует конфигурацию, удаляет дефолтный сайт и запускает Nginx.
- Использует **handler** `Restart Nginx`, который перезапускает веб-сервер при изменении конфигурации.

## Код play (финальная версия)

```yaml
- name: Install and configure LightHouse
  hosts: lighthouse
  become: true
  handlers:
    - name: Restart Nginx
      ansible.builtin.service:
        name: nginx
        state: restarted
      listen: "Restart nginx"
  tasks:
    - name: Install Nginx
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true

    - name: Install unzip (required to extract Lighthouse)
      ansible.builtin.apt:
        name: unzip
        state: present

    - name: Download LightHouse (master branch)
      ansible.builtin.get_url:
        url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
        dest: /tmp/lighthouse.zip
        mode: '0644'

    - name: Create directory for LightHouse
      ansible.builtin.file:
        path: /var/www/lighthouse
        state: directory
        mode: '0755'

    - name: Extract LightHouse
      ansible.builtin.unarchive:
        src: /tmp/lighthouse.zip
        dest: /tmp
        remote_src: true
        creates: /tmp/lighthouse-master/index.html

    - name: Copy Lighthouse files to web root
      ansible.builtin.shell: |
        cp -r /tmp/lighthouse-master/* /var/www/lighthouse/
      args:
        creates: /var/www/lighthouse/index.html
      changed_when: false

    - name: Configure Nginx for LightHouse
      ansible.builtin.template:
        src: nginx.conf.j2
        dest: /etc/nginx/sites-available/lighthouse
        mode: '0644'
      notify: Restart Nginx

    - name: Enable Nginx site
      ansible.builtin.file:
        src: /etc/nginx/sites-available/lighthouse
        dest: /etc/nginx/sites-enabled/lighthouse
        state: link
      notify: Restart Nginx

    - name: Remove default Nginx site
      ansible.builtin.file:
        path: /etc/nginx/sites-enabled/default
        state: absent
      notify: Restart Nginx

    - name: Start Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

# Задание 2 – Использование рекомендованных модулей

При написании play для LightHouse использованы модули:

1) apt – для установки Nginx и unzip.

2) get_url – для загрузки архива LightHouse из репозитория.

3) template – для создания конфигурации Nginx из Jinja2-шаблона.

Для установки пакетов на Ubuntu используется apt; если бы целевая ОС была RedHat-совместимой, применялся бы yum / dnf.

## Установка Nginx и unzip (модуль apt)
```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

- name: Install unzip
  ansible.builtin.apt:
    name: unzip
    state: present
```

## Скачивание LightHouse (модуль get_url)
```yaml
- name: Download LightHouse (master branch)
  ansible.builtin.get_url:
    url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
    dest: /tmp/lighthouse.zip
    mode: '0644'
```

## Конфигурация Nginx через шаблон (модуль template)
```yaml
- name: Configure Nginx for LightHouse
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/sites-available/lighthouse
    mode: '0644'
  notify: Restart Nginx
```

# Задание 3 – Tasks: скачать статику LightHouse, установить Nginx, настроить конфиг, запустить веб-сервер

В play «Install and configure LightHouse» последовательно выполняются следующие задачи, реализующие все требуемые шаги:

1) Установка Nginx – модуль apt ставит веб-сервер.

2) Установка unzip – модуль apt устанавливает утилиту для распаковки ZIP.

3) Скачивание LightHouse – модуль get_url загружает архив master.zip.

4) Распаковка и копирование файлов – unarchive извлекает архив во временную папку, затем shell копирует содержимое в /var/www/lighthouse.

5) Настройка конфига – модуль template генерирует конфигурационный файл Nginx из Jinja2-шаблона, определяя порт 8686 и корневую директиву /var/www/lighthouse.

6) Запуск веб-сервера – активация сайта, удаление дефолтного конфига и запуск Nginx с автозагрузкой.

Дополнительно используется handler Restart Nginx для перезапуска сервиса при изменении конфигурации.

## Код tasks (фрагмент playbook)
```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

- name: Install unzip
  ansible.builtin.apt:
    name: unzip
    state: present

- name: Download LightHouse (master branch)
  ansible.builtin.get_url:
    url: "https://github.com/VKCOM/lighthouse/archive/refs/heads/master.zip"
    dest: /tmp/lighthouse.zip
    mode: '0644'

- name: Create directory for LightHouse
  ansible.builtin.file:
    path: /var/www/lighthouse
    state: directory
    mode: '0755'

- name: Extract LightHouse
  ansible.builtin.unarchive:
    src: /tmp/lighthouse.zip
    dest: /tmp
    remote_src: true
    creates: /tmp/lighthouse-master/index.html

- name: Copy Lighthouse files to web root
  ansible.builtin.shell: |
    cp -r /tmp/lighthouse-master/* /var/www/lighthouse/
  args:
    creates: /var/www/lighthouse/index.html
  changed_when: false

- name: Configure Nginx for LightHouse
  ansible.builtin.template:
    src: nginx.conf.j2
    dest: /etc/nginx/sites-available/lighthouse
    mode: '0644'
  notify: Restart Nginx

- name: Enable Nginx site
  ansible.builtin.file:
    src: /etc/nginx/sites-available/lighthouse
    dest: /etc/nginx/sites-enabled/lighthouse
    state: link
  notify: Restart Nginx

- name: Remove default Nginx site
  ansible.builtin.file:
    path: /etc/nginx/sites-enabled/default
    state: absent
  notify: Restart Nginx

- name: Start Nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

# Задание 4 – Подготовьте свой inventory-файл `prod.yml`

Инвентарный файл inventory/prod.yml содержит три группы хостов, соответствующие сервисам, развёрнутым в Docker-контейнерах на локальной машине:

1) clickhouse – хост clickhouse-01 (Ubuntu 22.04, порт 2222)

2) vector – хост vector-01 (Ubuntu 22.04, порт 2223)

3) lighthouse – хост lighthouse-01 (Ubuntu 22.04, порт 2224)

Подключение по SSH с пользователем ansible и паролем ansible.

## Код inventory/prod.yml

```yaml
---
all:
  children:
    clickhouse:
      hosts:
        clickhouse-01:
          ansible_host: localhost
          ansible_port: 2222
          ansible_user: ansible
          ansible_password: ansible
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    vector:
      hosts:
        vector-01:
          ansible_host: localhost
          ansible_port: 2223
          ansible_user: ansible
          ansible_password: ansible
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
    lighthouse:
      hosts:
        lighthouse-01:
          ansible_host: localhost
          ansible_port: 2224
          ansible_user: ansible
          ansible_password: ansible
          ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```

# Задание 5 – Запуск `ansible-lint site.yml` и исправление ошибок

Для проверки playbook на соответствие стандартам используется ansible-lint.

**Запуск ansible-lint**

<img width="1025" height="100" alt="image" src="https://github.com/user-attachments/assets/308aeddd-f989-45ee-9649-71d687e7ee0d" />

# Задание 6 – Запуск playbook с флагом `--check`

Флаг `--check` выполняет сухую проверку (dry-run): Ansible покажет планируемые изменения, но не будет вносить реальных правок.
Это позволяет убедиться в корректности playbook.

**Запуск проверки Playbook**

<img width="1042" height="1005" alt="image" src="https://github.com/user-attachments/assets/d0d196a5-d0cf-4565-8fe9-0110a957f8e2" />

# Задание 7 – Запуск playbook с флагом `--diff`

Флаг `--diff` показывает изменения в конфигурационных файлах при выполнении playbook.  
При первом запуске (после очистки состояния или на свежих хостах) видны добавленные строки в настройках Nginx и другие правки, вносимые Ansible.

**Первый запуск Playbook с отображением изменений**

<img width="1048" height="1002" alt="image" src="https://github.com/user-attachments/assets/ae44a853-1140-4fc5-9a11-2cd52e8a43ff" />

