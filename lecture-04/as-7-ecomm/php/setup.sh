#!/bin/bash

/usr/bin/cp /etc/postgresql/12/main/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf.bkp
/usr/bin/cp /srv/apps/its-web-2020/lecture-01/ansible/files/etc/postgresql/12/main/pg_hba.conf /etc/postgresql/12/main/pg_hba.conf
/usr/sbin/service postgresql restart

echo "Creating DB..."
/usr/bin/su - postgres -c "/usr/bin/psql -U postgres < /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/scripts/create-db.sql"

echo "Creating Schema..."
/usr/bin/su - postgres -c 'PGPASSWORD=mvlabs /usr/bin/psql -U mvlabs ecommerce < /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/scripts/db-dump.sql'

echo "Enabling Web Server..."
/usr/bin/cp ./apache2/as5.conf /etc/apache2/sites-available
/usr/sbin/a2ensite as5 
/usr/bin/systemctl reload apache2

echo "Populating with Data..."
/usr/bin/su - postgres -c '/usr/bin/php /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/scripts/filldata.php'

echo "Initializing PHP App"
/usr/bin/su - mvlabs -c '/usr/bin/wget https://getcomposer.org/installer'
/usr/bin/su - mvlabs -c '/usr/bin/mv installer /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/public/composer-setup.php'
/usr/bin/su - mvlabs -c '/usr/bin/php /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/public/composer-setup.php'
/usr/bin/su - mvlabs -c '/usr/bin/rm /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/public/composer-setup.php'
/usr/bin/su - mvlabs -c '/usr/bin/cp /home/mvlabs/composer.phar /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/public/'
/usr/bin/su - mvlabs -c 'cd /srv/apps/its-web-2020/lecture-02/as-5-ecommerce/php/public && /usr/bin/php ./composer.phar install'
