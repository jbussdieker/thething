salt-api:
  pkg.installed: []
  service.running:
    - require:
      - pkg: salt-api

/etc/salt/master.d/salt-api.conf:
  file.managed:
    - source: salt://salt-api/files/salt-api.conf
    - require:
      - pkg: salt-api
    - watch_in:
      - service: salt-api

salt_api:
  group.present:
    - gid: 401
    - name: salt_api
  user.present:
    - fullname: Salt API User
    - shell: /bin/bash
    - home: /home/salt_api
    - password: $6$by00SUY0$1wiOGpZjI4kcTzq7aH/iyGdF/PPLS3NfkTMTjBI0eVq.vNIw//vH91PSmAh9lzIZfsWlpro.BuUXKquSKkc9M1
    - uid: 401
    - gid: 401
    - groups:
      - wheel
