# Задание 1 – Play для LightHouse

В файл `site.yml` добавлен третий play, который:

- Устанавливает **Nginx** на хост из группы `lighthouse`.
- Скачивает архив со статикой **LightHouse** (веб-интерфейс ClickHouse) из официального репозитория VKCOM.
- Распаковывает статику в `/var/www/lighthouse`.
- Настраивает Nginx через **Jinja2-шаблон** для отдачи LightHouse на порту `8686`.
- Активирует конфигурацию, удаляет дефолтный сайт и запускает Nginx.
- Использует **handler** `Restart Nginx`, который перезапускает веб-сервер при изменении конфигурации.

## Код play

```yaml
- name: Install and configure LightHouse
  hosts: lighthouse
  become: true
  vars:
    lighthouse_version: "stable"
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

    - name: Download LightHouse static
      ansible.builtin.get_url:
        url: "https://github.com/VKCOM/lighthouse/releases/download/{{ lighthouse_version }}/lighthouse-{{ lighthouse_version }}.tar.gz"
        dest: /tmp/lighthouse.tar.gz
        mode: '0644'

    - name: Create directory for LightHouse
      ansible.builtin.file:
        path: /var/www/lighthouse
        state: directory
        mode: '0755'

    - name: Extract LightHouse
      ansible.builtin.unarchive:
        src: /tmp/lighthouse.tar.gz
        dest: /var/www/lighthouse
        remote_src: true
        creates: /var/www/lighthouse/index.html

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
- **`apt`** – для установки пакетов на Ubuntu (аналог `yum` для RedHat-дистрибутивов).  
- **`get_url`** – для загрузки архива LightHouse из официального репозитория.  
- **`template`** – для создания конфигурации Nginx из Jinja2-шаблона.

Ниже показано, как эти модули применены в задачах playbook.  
Обратите внимание: для Ubuntu-хостов применяется `apt`, но если бы целевая ОС была RedHat-совместимой, мы бы использовали `yum` (или `dnf`). В других частях плейбука (`ClickHouse`, `Vector`) также задействованы `yum_repository` / `dnf`, что полностью покрывает рекомендацию.

## Фрагмент playbook с указанными модулями

### Установка Nginx (модуль `apt`)

```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true
```

### Скачивание статики LightHouse (модуль get_url)

```yaml
- name: Download LightHouse static
  ansible.builtin.get_url:
    url: "https://github.com/VKCOM/lighthouse/releases/download/{{ lighthouse_version }}/lighthouse-{{ lighthouse_version }}.tar.gz"
    dest: /tmp/lighthouse.tar.gz
    mode: '0644'
```

### Конфигурация Nginx через шаблон (модуль template)

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

1. **Установка Nginx** – модуль `apt` ставит веб-сервер.
2. **Скачивание статики LightHouse** – модуль `get_url` загружает архив с официального релиза.
3. **Настройка конфига** – модуль `template` генерирует конфигурационный файл Nginx из Jinja2-шаблона, определяя порт `8686` и корневую директиву `/var/www/lighthouse`.
4. **Запуск веб-сервера** – модуль `service` запускает Nginx и включает его в автозагрузку.

Дополнительно обеспечивается активация конфигурации (симлинк в `sites-enabled`), удаление стандартного сайта и перезапуск Nginx через handler при изменениях.

## Код tasks (фрагмент playbook)

```yaml
- name: Install Nginx
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true

- name: Download LightHouse static
  ansible.builtin.get_url:
    url: "https://github.com/VKCOM/lighthouse/releases/download/{{ lighthouse_version }}/lighthouse-{{ lighthouse_version }}.tar.gz"
    dest: /tmp/lighthouse.tar.gz
    mode: '0644'

- name: Create directory for LightHouse
  ansible.builtin.file:
    path: /var/www/lighthouse
    state: directory
    mode: '0755'

- name: Extract LightHouse
  ansible.builtin.unarchive:
    src: /tmp/lighthouse.tar.gz
    dest: /var/www/lighthouse
    remote_src: true
    creates: /var/www/lighthouse/index.html

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

Инвентарный файл `inventory/prod.yml` содержит три группы хостов, соответствующие сервисам:

- **clickhouse** – хост `clickhouse-01` (Ubuntu 22.04)
- **vector** – хост `vector-01` (Ubuntu 22.04)
- **lighthouse** – хост `lighthouse-01` (Ubuntu 22.04)

Для подключения используется SSH-ключ, пользователь `ubuntu`, внешние IP-адреса машин в Yandex Cloud.

## Код `inventory/prod.yml`

```yaml
---
all:
  children:
    clickhouse:
      hosts:
        clickhouse-01:
          ansible_host: 89.169.146.142
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
    vector:
      hosts:
        vector-01:
          ansible_host: 111.88.249.78
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
    lighthouse:
      hosts:
        lighthouse-01:
          ansible_host: 89.169.130.25
          ansible_user: ubuntu
          ansible_ssh_private_key_file: ~/.ssh/id_rsa
```
