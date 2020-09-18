# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}

    {%- if grains.kernel|lower in ('windows', 'linux', 'darwin',) %}

include:
  - {{ '.macapp' if rider.pkg.use_upstream_macapp else '.archive' }}
  - .config
  - .linuxenv

    {%- else %}

rider-not-available-to-install:
  test.show_notification:
    - text: |
        The rider package is unavailable for {{ salt['grains.get']('finger', grains.os_family) }}

    {%- endif %}
