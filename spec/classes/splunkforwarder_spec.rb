require 'spec_helper'

describe 'splunkforwarder' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "splunkforwarder class without any parameters" do
          let(:params) {{ }}

          service_name = case facts[:kernel]
          when 'windows' then 'SplunkForwarder'
            else 'splunk'
          end

# This is to ignore the bug described here: https://github.com/rodjek/rspec-puppet/issues/192
          if facts[:osfamily] != 'windows'
            it { is_expected.to compile.with_all_deps }
          end

          it { is_expected.to contain_class('splunkforwarder') }
          it { is_expected.to contain_class('splunkforwarder::params') }
          it { is_expected.to contain_class('splunkforwarder::install').that_comes_before('splunkforwarder::config') }
          it { is_expected.to contain_class('splunkforwarder::config') }
          it { is_expected.to contain_class('splunkforwarder::service').that_subscribes_to('splunkforwarder::config') }
			    it { is_expected.to contain_service(service_name) }
			    it { is_expected.to contain_package('splunkforwarder').with_ensure('present') }

          if facts[:osfamily] == 'windows'
			      it { is_expected.not_to contain_exec('Install Splunk Service') }
          else
			      it { is_expected.to contain_exec('Install Splunk Service') }
          end

          if facts[:osfamily] == 'windows'
            it do
              is_expected.to contain_ini_setting('Server Name')
                .with(
                  :ensure => 'present',
                  :path => 'C:/Program Files/SplunkUniversalForwarder/etc/system/local/server.conf',
                  :section => 'general',
                  :setting => 'serverName',
                  :value => facts[:fqdn]
                )
              end

            it do
              is_expected.to contain_ini_setting('Disable SSLV3')
                .with(
                  :ensure => 'present',
                  :path => 'C:/Program Files/SplunkUniversalForwarder/etc/system/local/server.conf',
                  :section => 'sslConfig',
                  :setting => 'supportSSLV3Only',
                  :value => 'False'
                )
              end

            it do
              is_expected.to contain_ini_setting('Set TLS 1.2')
                .with(
                  :ensure => 'present',
                  :path => 'C:/Program Files/SplunkUniversalForwarder/etc/system/local/server.conf',
                  :section => 'sslConfig',
                  :setting => 'cipherSuite',
                  :value => 'TLSv1.2'
                )
              end

          else

            it do
              is_expected.to contain_ini_setting('Server Name')
                .with(
                  :ensure => 'present',
                  :path => '/opt/splunkforwarder/etc/system/local/server.conf',
                  :section => 'general',
                  :setting => 'serverName',
                  :value => facts[:fqdn]
                )
              end


            it do
              is_expected.to contain_ini_setting('Disable SSLV3')
                .with(
                  :ensure => 'present',
                  :path => '/opt/splunkforwarder/etc/system/local/server.conf',
                  :section => 'sslConfig',
                  :setting => 'supportSSLV3Only',
                  :value => 'False'
                )
            end

            it do
              is_expected.to contain_ini_setting('Set TLS 1.2')
                .with(
                  :ensure => 'present',
                  :path => '/opt/splunkforwarder/etc/system/local/server.conf',
                  :section => 'sslConfig',
                  :setting => 'cipherSuite',
                  :value => 'TLSv1.2'
                )
              end
          end
        end
    end
  end

  context 'unsupported operating system' do
    describe 'splunkforwarder class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('splunkforwarder') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
  end
end
