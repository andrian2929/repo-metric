#!/bin/bash

filename="$1"

if ! [ -x "$(command -v git)" ]; then
    echo "Error: git is not installed." >&2
    exit 1
fi

if [ -z "$filename" ]; then
    echo "Please provide the filename as an argument."
    exit 1
fi

if [ ! -f "$filename" ]; then
    echo "File not found: $filename"
    exit 1
fi

if [ ! -s "$filename" ]; then
    echo "File is empty: $filename"
    exit 1
fi

temp_dir="temp"


if [ ! -d "$temp_dir" ]; then
    echo "Creating temporary directory"
    mkdir -p temp
fi

repo_name() {
    local repo_link="$1"
    local username=$(echo $repo_link | awk -F'/' '{print $4}')
    local repo_name=$(echo $repo_link | awk -F'/' '{print $5}')
    echo "$username-$repo_name"
}

output_file="summary.json"

if [ -f "$output_file" ]; then
    rm "$output_file"
fi

echo "[" >> "$output_file"

first_repo=true

while IFS= read -r p || [ -n "$p" ]; do
   
    repo=$(repo_name "$p")

    if [ "$first_repo" = true ]; then
        first_repo=false
    else 
        echo "," >> "$output_file"
    fi

    echo "{ \"repository\": \"$p\"," >> "$output_file"
    echo "  \"contributors\": [" >> "$output_file"

    first_contributor=true

    if [ -d "$temp_dir/$repo" ]; then
        echo "Repository already exists: $repo. Pulling the latest changes."
        cd "$temp_dir/$repo" &>/dev/null
        git pull &>/dev/null
        cd - &>/dev/null
    else
         echo "Cloning repository: $p"
         git clone "$p" "$temp_dir/$repo" &>/dev/null
    fi
  
    cd "$temp_dir/$repo" &>/dev/null

    authors=$(git shortlog -sne --all)

    echo "$authors" | while IFS= read -r author; 
    do
    name=$(echo "$author" | sed -E 's/<.*>//g' | awk '{$1=""; print $0}' | awk '{$1=$1};1' | sed 's/"/\\"/g' )
    email=$(echo "$author" | grep -oP '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}')

    if [ -n "$email" ]; then
        if [ "$first_contributor" = true ]; then
        first_contributor=false
        else 
        echo "," >> "../../$output_file"
        fi

       summary=$(git log --all --author="$email" --pretty=tformat: --numstat | awk '{insertions+=$1; deletions+=$2} END {print insertions, deletions}')
        insertions=$(echo "$summary" | awk '{print $1}')
        deletions=$(echo "$summary" | awk '{print $2}')

        if [ -z "$insertions" ]; then
            insertions=0
        fi

        if [ -z "$deletions" ]; then
            deletions=0
        fi

        echo "    { \"name\":\"$name\", \"email\": \"$email\", \"insertion\": $insertions, \"deletion\": $deletions }" >> "../../$output_file"
    fi

    done

    echo "  ]" >> "../../$output_file" 
    echo "}" >> "../../$output_file"

    cd ../../ &>/dev/null
done < "$filename"

echo "]" >> "$output_file"


