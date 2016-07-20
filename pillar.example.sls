aptmirror:
  base_path: '/srv/aptmirror'
  mirrors:
    saltstack:
      releases:
        trusty:
          url: 'http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest'
          key_url: 'https://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
          comps:
            - main
        xenial:
          url: 'http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest'
          key_url: 'https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub'
          comps:
            - main
  cron:
    hour: '4'
    minute: '0'
    daymonth: '*'
    month: '*'
    dayweek: '*'
    identifier: 'APTMIRROR'
