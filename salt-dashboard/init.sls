compat-libicu4:
  pkg.installed: []

v8:
  pkg.installed:
    - fromrepo: epel
    - require:
      - pkg: compat-libicu4

nodejs:
  pkg.installed:
    - fromrepo: epel
    - require:
      - pkg: v8

ruby:
  pkg.installed: []

ruby-devel:
  pkg.installed:
    - require:
      - pkg: ruby

bundler:
  gem.installed:
    - require:
      - pkg: ruby

gcc:
  pkg.installed: []

io-console:
  gem.installed:
    - require:
      - pkg: gcc
      - pkg: ruby-devel

postgresql94-devel:
  pkg.installed: []

sqlite-devel:
  pkg.installed: []

ruby-enc:
  git.latest:
    - name: https://github.com/jbussdieker/ruby-enc.git
    - target: /home/ec2-user/ruby-enc
    - branch: salt-play
    - rev: salt-play
    - user: ec2-user

ruby-enc-salt-config:
  file.managed:
    - name: /home/ec2-user/ruby-enc/config/initializers/salt.rb
    - source: salt://salt-dashboard/files/salt.rb
    - template: jinja

ruby-enc-db-config:
  file.managed:
    - name: /home/ec2-user/ruby-enc/config/database.yml
    - source: salt://salt-dashboard/files/database.yml
    - template: jinja

bundle:
  cmd.run:
    - name: bundle && touch /var/tmp/ruby-enc.bundled.state
    - cwd: /home/ec2-user/ruby-enc
    - env:
      - DB: pg
    - user: ec2-user
    - unless: test -f /var/tmp/ruby-enc.bundled.state

dbcreate:
  cmd.run:
    - name: bundle exec /home/ec2-user/bin/rake db:create && touch /var/tmp/ruby-enc.db.created.state
    - cwd: /home/ec2-user/ruby-enc
    - env:
      - DB: pg
    - user: ec2-user
    - require:
      - cmd: bundle
    - unless: test -f /var/tmp/ruby-enc.db.created.state

dbmigrate:
  cmd.run:
    - name: bundle exec /home/ec2-user/bin/rake db:migrate && touch /var/tmp/ruby-enc.db.migrated.state
    - cwd: /home/ec2-user/ruby-enc
    - env:
      - DB: pg
    - user: ec2-user
    - require:
      - cmd: dbcreate
    - unless: test -f /var/tmp/ruby-enc.db.migrated.state

webserver:
  cmd.run:
    - name: bundle exec /home/ec2-user/bin/rails s -b 0.0.0.0 -d
    - cwd: /home/ec2-user/ruby-enc
    - env:
      - DB: pg
    - user: ec2-user
    - require:
      - cmd: dbmigrate
    - unless: test -f /home/ec2-user/ruby-enc/tmp/pids/server.pid

startworker:
  cmd.run:
    - name: nohup bundle exec /home/ec2-user/bin/rails r salt.rb 0<&- &> log/worker.log &
    - cwd: /home/ec2-user/ruby-enc
    - env:
      - DB: pg
    - user: ec2-user
    - require:
      - cmd: webserver
      - file: ruby-enc-salt-config
    - unless: test -f /home/ec2-user/ruby-enc/tmp/pids/worker.pid
