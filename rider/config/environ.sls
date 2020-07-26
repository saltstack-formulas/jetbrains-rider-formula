# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider as r with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

    {%- if r.pkg.use_upstream_macapp %}
        {%- set sls_package_install = tplroot ~ '.macapp.install' %}
    {%- else %}
        {%- set sls_package_install = tplroot ~ '.archive.install' %}
    {%- endif %}

include:
  - {{ sls_package_install }}

r-config-file-file-managed-environ_file:
  file.managed:
    - name: {{ r.environ_file }}
    - source: {{ files_switch(['environ.sh.jinja'],
                              lookup='r-config-file-file-managed-environ_file'
                 )
              }}
    - mode: 644
    - user: {{ r.identity.rootuser }}
    - group: {{ r.identity.rootgroup }}
    - makedirs: True
    - template: jinja
    - context:
              {%- if r.pkg.use_upstream_macapp %}
        path: '{{ r.dir.path }}/{{ r.pkg.name }}{{ '' if 'edition' not in r else ' %sE'|format(r.edition) }}.app/Contents/MacOS'   # noqa 204
              {%- else %}
        path: {{ r.dir.path }}/bin
              {%- endif %}
        environ: {{ r.environ|json }}
    - require:
      - sls: {{ sls_package_install }}
