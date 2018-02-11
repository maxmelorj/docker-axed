FROM phusion/baseimage
MAINTAINER Holger Schinzel <holger@axe.org>

ARG USER_ID
ARG GROUP_ID

ENV HOME /axe

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
RUN groupadd -g ${GROUP_ID} axe
RUN useradd -u ${USER_ID} -g axe -s /bin/bash -m -d /axe axe

RUN chown axe:axe -R /axe

ADD https://github.com/AXErunners/axe/releases/download/v0.12.2.3/axecore-0.12.2.3-linux64.tar.gz /tmp/
RUN tar -xvf /tmp/axecore-*.tar.gz -C /tmp/
RUN cp /tmp/axecore*/bin/*  /usr/local/bin
RUN rm -rf /tmp/axecore*

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# For some reason, docker.io (0.9.1~dfsg1-2) pkg in Ubuntu 14.04 has permission
# denied issues when executing /bin/bash from trusted builds.  Building locally
# works fine (strange).  Using the upstream docker (0.11.1) pkg from
# http://get.docker.io/ubuntu works fine also and seems simpler.
USER axe

VOLUME ["/axe"]

EXPOSE 9998 9999 19998 19999

WORKDIR /axe

CMD ["axe_oneshot"]