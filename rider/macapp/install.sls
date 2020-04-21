# -*- coding: utf-8 -*-
# vim: ft=sls

  {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}

rider-macos-app-install-curl:
  file.directory:
    - name: {{ rider.dir.tmp }}
    - makedirs: True
    - clean: True
  pkg.installed:
    - name: curl
  cmd.run:
    - name: curl -Lo {{ rider.dir.tmp }}/rider-{{ rider.version }} {{ rider.pkg.macapp.source }}
    - unless: test -f {{ rider.dir.tmp }}/rider-{{ rider.version }}
    - require:
      - file: rider-macos-app-install-curl
      - pkg: rider-macos-app-install-curl
    - retry: {{ rider.retry_option|json }}

      # Check the hash sum. If check fails remove
      # the file to trigger fresh download on rerun
rider-macos-app-install-checksum:
  module.run:
    - onlyif: {{ rider.pkg.macapp.source_hash }}
    - name: file.check_hash
    - path: {{ rider.dir.tmp }}/rider-{{ rider.version }}
    - file_hash: {{ rider.pkg.macapp.source_hash }}
    - require:
      - cmd: rider-macos-app-install-curl
    - require_in:
      - macpackage: rider-macos-app-install-macpackage
  file.absent:
    - name: {{ rider.dir.tmp }}/rider-{{ rider.version }}
    - onfail:
      - module: rider-macos-app-install-checksum

rider-macos-app-install-macpackage:
  macpackage.installed:
    - name: {{ rider.dir.tmp }}/rider-{{ rider.version }}
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
    - onchanges:
      - cmd: rider-macos-app-install-curl
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rider/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      appname: {{ rider.pkg.name }}
      edition: {{ rider.edition }}
      user: {{ rider.identity.user }}
      homes: {{ rider.dir.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh
    - runas: {{ rider.identity.user }}
    - require:
      - file: rider-macos-app-install-macpackage

    {%- else %}

rider-macos-app-install-unavailable:
  test.show_notification:
    - text: |
        The rider macpackage is only available on MacOS

    {%- endif %}
