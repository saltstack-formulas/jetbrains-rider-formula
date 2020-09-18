# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if rider.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

rider-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ rider.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='rider-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      environ: {{ rider.environ|json }}
                      {%- if rider.pkg.use_upstream_macapp %}
      edition:  {{ '' if not rider.edition else ' %sE'|format(rider.edition) }}.app/Contents/MacOS
      appname: {{ rider.dir.path }}/{{ rider.pkg.name }}
                      {%- else %}
      edition: ''
      appname: {{ rider.dir.path }}/bin
                      {%- endif %}
    - require:
      - sls: {{ sls_package_install }}
    {%- endif %}
