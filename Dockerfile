FROM resin/rpi-raspbian

MAINTAINER Michael Wilmes <mwilmes@gmx.de>
# Based of work by https://github.com/nicosingh

# Add GPG keys for additional APT repository and add repository
RUN gpg --keyserver pgp.mit.edu --recv-keys 40C430F5 &&\
  gpg --armor --export 40C430F5 | apt-key add - &&\
  mv /etc/apt/sources.list /etc/apt/sources.list.bak &&\
  grep -v flightradar24 /etc/apt/sources.list.bak > /etc/apt/sources.list || echo OK &&\
  echo 'deb http://repo.feed.flightradar24.com flightradar24 raspberrypi-stable' >> /etc/apt/sources.list

# Install stuff
RUN apt-get update -y &&\
  apt-get -y install cmake gcc pkg-config libusb-1.0 make git-core libc-dev wget supervisor fr24feed &&\
  apt-get clean

WORKDIR /tmp

RUN git clone git://git.osmocom.org/rtl-sdr.git &&\
  mkdir -p rtl-sdr/build &&\
  cd rtl-sdr/build &&\
  cmake ../ -DINSTALL_UDEV_RULES=ON -DDETACH_KERNEL_DRIVER=ON &&\
  make &&\
  make install &&\
  rm -rf rtl-sdr

RUN ldconfig

WORKDIR /

RUN git clone https://github.com/MalcolmRobb/dump1090.git &&\
  cd /dump1090 &&\
  make &&\
  ln -s /dump1090 /bin/

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080 8754

CMD ["/usr/bin/supervisord"]
