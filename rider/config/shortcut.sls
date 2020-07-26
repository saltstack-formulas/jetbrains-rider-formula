# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if rider.linux.install_desktop_file %}
    {%- if rider.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

rider-config-file-file-managed-desktop-shortcut_file:
  file.managed:
    - name: {{ rider.linux.desktop_file }}
    - source: {{ files_switch(['shortcut.desktop.jinja'],
                              lookup='rider-config-file-file-managed-desktop-shortcut_file'
                 )
              }}
    - mode: 644
    - user: {{ rider.identity.user }}
    - makedirs: True
    - template: jinja
    - context:
        edition: {{ '' if 'edition' not in rider else rider.edition|json }}
        command: {{ rider.command|json }}
                            {%- if grains.os == 'MacOS' %}
        appname: {{ rider.dir.path }}/{{ rider.pkg.name }}
                            {%- else %}
        appname: {{ rider.dir.path }}
    - onlyif: test -f {{ rider.dir.path }}/{{ rider.command }}
                            {%- endif %}
    - require:
      - sls: {{ sls_package_install }}

{%- endif %}
