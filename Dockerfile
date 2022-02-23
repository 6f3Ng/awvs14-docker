FROM ubuntu:20.04
ARG version=220117111
# --build-arg version=210615184

ENV DEBIAN_FRONTEND noninteractive
ENV acunetix_install = acunetix_14.6.${version}_x64.sh


# acunetix
# RUN  apt-get update --fix-missing
ADD acunetix_14.6.${version}_x64.sh /tmp/acunetix_14.6.${version}_x64.sh
ADD wvsc /tmp/wvsc
ADD license_info.json /tmp/license_info.json
ADD wa_data.dat  /tmp/wa_data.dat 
ADD install.expect /tmp/install.expect
WORKDIR /tmp
RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
  && sed -i "s@http://.*security.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
  && apt-get update --fix-missing && apt-get upgrade -y && apt-get install -y net-tools apt-utils sudo
RUN apt-get install -y libxdamage1 libgtk-3-0 libasound2 libnss3 libxss1 libx11-xcb1 libxcb-dri3-0 libgbm1 libdrm2 libxshmfence1
RUN chmod u+x /tmp/acunetix_14.6.${version}_x64.sh
RUN sh -c '/bin/echo -e "\nyes\nubuntu\nadmin@test.com\nTest1234\nTest1234\n"| /tmp/acunetix_14.6.${version}_x64.sh'; \
    chmod 444 license_info.json wa_data.dat;\
    chmod +x /tmp/acunetix_14.6.${version}_x64.sh;\
    chmod +x /tmp/install.expect && expect /tmp/install.expect;\
    cp /tmp/wvsc /home/acunetix/.acunetix/v_${version}/scanner/;\
    cp /tmp/wa_data.dat /home/acunetix/.acunetix/data/license/;\
    cp /tmp/license_info.json /home/acunetix/.acunetix/data/license/
CMD su -l acunetix -c /home/acunetix/.acunetix/start.sh
EXPOSE 3443
