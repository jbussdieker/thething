v8:
  pkg.installed:
    - fromrepo: epel

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

bundle:
  cmd.run:
    - name: bundle && touch /home/ec2-user/ruby-enc/bundled.state
    - cwd: /home/ec2-user/ruby-enc
    - user: ec2-user
    - unless: test -f /home/ec2-user/ruby-enc/bundled.state

dbmigrate:
  cmd.run:
    - name: sleep 10; bundle exec /home/ec2-user/bin/rake db:migrate && touch /home/ec2-user/ruby-enc/migrated.state
    - cwd: /home/ec2-user/ruby-enc
    - user: ec2-user
    - require:
      - cmd: bundle
    - unless: test -f /home/ec2-user/ruby-enc/migrated.state

webserver:
  cmd.run:
    - name: bundle exec /home/ec2-user/bin/rails s -b 0.0.0.0 -d
    - cwd: /home/ec2-user/ruby-enc
    - user: ec2-user
    - require:
      - cmd: dbmigrate
    - unless: test -f /home/ec2-user/ruby-enc/tmp/pids/server.pid

startworker:
  cmd.run:
    - name: nohup bundle exec /home/ec2-user/bin/rails r salt.rb 0<&- &> log/worker.log &
    - cwd: /home/ec2-user/ruby-enc
    - user: ec2-user
    - require:
      - cmd: webserver
      - file: ruby-enc-salt-config
    - unless: test -f /home/ec2-user/ruby-enc/log/worker.log
