# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}

   {%- if rider.pkg.use_upstream_macapp %}
       {%- set sls_package_clean = tplroot ~ '.macapp.clean' %}
   {%- else %}
       {%- set sls_package_clean = tplroot ~ '.archive.clean' %}
   {%- endif %}

include:
  - {{ sls_package_clean }}

rider-config-clean-file-absent:
  file.absent:
    - names:
      - /tmp/dummy_list_item
               {%- if rider.config_file and rider.config %}
      - {{ rider.config_file }}
               {%- endif %}
               {%- if rider.environ_file %}
      - {{ rider.environ_file }}
               {%- endif %}
               {%- if grains.kernel|lower == 'linux' %}
      - {{ rider.linux.desktop_file }}
               {%- elif grains.os == 'MacOS' %}
      - {{ rider.dir.homes }}/{{ rider.identity.user }}/Desktop/{{ rider.pkg.name }}{{ ' %sE'|format(rider.edition) if rider.edition else '' }}  # noqa 204
               {%- endif %}
    - require:
      - sls: {{ sls_package_clean }}
