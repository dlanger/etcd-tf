data "ignition_config" "init" {
  systemd = [
    "${data.ignition_systemd_unit.etcd.id}",
    "${data.ignition_systemd_unit.etcd_bootstrap.id}",
  ]

  files = [
    "${data.ignition_file.etcd_bootstrap.id}",
  ]
}

data "ignition_systemd_unit" "etcd" {
  name = "etcd-member.service"

  dropin {
    name    = "20-etcd-member.conf"
    content = "${file("cloud-init/etcd.unit")}"
  }
}

data "ignition_file" "etcd_bootstrap" {
  filesystem = "root"
  path       = "/opt/etcd-bootstrap"
  mode       = "365"                 # Decimal of 0555

  content {
    content = "${file("cloud-init/etcd-bootstrap")}"
  }
}

data "ignition_systemd_unit" "etcd_bootstrap" {
  name    = "etcd-bootstrap.service"
  content = "${file("cloud-init/etcd-bootstrap.unit")}"
}
