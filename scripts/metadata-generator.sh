#!/usr/bin/env bash
# shellcheck disable=SC1001,SC2154

set -eu

output=""
input="$(cat "${OUTPUT_FILE}" || echo {})"

if [[ "${1##*.}" == "vmdk" ]]; then
    output="\"virtualbox_source_virtualdisk_path\":\"${1}\""
elif [[ "${1##*.}" == "ovf" ]]; then
    output="\"virtualbox_source_package_path\":\"${1}\""
elif [[ "${1}" =~ [a-z]{2}-[a-z]+-[0-9]+\/ami-[0-9A-Za-z]{8} ]]; then
    arr=($(echo "${1}" | tr '/' ' '))
    REGION="${arr[0]}"
    AMI="${arr[1]}"
    output="\"aws_ami_id\":\"${AMI}\",\"aws_region\":\"${REGION}\""
fi

echo "${output}"

if ! [ -z "${username+x}" ]; then
    output="${output},\"username\":\"${username}\""
fi

if ! [ -z "${password+x}" ]; then
    output="${output},\"password\":\"${password}\""
fi

if ! [ -z "${artifact_id+x}" ]; then
    output="${output},\"source_artifact_id\":\"${artifact_id}\""
fi

if ! [ -z "${group_id+x}" ]; then
    output="${output},\"source_group_id\":\"${group_id}\""
fi

if ! [ -z "${version+x}" ]; then
    output="${output},\"source_version\":\"${version}\""
fi

output="{${output}}"

echo "${input}" "${output}" | jq -r add -s > "${OUTPUT_FILE}"
