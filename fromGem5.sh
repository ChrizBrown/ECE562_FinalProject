#SET TO YOUR PERSONAL GEM5 PATH
GEM5_PATH=$(cat gem5path.config)

  if [[ ! -d $GEM5_PATH ]]
  then
    echo "Please set the GEM5 path correctly!"
    exit 1
  fi

# # DO NOT CHANGE ANYTHING AFTER THIS LINE
# PROJECT_PATH=$(pwd)/

# timestamp() {
#   date +"%Y-%m-%d_%H-%M-%S"
# }

# CACHE_FILE=$GEM5_PATH"src/mem/cache/Cache.py"
# RP_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/ReplacementPolicies.py"
# SCON_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/SConscript"
# SLRU_HH_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.hh"
# SLRU_CC_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.cc"


# # file $CACHE_FILE
# # file $RP_FILE
# # file $SCON_FILE
# # file $SLRU_HH_FILE
# # file $SLRU_CC_FILE

# cp $CACHE_FILE      $PROJECT_PATH/Cache.py
# cp $RP_FILE         $PROJECT_PATH/ReplacementPolicies.py
# cp $SCON_FILE       $PROJECT_PATH/SConscript
# cp $SLRU_HH_FILE    $PROJECT_PATH/slru_rp.hh
# cp $SLRU_CC_FILE    $PROJECT_PATH/slru_rp.cc 

# echo "Done pulling modified files from GEM5!"
