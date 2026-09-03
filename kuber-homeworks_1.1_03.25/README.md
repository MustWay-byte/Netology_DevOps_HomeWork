# Задание 1. Установка MicroK8S

## 1. Установка MicroK8S

На виртуальной машине Ubuntu был установлен MicroK8S. Для управления кластером без sudo текущий пользователь добавлен в группу `microk8s`. После запуска кластер перешёл в состояние `running`.

**Состояние MicroK8S**

<img width="888" height="596" alt="image" src="https://github.com/user-attachments/assets/a3655429-4880-4b4a-bda5-a668446da6aa" />

## 2. Установка Dashboard

Был включён аддон `dashboard`, а также `dns`, `ingress` и `storage`. Создан административный ServiceAccount и назначена роль `cluster-admin`. Сгенерирован токен для входа в Dashboard. Для доступа к веб-интерфейсу использован `port-forward`, который пробрасывает порт Dashboard на внешний интерфейс. Dashboard доступен по адресу `https://<IP-адрес-ВМ>:10443`.

**Веб-интерфейс `dashboard`**

<img width="1845" height="1758" alt="image" src="https://github.com/user-attachments/assets/f765a809-f42d-4127-96c6-f58c47c35400" />

## 3. Генерация сертификата для подключения к внешнему IP-адресу

Был сгенерирован самоподписанный SSL-сертификат с указанием внешнего IP в поле Subject Alternative Name (SAN). Сертификат и ключ помещены в Secret `kubernetes-dashboard-certs`, после чего под Dashboard перезапущен для применения нового сертификата. Теперь при обращении к Dashboard по IP не возникает ошибки несовпадения имени сертификата, хотя браузер всё ещё предупреждает о недоверенном самоподписанном центре.

**Сгенерированный сертификат**

<img width="1710" height="1004" alt="image" src="https://github.com/user-attachments/assets/ab33d459-0357-411f-9179-eff12bcf882e" />

## Итог

- MicroK8S успешно запущен.
- Dashboard установлен и доступен.
- Сертификат с SAN сгенерирован и применён.
- Вход в Dashboard выполняется по токену администратора.

# Задание 2. Установка и настройка локального kubectl

## 1. Установка kubectl

На локальную машину (виртуальную машину с MicroK8S) был установлен `kubectl`. Для установки использовался пакетный менеджер `snap` (команда `sudo snap install kubectl --classic`), как наиболее простой и не требующий ручного добавления репозиториев. После установки выполнена проверка версии клиента (`kubectl version --client`), подтвердившая работоспособность утилиты.

**Версия установленного kubectl**

<img width="591" height="58" alt="image" src="https://github.com/user-attachments/assets/63461405-8184-4679-863b-82b49079321c" />

## 2. Настройка локального подключения к кластеру

Для подключения kubectl к кластеру MicroK8S был получен конфигурационный файл (`kubeconfig`). Так как kubectl устанавливался на той же машине, где работает MicroK8S, команда `microk8s config` была перенаправлена в файл `~/.kube/config`. После этого kubectl начал использовать этот конфиг по умолчанию. Для проверки подключения выполнена команда `kubectl get nodes`, которая успешно отобразила узел кластера в статусе `Ready`.

**Проверка подключения узла кластера**

<img width="534" height="59" alt="image" src="https://github.com/user-attachments/assets/c07ec6f7-a2a5-4e85-b79e-baebbce55bfd" />

## 3. Подключение к Dashboard с помощью port-forward

Для доступа к Kubernetes Dashboard с локальной машины был запущен проброс порта с помощью команды `kubectl port-forward`. Эта команда перенаправила локальный порт `10443` на порт `443` сервиса `kubernetes-dashboard` в namespace `kube-system`. После этого в браузере открыт адрес `https://localhost:10443` (или `https://<IP-адрес-ВМ>:10443`). Для входа в интерфейс использован ранее созданный токен администратора.

**Проброс порта `10443` на порт `443`**

<img width="1109" height="70" alt="image" src="https://github.com/user-attachments/assets/a0788f5c-e235-4648-9359-e786147f5658" />

## Итог

- kubectl установлен и работает.
- Локальное подключение к кластеру MicroK8S настроено.
- Доступ к Dashboard обеспечен через port-forward.
