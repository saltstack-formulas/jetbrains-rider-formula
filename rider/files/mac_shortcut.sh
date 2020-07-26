#!/usr/bin/env bash

Source="{{ appname }}{{ '' if not edition else ' %sE'|format(edition) }}.app"
Destination="{{ homes }}/{{ user }}/Desktop"
/usr/bin/osascript -e "tell application \"Finder\" to make alias file to POSIX file \"$Source\" at POSIX file \"$Destination\""
