# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import rider with context %}
{%- from tplroot ~ "/files/macros.jinja" import format_kwargs with context %}

    {% if grains.kernel|lower == 'linux' %}

rider-linuxenv-home-file-symlink:
  file.symlink:
    - name: /opt/rider
    - target: {{ rider.pkg.archive.path }}
    - onlyif: test -d '{{ rider.pkg.archive.path }}'
    - force: True

        {% if rider.linux.altpriority|int > 0 and grains.os_family not in ('Arch',) %}

rider-linuxenv-home-alternatives-install:
  alternatives.install:
    - name: riderhome
    - link: /opt/rider
    - path: {{ rider.pkg.archive.path }}
    - priority: {{ rider.linux.altpriority }}
    - retry: {{ rider.retry_option|json }}

rider-linuxenv-home-alternatives-set:
  alternatives.set:
    - name: riderhome
    - path: {{ rider.pkg.archive.path }}
    - onchanges:
      - alternatives: rider-linuxenv-home-alternatives-install
    - retry: {{ rider.retry_option|json }}

rider-linuxenv-executable-alternatives-install:
  alternatives.install:
    - name: rider
    - link: {{ rider.linux.symlink }}
    - path: {{ rider.pkg.archive.path }}/{{ rider.command }}
    - priority: {{ rider.linux.altpriority }}
    - require:
      - alternatives: rider-linuxenv-home-alternatives-install
      - alternatives: rider-linuxenv-home-alternatives-set
    - retry: {{ rider.retry_option|json }}

rider-linuxenv-executable-alternatives-set:
  alternatives.set:
    - name: rider
    - path: {{ rider.pkg.archive.path }}/{{ rider.command }}
    - onchanges:
      - alternatives: rider-linuxenv-executable-alternatives-install
    - retry: {{ rider.retry_option|json }}

        {%- else %}

rider-linuxenv-alternatives-install-unapplicable:
  test.show_notification:
    - text: |
        Linux alternatives are turned off (rider.linux.altpriority=0),
        or not applicable on {{ grains.os or grains.os_family }} OS.
        {% endif %}
    {% endif %}
