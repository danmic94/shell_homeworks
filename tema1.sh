shopt -s globstar

FOLDER=$1;
MIN_SIZE=$2;
OUTPUT_FILE=$3;
TOTAL_SIZE=0;

# Validate to see if the first parameter is a directory

if [[ -d $FOLDER ]]; then
    printf "%s is a valid directory \n" "${FOLDER}"
else
    printf "%s is not a valid directory\n" "${FOLDER}"
    exit 1
fi


if [ -z ${MIN_SIZE+x} ];then
  printf "Minimum file size has not been set!\n"
else
  printf "Minimum file size has been set to %d!\n" "${MIN_SIZE}"
fi


if [[ ! -z $OUTPUT_FILE ]]; then
  if [ -e $OUTPUT_FILE ]
  then
      printf "Emptied the contests of the file %s \n" "${OUTPUT_FILE}"
      echo > $OUTPUT_FILE
  else
      printf "Creating new file called : %s \n" "${OUTPUT_FILE}"
  fi
else
  printf "\n"
  printf "OUTPUT WILL NOT BE WRITTEN SINCE NO FILE IS PROVIDED!\n"
  printf "\n"
fi

# I must confess that the recursive iteration I found on stack overflow :(
for i in $FOLDER/**/*
do
    if [ -f "$i" ];
    then
      if [ -z ${MIN_SIZE+x} ];then
        TEMP_FILE_SIZE="$(du -b "$i" | awk '{print $1}')"
        let TOTAL_SIZE+=TEMP_FILE_SIZE;
        if [[ ! -z $OUTPUT_FILE ]]; then
          echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
        fi
      else
        TEMP_FILE_SIZE="$(du -b "$i" | awk '{print $1}')"
        if [[ $TEMP_FILE_SIZE -gt $MIN_SIZE ]]; then
          let TOTAL_SIZE+=TEMP_FILE_SIZE;
          if [[ ! -z $OUTPUT_FILE ]]; then
            echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
          fi
        else
          printf "%s:%d is under the size limit\n" "${i##*/}" "${TEMP_FILE_SIZE}"
        fi
      fi
    fi
done

  printf "\n \t The total size of the itterated files is: %d \n\n" "${TOTAL_SIZE}"
  exit 0
