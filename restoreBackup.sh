#SET TO YOUR PERSONAL GEM5 PATH BY MODIFYING THE CONFIG FILE
GEM5_PATH=$(cat gem5path.config)

if [[ ! -f $GEM5_PATH"build/ARM/gem5.opt" ]]
  then
    echo "Please set the GEM5 path correctly!"
    exit 1
fi

CACHE_FILE=$GEM5_PATH"src/mem/cache/Cache.py"
RP_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/ReplacementPolicies.py"
SCON_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/SConscript"
SLRU_HH_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.hh"
SLRU_CC_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.cc"

BACKUP_DIR=$1

if [ "$BACKUP_DIR" == "" ]; then
        echo "Please enter a backup Directory"
        exit 1
fi

if [[ ! -f $BACKUP_DIR"Cache.py" ]]
  then
    echo "This backup directory is invalid."
    exit 1
fi

if [[ ! -f $BACKUP_DIR"ReplacementPolicies.py" ]]
  then
    echo "This backup directory is invalid."
    exit 1
fi

if [[ ! -f $BACKUP_DIR"SConscript" ]]
  then
    echo "This backup directory is invalid."
    exit 1
fi

if [[ ! -f $BACKUP_DIR"slru_rp.hh" ]]
  then
    echo "This backup directory is invalid."
    exit 1
fi

if [[ ! -f $BACKUP_DIR"slru_rp.cc" ]]
  then
    echo "This backup directory is invalid."
    exit 1
fi

cp $BACKUP_DIR"Cache.py"                    $CACHE_FILE
cp $BACKUP_DIR"ReplacementPolicies.py"      $RP_FILE
cp $BACKUP_DIR"SConscript"                  $SCON_FILE
cp $BACKUP_DIR"slru_rp.hh"                  $SLRU_HH_FILE
cp $BACKUP_DIR"slru_rp.cc"                  $SLRU_CC_FILE

echo "Restored backup from $BACKUP_DIR"