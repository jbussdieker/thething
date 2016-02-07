include:
  - git
  - django
  - django.tagging
  - pytz
  - pyparsing
  - pycairo
  - apache

graphite-web-repo:
  git.latest:
    - name: https://github.com/graphite-project/graphite-web.git
    - target: /usr/local/src/graphite-web

graphite-web-install:
  cmd.run:
    - name: python setup.py install && touch /usr/local/src/graphite-web/salt.installed
    - cwd: /usr/local/src/graphite-web
    - creates: /usr/local/src/graphite-web/salt.installed
    - require:
      - git: graphite-web-repo

graphite-local-settings:
  file.managed:
    - name: /opt/graphite/webapp/graphite/local_settings.py
    - source: salt://graphite-web/files/local_settings.py
    - template: jinja
    - requires:
      - cmd: graphite-web-install

graphite-syncdb:
  cmd.run:
    - name: django-admin.py syncdb --pythonpath=/opt/graphite/webapp --settings graphite.settings --noinput
    - creates: /opt/graphite/storage/graphite.db
    - requires:
      - file: graphite-local-settings

graphite-runserver:
  cmd.run:
    - name: nohup django-admin.py runserver --pythonpath=/opt/graphite/webapp --settings graphite.settings 0.0.0.0:8080 0<&- &> /opt/graphite/storage/log/webapp/daemon.log &
    - cwd: /opt/graphite/webapp
    - unless: lsof -nPi:8080 | grep LISTEN
    - requires:
      - cmd: graphite-syncdb
