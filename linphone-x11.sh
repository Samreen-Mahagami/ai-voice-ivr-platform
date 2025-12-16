#!/bin/bash
# Linphone wrapper to force X11 instead of Wayland
export QT_QPA_PLATFORM=xcb
exec linphone "$@"