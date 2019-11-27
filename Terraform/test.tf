provider "aws" {
  profile = "aws_test"
  region  = var.region
}

resource "aws_instance" "airflow_server" {
  ami = var.server_ami
  instance_type = var.server_instance_type
  key_name = "aurimas.griciunas.test"
  iam_instance_profile = "EMR_EC2_DefaultRole"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.aws_key_path)
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's|.*executor =.*|executor = ${var.executor_type}|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*sql_alchemy_conn =.*|sql_alchemy_conn = mysql://airflow_user:airflow@${self.private_ip}:3306/airflow_data|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*result_backend =.*|result_backend = db+mysql://airflow_user:airflow@${self.private_ip}:3306/airflow_data|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*broker_url =.*|broker_url = pyamqp://airflow_user:airflow@${self.private_ip}:5672/|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*bind-address.*|bind-address = ${var.mysql_exposure[var.executor_type]}|' /etc/mysql/mysql.conf.d/mysqld.cnf",
      "sudo systemctl restart mysql",
      "sudo supervisorctl restart airflowserver",
      "sudo supervisorctl restart airflowscheduler",
      "sudo supervisorctl restart airflowflower"
    ]
  }
}


resource "aws_instance" "airflow_worker" {
  ami = var.worker_ami
  instance_type = var.worker_instance_type
  key_name = "aurimas.griciunas.test"
  iam_instance_profile = "EMR_EC2_DefaultRole"

  connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file(var.aws_key_path)
    agent = true
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i 's|.*executor =.*|executor = ${var.executor_type}|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*sql_alchemy_conn =.*|sql_alchemy_conn = mysql://airflow_user:airflow@${aws_instance.airflow_server.private_ip}:3306/airflow_data|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*result_backend =.*|result_backend = db+mysql://airflow_user:airflow@${aws_instance.airflow_server.private_ip}:3306/airflow_data|' /home/ubuntu/airflow/airflow.cfg",
      "sudo sed -i 's|.*broker_url =.*|broker_url = pyamqp://airflow_user:airflow@${aws_instance.airflow_server.private_ip}:5672/|' /home/ubuntu/airflow/airflow.cfg",
      "sudo supervisorctl restart airflowworker"
    ]
  }
}
