require 'serverspec'

set :backend, :exec

describe package('apt-mirror') do
  it { should be_installed }
end

describe user('apt-mirror') do
  it { should exist }
end

describe file('/srv/aptmirror') do
  it { should be_directory }
end

describe file('/etc/apt/mirror.list') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'root' }
  it { should be_readable.by_user('apt-mirror') }
  it { should contain '## This file is managed by SaltStack ##' }
  it { should contain 'deb-amd64 http://repo.saltstack.com/apt/ubuntu/14.04/amd64/latest trusty main' }
  it { should contain 'deb-amd64 http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main' }
end

describe file('/srv/aptmirror/repo.saltstack.com/apt/ubuntu/14.04/amd64/latest/SALTSTACK-GPG-KEY.pub') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'apt-mirror' }
  it { should be_readable.by_user('apt-mirror') }
  it { should contain '-----BEGIN PGP PUBLIC KEY BLOCK-----' }
end

describe file('/srv/aptmirror/repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub') do
  it { should be_file }
  it { should be_mode 644 }
  it { should be_owned_by 'apt-mirror' }
  it { should be_readable.by_user('apt-mirror') }
  it { should contain '-----BEGIN PGP PUBLIC KEY BLOCK-----' }
end

describe file('/etc/cron.d/apt-mirror') do
  it { should_not exist }
end

describe cron do
  should { have_entry('0 2 * * * /usr/bin/apt-mirror > /var/spool/apt-mirror/var/cron.log').with_user('apt-mirror') }
end
