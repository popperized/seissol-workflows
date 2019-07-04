#!/usr/bin/env bash

cp ./seissol/build/SeisSol_release_generatedKernels_dnoarch_hybrid_none_9_2 \
   ./workflows/tpv33/input-data/

cd ./workflows/tpv33/input-data
mpiexec \
  --allow-run-as-root \
  --oversubscribe \
  -np 1 \
  ./SeisSol_release_generatedKernels_dnoarch_hybrid_none_9_2 \
  parameters_tpv33_master.par > output/out.txt
