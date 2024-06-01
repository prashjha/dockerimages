#!/bin/bash

(
echo "<<<<<<<<<<< >>>>>>>>>>>"
echo "PERIDEM"
echo "<<<<<<<<<<< >>>>>>>>>>>"
git clone https://github.com/prashjha/PeriDEM.git 
cd PeriDEM 
git checkout remove_hpx 
git submodule update --init --recursive 
cd .. 

build_types=(Debug Release)

for build_type in "${build_types[@]}"; do
  echo "Build type = ${build_type}"
  
  mkdir -p peridem_build/${build_type} && cd peridem_build/${build_type}

  cmake \
    -DCMAKE_BUILD_TYPE=${build_type} \
    -DEnable_Tests=ON \
    -DDisable_Docker_MPI_Tests=OFF \
    -DVTK_DIR="/usr/local/lib/cmake/vtk-9.2" \
    -DMETIS_DIR="/usr/local/Cellar/metis/5.1.0" \
    ../../PeriDEM 

  make -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 

  ctest --extra-verbose

  # cd to base
  cd ../..
done
) |& tee "build_peridem.log"
