/usr/bin/systemctl enable docker
/usr/bin/systemctl disable nginx
/usr/bin/systemctl disable apache2
/usr/bin/apt install docker-compose
sudo /usr/sbin/groupadd docker
sudo /usr/sbin/usermod -aG docker mvlabs