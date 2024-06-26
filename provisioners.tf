resource "null_resource" "mongo_user_setup" {
  depends_on = [aws_instance.mongodb]

  provisioner "remote-exec" {
    inline = [
      "mongo --eval 'db.createUser({user:\"admin\",pwd:\"password123\",roles:[{role:\"userAdminAnyDatabase\",db:\"admin\"}]})'",
      "sudo sed -i '/#security:/a\\security:\\n  authorization: \"enabled\"' /etc/mongod.conf",
      "sudo systemctl restart mongod"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = var.private_key_path
      host        = aws_instance.mongodb.public_ip
    }
  }
}
