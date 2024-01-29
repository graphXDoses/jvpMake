#!/bin/bash

source ./jvpMake/config.sh

# Check if the build directory exists
if [ -d "$build_dir" ]; then
    # Check if there are any .class files in the build directory
    if [ ! "$(ls -A ${build_dir}${project_name}/bin/*.class 2>/dev/null)" ]; then
        # No .class files, so call buildProject.sh
        echo "No .class files found. Calling $project_script..."
    fi
    "$project_script"
else
    # No build directory, so call buildProject.sh
    echo "No build directory found. Calling $project_script..."
    "$project_script"
    echo ""
fi

# Run the Java program
java -cp "${build_dir}${project_name}/bin" $root_file
# if [ ! $? -eq 0 ]; then
#     for file in "${build_dir}${project_name}/bin"*.class; do
#         rm "$file"
#         echo "Deleted: $file"
#     done
#     exit 1  # Exit the script with an error code
# fi
