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

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('splunkforwarder') }
          it { is_expected.to contain_class('splunkforwarder::params') }
          it { is_expected.to contain_class('splunkforwarder::install').that_comes_before('splunkforwarder::config') }
          it { is_expected.to contain_class('splunkforwarder::config') }
          it { is_expected.to contain_class('splunkforwarder::service').that_subscribes_to('splunkforwarder::config') }

	  context "on redhat-6-x86_64" do
		  let (:facts) do
			  {
				  :osfamily                  => 'RedHat',
				  :operatingsystem           => 'RedHat',
				  :operatingsystemmajrelease => '6',
			  }
			  it { is_expected.to contain_service('splunk') }
			  it { is_expected.to contain_package('splunkforwarder').with_ensure('present') }
		  end
	  end

	  context "on Windows 7" do
		  let (:facts) do
			  {
				  :osfamily                  => 'Windows',
				  :operatingsystem           => 'Windows',
				  :operatingsystemmajrelease => '7',
			  }
			  it { is_expected.to contain_service('splunkforwarder') }
			  it { is_expected.to contain_package('splunkforwarder').with_ensure('present') }
		  end
	  end
          it do
            is_expected.to contain_ini_setting('Server Name')
              .with(
                :ensure => 'present',
                :path => '/opt/splunkforwarder/etc/system/local/server.conf',
                :section => 'general',
                :setting => 'serverName',
                :value => 'foo.example.com'
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
