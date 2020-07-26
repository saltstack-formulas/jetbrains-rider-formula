# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider as r with context %}

r-macos-app-clean-files:
  file.absent:
    - names:
      - {{ r.dir.tmp }}
      - {{ r.dir.path }}/{{ r.pkg.name }}{{ '' if 'edition' not in r else ' %sE'|format(r.edition) }}.app

    {%- else %}

r-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The r macpackage is only available on MacOS

    {%- endif %}
