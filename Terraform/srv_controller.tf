# somewhat recent version is needed for DNSimple
terraform {
  required_version = ">= 0.9.3"
}

resource "packet_device" "controller" {
#  count = "${var.server_count}"

  hostname = "${format("ewr%03d", count.index + 1)}"

  plan = "baremetal_1"
  facility = "ewr1"
  operating_system = "centos_7"
#  operating_system = "ubuntu_14_04"
  billing_cycle = "hourly"
  project_id = "${var.packet_project_id}"

  connection {
        type = "ssh"
        user = "root"
        port = 22
        timeout = "${var.ssh-timeout}"
        private_key = "${file("~/.ssh/OpenStackWorkshop.rsa")}"
  }
  
  provisioner "file" {
    source      = "install_openstack.sh"
    destination = "/tmp/install_openstack.sh"
  }

  provisioner "remote-exec" {
       inline = [
        "chmod +x /tmp/install_openstack.sh",
        "/tmp/install_openstack.sh",
       ]
  }
}
