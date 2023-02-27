FROM mhart/alpine-node:15

RUN apk add --no-cache --update git bash python2 gcc g++ make openssh-client ffmpeg curl clang neofetch sudo\
    && adduser -u 997 -D -h /home/container container \
    && echo "container ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
COPY ./config.conf /home/container/.config/neofetch/config.conf

CMD ["/bin/sh"]

cd /opt && \
wget https://github.com/opencv/opencv/archive/4.5.1.zip && \
unzip 4.5.1.zip && rm 4.5.1.zip && \
wget https://github.com/opencv/opencv_contrib/archive/4.5.1.zip && \
unzip 4.5.1.zip && rm 4.5.1.zip \
&& \
cd /opt/opencv-4.5.1 && mkdir build && cd build && \
cmake -D CMAKE_BUILD_TYPE=RELEASE \
-D CMAKE_C_COMPILER=/usr/bin/clang \
-D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
-D CMAKE_INSTALL_PREFIX=/usr/local \
-D INSTALL_PYTHON_EXAMPLES=OFF \
-D INSTALL_C_EXAMPLES=OFF \
-D WITH_FFMPEG=ON \
-D WITH_TBB=ON \
-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-4.5.1/modules \
.. \
&& \
make -j$(nproc) && make install && cd .. && rm -rf build