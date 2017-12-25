# smarthome.py  -NG
# 
#
FROM debian:jessie
MAINTAINER Julian Kalinowski

ENV DEBIAN_FRONTEND noninteractive

## Change Language
RUN apt-get update -qq && apt-get install -y locales apt-utils ;\
    echo "Europe/Berlin" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="de_DE.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=de_DE.UTF-8


RUN apt-get -y install -y build-essential git dialog openntpd python3 python3-dev python3-setuptools unzip python3-psutil python3-serial && \
    easy_install3 pip && \
    pip3 install ephem pyyaml cherrypy jinja2 pyserial python-forecastio colorama influxdb pychromecast ipython logutils ruamel.yaml && \
    adduser smarthome --disabled-password --gecos "First Last,RoomNumber,WorkPhone,HomePhone" && usermod -aG www-data  smarthome



RUN cd /usr/local && \ 
    git clone git://github.com/smarthomeNG/smarthome.git --branch v1.3_Hotfix_2 && \
    cd ./smarthome/ && git clone https://github.com/smarthomeNG/plugins.git --branch v1.3 && \
    chown -R smarthome:smarthome /usr/local/smarthome && \
    mkdir -p /usr/local/smarthome/var/run/ && \
    cd /usr/local/smarthome/ && pip3 install -r requirements/all.txt

RUN chmod 755 /usr/local/smarthome/bin/smarthome.py

CMD ["/usr/local/smarthome/bin/smarthome.py", "-d"]
#CMD ["/usr/local/bin/run.sh"]

## CLI, Network, Speechparser
EXPOSE 2323 2424 2788




# Start with docker -d -p 2424:2424 -p 2323:2323 -p 2788:2788 -v /path/to/your/smarthome.py_folder:/usr/local/smarthome.py henfri/smarthome.py

#docker -d -p 2424:2424 -p 2323:2323 -p 2788:2788 -v /mnt2/RockOn/config/smarthome:/usr/local/smarthome.py henfri/smarthome.py
