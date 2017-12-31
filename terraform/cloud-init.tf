data "ignition_config" "init" {
  systemd = [
    "${data.ignition_systemd_unit.etcd.id}",
  ]
}

data "ignition_systemd_unit" "etcd" {
  name = "etcd-member.service"

  dropin {
    name    = "20-etcd-member.conf"
    content = "${data.template_file.etcd_unit.rendered}"
  }
}

data "template_file" "etcd_unit" {
  template = "${file("cloud-init/etcd.unit")}"

  vars {
    cluster_name = "${var.etcd_cluster_name}"
  }
}
