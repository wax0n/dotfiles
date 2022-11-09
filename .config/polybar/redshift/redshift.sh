#!/bin/bash

CURRENT_TEMP=$(($(cat ./redata)))

temp() {
  if [ $CURRENT_TEMP -lt 12000 ] ; then
    redshift -O 4000 $> /dev/null
    echo "$(($CURRENT_TEMP + 4000))" > ./redata
  else
    remove_temp
  fi
}

remove_temp() {
  redshift -x $> /dev/null
  echo '0' > ./redata
}

while [ $# -gt 0 ] ; do
  case "$1" in
    -a|--add)
      temp
      shift
    ;;
    -x)
      remove_temp
      shift
    ;;
    *)
      if [[ $1 =~ ^\- ]] ; then
        echo "error: unknown flag '$1'"
      fi
      shift
    ;;
  esac
done

PRINT_TEMP=$((($(($(cat ./redata))) * 100)/12000))

if [ $PRINT_TEMP = '0' ] ; then
  echo 'off'
else
  echo "$PRINT_TEMP%"
fi
