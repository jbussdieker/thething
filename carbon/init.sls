include:
  - whisper
  - git
  - twisted

carbon-repo:
  git.latest:
    - name: https://github.com/graphite-project/carbon.git
    - target: /usr/local/src/carbon

carbon-install:
  cmd.run:
    - name: python setup.py install && touch /usr/local/src/carbon/salt.installed
    - cwd: /usr/local/src/carbon
    - creates: /usr/local/src/carbon/salt.installed
    - require:
      - git: carbon-repo

carbon-config:
  file.managed:
    - name: /opt/graphite/conf/carbon.conf
    - source: salt://carbon/files/carbon.conf
    - template: jinja
    - require:
      - cmd: carbon-install

carbon-storage-schemas-config:
  file.managed:
    - name: /opt/graphite/conf/storage-schemas.conf
    - source: salt://carbon/files/storage-schemas.conf
    - template: jinja
    - require:
      - cmd: carbon-install

carbon-cache:
  cmd.run:
    - name: /opt/graphite/bin/carbon-cache.py start
    - require:
      - file: carbon-config
      - file: carbon-storage-schemas-config
    - unless: /opt/graphite/bin/carbon-cache.py status
