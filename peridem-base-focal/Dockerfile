FROM ubuntu:focal

# Set metadata
LABEL maintainer="Prashant K. Jha <pjha.sci@gmail.com>"
LABEL description="Ubuntu 20.04 (focal) with VTK (9.2.5) and HPX (1.8.1) for PeriDEM tests"

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
    libgmsh-dev gmsh libflann-dev \
    gcc-10 g++-10 libtbb-dev libasio-dev libglvnd-dev  && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 

RUN pip3 install numpy pyvista pandas

RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get autoclean -y 

RUN gcc -v 

# create symlink for metis
RUN ln -sf /usr/lib/x86_64-linux-gnu/libmetis.so /usr/lib/libmetis.so
RUN ls /usr/include/metis*
RUN ls /usr/lib/libmetis*

# -----------------------
# cmake
# -----------------------
RUN apt-get purge --auto-remove cmake && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main' && \
    apt-get update --fix-missing && \
    apt-get install -y cmake

RUN cmake --version 

RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get autoclean -y 

# -----------------------
# HPX
# -----------------------
ENV HPX_MAJOR_VERSION=1
ENV HPX_MINOR_VERSION=8
ENV HPX_PATCH_VERSION=1
ENV HPX_VERSION=$HPX_MAJOR_VERSION.$HPX_MINOR_VERSION.$HPX_PATCH_VERSION

ENV HPX_INSTALL_PATH /usr/local

RUN cd /tmp && \
    wget https://github.com/STEllAR-GROUP/hpx/archive/refs/tags/${HPX_VERSION}.tar.gz && \
    mkdir -p hpx-${HPX_VERSION} && \
    tar -zxf ${HPX_VERSION}.tar.gz -C hpx-${HPX_VERSION} --strip-components=1 && \
    rm -f ${HPX_VERSION}.tar.gz && \
    mkdir -p hpx_build && \
    cd hpx_build && \
    cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=${HPX_INSTALL_PATH} \
    -D CMAKE_CXX_COMPILER=g++ \
    -D CMAKE_C_COMPILER=gcc \
    -D CMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -D HPX_WITH_THREAD_IDLE_RATES=ON \
    -D HPX_WITH_DISABLED_SIGNAL_EXCEPTION_HANDLERS=ON \
    -D HPX_WITH_MALLOC=system \
    -D HPX_WITH_EXAMPLES=OFF \
    -D HPX_WITH_TESTS=OFF \
    -D HPX_WITH_NETWORKING=OFF \
    ../hpx-${HPX_VERSION} && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install && \
    cd .. && \
    rm -rf hpx-${HPX_VERSION} && \
    rm -rf hpx_build

ENV HPX_DIR ${HPX_INSTALL_PATH}

# -----------------------
# VTK
# -----------------------
ENV VTK_MAJOR_VERSION=9
ENV VTK_MINOR_VERSION=2
ENV VTK_PATCH_VERSION=5
ENV VTK_VERSION=$VTK_MAJOR_VERSION.$VTK_MINOR_VERSION.$VTK_PATCH_VERSION

ENV VTK_INSTALL_PATH /usr/local

RUN cd /tmp && \
    git clone --recursive https://gitlab.kitware.com/vtk/vtk.git vtk-${VTK_VERSION} && \
    cd vtk-${VTK_VERSION} && \
    git checkout v${VTK_VERSION} && \
    cd .. && \
    mkdir -p vtk_build && \
    cd vtk_build && \
    cmake -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=${VTK_INSTALL_PATH} \
    -D VTK_Group_MPI:BOOL=ON \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_SHARED_LIBS=ON \
    -D BUILD_TESTING=OFF \
    -D VTK_USE_SYSTEM_EXPAT=ON \
    -D VTK_USE_SYSTEM_HDF5=ON \
    -D VTK_USE_SYSTEM_JPEG=ON \
    -D VTK_USE_SYSTEM_LIBXML2=ON \
    -D VTK_USE_SYSTEM_NETCDF=ON \
    -D VTK_USE_SYSTEM_PNG=ON \
    -D VTK_USE_SYSTEM_TIFF=ON \
    -D VTK_USE_SYSTEM_ZLIB=ON \
    -D VTK_REQUIRED_OBJCXX_FLAGS='' \
    -D VTK_QT_VERSION:STRING=5 \
    -D VTK_Group_Qt=ON \
    ../vtk-${VTK_VERSION} && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install && \
    cd .. && \
    rm -rf vtk-${VTK_VERSION} && \
    rm -rf vtk_build

ENV VTK_DIR ${VTK_INSTALL_PATH}
