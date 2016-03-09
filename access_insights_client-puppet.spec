%global puppet_modules_dir %{_datadir}/puppet/modules
%global puppet_module access_insights_client
%global puppet_full_name lphiri-%{puppet_module}

Name:       redhat-access-insights-puppet
Version:    0.0.8
Release:    1%{?dist}
Summary:    Puppet module for Red Hat Access Insights deployment
Group:      Applications/System
License:    GPLv2
URL:        https://github.com/redhataccess/puppet-access_insights_client
Source0:	  https://forgeapi.puppetlabs.com/v3/files/%{puppet_full_name}-%{version}.tar.gz

BuildArch:  noarch

Requires:   puppet >= 2.7.0


%description
Puppet module for registering RHEl clients to the Red Access Insights service.

%prep
%setup -q -n %{puppet_full_name}-%{version}

%build

%install
mkdir -p %{buildroot}/%{puppet_modules_dir}/%{puppet_module}
cp -p metadata.json %{buildroot}/%{puppet_modules_dir}/%{puppet_module}/
cp -rp manifests/ %{buildroot}/%{puppet_modules_dir}/%{puppet_module}/manifests
cp -rp templates/ %{buildroot}/%{puppet_modules_dir}/%{puppet_module}/templates



%files
%doc README.md
%{puppet_modules_dir}/%{puppet_module}

%changelog
* Tue Jun 23 2015 Lindani Phiri <lphiri@redhat.com> 0.0.8-1
- Initial upstream package release
