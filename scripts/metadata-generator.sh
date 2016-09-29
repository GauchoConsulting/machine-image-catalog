#!/usr/bin/env bash

output=""
input="$(cat ${OUTPUT_FILE} || echo {})"

if [[ "${1##*.}" == "vmdk" ]]; then
    output="\"virtualbox_source_virtualdisk_path\":\"${1}\","
elif [[ "${1##*.}" == "ovf" ]]; then
    output="\"virtualbox_source_package_path\":\"${1}\","
fi

output="{${output}\"username\":\"${username}\",\"password\":\"${password}\"}"

echo "${input}" "${output}" | jq -r add -s > "${OUTPUT_FILE}"
