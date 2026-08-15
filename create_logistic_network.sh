#!/bin/bash


VPC_NAME="logistic"


echo "Создание VPC $VPC_NAME"
yc vpc network create --name $VPC_NAME

echo "Получение ID созданной сети"
VPC_ID=$(yc vpc network list | grep $VPC_NAME | cut -d'|' -f2)

echo "Создание подсети nat-instance-subnet и public-servers"
yc vpc subnet create \
  --name nat-instance-subnet \
  --network-id $VPC_ID \
  --zone ru-central1-d \
  --range 10.140.0.0/24

yc vpc subnet create \
  --name public-servers \
  --network-id $VPC_ID \
  --zone ru-central1-d \
  --range 10.120.0.0/24 

echo "Создание NAT-инстанса"
yc compute instance create \
  --name nat-instance \
  --hostname nat-instance \
  --zone ru-central1-d \
  --network-interface subnet-name=nat-instance-subnet,nat-ip-version=ipv4,ipv4-address=10.140.0.10 \
  --create-boot-disk image-id=fd8aujl9olvkde2f2104,size=10 \
  --ssh-key ~/.ssh/id_ed25519.pub

echo "Создание таблицы маршрутизации"
yc vpc route-table create \
  --name nat-instance-route \
  --network-name logistic \
  --route destination=0.0.0.0/0,next-hop=10.140.0.10

echo "Привязка таблицы к подсети public-servers"
yc vpc subnet update \
  --name public-servers \
  --route-table-name nat-instance-route
