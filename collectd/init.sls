collectd:
  pkg.installed: []
  service.running:
    - require:
      - pkg: collectd
    - enable: True
/etc/collectd.d/hostname.conf:
  file.managed:
    - source: salt://collectd/files/hostname.conf
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd
/etc/collectd.d/interval.conf:
  file.managed:
    - source: salt://collectd/files/interval.conf
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd
/etc/collectd.d/graphite.conf:
  file.managed:
    - source: salt://collectd/files/graphite.conf
    - template: jinja
    - require:
      - pkg: collectd
    - watch_in:
      - service: collectd
