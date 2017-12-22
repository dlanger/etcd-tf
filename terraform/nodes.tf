resource "aws_launch_configuration" "node" {
  name_prefix   = "etcd-node-config-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"

  associate_public_ip_address = "true" # TODO: remove me

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nodes" {
  name_prefix          = "etcd-nodes-"
  max_size             = "${var.cluster_size + 1}"
  min_size             = "${var.cluster_size}"
  vpc_zone_identifier  = "${var.subnet_ids}"
  default_cooldown     = "60"
  launch_configuration = "${aws_launch_configuration.node.id}"

  tags = [
    {
      key                 = "${var.tag_name}"
      value               = "etcd"
      propagate_at_launch = true
    },
    {
      key                 = "Name"
      value               = "etcd-node"
      propagate_at_launch = "true"
    },
  ]
}
