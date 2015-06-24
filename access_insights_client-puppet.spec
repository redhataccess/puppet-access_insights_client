%global puppet_modules_dir %{_datadir}/puppet/modules
%global puppet_module access_insights_client
%global puppet_full_name lphiri-%{puppet_module}

Name:       access_insights_client-puppet
Version:    0.0.6
Release:    1%{?dist}
Summary:    Puppet module for Red Hat Access Insights deployment
Group:      Applications/System
License:    GPLv2.0
URL:        https://github.com/redhataccess/puppet-access_insights_client
Source0:    %{puppet_full_name}-%{version}.tar.gz

BuildArch:  noarch

Requires:   puppet >= 2.7.0
BuildRequires: puppet >= 2.7.0


%description
Puppet module for registering RHEl clients to the Red Access Insights service.

%prep
%setup -q -n %{puppet_full_name}-%{version}

%build
puppet module build .

%install
rm -rf %{buildroot}
install -d -m 0755 %{buildroot}/%{_datadir}/access_insights_client-puppet
cp -r * %{buildroot}/%{_datadir}/access_insights_client-puppet
mkdir -p %{buildroot}/%{puppet_modules_dir}/%{puppet_module}
cp -r pkg/%{puppet_full_name}-%{version}/* %{buildroot}/%{puppet_modules_dir}/%{puppet_module}

%files
%{_datadir}/access_insights_client-puppet/*
%{puppet_modules_dir}/%{puppet_module}

%changelog
* Tue Jun 23 2015 Lindani Phiri <lphiri@redhat.com> 0.0.6-1
- Initial upstream package release




