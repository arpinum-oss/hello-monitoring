#!/usr/bin/env bash

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")"; pwd)"
source "${HERE}/util.sh"
source "${HERE}/http.sh"
source "${HERE}/console_notification.sh"
source "${HERE}/slack_notification.sh"
source "${HERE}/notification.sh"
source "${HERE}/monitor.sh"

monitor__run
