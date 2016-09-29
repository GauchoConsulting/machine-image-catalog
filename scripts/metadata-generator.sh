#!/usr/bin/env bash

output=""
input="$(cat "${OUTPUT_FILE}" || echo {})"

if [[ "${1##*.}" == "vmdk" ]]; then
    output="\"virtualbox_source_virtualdisk_path\":\"${1}\","
elif [[ "${1##*.}" == "ovf" ]]; then
    output="\"virtualbox_source_package_path\":\"${1}\","
elif [[ "${1}" =~ [a-z]{2}-[a-z]+-[0-9]+\/ami-[0-9A-Za-z]{8} ]]; then
    arr=($(echo "${1}" | tr '/' ' '))
    REGION="${arr[0]}"
    AMI="${arr[1]}"
    output="\"aws_ami_id\":\"${AMI}\",\"aws_region\":\"${REGION}\""
fi

if ! [ -z "${username+x}" ]; then
    output="{${output},\"username\":\"${username}\""
fi

if ! [ -z "${password+x}" ]; then
    output="{${output},\"password\":\"${password}\""
fi

output="{${output}}"

echo "${input}" "${output}" | jq -r add -s > "${OUTPUT_FILE}"
