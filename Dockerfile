FROM debian:jessie
MAINTAINER will-beta https://github.com/will-beta

# Update the system and set up packages
RUN sed -i "s/security.debian.org/mirrors.ustc.edu.cn\/debian-security/g" /etc/apt/sources.list \
 && sed -i "s/httpredir.debian.org/mirrors.ustc.edu.cn/g" /etc/apt/sources.list \
 && apt-get update \
 && apt-get dist-upgrade -y \
 && apt-get install \
    apt-transport-https \
    wget \
    cups \
    avahi-daemon \
    python-cups \
    cups-pdf \
    hpijs-ppds \
    supervisor \
    -y --force-yes  \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up MIME types, daemon paths and admin username
RUN sh -c "echo 'image/urf urf string(0,UNIRAST<00>)' > /usr/share/cups/mime/airprint.types" \
 && sh -c "echo 'image/urf application/pdf 100 pdftoraster' > /usr/share/cups/mime/airprint.convs" \
 && mkdir -p /var/log/supervisor \
 && mkdir -p /var/run/dbus \
 && useradd -G lp,lpadmin -s /bin/bash cups \
 && echo 'cups:cups' | chpasswd

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 631
CMD ["/usr/bin/supervisord"]
