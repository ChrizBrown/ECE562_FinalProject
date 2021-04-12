#SET TO YOUR PERSONAL GEM5 PATH
GEM5_PATH=$(cat gem5path.config)

  if [[ ! -d $GEM5_PATH ]]
  then
    echo "Please set the GEM5 path correctly!"
    exit 1
  fi

# DO NOT CHANGE ANYTHING AFTER THIS LINE
PROJECT_PATH=$(pwd)/
BACKUP_PATH=$(pwd)/Backup/

timestamp() {
  date +"%Y-%m-%d_%H-%M-%S"
}

CACHE_FILE=$GEM5_PATH"src/mem/cache/Cache.py"
RP_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/ReplacementPolicies.py"
SCON_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/SConscript"
SLRU_HH_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.hh"
SLRU_CC_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.cc"


# file $CACHE_FILE
# file $RP_FILE
# file $SCON_FILE
# file $SLRU_HH_FILE
# file $SLRU_CC_FILE

# Backup old files
cp $CACHE_FILE      $BACKUP_PATH/$(timestamp)_Cache.py
cp $RP_FILE         $BACKUP_PATH/$(timestamp)_ReplacementPolicies.py
cp $SCON_FILE       $BACKUP_PATH/$(timestamp)_SConscript.py
cp $SLRU_HH_FILE    $BACKUP_PATH/$(timestamp)_slru_rp.hh
cp $SLRU_CC_FILE    $BACKUP_PATH/$(timestamp)_slru_rp.cc

cp $PROJECT_PATH/Cache.py               $CACHE_FILE
cp $PROJECT_PATH/ReplacementPolicies.py $RP_FILE
cp $PROJECT_PATH/slru_rp.hh             $SLRU_HH_FILE
cp $PROJECT_PATH/slru_rp.cc             $SLRU_CC_FILE

echo "Done transferring files to GEM5!"
