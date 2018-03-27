#!/bin/bash
DATESTAMP=$(date +%Y%m%d%H%M%S)
HOST_NAME=$(hostname)

function help_text {
   printf "\n"
   echo "Runs top and iostat at intervals"
   echo "Usage:"
   echo "    -h        Display this help message."
   echo "    -d        [Option] Delay/Interval (defaults to 5 seconds)."
   echo "    -f        [Option] Create output file rocket-stats-hostname-date.txt."
   echo "    -i        [Option] Number of iterations."
   echo "    -n        [Option] Add NFS statistics."
   echo "    -t        [Option] Suppress top output; substitute iostat cpu report."
   printf "\n"
   exit 0
}

while getopts "hd:fi:nt" opt; do
  case ${opt} in
    h )
      help_text
      ;;
    d ) 
      DELAY=$OPTARG
      ;;
    f )
      FILE=stats-$HOST_NAME-$DATESTAMP.txt
      ;;
    i )
      ITERATIONS=$OPTARG
      ;;
    n )
      NFS_STATS=1
      ;;
    t )
      NO_TOP=1
      ;;
    \? )
      echo "Invalid Option: -$OPTARG" 1>&2
      help_text
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

if [[ ! $DELAY ]]; then
   DELAY=5
fi

if [[ $FILE ]]; then
   exec > >(tee -ia "$FILE")
fi

function main_loop {
   if [[ $NO_TOP ]]; then
      date
      echo "CPU ....."
      iostat -c
      echo "MEMORY ....."
      vmstat
   else
      echo "CPU/MEMORY/PROCS ....."
      top -b -n 1
   fi
   echo "DISK ....."
   iostat
   if [[ $NFS_STATS ]]; then
      echo "NFS ....."
      iostat -n
   fi
   sleep $DELAY 
}

printf 'Options: ' 
if [[ $NO_TOP ]]; then 
   printf " top output suppressed "
fi
if [[ $NFS_STATS ]]; then
   printf " NFS stats enabled "
fi
if [[ $ITERATIONS ]]; then
   printf " Iterations:%s " "$ITERATIONS"
fi
if [[ $DELAY ]]; then 
   printf " Delay:%s " "$DELAY"
fi
if [[ $FILE ]]; then
   printf " printing to file "
fi
printf "\n"

if [[ $ITERATIONS ]]; then
   count=0
   while [ $count -lt "$ITERATIONS" ]; do
      main_loop
   count=$((count + 1))
   done
   exit 0
else
   while true; do
      main_loop
   done
   exit 0 
fi


