FROM ubuntu:bionic

# Set metadata
LABEL maintainer="Prashant K. Jha <pjha.sci@gmail.com>"
LABEL description="Ubuntu 18.04 (bionic) with VTK (9.3.0) for PeriDEM tests"

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
    libmetis-dev \
    libtbb-dev libasio-dev libglvnd-dev \
    libjpeg-dev zlib1g-dev # for pillow python library \
    libgl1-mesa-dev # for VTK 

# python packages
RUN pip3 install numpy pyvista pandas

# clean up
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get autoclean -y 

# create symlink for metis
RUN ln -sf /usr/lib/x86_64-linux-gnu/libmetis.so /usr/lib/libmetis.so && \
    echo "Display metis header and lib files" && \
    ls /usr/include/metis* && \
    ls /usr/lib/libmetis*

# -----------------------
# cmake
# -----------------------
RUN apt-get purge --auto-remove cmake && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null && \
    apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' 

# fix public key issue with kitware repo following https://askubuntu.com/a/1484178 and https://askubuntu.com/a/865294
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4 && \
    gpg --export --armor 6AF7F09730B3F0A4 | apt-key add - && \
    apt-get update 

RUN apt-get update --fix-missing && \
    apt-get install -y cmake

RUN cmake --version 

# clean up
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* && \
    apt-get autoremove -y && \
    apt-get autoclean -y 

# -----------------------
# VTK
# -----------------------
ENV VTK_MAJOR_VERSION=9
ENV VTK_MINOR_VERSION=3
ENV VTK_PATCH_VERSION=0
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
    -D BUILD_SHARED_LIBS=ON \
    -D BUILD_TESTING=OFF \
    -D VTK_REQUIRED_OBJCXX_FLAGS='' \
    -D HDF5_BUILD_FRAMEWORKS=OFF \
    -D VTK_BUILD_DOCUMENTATION=OFF \
    -D VTK_BUILD_EXAMPLES=OFF \
    -D VTK_BUILD_SCALED_SOA_ARRAYS=OFF \
    -D VTK_BUILD_SPHINX_DOCUMENTATION=OFF \
    -D VTK_GROUP_ENABLE_MPI=NO \
    -D VTK_GROUP_ENABLE_Qt=DONT_WANT \
    -D VTK_GROUP_ENABLE_Rendering=NO \
    -D VTK_GROUP_ENABLE_Views=NO \
    -D VTK_GROUP_ENABLE_Web=NO \
    -D VTK_Group_MPI=ON \
    -D VTK_USE_MPI=OFF \
    -D VTK_WRAP_PYTHON=OFF \
    ../vtk-${VTK_VERSION} && \
    make -j $(cat /proc/cpuinfo | grep processor | wc -l) VERBOSE=1 && \
    make install && \
    cd .. && \
    rm -rf vtk-${VTK_VERSION} && \
    rm -rf vtk_build

ENV VTK_DIR ${VTK_INSTALL_PATH}

