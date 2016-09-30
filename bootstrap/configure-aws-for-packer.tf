variable "region" {
  type        = "string"
  description = "AWS region to provision resources into"
  default     = "eu-west-1"
}

variable "vmie_bucket_name" {
  type        = "string"
  description = "S3 bucket to use for the VM import/export service"
  default     = "pervenche-vmie-bucket"
}

variable "vagrant_bucket_name" {
  type        = "string"
  description = "S3 bucket to upload vagrant images to"
  default     = "pervenche-vagrant-bucket"
}

variable "packer_inflight_build_role" {
  type        = "string"
  description = "A role to be attached to instances created by packer"
  default     = "eu-west-1-inflight_packer_run"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "vmie" {
  bucket        = "${var.vmie_bucket_name}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "${var.vmie_bucket_name}"
  }
}

resource "aws_s3_bucket" "vagrant" {
  bucket        = "${var.vagrant_bucket_name}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "${var.vagrant_bucket_name}"
  }
}

resource "aws_iam_role" "vmie" {
  name               = "vmimport"
  assume_role_policy = "${file("${path.module}/AssumeRoleVMIE.json")}"
}

data "template_file" "vmie" {
  template = "${file("${path.module}/VMIEPolicy.json.tmpl")}"

  vars {
    bucket_name = "${var.vmie_bucket_name}"
  }
}

resource "aws_iam_policy" "vmie" {
  name        = "VMIE"
  path        = "/"
  description = "Grants the AWS VMIE service the necessary execution permissions"
  policy      = "${data.template_file.vmie.rendered}"
}

resource "aws_iam_role_policy_attachment" "attach_vmie_policy_to_vmimport_role" {
  role       = "${aws_iam_role.vmie.name}"
  policy_arn = "${aws_iam_policy.vmie.arn}"
}

data "template_file" "packer_execution_policy" {
  template = "${file("${path.module}/PackerExecutionPolicy.json.tmpl")}"

  vars {
    accountid = "${data.aws_caller_identity.current.account_id}"
    role      = "${var.packer_inflight_build_role}"
  }
}

resource "aws_iam_policy" "packer-execution" {
  name        = "packer_execution"
  path        = "/"
  description = "Allows a packer run minimal permissions"
  policy      = "${data.template_file.packer_execution_policy.rendered}"
}

resource "aws_iam_role" "inflight_packer_run" {
  name               = "${var.packer_inflight_build_role}"
  assume_role_policy = "${file("${path.module}/AssumeRoleEC2Instance.json")}"
}

resource "aws_iam_instance_profile" "inflight_packer_run" {
  name  = "${var.packer_inflight_build_role}"
  roles = ["${aws_iam_role.inflight_packer_run.name}"]
}
