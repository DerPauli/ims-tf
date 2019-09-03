#!/bin/bash

db_pass=$1
gh_token=$2
graf_pass=$3

sudo apt-get update
sudo apt-get install -y git
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password ${db_pass}"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password ${db_pass}"
sudo apt-get -y install mysql-server

# change bind address in mysql conf
sudo sed -i "s/.*bind-address.*/# bind-address = 127.0.0.1/" /etc/mysql/mysql.conf.d/mysqld.cnf

# fix mysql user
root_fix="GRANT ALL ON *.* to root IDENTIFIED BY '${db_pass}';FLUSH PRIVILEGES;"
mysql -u root -p${db_pass} -e "${root_fix}"

# setup grafana exporter user
graf_user="CREATE USER 'mysqld_exporter' IDENTIFIED BY '${graf_pass}' WITH MAX_USER_CONNECTIONS 5;GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'mysqld_exporter';FLUSH PRIVILEGES;"
mysql -u root -p${db_pass} -e "${graf_user}"

# get repo
git clone https://${gh_token}@github.com/DerPauli/ims-api.git

# install prometheus
useradd -M -r -s /bin/false prometheus
mkdir /etc/prometheus /var/lib/prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.12.0/prometheus-2.12.0.linux-amd64.tar.gz
tar xzf prometheus-2.12.0.linux-amd64.tar.gz
cp prometheus-2.12.0.linux-amd64/{prometheus,promtool} /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/{prometheus,promtool}
cp -r prometheus-2.12.0.linux-amd64/{consoles,console_libraries} /etc/prometheus/
cp prometheus-2.12.0.linux-amd64/prometheus.yml /etc/prometheus/prometheus.yml

# install node_exporter
sudo useradd node_exporter -s /sbin/nologin
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar xvf node_exporter-0.18.1.linux-amd64.tar.gz
sudo cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin

# install mysqld_exporter
sudo useradd mysqld_exporter
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz
tar xvf mysqld_exporter-0.12.1.linux-amd64.tar.gz

sudo mv  mysqld_exporter-0.12.1.linux-amd64/mysqld_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/mysqld_exporter
sudo chown root:prometheus /etc/.mysqld_exporter.cnf


# care about grafana
wget https://dl.grafana.com/oss/release/grafana_6.3.4_amd64.deb
sudo dpkg -i grafana_6.3.4_amd64.deb
sudo apt-get install -f -y
sudo dpkg -i grafana_6.3.4_amd64.deb


# copy all the configs and start/enable the services
cp ims-api/config/prometheus/prometheus.yaml /etc/prometheus/
cp ims-api/config/prometheus/prometheus.service /etc/systemd/system/
cp ims-api/config/prometheus/node_exporter.service /etc/systemd/system


chown -R prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus


# firewall
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 3000
sudo ufw allow 3306
sudo ufw allow https
sudo ufw allow ssh

sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 3000

echo "y" | sudo ufw enable


systemctl daemon-reload
systemctl unmask prometheus

systemctl restart mysql

systemctl start prometheus
systemctl start node_exporter
systemctl start mysqld_exporter
systemctl start grafana-server

systemctl enable prometheus
systemctl enable node_exporter
systemctl enable mysqld_exporter
systemctl enable grafana-server