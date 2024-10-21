#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

main() {
    # if not root, exit the script
    if [[ "${EUID}" -ne 0 ]]; then
        echo "The script must be run as root!"
        exit 1
    fi

    # copy sources.list
    setup_apt_repos() {
        cp "./apt/sources.list" "/etc/apt/sources.list"
        apt update
    }
    setup_apt_repos

    # docker installation
    install_docker() {
        # remove conflicting packages
        apt remove --assume-yes docker.io \
                                docker-doc \
                                docker-compose \
                                podman-docker \
                                containerd \
                                runc

        # add docker gpg key
        apt update
        apt install --assume-yes ca-certificates \
                                 curl
        install --mode=0755 \
                --directory /etc/apt/keyrings
        curl --fail \
             --silent \
             --show-error \
             "https://download.docker.com/linux/debian/gpg" \
             --output "/etc/apt/keyrings/docker.asc"
        chmod a+r /etc/apt/keyrings/docker.asc

        # add apt repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list
        apt update

        # install docker packages
        apt install --assume-yes docker-ce \
                                 docker-ce-cli \
                                 containerd.io \
                                 docker-buildx-plugin \
                                 docker-compose-plugin
    }
    install_docker

    # install additional utilities
    install_utilities() {
        apt update
        # plocate -> MUCH faster "find"
        # command-not-found -> if trying to enter a command of not installed package,
        #                      will display the needed package(s)
        apt install --assume-yes plocate \
                                 command-not-found
        # create plocate db
        updatedb
        # update command-not-found db
        update-command-not-found
    }
    install_utilities

    # install and setup ssh
    install_ssh() {
        # install openssh server package
        apt install --assume-yes openssh-server

        # create necessary directory and files with correct permissions
        # check if directory exists, if not create it
        if ! [[ -d "${HOME}/.ssh" ]]; then
            mkdir --parents "${HOME}/.ssh"
        fi 
        chmod 700 "${HOME}/.ssh" 
        touch "${HOME}/.ssh/authorized_keys"
        chmod 600 "${HOME}/.ssh/authorized_keys"

        # copy sshd_config into its directory
        cp "./sshd/sshd_config" "/etc/ssh/sshd_config"

        # enable sshd
        systemctl enable ssh.service
        systemctl start ssh.service
    }
    install_ssh

    # install and setup fail2ban
    install_fail2ban() {
        # install fail2ban package
        apt install --assume-yes fail2ban

        # copy fail2ban.local and jail.local into its directory
        cp "./fail2ban/fail2ban.local" "/etc/fail2ban/fail2ban.local"
        cp "./fail2ban/jail.local" "/etc/fail2ban/jail.local"

        # enable fail2ban
        systemctl enable fail2ban.service
        systemctl start fail2ban.service
    }
    # not ready yet, will have to look into syncing on different nodes
    #install_fail2ban

}

main