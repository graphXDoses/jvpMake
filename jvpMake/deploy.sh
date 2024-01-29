#!/bin/bash

source ./jvpMake/config.sh

# Check if the build directory exists, if not exit with error
if [ ! -d "${build_dir}${project_name}/bin" ]; then
    echo "No '${build_dir}${project_name}/bin' directory found..."
    exit 1  # Exit the script with an error code
fi

if [ ! -d "${build_dir}${project_name}/deploy" ]; then
    mkdir "${build_dir}${project_name}/deploy"
fi

if [ ! -f "${build_dir}${project_name}/deploy/manifest.mf" ]; then
    echo "Main-Class: ${root_file}" > "${build_dir}${project_name}/deploy/"manifest.mf
    echo "${build_dir}${project_name}/deploy/manifest.mf created."
fi
jar --create --file "${build_dir}${project_name}/deploy/${project_name}.jar" --manifest "${build_dir}${project_name}/deploy/manifest.mf" -C "${build_dir}${project_name}/bin/" .
if [ $? -eq 0 ]; then
    echo "${build_dir}${project_name}/deploy/${project_name}.jar deployment successful."
fi
