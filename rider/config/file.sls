# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

{%- if 'config' in rider and rider.config and rider.config_file %}
    {%- if rider.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}
    {%- if grains.os != 'Windows' %}

include:
  - {{ sls_package_install }}

rider-config-file-managed-config_file:
  file.managed:
    - name: {{ rider.config_file }}
    - source: {{ files_switch(['file.default.jinja'],
                              lookup='rider-config-file-file-managed-config_file'
                 )
              }}
    - mode: 640
    - user: {{ rider.identity.rootuser }}
    - group: {{ rider.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
      config: {{ rider.config|json }}
    - require:
      - sls: {{ sls_package_install }}

    {%- endif %}
{%- endif %}
