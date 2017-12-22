resource "aws_launch_configuration" "node" {
  name_prefix   = "etcd-node-config-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"

  security_groups = [
    "${aws_security_group.from_network.id}",
    "${aws_security_group.from_world.id}",
  ]

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

resource "aws_security_group" "from_network" {
  name   = "etcd_from_network"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = "true"
  }
}

resource "aws_security_group" "from_world" {
  name   = "etcd_from_world"
  vpc_id = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
