{% from "rider/map.jinja" import rider with context %}

{% if rider.prefs.user %}

rider-desktop-shortcut-clean:
  file.absent:
    - name: '{{ rider.homes }}/{{ rider.prefs.user }}/Desktop/Rider'
    - require_in:
      - file: rider-desktop-shortcut-add
    - onlyif: test "`uname`" = "Darwin"

rider-desktop-shortcut-add:
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rider/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ rider.prefs.user }}
      homes: {{ rider.homes }}
      edition: {{ rider.jetbrains.edition }}
    - onlyif: test "`uname`" = "Darwin"
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ rider.jetbrains.edition }}
    - runas: {{ rider.prefs.user }}
    - require:
      - file: rider-desktop-shortcut-add
    - require_in:
      - file: rider-desktop-shortcut-install
    - onlyif: test "`uname`" = "Darwin"

rider-desktop-shortcut-install:
  file.managed:
    - source: salt://rider/files/rider.desktop
    - name: {{ rider.homes }}/{{ rider.prefs.user }}/Desktop/rider{{ rider.jetbrains.edition }}.desktop
    - makedirs: True
    - user: {{ rider.prefs.user }}
       {% if rider.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ rider.prefs.group }}
       {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ rider.jetbrains.realcmd }}
    - context:
      home: {{ rider.jetbrains.realhome }}
      command: {{ rider.command }}


  {% if rider.prefs.jarurl or rider.prefs.jardir %}

rider-prefs-importfile:
  file.managed:
    - onlyif: test -f {{ rider.prefs.jardir }}/{{ rider.prefs.jarfile }}
    - name: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.jarfile }}
    - source: {{ rider.prefs.jardir }}/{{ rider.prefs.jarfile }}
    - makedirs: True
    - user: {{ rider.prefs.user }}
       {% if rider.prefs.group and grains.os not in ('MacOS',) %}
    - group: {{ rider.prefs.group }}
       {% endif %}
    - if_missing: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.jarfile }}
  cmd.run:
    - unless: test -f {{ rider.prefs.jardir }}/{{ rider.prefs.jarfile }}
    - name: curl -o {{rider.homes}}/{{rider.prefs.user}}/{{rider.prefs.jarfile}} {{rider.prefs.jarurl}}
    - runas: {{ rider.prefs.user }}
    - if_missing: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.jarfile }}
  {% endif %}


{% endif %}

