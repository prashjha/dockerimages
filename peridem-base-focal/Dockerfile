FROM ubuntu:focal

# Set metadata
LABEL maintainer="Prashant K. Jha <pjha.sci@gmail.com>"
LABEL description="Ubuntu 20.04 (focal) with HPX for PeriDEM tests"

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
RUN apt-get update --fix-missing && \
    apt-get install -y cmake 

RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \ 
    apt-get autoclean -y 

# -----------------------
# HPX
# -----------------------
ENV HPX_MAJOR_VERSION=1
ENV HPX_MINOR_VERSION=3
ENV HPX_PATCH_VERSION=0
ENV HPX_VERSION=$HPX_MAJOR_VERSION.$HPX_MINOR_VERSION.$HPX_PATCH_VERSION

ENV HPX_INSTALL_PATH /usr/local

RUN cd /tmp && \
    wget https://github.com/STEllAR-GROUP/hpx/archive/${HPX_VERSION}.tar.gz && \
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
    -D HPX_WITH_MALLOC=jemalloc \
    -D HPX_WITH_EXAMPLES=OFF \
    -D HPX_WITH_NETWORKING=OFF \
    ../hpx-${HPX_VERSION} && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install && \
    cd .. && rm -rf hpx-$HPX_VERSION && rm -rf hpx_build

ENV HPX_DIR $HPX_INSTALL_PATH

