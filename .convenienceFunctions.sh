#!/usr/bin/env bash

# Convenience functions
# mcd
mcd() {
  if [[ -d $1 ]]; then
    echo "directory already existed"
  else 
    mkdir -p $1 && cd $1
    echo "directory created"
  fi
}

# upgraded version of original terminal commands for more convenient use
# an upgraded version of touch, will create the necessary path if not existent
touchu() {
  # check for right parameter
  if [[ $# != 1 ]]; then
    echo "Usage: touchu <path/filename>"
    return 1
  fi

  err_msg=$(touch $1 2>&1 >/dev/null)
  pattern=".*No such file or directory"
  file_pattern="(.*)/(.*\..*)"

  if [[ $err_msg =~ $pattern ]]; then
    if [[ $1 =~ $file_pattern ]]; then
      file_path="${match[1]}"
    fi

    echo "directory:${file_path}/ does not exist yet"
    echo "creating the necessary path... $file_path"

    mkdir -p $file_path
    touch $1
  fi
}

# upgraded cp, if the destination does not exist yet, will create the necessary path
cpu() {
  destination=${@: -1}
  no_arguments=$#

  pattern=".*/.*/?"
  if [[ $destination =~ $pattern ]]; then 
    echo "copying to desination destination: $destination"
    cp $@;

    if [[ $? == 1 ]]; then
      echo "the directory $destination does not exist yet, creating..."
      mkdir -p $destination
      cp "$@";
    fi

    echo "successfully created directory $destination and copied files ${@:1:$(( $no_arguments - 1 ))}";
  else 
    echo "Usage: cpu {files} <destination>"
    return 1
  fi
}

mvRecentDl() {

  # is no argument is provided, perform the action once
  if [[ $# == 0 ]]; then 
    n=1 
  else
    # check the input is an integer
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
      echo "Please provide an integer as the number of files you want to move"
      return 1
    else 
      n=$1
    fi
  fi

  for (( i=0; i<n; i++)); do

    # get the most recent modified file name in Downloads
    recentDl=$(ls -t ~/Downloads | head -n1)

    # check if the file exists
    if [ -z "$recentDl" ]; then 
      echo "No file found in ~/Downloads/"
      return 1
    fi

    mv "$HOME/Downloads/$recentDl" .
    echo "successfully moved $recentDl to $(pwd)"

  done
}

mvRecentScreenshot() {

  # is no argument is provided, perform the action once
  if [[ $# == 0 ]]; then 
    n=1 
  else
    # check the input is an integer
    if ! [[ "$1" =~ ^[0-9]+$ ]]; then
      echo "Please provide an integer as the number of files you want to move"
      return 1
    else 
      n=$1
    fi
  fi

  for (( i=0; i<n; i++)); do

    # get the most recent modified file name in Downloads
    recentScreenshot=$(find ~/Desktop -maxdepth 1 -name '*.png' -print0 | xargs -0 ls -t | head -n1)
    # recentScreenshot=$(ls -t ~/Desktop/*.png | head -n1)
    # recentScreenshot=$(echo "$recentScreenshot" | sed 's/ /\\ /g')

    # check if the file exists
    if [ -z "$recentScreenshot" ]; then 
      echo "No png file found in ~/Desktop/"
      return 1
    fi

    mv "$recentScreenshot" .
    echo "successfully moved $recentScreenshot to $(pwd)"

  done
}

xable() {
    if [[ $# -lt 1 ]]; then
        echo "Please provide at least one file to be modified"
        return 1
    fi

    for var in "$@"; do
        chmod +x "$var"
    done
}

## Data Science
pipenvDS() {
  cp ~/shell_scripts/DefaultPipfile ./Pipfile
  pipenv install 
}

# git related
gitacp() {
    if [[ $# == 1 ]];
      then branch=main
    else
      branch=$2
    fi

    git add -A
    git commit -m "$1"
    git push -u origin "$branch" 
}

gitinit() {
  if [[ $# != 1 ]]; then
    echo "Usage: gitinit <repo name>"
    return 1
  fi

  if [[ -d ./.git ]]; then
    echo "direcotry is already a github repo, abandonning mission"
    return 2
  fi

  git ls-remote git@github.com:jbdouz/$1.git
  if [[ $? == 128 ]]; then
    echo "Please make sure the remote repo is created and you have access to that"
    return 3
  fi

  echo "# $1" >> README.md
  git init
  git add -A
  git commit -m "first commit"
  git branch -M main
  git remote add origin git@github.com:jbdouz/$1.git
  git push -u origin main
}

# frontend framework
# Jekyll
jekyllinit() {
  if [[ $# != 2 ]]; then
    echo "Usage: jekyllinit <project_name> <remote_repo_name>"
    return 1
  fi
  
  git ls-remote git@github.com:jbdouz/$2.git
  if [[ $? == 128 ]]; then
    return 2
  else 
    echo "remote repo checking passed..."
  fi

  jekyll new $1
  cd $1
  echo "_site/" >> .gitignore
  echo ".bundle" >> .gitignore
  mkdir _layouts
  mkdir _includes
  gitinit $2

  bundler exec jekyll serve
}


