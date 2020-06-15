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
              {%- if rider.pkg.use_upstream_macapp %}
        path: '/Applications/{{ rider.pkg.name }}{{ '' if 'edition' not in rider else '\ %sE'|format(rider.edition) }}.app/Contents/MacOS'   # noqa 204
              {%- else %}
        path: {{ rider.pkg.archive.path }}/bin
              {%- endif %}
        environ: {{ rider.environ|json }}
    - require:
      - sls: {{ sls_package_install }}
