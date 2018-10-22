require 'spec_helper'

describe 'collectd::plugin::mysql::database', type: :define do
  on_supported_os(baseline_os_hash).each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end

      options = os_specific_options(facts)
      context 'all options' do
        let :title do
          'dbname'
        end

        let :facts do
          facts.merge(collectd_version: '5.6')
        end

        let :params do
          {
            'aliasname' => 'fancyname',
            'host' => 'database.serv.er',
            'port' => '8010',
            'username' => 'db_user',
            'password' => 'secret',
            'sslkey' => '/path/to/key.pem',
            'sslcert' => '/path/to/cert.pem',
            'sslca' => '/path/to/ca.pem',
            'sslcapath' => '/path/to/cas/',
            'sslcipher' => 'DHE-RSA-AES256-SHA',
            'masterstats' => true,
            'slavestats' => true,
            'socket' => '/path/to/socket',
            'connecttimeout' => 10,
            'innodbstats' => true,
            'slavenotifications' => 'true',
            'wsrepstats' => true
          }
        end

        it 'creates an mysql database' do
          content_database_file = <<EOS
# Generated by Puppet

<Plugin mysql>
  <Database "dbname">
    Host "database.serv.er"
    User "db_user"
    Password "secret"
    Port "8010"
    MasterStats true
    SlaveStats true
    Socket "/path/to/socket"
    Alias "fancyname"
    ConnectTimeout 10
    InnodbStats true
    WsrepStats true
    SlaveNotifications true
    SSLKey "/path/to/key.pem"
    SSLCert "/path/to/cert.pem"
    SSLCA "/path/to/ca.pem"
    SSLCAPath "/path/to/cas/"
    SSLCipher "DHE-RSA-AES256-SHA"
  </Database>
</Plugin>
EOS
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_class('collectd::plugin::mysql')
          is_expected.to contain_file('dbname.conf').with(
            content: content_database_file,
            path: "#{options[:plugin_conf_dir]}/mysql-dbname.conf"
          )
        end
      end

      context 'default options' do
        let :title do
          'dbname'
        end

        let :facts do
          facts.merge(collectd_version: '5.6')
        end

        it 'creates an mysql database' do
          content_database_file = <<EOS
# Generated by Puppet

<Plugin mysql>
  <Database "dbname">
    Host "UNSET"
    User "UNSET"
    Password "UNSET"
    Port "3306"
    MasterStats false
    SlaveStats false
  </Database>
</Plugin>
EOS
          is_expected.to compile.with_all_deps
          is_expected.to contain_class('collectd')
          is_expected.to contain_class('collectd::plugin::mysql')
          is_expected.to contain_file('dbname.conf').with(
            content: content_database_file,
            path: "#{options[:plugin_conf_dir]}/mysql-dbname.conf"
          )
        end
      end
    end
  end
end
