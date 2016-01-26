#!/bin/bash
: ${GIT_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}

__create_rundir() {
	mkdir -p /var/run/sshd
}

__configure_user() {
  echo -e "$GIT_USERPASS\n$GIT_USERPASS" | (passwd --stdin git)
  echo git user password: $GIT_USERPASS
  mkdir -p $GIT_HOME/.ssh
  chown git:git -R $GIT_HOME/.ssh
  chmod 700 -R $GIT_HOME/.ssh
  if [ -n "${GIT_KEYS}" ] && [ ! -f $GIT_HOME/.ssh/authorized_keys ]; then
    curl -o $GIT_HOME/.ssh/authorized_keys $GIT_KEYS
  fi
}

__create_hostkeys() {
  ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
}

# Call all functions
__create_rundir
__create_hostkeys
__configure_user

exec "$@"
