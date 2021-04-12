#SET TO YOUR PERSONAL GEM5 PATH BY MODIFYING THE CONFIG FILE
GEM5_PATH=$(cat gem5path.config)

  if [[ ! -f $GEM5_PATH"build/ARM/gem5.opt" ]]
  then
    echo "Please set the GEM5 path correctly!"
    exit 1
  fi

PROJECT_PATH=$(pwd)/

RESULTS_PATH=$PROJECT_PATH"SimulationResults"/

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

CONFIG_DIR=$RESULTS_PATH$TIMESTAMP/"configs"
STATS_DIR=$RESULTS_PATH$TIMESTAMP/"stats"

mkdir -p $CONFIG_DIR
mkdir -p $STATS_DIR

benchmarks=(
	a2time01
	cacheb01
	bitmnp01
	mcf
	libquantum
)

cd $GEM5_PATH

# for bench in "${benchmarks[@]}"; do
# 	build/ARM/gem5.opt --stats-file $STATS_DIR/stats-"$bench".txt 		\
# 	--dump-config=$CONFIG_DIR/config-"$bench".ini configs/example/se.py 		\
# 	--caches --l1i_size=32kB --l1i_assoc=4 --l1d_size=32kB --l1d_assoc=4 	\
# 	--cacheline_size=64 --cpu-clock=1.6GHz  	 			\
# 	--cpu-type=O3_ARM_v7a_3 -n 1 --maxinst=100000000 --bench "$bench"
# done

for bench in "${benchmarks[@]}"; do
	build/ARM/gem5.opt --stats-file $STATS_DIR/stats-"$bench"-l2.txt 			\
	--dump-config=$CONFIG_DIR/config-"$bench"-l2.ini configs/example/se.py 		\
	--caches --l1i_size=32kB --l1i_assoc=4 --l1d_size=32kB --l1d_assoc=4 		\
	--cacheline_size=64 --cpu-clock=1.6GHz --l2cache --l2_size=1MB --l2_assoc=8	\
	--cpu-type=O3_ARM_v7a_3 -n 1 --maxinst=100000000 --bench "$bench"
done

cd $PROJECT_PATH


