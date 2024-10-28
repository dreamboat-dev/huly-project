#!/usr/bin/env bash
# shellcheck disable=SC2086,SC2155

set -o errexit
set -o nounset
set -o pipefail

declare DESIRED_LOG_LEVEL="${DESIRED_LOG_LEVEL:?ERROR: The log level hasn\'t been set}"
declare LOG_FILE="${LOG_FILE:?ERROR: The log file hasn\'t been set}"
declare LOG_DIR
declare -A LOG_LEVELS
declare -A LOG_COLORS
init_log() {
    # get directory of log file
    LOG_DIR="$(dirname ${LOG_FILE})"

    # create log directory if it doesn't exist
    if ! [[ -d "${LOG_DIR}" ]]; then
        mkdir --parents "${LOG_DIR}"
    fi
    # create log file if it doesn't exist
    if ! [[ -f "${LOG_FILE}" ]]; then
        touch "${LOG_FILE}"
    fi
    chmod 644 "${LOG_FILE}"

    LOG_LEVELS=(
        [DEBUG]=0
        [INFO]=1
        [WARN]=2
        [ERROR]=3
        [FATAL]=4
    )
    LOG_COLORS=(
        [DEBUG]="\e[1;97m"     # White
        [INFO]="\e[38;5;114m"  # Green
        [WARN]="\e[38;5;228m"  # Yellow
        [ERROR]="\e[38;5;203m" # Red
        [FATAL]="\e[38;5;99m"  # Purple
        [RESET]="\e[0m"        # Reset
    )

    log() {
        local log_level="${1}"
        local log_message="${2}"

        # check if this log level should be logged
        if [[ "${LOG_LEVELS[${log_level}]}" -ge "${LOG_LEVELS[${DESIRED_LOG_LEVEL}]}" ]]; then
            local timestamp="$(date '+%Y-%m-%d %H:%M:%S')" # YYYY-MM-DD HH:MM:SS
            local log_entry="[${timestamp}] [${log_level}]\t${log_message}"

            # output to console (with colors)
            echo -e "${LOG_COLORS[${log_level}]}${log_entry}${LOG_COLORS["RESET"]}"
            # output to file (without colors)
            echo -e "${log_entry}" >> "${LOG_FILE}"
        fi
    }

    log_debug() {
        local message="${1}"
        log "DEBUG" "${message}"
    }
    log_info() {
        local message="${1}"
        log "INFO" "${message}"
    }
    log_warn() {
        local message="${1}"
        log "WARN" "${message}"
    }
    log_error() {
        local message="${1}"
        log "ERROR" "${message}"
    }
    log_fatal() {
        local message="${1}"
        log "FATAL" "${message}"
    }
}
init_log