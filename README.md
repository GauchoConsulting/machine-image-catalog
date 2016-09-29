# Machine Image Catalog

Write some Blah, blah...

![Machine Image Catalog](media/catalog.png)

# Building the Foundation Image

To build the Foundation Image execute the following command from the root of the repository:

```
ROOT_PASSWORD="$(openssl rand -base64 32)" BOOTLOADER_PASSWORD="$(openssl rand -base64 32)" packer build -force -var-file boxes/foundation/variables.json boxes/foundation/packer.json 
```

# Building the Membrane Image

To build the membrane image execute the following commands from the root of the repository:

```
cat boxes/membrane/staging-variables.json builds/com.gauchoconsulting.cloud.virtualbox.centos6-foundation/0.0.0.0/variables.json | jq add -s -r > boxes/membrane/merged-variables.json
packer build -force -var-file boxes/membrane/merged-variables.json boxes/membrane/packer.json
```