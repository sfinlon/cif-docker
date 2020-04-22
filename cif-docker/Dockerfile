FROM ubuntu:16.04
LABEL developer="Wes Young <wes@csirtgadgets.org>"
LABEL docker_maintainer="Scott Finlon (@sfinlon)"

EXPOSE 5000

ENV DOCKER_BUILD=yes

ENV SUDO_USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY entrypoint /

ADD https://github.com/csirtgadgets/bearded-avenger-deploymentkit/archive/3.0.8.tar.gz /tmp/dk.tar.gz
ADD https://github.com/csirtgadgets/bearded-avenger/archive/3.0.8.tar.gz /tmp/ba.tar.gz

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections ; \
    mkdir -p /etc/resolvconf/resolv.conf.d ; \
    mkdir -p /var/log/cif ; \
    chmod 755 /entrypoint ; \
    mkdir -p /var/lib/cif ; \
    mkdir -p /etc/cif ; \
    mkdir -p /etc/cron.d ; \
    useradd cif

RUN apt-get update ; \
    apt-get --no-install-recommends -y install ; \
    apt-get install -y sudo resolvconf curl wget python3-pip build-essential \
        python3-dev python3 aptitude libffi-dev libssl-dev sqlite3 software-properties-common ; \
    cd /tmp ; \
    tar -zxf ba.tar.gz ; \
    tar -zxf dk.tar.gz ; \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.5 1 ; \
    update-alternatives --install /usr/bin/pip pip /usr/bin/pip3 1

WORKDIR /tmp/bearded-avenger-3.0.8

RUN pip install --upgrade pip ; \
    pip install -r dev_requirements.txt ; \
    CIF_ENABLE_INSTALL=1 python setup.py install ; \
    pip install 'setuptools>=18.3,<34.0' 'ansible>=2.4,<2.5' 'supervisor>=4' ; \
    ansible-galaxy install csirtgadgets.cif,0.0.14 ; \
    cd /tmp/bearded-avenger-deploymentkit-3.0.8/ubuntu16 ; \
    bash ../ansible.sh

WORKDIR /tmp

RUN cp /home/cif/.cif.yml /var/lib/cif/ ; \
    cp /etc/cif/csirtg-smrt.yml /var/lib/cif/ ; \
    cp /etc/cif/cif-router.yml /var/lib/cif/

WORKDIR /home/cif

ENTRYPOINT ["/entrypoint", "-n"]
