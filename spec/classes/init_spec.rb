require 'spec_helper'

describe 'access_insights_client' do
  context 'with explicit deployment style' do
    context 'on 6.10' do
      let :params do
        {:deployment_style => 'old'}
      end

      let :facts do
        {:operatingsystemrelease => '6.10'}
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('access_insights_client::old') }
    end
  end

  context 'with autodetection' do
    {
      '6.9' => 'old',
      '6.10' => 'current',
      '7.0' => 'old',
      '7.4' => 'old',
      '7.5' => 'current',
    }.each do |version, expected|
      context "on #{version}" do
        let :facts do
          {:operatingsystemrelease => version}
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class("access_insights_client::#{expected}") }
      end
    end
  end
end
