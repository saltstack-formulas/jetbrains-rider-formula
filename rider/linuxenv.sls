{% from "rider/map.jinja" import rider with context %}

{% if grains.os not in ('MacOS', 'Windows',) %}

rider-home-symlink:
  file.symlink:
    - name: '{{ rider.jetbrains.home }}/rider'
    - target: '{{ rider.jetbrains.realhome }}'
    - onlyif: test -d {{ rider.jetbrains.realhome }}
    - force: True

# Update system profile with PATH
rider-config:
  file.managed:
    - name: /etc/profile.d/rider.sh
    - source: salt://rider/files/rider.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      home: '{{ rider.jetbrains.home }}/rider'

  # Linux alternatives
  {% if rider.linux.altpriority > 0 and grains.os_family not in ('Arch',) %}

# Add rider-home to alternatives system
rider-home-alt-install:
  alternatives.install:
    - name: rider-home
    - link: '{{ rider.jetbrains.home }}/rider'
    - path: '{{ rider.jetbrains.realhome }}'
    - priority: {{ rider.linux.altpriority }}

rider-home-alt-set:
  alternatives.set:
    - name: rider-home
    - path: {{ rider.jetbrains.realhome }}
    - onchanges:
      - alternatives: rider-home-alt-install

# Add to alternatives system
rider-alt-install:
  alternatives.install:
    - name: rider
    - link: {{ rider.linux.symlink }}
    - path: {{ rider.jetbrains.realcmd }}
    - priority: {{ rider.linux.altpriority }}
    - require:
      - alternatives: rider-home-alt-install
      - alternatives: rider-home-alt-set

rider-alt-set:
  alternatives.set:
    - name: rider
    - path: {{ rider.jetbrains.realcmd }}
    - onchanges:
      - alternatives: rider-alt-install

  {% endif %}

  {% if rider.linux.install_desktop_file %}
rider-global-desktop-file:
  file.managed:
    - name: {{ rider.linux.desktop_file }}
    - source: salt://rider/files/rider.desktop
    - template: jinja
    - context:
      home: {{ rider.jetbrains.realhome }}
      command: {{ rider.command }}
      edition: {{ rider.jetbrains.edition }}
    - onlyif: test -f {{ rider.jetbrains.realhome }}/{{ rider.command }}
  {% endif %}

{% endif %}
