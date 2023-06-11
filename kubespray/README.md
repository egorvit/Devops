# Подготовка ноды
## Поднять сеть

``` bash 
nano /etc/network/interfaces

```
auto eth0
iface eth0 inet static
  address 'адрес'
  netmask 'маска'
  gateway 'шлюз'
```

systemctl restart networking
```

## Обновление пакетов

```bash
sudo apt-get update
sudo apt-get upgrade
```

## Отключить своп 
``` bash
swapoff -a (only k8s)
```

## Настроить подключение по публичному ключу

``` bash
cat ~/.ssh/id_rsa.pub # узнать свой public key
mkdir -p /root/.ssh
chmod 700 /root/.ssh
echo 'ssh-ключ' >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
```

## Вход только по ssh ключу
``` bash
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/KbdInteractiveAuthentication yes/KbdInteractiveAuthentication no/g' /etc/ssh/sshd_config
systemctl restart sshd
```

## Создание PV
``` bash
DATA_DEVICE=/dev/sdb1
APPEND_FOLDERS_COUNT=10
DATA_FOLDER=/data

DISK_UUID=$(blkid -s UUID -o value $DATA_DEVICE)
echo $DISK_UUID
blkid | grep $DISK_UUID
PVS_DATA_FOLDER=${DATA_FOLDER}/k8s-disk_${DISK_UUID}
CURRENT_FOLDERS_COUNT=$(ls $PVS_DATA_FOLDER | wc -l)
END_FOLDER_NUMBER=$((CURRENT_FOLDERS_COUNT + APPEND_FOLDERS_COUNT - 1))
for i in $(seq $CURRENT_FOLDERS_COUNT $END_FOLDER_NUMBER); do
  mkdir -p ${PVS_DATA_FOLDER}/vol${i} /mnt/disks/${DISK_UUID}_vol${i}
  echo "${PVS_DATA_FOLDER}/vol${i} /mnt/disks/${DISK_UUID}_vol${i} none defaults,bind 0 0" | tee -a /etc/fstab
done
mount -a
```

<!-- ----------------------------------
ЧТО ДЕЛАЕТ СКРИПТ

Скрипт создает каталоги для хранения данных k8s Resistent Volume (PV) и монтирует их в /mnt/disks. local-volume-provisioner при обнаружении в /mnt/disks новых монтирований автоматически добавляет доступные PV в k8s. Скрипт всегда добавляет новые каталоги при каждом запуске на настроенное количество в переменной “APPEND_FOLDERS_COUNT”. В переменной “DATA_DEVICE” необходимо указать путь до блочного устройства, который подмонтирован в каталог “DATA_FOLDER”. Переменная “DATA_FOLDER” содержит фактический каталог, в котором будут храниться данные PV. -->




# Установка кластера

## Клонируем kubespray и редактируем файл инвентори
``` bash
git clone https://github.com/kubernetes-sigs/kubespray.git
git checkout release-'version' 
cd kubespray
# Делаем копию папки /kubespray/inventory/sample
# Редактируем инвентори файл по пути /kubespray/inventory/mycluster/inventory.ini
# Для того, чтобы поднялся ingress controler, перходим в /kubespray/inventory/mycluster/group_vars/k8s_cluster/addons.yml и стави флаг ingress_nginx_enabled - в true
```

## Установка через докер контейнер 
``` bash
docker pull quay.io/kubespray/kubespray:v2.18.0

docker run -it -v /Users/olegpk/kubespray-2.18.0/inventory/mycluster:/kubespray/inventory/k8s01 -v ~/.ssh/id_rsa:/root/.ssh/id_rsa quay.io/kubespray/kubespray:v2.18.0 bash

ansible-playbook -i inventory/k8s01 cluster.yml -v 
```

## Получение kubeconfig для Lens
```bash

kubectl -n kube-system create serviceaccount elebedev

kubectl create clusterrolebinding elebedev-superadmin --clusterrole=cluster-admin --serviceaccount=kube-system:elebedev

kubectl get serviceaccounts elebedev -o yaml -n kube-system

kubectl describe secret -n kube-system  elevedev-token-pgfnv | grep "token"

kubectl config view --flatten --minify | grep "certificate-authority-data"
```