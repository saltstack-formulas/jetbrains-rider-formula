# -*- coding: utf-8 -*-
# vim: ft=sls

    {%- if grains.os_family == 'MacOS' %}

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}

rider-macos-app-clean-files:
  file.absent:
    - names:
      - {{ rider.dir.tmp }}
      - /Applications/{{ rider.pkg.name }}{{ '' if 'edition' not in rider else '\ %sE'|format(rider.edition) }}.app

    {%- else %}

rider-macos-app-clean-unavailable:
  test.show_notification:
    - text: |
        The rider macpackage is only available on MacOS

    {%- endif %}
