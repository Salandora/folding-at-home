FROM debian:stable-slim
LABEL maintainer="john.k.tims@gmail.com"

ENV FAH_VERSION_MINOR=7.5.1
ENV FAH_VERSION_MAJOR=7.5

ENV DEBIAN_FRONTEND=noninteractive

ENV USERNAME=Anonymous
ENV TEAM=0
ENV POWER=full
ENV GPU=false
ENV SMP=true
ENV PASSKEY=

RUN useradd -ms /bin/bash folder

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl adduser bzip2 ca-certificates &&\
        curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAH_VERSION_MAJOR}/fahclient_${FAH_VERSION_MINOR}_amd64.deb &&\
        mkdir -p /etc/fahclient/ &&\
        dpkg --install /tmp/fah.deb &&\
        apt-get remove -y curl &&\
        apt-get autoremove -y &&\
        rm --recursive --verbose --force /tmp/* /var/log/* /var/lib/apt/
        
ADD config.xml /etc/fahclient/
RUN chown fahclient:root /etc/fahclient/config.xml
RUN sed -i -e "s/{{USERNAME}}/$USERNAME/;s/{{TEAM}}/$TEAM/;s/{{PASSKEY}}/$PASSKEY/;s/{{POWER}}/$POWER/;s/{{GPU}}/$GPU/" /etc/fahclient/config.xml

# Web viewer
EXPOSE 7396
EXPOSE 36330

USER folder

WORKDIR /home/folder

ENTRYPOINT ["FAHClient", "--web-allow=0/0:7396", "--allow=0/0:36330"]
CMD ["--smp=$SMP"]
