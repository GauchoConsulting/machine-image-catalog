# Foundation Image

The initial component of our golden image catalog is the foundation image. These images will generally be pristine Linux distribution images in a virtual hard disk form. Starting with a distribution such as CentOS or RedHat Enterprise Linux (RHEL), we install the minimal OS and clone the virtual disk. That virtual disk is ready to be passed on to the next step.

## Building

```
ROOT_PASSWORD="$(openssl rand -base64 32)" BOOTLOADER_PASSWORD="$(openssl rand -base64 32)" packer build -var-file variables.json packer.json
```