require 'spec_helper'

describe 'access_insights_client::current' do
  context 'on 6.10' do
    let :facts do
      {:operatingsystemrelease => '6.10'}
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/redhat-access-insights/redhat-access-insights.conf').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.daily/redhat-access-insights').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.weekly/redhat-access-insights').with_ensure('absent') }

    it { is_expected.to contain_package('insights-client') }
    it { is_expected.to contain_file('/etc/cron.daily/insights-client').with_ensure('link').with_target('/etc/insights-client/insights-client.cron') }
    it { is_expected.to contain_file('/etc/cron.weekly/insights-client').with_ensure('absent') }
    it { is_expected.to contain_exec('/usr/bin/insights-client --register') }
    it { is_expected.not_to contain_service('insights-client.timer') }
  end

  context 'on 7.0' do
    let :facts do
      {:operatingsystemrelease => '7.0'}
    end

    it { is_expected.to compile.with_all_deps }

    it { is_expected.to contain_file('/etc/redhat-access-insights/redhat-access-insights.conf').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.daily/redhat-access-insights').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.weekly/redhat-access-insights').with_ensure('absent') }

    it { is_expected.to contain_package('insights-client') }
    it { is_expected.to contain_file('/etc/insights-client/insights-client.conf').with_ensure('file') }
    it { is_expected.to contain_file('/etc/cron.daily/insights-client').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.weekly/insights-client').with_ensure('absent') }
    it { is_expected.to contain_exec('/usr/bin/insights-client --register') }
    it { is_expected.to contain_service('insights-client.timer') }
  end
end
