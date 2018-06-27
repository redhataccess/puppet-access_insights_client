require 'spec_helper'

describe 'access_insights_client' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_package('redhat-access-insights') }
    it { is_expected.to contain_file('/etc/cron.daily/redhat-access-insights').with_ensure('link') }
    it { is_expected.to contain_file('/etc/cron.weekly/redhat-access-insights').with_ensure('absent') }
  end
end
