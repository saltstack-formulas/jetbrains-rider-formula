{% from "rider/map.jinja" import rider with context %}

{% if rider.prefs.user not in (None, 'undefined_user') %}

  {% if grains.os == 'MacOS' %}
rider-desktop-shortcut-clean:
  file.absent:
    - name: '{{ rider.homes }}/{{ rider.prefs.user }}/Desktop/Rider'
    - require_in:
      - file: rider-desktop-shortcut-add
  {% endif %}

rider-desktop-shortcut-add:
  {% if grains.os == 'MacOS' %}
  file.managed:
    - name: /tmp/mac_shortcut.sh
    - source: salt://rider/files/mac_shortcut.sh
    - mode: 755
    - template: jinja
    - context:
      user: {{ rider.prefs.user }}
      homes: {{ rider.homes }}
  cmd.run:
    - name: /tmp/mac_shortcut.sh {{ rider.jetbrains.edition }}
    - runas: {{ rider.prefs.user }}
    - require:
      - file: rider-desktop-shortcut-add
   {% else %}
  file.managed:
    - source: salt://rider/files/rider.desktop
    - name: {{ rider.homes }}/{{ rider.prefs.user }}/Desktop/rider.desktop
    - user: {{ rider.prefs.user }}
    - makedirs: True
      {% if salt['grains.get']('os_family') in ('Suse') %} 
    - group: users
      {% else %}
    - group: {{ rider.prefs.user }}
      {% endif %}
    - mode: 644
    - force: True
    - template: jinja
    - onlyif: test -f {{ rider.symhome }}/{{ rider.command }}
    - context:
      home: {{ rider.symhome }}
      command: {{ rider.command }}
   {% endif %}


  {% if rider.prefs.importurl or rider.prefs.importdir %}

rider-prefs-importfile:
   {% if rider.prefs.importdir %}
  file.managed:
    - onlyif: test -f {{ rider.prefs.importdir }}/{{ rider.prefs.myfile }}
    - name: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.myfile }}
    - source: {{ rider.prefs.importdir }}/{{ rider.prefs.myfile }}
    - user: {{ rider.prefs.user }}
    - makedirs: True
        {% if salt['grains.get']('os_family') in ('Suse') %}
    - group: users
        {% elif grains.os not in ('MacOS') %}
        #inherit Darwin ownership
    - group: {{ rider.prefs.user }}
        {% endif %}
    - if_missing: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.myfile }}
   {% else %}
  cmd.run:
    - name: curl -o {{rider.homes}}/{{rider.prefs.user}}/{{rider.prefs.myfile}} {{rider.prefs.importurl}}
    - runas: {{ rider.prefs.user }}
    - if_missing: {{ rider.homes }}/{{ rider.prefs.user }}/{{ rider.prefs.myfile }}
   {% endif %}

  {% endif %}

{% endif %}

