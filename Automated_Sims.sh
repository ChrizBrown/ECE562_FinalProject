#!/bin/bash
maxInsts=1000000
while getopts i:j: flag
do
    case "${flag}" in
        i) maxInsts=${OPTARG};;
        j) coresUse=${OPTARG};;
    esac
done
#echo "User will be building with protection argument: $protectionParam"

#sed -i s/"#define PROT_SIZE".*/"#define PROT_SIZE $protectionParam"/ slru_rp.cc

# Check for the gem5 path 

GEM5_PATH=$(cat gem5path.config)                        #

  if [[ ! -d $GEM5_PATH ]]
  then
    echo "Please set the GEM5 path correctly!"
    exit 1
  fi
PROJECT_PATH=$(pwd)/
BACKUP_PATH=$(pwd)/Backup/
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")


CACHE_FILE=$GEM5_PATH"src/mem/cache/Cache.py"
RP_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/ReplacementPolicies.py"
SCON_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/SConscript"
SLRU_HH_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.hh"
SLRU_CC_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.cc"
mkdir -p $BACKUP_PATH/$TIMESTAMP

#DON"T COPY UNTIL AFTER VANILLA SIMS
declare -a simulations=("mcf" "libquantum" "a2time01" "cacheb01" "bitmnp01")
declare -a cacheSizes=(32 128)
declare -a blockSizes=(64 128)
declare -a numberBlocks=(64 128 256 512 1024)
declare -a blockIterations=(1 2 2 2 1)
echo "Part $part"
L1iSize=32kB
L1iAssoc=1
L1dSize=32kB
L1dAssoc=1
cachelineSize=64
maxInst=10
testName=MCF_
for cacheLineSize in ${blockSizes[@]};
do
    for cacheVar in ${cacheSizes[@]};
    do
        for sims in ${simulations[@]};
        do
            echo "*********************************$benchName***************************************"
            $GEM5_PATH"build/ARM/gem5.opt"\
                "--stats-file="$sims"_""$cacheVar""kB_""$cacheLineSize""bs_pr_SLRU.txt"\
                --dump-config="$sims""_""$cacheVar""kB_""$cacheLineSize""bs_pr_SLRU.ini"\
                $GEM5_PATH"configs/example/se.py" \
                --caches\
                --l1i_size=${cacheSizes[y]}"kB"\
                --l1i_assoc=$L1iAssoc\
                --l1d_size=${cacheSizes[y]}"kB"\
                --l1d_assoc=$L1dAssoc\
                --cacheline_size=${blockSizes[y]}\
                --cpu-clock=1.6GHz\
                --cpu-type=O3_ARM_v7a_3 -n 1\
                --maxinsts=$maxInst\
                --bench $sims
        done
    done
done



#now need to build for SLRU
declare -a cacheSizes=( 32  32  32  32  128 128 128 128)
declare -a blockSizes=( 128 128 64  64  128 128 64  64)
declare -a numBlocks=(  64  128 128 256 256 512 512 1024)
declare -a blockIterations=(1 2 2 2 1)

x=0
y=0
for num in ${blockIterations[@]};
do
    sed -i s/"#define PROT_SIZE".*/"#define PROT_SIZE $protectionParam"/ slru_rp.cc
    cp $CACHE_FILE      $BACKUP_PATH$TIMESTAMP/"Cache.py"
    cp $RP_FILE         $BACKUP_PATH$TIMESTAMP/"ReplacementPolicies.py"
    cp $SCON_FILE       $BACKUP_PATH$TIMESTAMP/"SConscript"
    cp $SLRU_HH_FILE    $BACKUP_PATH$TIMESTAMP/"slru_rp.hh"
    cp $SLRU_CC_FILE    $BACKUP_PATH$TIMESTAMP/"slru_rp.cc"

    cp $PROJECT_PATH/Cache.py               $CACHE_FILE
    cp $PROJECT_PATH/ReplacementPolicies.py $RP_FILE
    cp $PROJECT_PATH/SConscript             $SCON_FILE
    cp $PROJECT_PATH/slru_rp.hh             $SLRU_HH_FILE
    cp $PROJECT_PATH/slru_rp.cc             $SLRU_CC_FILE
    cp $PROJECT_PATH/SConscript             $SCON_FILE
    #BUILD GEM5 with new values
    scons $GEM5_PATH"build/ARM/gem5.opt -j "$coresUse

    for ((i=1;i<=${blockIterations[x]};i++))
    do
        for sims in ${simulations[@]};
        do
            echo "*************************$benchName${cacheSizes[y]}*************************************"
            $GEM5_PATH"build/ARM/gem5.opt"\
                "--stats-file="$sims"_""${cacheSizes[y]}""kB_""${blockSizes[y]}""bs_""${numBlocks[y]}""pr_SLRU.txt"\
                --dump-config="$sims""_""${cacheSizes[y]}""kB_""${blockSizes[y]}""bs_""${numBlocks[y]}""pr_SLRU.ini"\
                $GEM5_PATH"configs/example/se.py" \
                --caches\
                --l1i_size=${cacheSizes[y]}"kB"\
                --l1i_assoc=$L1iAssoc\
                --l1d_size=${cacheSizes[y]}"kB"\
                --l1d_assoc=$L1dAssoc\
                --cacheline_size=${blockSizes[y]}\
                --cpu-clock=1.6GHz\
                --cpu-type=O3_ARM_v7a_3 -n 1\
                --maxinsts=$maxInst\
                --bench $sims
            y=$(($y+1))
        done
        x=$(($x+1))
    done
done

#RESTORE GEM5 BEFORE LEAVING
cp $BACKUP_PATH$TIMESTAMP/Cache.py               $CACHE_FILE
cp $BACKUP_PATH$TIMESTAMP/ReplacementPolicies.py $RP_FILE
cp $BACKUP_PATH$TIMESTAMP/SConscript             $SCON_FILE
cp $BACKUP_PATH$TIMESTAMP/slru_rp.hh             $SLRU_HH_FILE
cp $BACKUP_PATH$TIMESTAMP/slru_rp.cc             $SLRU_CC_FILE
cp $BACKUP_PATH$TIMESTAMP/SConscript             $SCON_FILE
#BUILD GEM5 with new values
scons $GEM5_PATH"build/ARM/gem5.opt -j "$coresUse

