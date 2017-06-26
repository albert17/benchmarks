#!/bin/bash

####################
# GLOBAL VARIABLES #
####################

# Features variables
FEATURES_PATH="./features"
FEATURES_RESULT="./results/features"

# Caffe variables
CAFFE_PATH="/home/alberto/Software/caffe"
CNN_RESULT="./results/cnn"
CNN_PATH="./cnn"

# Skylake HWC
HWC_SKYLAKE="./hwc/skylake"


# Use english system
LC_ALL=en_US.utf-8

#############
# Funcitons #
#############

# Prints usage information
function usage() {
  echo "./perf.sh -b [features|cnn] -t [orb|alex|caffenet] -p images_path -a [arm|skylake]" >&2
  echo -e "\t-b features -t orb -p images_path -a [arm|skylake]" >&2
  echo -e "\t-b cnn -t [alex|caffenet] -p images_path -a [arm|skylake]" >&2
  exit 1
}

# Param: List of files
function check_path() {
  [ -d $1 ] || (echo "$1 not exist" & exit 1)
}

# Obtain perf params
#
# Param1: Architecture
function perf_params() {
  case $1 in
  skylake)
    HWC=$HWC_SKYLAKE
    ;;
  arm)
    HWC=$HWC_ARM
    ;;
  *)
    exit 1
    ;;
  esac
}

# Execute command with perf
#
# Param1: Executable path
# Param2: Result file
function perf_execute() {
count=1
cat $HWC | cut -d' ' -f2 |
while read c1 && read c2 && read c3 && read c4; do
    PERF_PARAMS="stat -e r$c1,r$c2,r$c3,r$c4"
    echo "BIN: $1"
    perf $PERF_PARAMS -r10 -o "$2-$count" $1 #1> /dev/null
    # execution information
    if [ $? -eq 0 ]; then
      echo "SUCCES!"
    else
      echo "ERROR!"
    fi
    count=$((count+1))
done
}

# Execute opencv features extration
#
# Param1: Algorithm type
# Param2: Image path
function features() {
  make -C $FEATURES_PATH clean &> /dev/null # clean
  make -C $FEATURES_PATH &> /dev/null # compile
  # Create result directory
  mkdir -p $FEATURES_RESULT/$1
  # Execute
  for img in $(ls $2 | grep .png)
  do
      perf_execute "features/features $2/$img" "$FEATURES_RESULT/$1/$img"
  done
  # Clen
  make -C $FEATURES_PATH clean &> /dev/null
}

# Execute cnn classification extration
#
# Param1: Model type
# Param2: Image path
function cnn() {
  make -C $CNN_PATH classification &> /dev/null
  # Select model
  if [ $1 == "alex" ]; then
    bvlc="bvlc_alexnet"
  elif [ $1 == "caffenet" ]; then
    bvlc="bvlc_reference_caffenet"
  fi
  # Create result directory
  mkdir -p $CNN_RESULT/classification/$1
  bin="$CNN_PATH/classification $CAFFE_PATH/models/$bvlc/deploy.prototxt $CAFFE_PATH/models/$bvlc/$bvlc.caffemodel $CAFFE_PATH/data/ilsvrc12/imagenet_mean.binaryproto $CAFFE_PATH/data/ilsvrc12/synset_words.txt"
  for img in $(ls $2 | grep .png)
    do
      echo "IMG: $img"
      perf_execute "$bin $2/$img" "$CNN_RESULT/single/$1/$img"
  done
  # Clen
  make -C $CNN_PATH clean &> /dev/null
}

########
# MAIN #
########
# Obtain parameters
while getopts "b:t:p:a:" opt
do
  case $opt in
    b )
    b=${OPTARG}
    (($b == "features" || $b == "cnn")) || usage
    ;;
    t )
    t=${OPTARG}
    (($t == "orb" || $t == "alex" || $t == "caffenet")) || usage
    ;;
    p )
    p=${OPTARG}
    ;;
    a )
    a=${OPTARG}
    ;;
    * )
    usage
    ;;
  esac
done

# Check parameters
if [[ -z $b ]] || [[ -z $t ]] || [[ -z $p ]] || [[ -z $a ]]
then
     usage
     exit 1
fi

# check path
check_path $p
# init perf_params
perf_params $a

# Execute seleted benchmarks
case $b in
  features )
  features $t $p
  ;;
  cnn )
  cnn $t $p
  ;;
  *)
  usage
  ;;
esac
