# Create a database and users for airfow
AIRFLOW_DB="airflow_data"
AIRFLOW_USER="airflow_user"
AIRFLOW_PASSWORD="airflow"

sudo mysql -e "CREATE DATABASE ${AIRFLOW_DB} DEFAULT CHARACTER SET utf8;"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'localhost' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "GRANT ALL ON ${AIRFLOW_DB}.* TO '${AIRFLOW_USER}'@'%' IDENTIFIED BY '${AIRFLOW_PASSWORD}';"
sudo mysql -e "FLUSH PRIVILEGES;"

sudo pip3 install apache-airflow[mysql,rabbitmq,celery]
airflow initdb

sudo sed -i 's|.*executor =.*|executor = LocalExecutor|' /home/ubuntu/airflow/airflow.cfg
sudo sed -i 's|.*sql_alchemy_conn =.*|sql_alchemy_conn = mysql://airflow_user:airflow@localhost:3306/airflow_data|' /home/ubuntu/airflow/airflow.cfg

airflow initdb

# Allow external connections
sudo sed -i "s|.*bind-address.*|bind-address = 0.0.0.0|" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i '/bind-address = 0.0.0.0/a explicit_defaults_for_timestamp = 1' /etc/mysql/mysql.conf.d/mysqld.cnf

# Restart mysql to enable new configs
sudo service mysql stop
sudo service mysql start

