FROM mysql
MAINTAINER chriamue@gmail.com
RUN apt-get update && apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor
RUN apt-get install -y build-essential git cmake wget
RUN apt-get install -y openssl libssl-dev mysql-client libmysqlclient-dev libmysql++-dev libboost-signals-dev libboost-system-dev libboost-filesystem-dev libboost-thread-dev libpoco-dev

RUN cd /tmp && wget http://www.cmake.org/files/v3.6/cmake-3.6.0.tar.gz && tar xf cmake-3.6.0.tar.gz && cd cmake-3.6.0 && ./configure && make && make install

RUN cd /tmp && git clone https://github.com/pocoproject/poco
RUN sed -i 's#mysqlclient_r#mysqlclient mysqlclient_r#g' /tmp/poco/cmake/FindMySQL.cmake
RUN cd /tmp/poco && mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make -j3 && make install && ldconfig

RUN mkdir -p /hypha && cd /hypha && git clone https://github.com/hyphaproject/hypha
RUN cd /hypha/hypha && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && make install

RUN cd /hypha && git clone https://github.com/hyphaproject/hyphahandlers.git
RUN cd /hypha/hyphahandlers && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && make install

RUN apt-get install -y qt5-default libqt5serialport5-dev
RUN apt-get install -y libboost-python-dev libopencv-dev
RUN cd /hypha && git clone https://github.com/hyphaproject/hyphaplugins.git
RUN cd /hypha/hyphaplugins && git submodule update --init --recursive && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && make install

RUN cd /tmp && git clone https://github.com/falsecam/confdesc.git
RUN cd /tmp/confdesc && git submodule update --init --recursive && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && make install

RUN cd /hypha && git clone https://github.com/hyphaproject/hyphawebmanager.git
RUN cd /hypha/hyphawebmanager && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && make && make install
RUN ldconfig
RUN mkdir -p /etc/hypha/
ADD hypha.conf /etc/hypha/hypha.conf
ADD runhypha.sh /bin/runhypha.sh
EXPOSE 80
CMD sh /bin/runhypha.sh
