include:
  - git

whisper-repo:
  git.latest:
    - name: https://github.com/graphite-project/whisper.git
    - target: /usr/local/src/whisper

whisper-install:
  cmd.run:
    - name: python setup.py install && touch /usr/local/src/whisper/salt.installed
    - cwd: /usr/local/src/whisper
    - creates: /usr/local/src/whisper/salt.installed
    - require:
      - git: whisper-repo
