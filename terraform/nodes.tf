resource "aws_launch_configuration" "node" {
  name_prefix   = "etcd-node-config-"
  image_id      = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"
  user_data     = "${data.ignition_config.init.rendered}"

  security_groups = [
    "${aws_security_group.etcd_nodes.id}",
  ]

  associate_public_ip_address = "true" # TODO: remove me

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "nodes" {
  name_prefix          = "etcd-nodes-"
  max_size             = "${coalesce(var.cluster_size, length(var.subnet_ids)) + 1}"
  min_size             = "${coalesce(var.cluster_size, length(var.subnet_ids))}"
  vpc_zone_identifier  = "${var.subnet_ids}"
  default_cooldown     = "60"
  launch_configuration = "${aws_launch_configuration.node.id}"

  tags = [
    {
      key                 = "${var.tag_name}"
      value               = "etcd"
      propagate_at_launch = "true"
    },
    {
      key                 = "Name"
      value               = "etcd-node"
      propagate_at_launch = "true"
    },
  ]
}

resource "aws_security_group" "etcd_nodes" {
  name   = "etcd-nodes"
  vpc_id = "${var.vpc_id}"

  # outbound to the internet
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # client connections
  ingress {
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["${var.network_cidr}"]
  }

  # intra-node connections
  ingress {
    from_port = 2379
    to_port   = 2379
    protocol  = "tcp"
    self      = "true"
  }

  # ssh'ing in from outside
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # TODO: refine this
  }

  tags = "${map(
    var.tag_name, "etcd",
    "Name", "etcd-nodes",
  )}"
}
