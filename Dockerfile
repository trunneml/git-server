FROM fedora:latest
MAINTAINER Michael Trunner <michael@trunner.de>

RUN dnf install -y \
        openssh-server \
        curl \
        git-all \
        passwd \
        ; dnf clean all

ENV GIT_HOME /srv/git
RUN mkdir /srv/git
VOLUME /srv/git

RUN useradd -M -d /srv/git -U git

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22
