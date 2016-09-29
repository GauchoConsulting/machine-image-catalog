variable "region" {
  type        = "string"
  description = "AWS region to provision resources into"
  default     = "eu-west-1"
}

variable "vmie_bucket_name" {
  type        = "string"
  description = "S3 bucket to use for the VM import/export service"
}

variable "vagrant_bucket_name" {
  type        = "string"
  description = "S3 bucket to upload vagrant images to"
}

provider "aws" {
  region = "${var.region}"
}

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
  acl           = "public-read"
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

resource "aws_iam_role_policy_attachment" "attach_security_audit_to_audit_role" {
  role       = "${aws_iam_role.vmie.name}"
  policy_arn = "${aws_iam_policy.vmie.arn}"
}
