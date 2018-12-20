shopt -s globstar

FOLDER=$1;
MIN_SIZE=$2;
OUTPUT_FILE=$3;

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

for i in $FOLDER/**/*
do
    if [ -f "$i" ];
    then
      if [ -z ${MIN_SIZE+x} ];then
        echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
      else
        TEMP_FILE_SIZE="$(du -b "$i" | awk '{print $1}')"
        if [[ $TEMP_FILE_SIZE -gt $MIN_SIZE ]]; then
          echo "${i##*/}:$TEMP_FILE_SIZE" >> $OUTPUT_FILE
        else
          printf "%s:%d is under the size limit\n" "${i##*/}" "${TEMP_FILE_SIZE}"
        fi
      fi
    fi
done
