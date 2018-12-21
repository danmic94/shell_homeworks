shopt -s globstar

FOLDER=$1;
MIN_SIZE=$2;
OUTPUT_FILE=$3;
TOTAL_SIZE=0;

# Validate to see if the first parameter is a directory
if [[ -d $FOLDER ]]; then
    printf "%s is a valid directory \n" "${FOLDER}"
else
  # IF the directory is invalid exit with code 1 for error and inform the user
    printf "%s is not a valid directory\n" "${FOLDER}"
    exit 1
fi

# Inform user on minium file size
if [ -z ${MIN_SIZE+x} ];then
  printf "Minimum file size has not been set!\n"
else
  printf "Minimum file size has been set to %d!\n" "${MIN_SIZE}"
fi

#  Check if output file name that is to be written in si set as a variable
if [[ ! -z $OUTPUT_FILE ]]; then
  # Chekck if file already exists
  if [ -e $OUTPUT_FILE ]
  then
    # if exists empty the file
      printf "Emptied the contests of the file %s \n" "${OUTPUT_FILE}"
      echo > $OUTPUT_FILE
  else
    # Inform the user that inside the iteration the file will be created
      printf "Creating new file called : %s \n" "${OUTPUT_FILE}"
  fi
else
  # Inform the user that the 3 param is not set therefore
  # the write to output file will not be used
  printf "\n"
  printf "OUTPUT WILL NOT BE WRITTEN SINCE NO FILE IS PROVIDED!\n"
  printf "\n"
fi

# Recursevly itterate the give folder
for i in $FOLDER/**/*
do
    if [ -f "$i" ];
    then
      # Logic in case the min size is NOT defined
      if [ -z ${MIN_SIZE+x} ];then
        # Get current file size in bytes
        TEMP_FILE_SIZE="$(du -b "$i" | awk '{print $1}')"
        # increment total file size
        let TOTAL_SIZE+=TEMP_FILE_SIZE;
        # If the output file name is defined use it and write to file
        if [[ ! -z $OUTPUT_FILE ]]; then
          echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
        fi
      else
        # Same logic as in above if only keeps in account the file size
        TEMP_FILE_SIZE="$(du -b "$i" | awk '{print $1}')"
        if [[ $TEMP_FILE_SIZE -gt $MIN_SIZE ]]; then
          let TOTAL_SIZE+=TEMP_FILE_SIZE;
          if [[ ! -z $OUTPUT_FILE ]]; then
            echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
          fi
        else
          # Inform wich files are under minumum size and also the size
          printf "%s:%d is under the size limit\n" "${i##*/}" "${TEMP_FILE_SIZE}"
        fi
      fi
    fi
done
  # Final information of the total size in bytes of the files
  printf "\n \t The total size of the itterated files is: %d \n\n" "${TOTAL_SIZE}"
  exit 0
