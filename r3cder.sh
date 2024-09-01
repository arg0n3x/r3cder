#!/bin/bash
export IFS='
'

# script version
version='4.0.1'

# default overwriting
overwrite=2

# Colors
rd="\e[01;31m"
grn="\e[01;32m"
yll="\e[01;33m"
end="\e[00m"

# Execution indicators
war="${yll}[!]${end}"

# Interrpus the script process by pressing ctrl+c
ctrl_c(){
  echo -e "\n${rd} Process interrupted ${end}\n"
  stty echoctl # enable the ^C character
  exit 1
}
trap ctrl_c SIGINT

# Prevents displaying the ^C character when pressing ctrl+c
stty -echoctl

# Evaluates the execucion
state(){
  local action=$1
  local value=$2

  # Check the action type; if it is 'msg' display the error and the message 
  if [[ $action == msg ]]; then
    echo -e "\n${rd}[ERROR]${end} $value\n"
    exit 1
  fi
}

# Help menu
help_menu(){
cat << EOF
use: ${0##*/} [-h] [-v] [-o] -p

description:
 When passing a directory to the script, it will overwrite all files within the directory,
 This action is irreversible.

options:
 -p       directory path to corrupt them.
 -o       number of times to overwrite (default 2).
 -h       show help menu.
 -v       script version.
EOF
exit 0
}

# Overwrite all files in the directory, making them unrecoverable
overwriteData(){
  local dpath=$1
  local overwrite=$overwrite
  local context="${yll}[${rd}OverWriting${yll}]${end}"

  # Expands all visible and hidden files and directories
  for file in "$dpath"/* "$dpath"/.[!.]*; do
    # Check if its is a file and overwrite it, but if it is a directory, calls the same funcion.
    if [[ -f $file ]]; then
      echo -e "${context} ${file}"
      shred -fzu -n $overwrite "$file"
    elif [[ -d $file ]]; then
      overwriteData $file
    fi
  done
}

# Display a summary of what the script does
showInfo(){
  local dpath=$1

  # Validates that the arguments are valid
  [[ -d $dpath ]] || state 'msg' "The $dpath directory does not exist"

  local countFiles=$(find $dpath -type f 2>/dev/null | wc -l)
  [[ $countFiles -eq 0 ]] && state 'msg' "The $dpath directory is empty"

  # Remove the last character of the directory path if it is a /
  [[ ${dpath: -1} == / ]] && dpath=${dpath%?}

  # Gets the size of the directory
  local getSize=$(du -sh $dpath | awk '{print $1}')

  echo -e "${war} ${yll}${countFiles}${end} files will be corrupted, and ${yll}${getSize}${end} of storage will be freed"; sleep 2

  overwriteData $dpath
}


# Check that parameter are passed to the script
if [[ $# -ne 0 ]]; then
  # Configure the necessary parameters
  while getopts ':p:o:,v,h' args 2>/dev/null; do
    case $args in
      \?) state 'msg' "Invalid parameter, use -h"
          ;;
      :) state 'msg' "The parameter requires an argument"
          ;;
      h) help_menu
          ;;
      v) echo -e "${grn}${0##*/}${end} ${version}"; exit 0
          ;;
      o) overwrite=$OPTARG
          ;;
      p) dpath=$OPTARG
          ;;
    esac
  done
  # Sets the argument position when using the -o parameter
  [[ $OPTIND -eq 2 ]] && shift $((OPTIND - 1))

  showInfo "$dpath"
else
  help_menu
fi

stty echoctl # enable the ^C character
