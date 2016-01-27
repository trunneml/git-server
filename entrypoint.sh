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
  chmod o-rwx -R $GIT_HOME/.ssh
  chown git:git $GIT_HOME
  chmod 700 $GIT_HOME
  if [ -n $GIT_KEYS ]; then
    curl -L -o $GIT_HOME/.ssh/authorized_keys2 $GIT_KEYS
  fi
}

__create_hostkeys() {
  install -g root -o root -m 770 -d ${GIT_HOME}/.sshd
  test -f ${GIT_HOME}/.sshd/ssh_host_rsa_key || ssh-keygen -t rsa -f ${GIT_HOME}/.sshd/ssh_host_rsa_key -N ''
  test -f ${GIT_HOME}/.sshd/ssh_host_ecdsa_key || ssh-keygen -t ecdsa -f ${GIT_HOME}/.sshd/ssh_host_ecdsa_key -N ''
  test -f ${GIT_HOME}/.sshd/ssh_host_ed25519_key || ssh-keygen -t ed25519 -f ${GIT_HOME}/.sshd/ssh_host_ed25519_key -N ''
}

# Call all functions
__create_rundir
__create_hostkeys
__configure_user

exec "$@"
