data "ignition_config" "init" {
    systemd = [
        "${data.ignition_systemd_unit.etcd.id}",
    ]
}

data "ignition_systemd_unit" "etcd" {
    name = "etcd.service"
    content = "${file("cloud-init/hello-world.unit")}"
}

output "cloud-init" {
  value = "${data.ignition_config.init.rendered}"
}
