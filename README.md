# Machine Image Catalog

Write some Blah, blah...

![Machine Image Catalog](media/catalog.png)

# Prerequsites

## Install the monkeylittle fork of packer:

Download the zip from https://github.com/monkeylittleinc/packer/releases and extract to a folder in your `$PATH`

## Install the post-processor-vagrant-s3 plugin:

```shell
$ go get github.com/lmars/packer-post-processor-vagrant-s3
$ mkdir -p $HOME/.packer.d/plugins
$ cp $GOPATH/bin/packer-post-processor-vagrant-s3 $HOME/.packer.d/plugins/
```

## Install the vagrant s3 authentication plugin:

```shell
vagrant plugin install vagrant-s3auth
```

## Bootstrap your AWS account

The built vagrant boxes are stored in an S3 bucket.
Additionally, the AWS VM import/export service requires an S3 bucket and IAM role.

Using terraform (https://www.terraform.io/) the account can be bootstrapped:

```shell
$ cd bootstrap/
$ terraform apply
```

# Building the Foundation Image

To build the Foundation Image execute the following command from the root of the repository:

```shell
$ ROOT_PASSWORD="$(openssl rand -base64 32)" BOOTLOADER_PASSWORD="$(openssl rand -base64 32)" packer build -force -var-file boxes/foundation/variables.json boxes/foundation/packer.json 
```

# Building the Membrane Image

To build the membrane image execute the following commands from the root of the repository:

```shell
$ packer build -force -parallel=false -var-file boxes/membrane/variables.json -var-file builds/com.pervenche.cloud/centos6-foundation/0.0.1.0/variables.json boxes/membrane/packer.json
```

# Building the Base Image

To build the base image execute the following command from the root of the repository:

```shell
$ packer build -force -var-file boxes/base/variables.json -var-file builds/com.pervenche.cloud/centos6-membrane/0.0.3.0/variables.json boxes/base/packer.json 
```

# Importing the Vagrant Image

```shell
$ vagrant box add s3://pervenche-vagrant-bucket/com.pervenche.cloud.aws.centos6-membrane
$ vagrant box add s3://pervenche-vagrant-bucket/com.pervenche.cloud.aws.centos6-base
```
