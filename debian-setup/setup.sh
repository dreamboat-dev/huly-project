#!/usr/bin/env bash
# shellcheck disable=SC2005,SC2155

set -o errexit
set -o nounset
set -o pipefail

main() {
    # source config
    source ./setup.cfg
    # source logging framework
    source ./logging.sh

    # check if root, else exit
    if [[ "${EUID}" -ne 0 ]]; then
        log_error "This script must be run as root. Exiting"
        exit 1
    fi

    # get base path of this script
    get_base_path() {
        local dir="$(dirname "${BASH_SOURCE[0]}")"
        cd "${dir}"
        echo "$(pwd)"
    }
    local base_dir="$(get_base_path)"

    # get distribution and check if it's debian, else exit
    local distribution_name="$(grep ^ID= /etc/os-release | cut -d= -f2)"
    if [[ "${distribution_name}" != "debian" ]]; then
        log_error "This script is only designed for debian. Exiting."
        exit 1
    fi
    # get version codename and check if it's bookworm, else exit
    local distribution_version="$(grep ^VERSION_CODENAME= /etc/os-release | cut -d= -f2)"
    if [[ "${distribution_version}" != "bookworm" ]]; then
        log_error "This script is only designed for debian bookworm. Exiting."
        exit 1
    fi

    # TODO (dreamboat-dev) outsource to config file
    local non_sudo_username
    while (true); do
        read -rp "Enter the username of the non-sudo user you want to use: $(echo $'\n> ')" non_sudo_username
        if [[ -z "${non_sudo_username:-}" ]]; then
            echo "You have to set a non-sudo user." >&2
            continue
        fi
        if ! [[ "${non_sudo_username}" =~ ^[a-zA-Z0-9_]+$ ]]; then
            echo "Invalid username. Only alphanumeric characters and underscores are allowed." >&2
            continue
        fi
        break
    done

    # check if user exists, if not exit
    if ! id -u "${non_sudo_username}" &> /dev/null; then
        log_error "This user does not exist. Exiting."
        exit 1
    fi

    setup_apt_sources() {
        # backup sources.list
        cp "/etc/apt/sources.list" "/etc/apt/sources.list.bak"
        # copy sources list from repo
        cp "${base_dir}/apt/sources.list" "/etc/apt/sources.list"
        apt update
    }
    setup_apt_sources

    install_utilities() {
        apt install --assume-yes ca-certificates \
                                 curl \
                                 plocate \
                                 command-not-found \
                                 openssh-server
        # create plocate db
        updatedb
        # update command-not-found db
        update-command-not-found
    }
    install_utilities

    # install docker
    install_docker() {
        # remove conflicting packages
        apt remove --assume-yes docker.io \
                                docker-doc \
                                docker-compose \
                                podman-docker \
                                containerd \
                                runc

        # add docker gpg key
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

        # install packages
        apt install --assume-yes docer-ce \
                                 docker-ce-cli \
                                 containerd.io \
                                 docker-buildx-plugin \
                                 docker-compose-plugin
    }
    install_docker

    setup_ssh() {
        local ssh_user_dir="/home/${non_sudo_username}/.ssh"
        # check if directory exists, if not create it
        if ! [[ -d "${ssh_user_dir}" ]]; then
            mkdir --parents "${ssh_user_dir}"
        fi
        # check if authorized_keys already exists, if not create it
        if ! [[ -f "${ssh_user_dir}/authorized_keys" ]]; then
            touch "${ssh_user_dir}/authorized_keys"
        fi
        # setup right user permissions
        chmod 700 "${ssh_user_dir}"
        chmod 600 "${ssh_user_dir}/authorized_keys"
        # make ${non_sudo_username} the owner
        chown --recursive "${non_sudo_username}:${non_sudo_username}" "${ssh_user_dir}"

        local sshd_config="/etc/ssh/sshd_config"
        # backup sshd_config
        cp "${sshd_config}" "${sshd_config}.bak"
        # copy sshd_config
        cp "${base_dir}/sshd/sshd_config" "${sshd_config}"

        # check validity of sshd_config
        if ! sshd -t; then
            log_error "Invalid sshd_config. Reverting."
            mv "${sshd_config}.bak" "${sshd_config}"
        fi

        # enable and start ssh
        systemctl enable ssh.service
        systemctl restart ssh.service
    }
}

main