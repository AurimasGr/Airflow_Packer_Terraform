sudo apt-get install -y mysql-server libmysqlclient-dev

AIRFLOW_DB="airflow_data"
AIRFLOW_USER="airflow_user"
AIRFLOW_PASSWORD="airflow"

sudo mysql -e "CREATE DATABASE ${AIRFLOW_DB} DEFAULT CHARACTER SET utf8;"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'localhost' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'%' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "FLUSH PRIVILEGES;"