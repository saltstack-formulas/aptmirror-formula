{%- from 'aptmirror/map.jinja' import aptmirror with context -%}

aptmirror:
  pkg.installed:
    - name: apt-mirror
  file.managed:
    - name: /etc/apt/mirror.list
    - source: salt://aptmirror/files/mirror.list.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: aptmirror

aptmirror-directory:
  file.directory:
    - name: {{ aptmirror.get('base_path') }}
    - user: apt-mirror
    - group: apt-mirror
    - dir_mode: 755
    - file_mode: 644
    - require:
      - pkg: aptmirror

# Loop over each mirror and release and create dirs
{%- for mirror, details in aptmirror.get('mirrors').items() %}
  {%- for release, opts in details.get('releases').items() %}
  {%- set full_path = aptmirror.get('base_path') + '/' + opts.get('url').replace('http://', '').replace('https://', '') %}

aptmirror-{{ mirror }}-{{ release }}-dir:
  file.directory:
    - name: {{ full_path }}
    - user: apt-mirror
    - group: apt-mirror
    - mode: 755
    - makedirs: True

    # If we have a key url grab the key and stick it in the repo root
    {%- if opts.get('key_url') %}
    {%- set key_name = opts.get('key_url').split('/')[-1] %}
aptmirror-{{ mirror }}-{{ release }}-key:
  cmd.run:
    - name: >
        wget {{ opts.get('key_url') }} -O {{ full_path }}/{{ key_name }}
    - user: apt-mirror
    - unless: ls {{ full_path }}/{{ key_name }}
    - require:
      - file: aptmirror-{{ mirror }}-{{ release }}-dir
    {%- endif %}
  {%- endfor %}
{%- endfor %}

# Purge the package crontab and manage with salt
aptmirror-cron:
  file.absent:
    - name: /etc/cron.d/apt-mirror
    - require:
      - pkg: aptmirror
  cron.present:
    - name: /usr/bin/apt-mirror > {{ aptmirror.get('var_path', salt.pillar.get('mirror_path', '/var/spool/apt-mirror') + '/var') }}/cron.log
    - user: apt-mirror
    - hour: '{{ aptmirror.cron.get('hour') }}'
    - minute: '{{ aptmirror.cron.get('minute') }}'
    - daymonth: '{{ aptmirror.cron.get('daymonth') }}'
    - month: '{{ aptmirror.cron.get('month') }}'
    - dayweek: '{{ aptmirror.cron.get('dayweek') }}'
    - identifier: '{{ aptmirror.cron.get('identifier') }}'
    - require:
      - pkg: aptmirror
