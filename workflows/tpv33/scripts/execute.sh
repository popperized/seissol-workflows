#!/usr/bin/env bash
set -e

EXECUTION_DIR="$PWD/workflows/tpv33/execution/"

# move binary
# TODO: we assume that there's only one binary in the build/ folder. Instead, we 
# can look for a SEISSOL_BIN variable and use that if defined; otherwise we can 
# try to copy whatever binary is there but throw an error if there's more than 
# one available
SEISSOL_BIN="$(ls $GITHUB_WORKSPACE/$SEISSOL_SRC_DIR/build/SeisSol_*)"

if [ -z "$OMP_NUM_THREADS" ]; then
  echo "No OMP_NUM_THREADS variable defined"
  exit 1
fi
if [ -z "$MPI_NUM_PROCESSES" ]; then
  echo "No MPI_NUM_ROCESSES variable defined"
  exit
fi
if [ -z "$SEISSOL_END_TIME" ]; then
  echo "No SEISSOL_END_TIME variable defined"
  exit 1
fi

cp "$SEISSOL_BIN" "$EXECUTION_DIR"

mkdir -p "$EXECUTION_DIR/output"

# run
cd "$EXECUTION_DIR"

sed -i "s#EndTime = .*#EndTime = $SEISSOL_END_TIME#" parameters_tpv33_master.par

mpirun \
  --allow-run-as-root \
  --oversubscribe \
  -np "$MPI_NUM_PROCESSES" \
  "$SEISSOL_BIN" \
  parameters_tpv33_master.par
