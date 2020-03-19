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

RUN useradd --system folder

RUN apt-get update && apt-get install --no-install-recommends -y \
        curl adduser bzip2 ca-certificates
       
RUN mkdir -p /etc/fahclient/
COPY --chown=folder:folder config.xml /etc/fahclient/ 

RUN curl -o /tmp/fah.deb https://download.foldingathome.org/releases/public/release/fahclient/debian-stable-64bit/v${FAH_VERSION_MAJOR}/fahclient_${FAH_VERSION_MINOR}_amd64.deb &&\
        dpkg --install /tmp/fah.deb
        
RUN apt-get remove -y curl &&\
        apt-get autoremove -y &&\
        rm --recursive --verbose --force /tmp/* /var/log/* /var/lib/apt/
        
RUN chown folder:folder /etc/fahclient/config.xml
RUN sed -i -e "s/{{USERNAME}}/$USERNAME/;s/{{TEAM}}/$TEAM/;s/{{PASSKEY}}/$PASSKEY/;s/{{POWER}}/$POWER/;s/{{GPU}}/$GPU/" /etc/fahclient/config.xml

# Web viewer
EXPOSE 7396
EXPOSE 36330

USER folder

WORKDIR /home/folder

ENTRYPOINT ["FAHClient", "--web-allow=0/0:7396", "--allow=0/0:36330"]
CMD ["--smp=${SMP}"]
