#install mysql dependencies
sudo apt-get install -y mysql-server libmysqlclient-dev

# Create a database and users for airfow
AIRFLOW_DB="airflow_data"
AIRFLOW_USER="airflow_user"
AIRFLOW_PASSWORD="airflow"

sudo mysql -e "CREATE DATABASE ${AIRFLOW_DB} DEFAULT CHARACTER SET utf8;"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'localhost' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'%' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Allow external connections
sudo sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/my.cnf

# Restart mysql to enable new configs
sudo service mysql stop
sudo service mysql start