{% from "rider/map.jinja" import rider with context %}

# Cleanup first
rider-remove-prev-archive:
  file.absent:
    - name: '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}'
    - require_in:
      - rider-install-dir

rider-install-dir:
  file.directory:
    - names:
      - '{{ rider.alt.realhome }}'
      - '{{ rider.tmpdir }}'
{% if grains.os not in ('MacOS', 'Windows') %}
      - '{{ rider.prefix }}'
      - '{{ rider.symhome }}'
    - user: root
    - group: root
    - mode: 755
{% endif %}
    - makedirs: True
    - require_in:
      - rider-download-archive

rider-download-archive:
  cmd.run:
    - name: curl {{ rider.dl.opts }} -o '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}' {{ rider.dl.source_url }}
      {% if grains['saltversioninfo'] >= [2017, 7, 0] %}
    - retry:
        attempts: {{ rider.dl.retries }}
        interval: {{ rider.dl.interval }}
      {% endif %}

{% if grains.os not in ('MacOS') %}
rider-unpacked-dir:
  file.directory:
    - name: '{{ rider.alt.realhome }}'
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
    - force: True
    - onchanges:
      - cmd: rider-download-archive
{% endif %}

{%- if rider.dl.src_hashsum %}
   # Check local archive using hashstring for older Salt / MacOS.
   # (see https://github.com/saltstack/salt/pull/41914).
  {%- if grains['saltversioninfo'] <= [2016, 11, 6] or grains.os in ('MacOS') %}
rider-check-archive-hash:
   module.run:
     - name: file.check_hash
     - path: '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}'
     - file_hash: {{ rider.dl.src_hashsum }}
     - onchanges:
       - cmd: rider-download-archive
     - require_in:
       - archive: rider-package-install
  {%- endif %}
{%- endif %}

rider-package-install:
{% if grains.os == 'MacOS' %}
  macpackage.installed:
    - name: '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}'
    - store: True
    - dmg: True
    - app: True
    - force: True
    - allow_untrusted: True
{% else %}
  archive.extracted:
    - source: 'file://{{ rider.tmpdir }}/{{ rider.dl.archive_name }}'
    - name: '{{ rider.alt.realhome }}'
    - archive_format: {{ rider.dl.archive_type }}
       {% if grains['saltversioninfo'] < [2016, 11, 0] %}
    - tar_options: {{ rider.dl.unpack_opts }}
    - if_missing: '{{ rider.alt.realcmd }}'
       {% else %}
    - options: {{ rider.dl.unpack_opts }}
       {% endif %}
       {% if grains['saltversioninfo'] >= [2016, 11, 0] %}
    - enforce_toplevel: False
       {% endif %}
       {%- if rider.dl.src_hashurl and grains['saltversioninfo'] > [2016, 11, 6] %}
    - source_hash: {{ rider.dl.src_hashurl }}
       {%- endif %}
{% endif %} 
    - onchanges:
      - cmd: rider-download-archive
    - require_in:
      - rider-remove-archive

rider-remove-archive:
  file.absent:
    - names:
      # todo: maybe just delete the tmpdir itself
      - '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}'
      - '{{ rider.tmpdir }}/{{ rider.dl.archive_name }}.sha256'
    - onchanges:
{%- if grains.os in ('Windows') %}
      - pkg: rider-package-install
{%- elif grains.os in ('MacOS') %}
      - macpackage: rider-package-install
{% else %}
      - archive: rider-package-install

rider-home-symlink:
  file.symlink:
    - name: '{{ rider.symhome }}'
    - target: '{{ rider.alt.realhome }}'
    - force: True
    - onchanges:
      - archive: rider-package-install

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
      rider_home: '{{ rider.symhome }}'

{% endif %}
