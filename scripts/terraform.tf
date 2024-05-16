resource "aws_instance" "test-server" {
  ami           = "ami-0bb84b8ffd87024d8" 
  instance_type = "t2.micro" 
  key_name = "jenkinm"
  vpc_security_group_ids= ["sg-0c6ce131ed5f2c0c5"]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./jenkinm.pem")
    host     = self.public_ip
  }
  provisioner "remote-exec" {
    inline = [ "echo 'wait to start instance' "]
  }
  tags = {
    Name = "test-server"
  }
  provisioner "local-exec" {
        command = " echo ${aws_instance.test-server.public_ip} > inventory "
  }
   provisioner "local-exec" {
  command = "ansible-playbook /var/lib/jenkins/workspace/banking/scripts/banking-playbook.yml "
  } 
}
