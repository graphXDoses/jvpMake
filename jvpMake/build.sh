#!/bin/bash

source ./jvpMake/config.sh

# Check if the build directory exists, or create it if not
if [ ! -d "$build_dir" ]; then
    echo "Creating the '$build_dir' directory..."
    mkdir -p "$build_dir"
else
    if [ ! -d "${build_dir}${project_name}/bin" ]; then
        echo "Creating the '${build_dir}${project_name}/bin' directory..."
        mkdir -p "${build_dir}${project_name}/bin"
    fi
fi

# Compile all .java files in the current directory
# for java_file in "$project_dir"*.java; do
#     if [ -f "$java_file" ]; then
#         javac --source-path "$project_dir" -d "${build_dir}${project_name}/bin" -cp "$project_dir" "$java_file"
#         if [ $? -eq 0 ]; then
#             echo "Compiled: $java_file"
#         else
#             echo "Compilation failed for $java_file"
#             for file in "${build_dir}${project_name}/bin"*.class; do
#                 rm "$file"
#                 echo "Deleted: $file"
#             done
#             exit 1  # Exit the script with an error code
#         fi
#     fi
# done

if [ ! -d "$project_dir" ]; then
    echo "Creating the '$project_dir' directory..."
    mkdir -p "$project_dir"
fi

if [ ! -f "$project_dir/$root_file.java" ]; then
    echo "public class $root_file
{
    public static void main(String[] args)
    {
        System.out.println(\"This is from \'$root_file\'. It looks ugly! CHANGE IT IMEDIATELLY!\");
    }
}" > "$project_dir/$root_file.java"
fi

# Check if the .projectStats file exists, if not, create it
if [ ! -f "$project_dir/.projectStats" ]; then
    touch "$project_dir/.projectStats"
fi

# Read the previous file modification times from .projectStats
declare -A prev_file_modtimes
while IFS= read -r line; do
    file_name=$(echo "$line" | cut -d ',' -f 1)
    mod_time=$(echo "$line" | cut -d ',' -f 2)
    prev_file_modtimes["$file_name"]=$mod_time
done < "$project_dir/.projectStats"

# cp -r $resource_folder "${build_dir}${project_name}/bin"

# Check and update the last modified times
for file in "$project_dir"/*.java; do
    if [ -f "$file" ]; then
        file_name=$(basename "$file")
        current_mod_time=$(date -r "$file" +"%s")

        if [ "${prev_file_modtimes[$file_name]}" != "$current_mod_time" ]; then
            # File has been modified
            # echo "File $file_name has been modified."
            javac --source-path "$project_dir" -d "${build_dir}${project_name}/bin" -cp "$project_dir" "$project_dir$file_name" -g
            if [ $? -eq 0 ]; then
                echo "Compiled: $project_dir$file_name"
            else
                echo "Compilation failed for $project_dir$file_name"
                rm "$project_dir/.projectStats"
                exit 1  # Exit the script with an error code
            fi
            prev_file_modtimes["$file_name"]=$current_mod_time
        fi
    fi
done

# Update .projectStats with the latest modification times
> "$project_dir/.projectStats"
for file_name in "${!prev_file_modtimes[@]}"; do
    mod_time="${prev_file_modtimes[$file_name]}"
    echo "$file_name,$mod_time" >> "$project_dir/.projectStats"
done

echo "Project '${project_name}' build successful."
