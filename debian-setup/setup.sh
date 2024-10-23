#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

main() {
    # get base directory of script
    local base_dir
    base_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    # debian version
    local debian_version=bookworm

    # if not root, exit the script
    if [[ "${EUID}" -ne 0 ]]; then
        echo "The script must be run as root!"
        exit 1
    fi

    read -rp "Enter the Username of your non-sudo user: " non_sudo_username

    # validate non_sudo_username, allowed:
    #   - upper- and lowercase letters
    #   - numbers
    #   - underscores
    if ! [[ "${non_sudo_username}" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Invalid username. Only alphanumeric characters and underscores are allowed."
        exit 1
    fi

    # check if command exists, if not exit
    verify_package_installation() {
        local command="${1}"
        local package_name="${2}"
        if ! command -v "${command}" &> /dev/null; then
            echo "${package_name} hasn't been installed properly. Exiting."
            exit 1
        fi
    }

    # copy sources.list
    setup_apt_repos() {
        # backup sources.list
        cp "/etc/apt/sources.list" "/etc/apt/sources.list.bak"
        cp "${base_dir}/apt/sources.list" "/etc/apt/sources.list"
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
        verify_package_installation "curl" "Curl"
        verify_package_installation "ca-certificates" "Ca-certificates"
        install --mode=0755 \
                --directory /etc/apt/keyrings
        curl --fail \
             --silent \
             --show-error \
             "https://download.docker.com/linux/debian/gpg" \
             --output "/etc/apt/keyrings/docker.asc"
        chmod a+r /etc/apt/keyrings/docker.asc

        # add apt repository
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian ${debian_version} stable" > /etc/apt/sources.list.d/docker.list
        apt update

        # install docker packages
        apt install --assume-yes docker-ce \
                                 docker-ce-cli \
                                 containerd.io \
                                 docker-buildx-plugin \
                                 docker-compose-plugin

        verify_package_installation "docker" "Docker"
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

        verify_package_installation "plocate" "Plocate"
        verify_package_installation "command-not-found" "Command-not-found"

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

        verify_package_installation "ssh" "OpenSSH-Server"

        # create necessary directory and files with correct permissions
        # check if directory exists, if not create it
        if ! [[ -d "/home/${non_sudo_username}/.ssh" ]]; then
            mkdir --parents "/home/${non_sudo_username}/.ssh"
        fi
        chmod 700 "/home/${non_sudo_username}/.ssh" 
        touch "/home/${non_sudo_username}/.ssh/authorized_keys"
        chmod 600 "/home/${non_sudo_username}/.ssh/authorized_keys"
        chown --recursive "${non_sudo_username}:${non_sudo_username}" "/home/${non_sudo_username}/.ssh"

        # backup sshd_config
        cp "/etc/ssh/sshd_config" "/etc/ssh/sshd_config.bak" 
        # copy sshd_config into its directory
        cp "${base_dir}/sshd/sshd_config" "/etc/ssh/sshd_config"

        # enable sshd
        systemctl enable ssh.service
        systemctl restart ssh.service
    }
    install_ssh

}

main