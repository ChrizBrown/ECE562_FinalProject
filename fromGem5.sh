#SET TO YOUR PERSONAL GEM5 PATH
GEM5_PATH="../gem5/"

# DO NOT CHANGE ANYTHING AFTER THIS LINE
PROJECT_PATH=$(pwd)/

timestamp() {
  date +"%Y-%m-%d_%H-%M-%S"
}

CACHE_FILE=$GEM5_PATH"src/mem/cache/Cache.py"
RP_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/ReplacementPolicies.py"
SLRU_HH_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.hh"
SLRU_CC_FILE=$GEM5_PATH"src/mem/cache/replacement_policies/slru_rp.cc"


# file $CACHE_FILE
# file $RP_FILE
# file $SLRU_HH_FILE
# file $SLRU_CC_FILE

cp $CACHE_FILE      $PROJECT_PATH/Cache.py
cp $RP_FILE         $PROJECT_PATH/ReplacementPolicies.py
cp $SLRU_HH_FILE    $PROJECT_PATH/slru_rp.hh
cp $SLRU_CC_FILE    $PROJECT_PATH/slru_rp.cc 

echo "Done!"
