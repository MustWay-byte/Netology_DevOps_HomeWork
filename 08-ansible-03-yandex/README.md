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

