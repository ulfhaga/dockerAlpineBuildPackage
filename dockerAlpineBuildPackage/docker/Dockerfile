FROM alpine:3.11.3

ARG BUILD_DATE
LABEL org.label-schema.build-date=$BUILD_DATE

RUN apk update
RUN apk add curl
RUN apk add vim
RUN apk add tree
RUN apk add busybox
RUN apk add leafpad
RUN apk add leafpad-lang
RUN apk add alpine-sdk
RUN apk --update add ttf-ubuntu-font-family
RUN apk update


# Update file /etc/abuild.conf
RUN sed -i -e 's/#PACKAGER="Your Name <your@email.address>"/PACKAGER="dev <dev@email.address>"/g'  /etc/abuild.conf


RUN mkdir -p /home/dev \
    && adduser -D dev \
    && chown -R dev:dev /home/dev 

RUN echo "dev ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && chmod 0440 /etc/sudoers.d/user

RUN addgroup dev abuild

RUN mkdir -p /var/cache/distfiles
#RUN chmod a+w /var/cache/distfiles
RUN chgrp abuild /var/cache/distfiles
RUN chmod g+w /var/cache/distfiles
# RUN mkdir /home/dev/aport
# RUN ln -s /home/dev/aports /home/dev/aport

WORKDIR /home/dev
USER dev

RUN git config --global user.name "dev" 
RUN git config --global user.email "dev@email.address" 
RUN git clone git://git.alpinelinux.org/aports
RUN abuild-keygen -n
# RUN abuild-keygen -a -i
ENTRYPOINT ["/bin/ash", "-c", "sleep 10000"]

