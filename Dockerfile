# Reference: https://askubuntu.com/questions/195545/how-to-enable-sftp-support-in-curl
FROM ubuntu:18.04

ENV CPPFLAGS=-I/usr/local/include
ENV LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib"
ENV LIBS="-ldl"

RUN sed -i -e "s/# deb-src /deb-src /g" /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y build-essential debhelper libssh-dev

WORKDIR /opt/

# Fetch cURL source code
RUN apt-get source curl
RUN apt-get build-dep -y curl
RUN cd curl-*/debian/ && sed -i -e "s@CONFIGURE_ARGS += --without-libssh2@CONFIGURE_ARGS += --with-libssh2@g" rules
RUN cd curl-*/ && dpkg-buildpackage -uc -us -b
RUN dpkg -i curl_*.deb
RUN dpkg -i libcurl3-*.deb
RUN dpkg -i libcurl3-gnutls_*.deb
RUN dpkg -i libcurl4-gnutls-dev_7.58.0-2ubuntu3.8_amd64.deb libcurl4_7.58.0-2ubuntu3.8_amd64.deb
