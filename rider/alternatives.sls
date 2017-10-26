{% from "rider/map.jinja" import rider with context %}

{% if grains.os not in ('MacOS', 'Windows') %}

  {% if grains.os_family not in ('Arch') %}

# Add pyCharmhome to alternatives system
rider-home-alt-install:
  alternatives.install:
    - name: riderhome
    - link: {{ rider.symhome }}
    - path: {{ rider.alt.realhome }}
    - priority: {{ rider.alt.priority }}

rider-home-alt-set:
  alternatives.set:
    - name: riderhome
    - path: {{ rider.alt.realhome }}
    - onchanges:
      - alternatives: rider-home-alt-install

# Add to alternatives system
rider-alt-install:
  alternatives.install:
    - name: rider
    - link: {{ rider.symlink }}
    - path: {{ rider.alt.realcmd }}
    - priority: {{ rider.alt.priority }}
    - require:
      - alternatives: rider-home-alt-install
      - alternatives: rider-home-alt-set

rider-alt-set:
  alternatives.set:
    - name: rider
    - path: {{ rider.alt.realcmd }}
    - onchanges:
      - alternatives: rider-alt-install

  {% endif %}

{% endif %}
