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

    read -p "Enter the Username of your non-sudo user: " non_sudo_username

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
        if ! [[ -d "/home/${non_sudo_username}/.ssh" ]]; then
            mkdir --parents "/home/${non_sudo_username}/.ssh"
        fi 
        chmod 700 "/home/${non_sudo_username}/.ssh" 
        touch "/home/${non_sudo_username}/.ssh/authorized_keys"
        chmod 600 "/home/${non_sudo_username}/.ssh/authorized_keys"

        # copy sshd_config into its directory
        cp "./sshd/sshd_config" "/etc/ssh/sshd_config"

        # enable sshd
        systemctl enable ssh.service
        systemctl start ssh.service
    }
    install_ssh

}

main