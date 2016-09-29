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
ROOT_PASSWORD="$(openssl rand -base64 32)" BOOTLOADER_PASSWORD="$(openssl rand -base64 32)" packer build -force -var-file boxes/foundation/variables.json boxes/foundation/packer.json 
```

# Building the Membrane Image

To build the membrane image execute the following commands from the root of the repository:

```shell
cat boxes/membrane/staging-variables.json builds/com.gauchoconsulting.cloud.virtualbox.centos6-foundation/0.0.0.0/variables.json | jq add -s -r > boxes/membrane/merged-variables.json
packer build -force -var-file boxes/membrane/merged-variables.json boxes/membrane/packer.json
```