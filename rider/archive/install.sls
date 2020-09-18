# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

rider-package-archive-install:
              {%- if grains.os == 'Windows' %}
  chocolatey.installed:
    - force: False
              {%- else %}
  pkg.installed:
              {%- endif %}
    - names: {{ rider.pkg.deps|json }}
    - require_in:
      - file: rider-package-archive-install

              {%- if rider.flavour|lower == 'windows' %}

  file.managed:
    - name: {{ rider.dir.tmp }}/rider.exe
    - source: {{ rider.pkg.archive.source }}
    - makedirs: True
    - source_hash: {{ rider.pkg.archive.source_hash }}
    - force: True
  cmd.run:
    - name: {{ rider.dir.tmp }}/rider.exe
    - require:
      - file: rider-package-archive-install

              {%- else %}

  file.directory:
    - name: {{ rider.dir.path }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: rider-package-archive-install
                 {%- if grains.os != 'Windows' %}
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - recurse:
        - user
        - group
        - mode
                 {%- endif %}
  archive.extracted:
    {{- format_kwargs(rider.pkg.archive) }}
    - retry: {{ rider.retry_option|json }}
                 {%- if grains.os != 'Windows' %}
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - recurse:
        - user
        - group
                 {%- endif %}
    - require:
      - file: rider-package-archive-install

              {%- endif %}
              {%- if grains.kernel|lower == 'linux' and rider.linux.altpriority|int == 0 %}

rider-archive-install-file-symlink-rider:
  file.symlink:
    - name: /usr/local/bin/{{ rider.command }}
    - target: {{ rider.dir.path }}/{{ rider.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: rider-package-archive-install

              {%- elif rider.flavour|lower == 'windowszip' %}

rider-archive-install-file-shortcut-rider:
  file.shortcut:
    - name: C:\Users\{{ rider.identity.rootuser }}\Desktop\{{ rider.dirname }}.lnk
    - target: {{ rider.dir.archive }}\{{ rider.dirname }}\{{ rider.command }}
    - working_dir: {{ rider.dir.archive }}\{{ rider.dirname }}\bin
    - icon_location: {{ rider.dir.archive }}\{{ rider.dirname }}\bin\rider.ico
    - makedirs: True
    - force: True
    - user: {{ rider.identity.rootuser }}
    - require:
      - archive: rider-package-archive-install

              {%- endif %}
