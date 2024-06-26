#!/bin/bash

# get name of this script
this_script=$(basename "$0")

(
## get paths from file
. /lib_vars_paths.txt
echo "VTK_LIB_CMAKE_DIR = ${VTK_LIB_CMAKE_DIR}"
echo "METIS_LIB_DIR = ${METIS_LIB_DIR}"

## or set them manually below
## VTK_LIB_CMAKE_DIR="/usr/local/lib/cmake/vtk-9.3"
## METIS_LIB_DIR="/usr/lib"

echo "<<<<<<<<<<< >>>>>>>>>>>"
echo "PERIDEM"
echo "<<<<<<<<<<< >>>>>>>>>>>"
git clone https://github.com/prashjha/PeriDEM.git 
cd PeriDEM 
cd .. 

build_types=(Debug Release)

for build_type in "${build_types[@]}"; do
  echo "Build type = ${build_type}"
  
  mkdir -p peridem_build/${build_type} && cd peridem_build/${build_type}

  cmake \
    -DCMAKE_BUILD_TYPE=${build_type} \
    -DEnable_Tests=ON \
    -DDisable_Docker_MPI_Tests=OFF \
    -DVTK_DIR="${VTK_LIB_CMAKE_DIR}" \
    -DMETIS_DIR="${METIS_LIB_DIR}" \
    ../../PeriDEM 

  make -j $(cat /proc/cpuinfo | grep processor | wc -l)

  ctest --verbose

  # cd to base
  cd ../..
done
) 2>&1 | tee "${this_script}.log"
