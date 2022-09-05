# access_insights_client

#### Table of Contents

1. [Overview - What is the access_insights_client module](#overview)
2. [Module Description - What the access insights client does and why it is useful](#module-description)
3. [Setup - The basics of getting started with access_insights_client](#setup)
    * [What access_insights_client affects](#what-access_insights_client-affects)
    * [Setup requirements](#setup-requirements)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview
The access_insights_client module allows you to easily configure the Red Hat Access Insights service on RHEL hosts using Puppet.

## Module Description

This module automates the registration of RHEL hosts to  Red Hat Access Insights, a hosted service designed to help you proactively identify and resolve technical issues in Red Hat Enterprise Linux and Red Hat Cloud Infrastructure environments.
The module can be used in RHEL hosts subscribed directly to the Red Hat CDN, or via Red Hat Satellite 5/6.

## Setup

### What access_insights_client affects

* This module will install the latest `insights` rpm package and install cron jobs in `/etc/cron.daily/insights-client` or a systemd timer.

### Setup Requirements

RHEL hosts need to be subscribed to the Red Hat CDN or Satellite in order to fulfill Red Hat Access Insights rpm dependencies.



## Usage

This module includes a single puppet class ,`access_insights_client`, which you apply to RHEL hosts to enroll them in the Red Hat Access Insights service.
The default parameters for the class will suffice for most deployments:

```
    class { 'access_insights_client':}
```

This will enable the Red Hat Insights service and schedule a daily job for uploading analytics data.

The default behavior is for the class to install the "old" insights package `redhat-access-insights` v1 for RHEL versions 6.9 and ealier or versions 7.0-7.5 and install the "new" insights package `insights-client` v3 for RHEL version 6.10+ and 7.6+.

Use the `deployment_style` parameter to force a particular version of the insights package ( assuming its available in your repository) e.g. :

```
    class { 'access_insights_client':
        deployment_style => "old"
    }
```


## Reference

###Class: access_insights_client
```
Parameters
#
# Change log level, valid options DEBUG, INFO, WARNING, ERROR, CRITICAL. Default DEBUG
#loglevel=DEBUG
# Attempt to auto configure with Satellite server
#auto_config=True
# Change authentication method, valid options BASIC, CERT. Default BASIC
#authmethod=BASIC
# username to use when authmethod is BASIC
#username=
# password to use when authmethod is BASIC
#password=
#base_url=cert-api.access.redhat.com:443/r/insights
# URL for your proxy.  Example: http://user:pass@192.168.100.50:8080
#proxy=
# Location of the certificate chain for api.access.redhat.com used for Certificate Pinning
#cert_verify=/etc/redhat-access-insights/cert-api.access.redhat.com.pem
#cert_verify=False
#cert_verify=True
# Enable/Disable GPG verification of dynamic configuration
#gpg=True
# Automatically update the dynamic configuration
#auto_update=True
# Obfuscate IP addresses
#obfuscate=False
# Obfuscate hostname
#obfuscate_hostname=False
```

## Limitations

This module has been tested with the following operating systems:
* RHEL 6.x
* RHEL 7.x

## Development

Submit your patches or pull requests to:
GitHub: <https://github.com/redhataccess/puppet-access_insights_client>


