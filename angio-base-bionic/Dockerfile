FROM ubuntu:bionic

# Set metadata
LABEL maintainer="Prashant K. Jha <pjha.sci@gmail.com>"
LABEL description="Ubuntu 18.04 (bionic) with Petsc and Libmesh"

# install essentials
RUN apt-get update --fix-missing && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git less wget curl lzip bzip2 unzip autoconf libtool pkg-config \
    rpm gcovr ruby-coveralls libproj-dev m4 \
    software-properties-common ubuntu-dev-tools \
    gfortran make build-essential libssl-dev clang-format-10 clang-tidy \
    openssh-server rsync \
    doxygen doxygen-latex graphviz ghostscript \
    lldb valgrind \
    python3-pip 

RUN apt-get update --fix-missing && \
    apt-get install -y \
    libopenmpi-dev openmpi-bin \
    libblas-dev liblapack-dev libmpfr-dev libgmp-dev \
    libhwloc-dev libjemalloc-dev libboost-all-dev libyaml-cpp-dev \
    libvtk7-dev libgmsh-dev gmsh libflann-dev 

RUN pip3 install numpy pyvista pandas

RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \ 
    apt-get autoclean -y 

# -----------------------
# cmake
# -----------------------
ARG CMAKE_MAJOR_VERSION=3.20
ARG CMAKE_MINOR_VERSION=2
ARG CMAKE_VERSION=$CMAKE_MAJOR_VERSION.$CMAKE_MINOR_VERSION

RUN cd /tmp && \
    wget https://cmake.org/files/v$CMAKE_MAJOR_VERSION/cmake-$CMAKE_VERSION.tar.gz && \
    tar xf cmake-$CMAKE_VERSION.tar.gz && \
    cd cmake-$CMAKE_VERSION && \
    ./bootstrap && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) && \
    make install && \
    cd .. && \
    rm -rf cmake*

# -----------------------
# PETSc
# -----------------------
ENV PETSC_VERSION 3.13.3

RUN cd /tmp && \
    wget http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-$PETSC_VERSION.tar.gz && \
    tar xf petsc-lite-$PETSC_VERSION.tar.gz && rm -f petsc-lite-$PETSC_VERSION.tar.gz && \
    cd petsc-$PETSC_VERSION && \
    ./configure \
    --prefix=/usr/lib/petsc-$PETSC_VERSION \
    --with-blas-lib=libblas.a \
    --with-lapack-lib=liblapack.a \
    --download-hypre  \
    --download-scalapack \
    --download-mumps \
    --download-metis \
    --download-parmetis \
    --download-superlu \
    --download-superlu_dist \
    --with-debugging=0 \
    COPTFLAGS='-O3' CXXOPTFLAGS='-O3' FOPTFLAGS='-O3' && \
    make VERBOSE=1 PETSC_DIR=`pwd` -j $(cat /proc/cpuinfo | grep processor | wc -l) all && \
    make PETSC_DIR=`pwd` install && \
    cd /tmp && rm -rf petsc-$PETSC_VERSION

#CFLAGS='-fPIC' CXXFLAGS='-fPIC' FCFLAGS='-fPIC' \

ENV PETSC_DIR /usr/lib/petsc-$PETSC_VERSION
ENV METIS_DIR $PETSC_DIR
ENV SCALAPACK_DIR $PETSC_DIR
ENV PARMETIS_DIR $PETSC_DIR
ENV SUPERLU_DIR $PETSC_DIR
ENV SUPERLU_DIST_DIR $PETSC_DIR
ENV MUMPS_DIR $PETSC_DIR
ENV HYPRE_DIR $PETSC_DIR

# -----------------------
# Libmesh
# -----------------------
ENV LIBMESH_VERSION=1.5.0
ENV LIBMESH_DIR /usr/lib/libmesh-$LIBMESH_VERSION

RUN cd /tmp && \
    wget https://github.com/libMesh/libmesh/archive/refs/tags/v${LIBMESH_VERSION}.tar.gz && \
    mkdir -p libmesh-${LIBMESH_VERSION} && \
    tar -zxf v${LIBMESH_VERSION}.tar.gz -C libmesh-${LIBMESH_VERSION} --strip-components=1 && \
    rm -f v${LIBMESH_VERSION}.tar.gz && \
    cd libmesh-${LIBMESH_VERSION} && \
    mkdir build && \
    cd build && \
    ../configure --with-methods="opt" \
                 --prefix=$LIBMESH_DIR \
                 --with-metis=PETSc && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) && \
    make install && \
    cd ../.. && rm -rf libmesh-${LIBMESH_VERSION}
