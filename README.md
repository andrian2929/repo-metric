## Introduction

This script summarizes information about a list of GitHub repositories and saves insertion and deletion per contributor the data in a JSON file.

## Requirement

- Bash v4 or higher
- Git

## Usage

1. Prepare the GitHub repo link to summarize in a txt file. Multiple line accepted. For example:
   ```
    https://github.com/material-components/material-web
    https://github.com/tmux/tmux
   ```
2. Run this command to start the script
   ```bash
     chmod +x
     repo-sum.sh /path/to/txt-file
   ```
3. This script will generate a json file as output. For example:
   ```json
   [
     {
       "repository": "https://github.com/material-components/material-web",
       "contributors": [
         {
           "name": "Elliott Marquez",
           "email": "emarquez@google.com",
           "insertion": 112934,
           "deletion": 73547
         },
         {
           "name": "Elizabeth Mitchell",
           "email": "lizmitchell@google.com",
           "insertion": 224671,
           "deletion": 217651
         }
       ]
     },
     {
       "repository": "https://github.com/tmux/tmux",
       "contributors": [
         {
           "name": "Nicholas Marriott",
           "email": "nicholas.marriott@gmail.com",
           "insertion": 320492,
           "deletion": 171988
         },
         {
           "name": "Thomas Adam",
           "email": "thomas@xteddy.org",
           "insertion": 1808,
           "deletion": 765
         }
       ]
     }
   ]
   ```

## Authors

- [@andrianramadan](https://www.github.com/andrianramadan)

**Made with ❤️ by Aan**
