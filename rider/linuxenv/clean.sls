# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

rider-linuxenv-home-file-absent:
  file.absent:
    - names:
      - /opt/rider
      - {{ rider.dir.path }}

        {% if rider.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

rider-linuxenv-home-alternatives-clean:
  alternatives.remove:
    - name: riderhome
    - path: {{ rider.dir.path }}
    - onlyif: update-alternatives --get-selections |grep ^riderhome


rider-linuxenv-executable-alternatives-clean:
  alternatives.remove:
    - name: rider
    - path: {{ rider.dir.path }}/{{ rider.command }}
    - onlyif: update-alternatives --get-selections |grep ^rider

        {%- else %}

rider-linuxenv-alternatives-clean-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (rider.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
