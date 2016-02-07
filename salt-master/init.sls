salt-master:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-master
    - enable: True
/etc/salt/master.d/external_auth.conf:
  file.managed:
    - source: salt://salt-master/files/external_auth.conf
    - require:
      - pkg: salt-master
    - watch_in:
      - service: salt-master
/etc/salt/master.d/insecure.conf:
  file.managed:
    - source: salt://salt-master/files/insecure.conf
    - require:
      - pkg: salt-master
    - watch_in:
      - service: salt-master
