#!/bin/bash
set -e
DOCKER_DIR="docker"
PLAYBOOK_DIR="playbook"
INVENTORY="inventory/prod.yml"
VAULT_PASSWORD_FILE="/tmp/vault_pass.txt"
cd "$(dirname "$0")/${DOCKER_DIR}"
docker build -t ansible_ubuntu -f Dockerfile.ubuntu .
docker build -t ansible_rocky -f Dockerfile.rocky .
docker build -t ansible_fedora -f Dockerfile.fedora .
docker stop ubuntu_host rocky_host fedora_host 2>/dev/null || true
docker rm ubuntu_host rocky_host fedora_host 2>/dev/null || true
docker run -d --name ubuntu_host -p 2222:22 ansible_ubuntu
docker run -d --name rocky_host -p 2223:22 ansible_rocky
docker run -d --name fedora_host -p 2224:22 ansible_fedora

docker exec rocky_host rm -f /run/nologin
docker exec fedora_host /usr/sbin/sshd -D &>/dev/null &
sleep 2

cd "../${PLAYBOOK_DIR}"
export ANSIBLE_HOST_KEY_CHECKING=False
for host in deb_host el_host fedora_host; do
    echo -n "Ожидание $host..."
    for i in {1..30}; do
        if ansible $host -i inventory/prod.yml -m ping &>/dev/null; then
            echo " готов"
            break
        fi
        sleep 2
    done
done
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2222" 2>/dev/null || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2223" 2>/dev/null || true
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "[localhost]:2224" 2>/dev/null || true
read -s -p "Введите пароль vault (netology): " VAULT_PASS
echo
echo -n "$VAULT_PASS" > "$VAULT_PASSWORD_FILE"
ansible-playbook -i inventory/prod.yml site.yml --vault-password-file "$VAULT_PASSWORD_FILE"
rm -f "$VAULT_PASSWORD_FILE"
cd "../${DOCKER_DIR}"
docker stop ubuntu_host rocky_host fedora_host
docker rm ubuntu_host rocky_host fedora_host
echo "Готово."
