salt-minion:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-minion
    - enable: True
/etc/salt/minion.d/schedule.conf:
  file.managed:
    - source: salt://salt-minion/files/schedule.conf
    - require:
      - pkg: salt-minion
    - watch_in:
      - service: salt-minion
