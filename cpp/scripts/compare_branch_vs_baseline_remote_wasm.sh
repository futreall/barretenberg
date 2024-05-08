#!/usr/bin/env bash

# Install requirements (numpy + scipy) for comparison script if necessary.
# Note: By default, installation will occur in $HOME/.local/bin.
# pip3 install --user -r $BUILD_DIR/_deps/benchmark-src/requirements.txt


# This script is used to compare a suite of benchmarks between baseline (default: master) and
# the branch from which the script is run. Simply check out the branch of interest, ensure
# it is up to date with local master, and run the script.

# Specify the benchmark suite and the "baseline" branch against which to compare
BENCHMARK=${1:-goblin_bench}
FILTER=${2:-"*."}
PRESET=${3:-wasm-threads}
BUILD_DIR=${4:-build-wasm-threads}
HARDWARE_CONCURRENCY=${HARDWARE_CONCURRENCY:-16}

BASELINE_BRANCH="master"
BENCH_TOOLS_DIR="$BUILD_DIR/_deps/benchmark-src/tools"

echo -e "\nComparing $BENCHMARK between $BASELINE_BRANCH and current branch:"

# Move above script dir.
cd $(dirname $0)/..

# Run benchmark in feature branch
echo -e "\nRunning benchmark in feature branch.."
./scripts/benchmark_wasm_remote.sh $BENCHMARK\
                                   "./$BENCHMARK --benchmark_filter=$FILTER\
                                                 --benchmark_out=../results_after.json\
                                                 --benchmark_out_format=json"

scp $BB_SSH_KEY $BB_SSH_INSTANCE:$BB_SSH_CPP_PATH/results_after.json $BUILD_DIR/

# Run benchmark in $BASELINE branch

echo -e "\nRunning benchmark in baseline branch.."
git checkout $BASELINE_BRANCH
./scripts/benchmark_wasm_remote.sh $BENCHMARK\
                                   "./$BENCHMARK --benchmark_filter=$FILTER\
                                                 --benchmark_out=../results_before.json\
                                                 --benchmark_out_format=json"

scp $BB_SSH_KEY $BB_SSH_INSTANCE:$BB_SSH_CPP_PATH/results_before.json $BUILD_DIR/

# Call compare.py on the results (json) to get high level statistics.
# See docs at https://github.com/google/benchmark/blob/main/docs/tools.md for more details.
$BENCH_TOOLS_DIR/compare.py benchmarks $BUILD_DIR/results_before.json $BUILD_DIR/results_after.json

# Return to branch from which the script was called
git checkout -