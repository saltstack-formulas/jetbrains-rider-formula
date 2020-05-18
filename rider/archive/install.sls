# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

rider-package-archive-install:
  pkg.installed:
    - names: {{ rider.pkg.deps|json }}
    - require_in:
      - file: rider-package-archive-install
  file.directory:
    - name: {{ rider.pkg.archive.path }}
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - mode: 755
    - makedirs: True
    - clean: True
    - require_in:
      - archive: rider-package-archive-install
    - recurse:
        - user
        - group
        - mode
  archive.extracted:
    {{- format_kwargs(rider.pkg.archive) }}
    - retry: {{ rider.retry_option|json }}
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - recurse:
        - user
        - group
    - require:
      - file: rider-package-archive-install

    {%- if rider.linux.altpriority|int == 0 %}

rider-archive-install-file-symlink-rider:
  file.symlink:
    - name: /usr/local/bin/rider
    - target: {{ rider.pkg.archive.path }}/{{ rider.command }}
    - force: True
    - onlyif: {{ grains.kernel|lower != 'windows' }}
    - require:
      - archive: rider-package-archive-install

    {%- endif %}
