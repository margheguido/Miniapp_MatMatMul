#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mguido/hdf5-install/lib64
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mguido/petsc-install-new/lib

for i in {1..16}
do
   mpirun -np $i ./test_miniapp 2>&1|tee log
done



