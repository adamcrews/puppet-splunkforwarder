#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with splunkforwarder](#setup)
    * [What splunkforwarder affects](#what-splunkforwarder-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with splunkforwarder](#beginning-with-splunkforwarder)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This will install the Splunk Universal Forwarder and allow for client side
configuration of inputs files.

## Module Description

This current version requires that you install a TA file that contains the output locations.  It is not intended to be a generic module at this point.

Additionally, this module can currently only use the splunk 'monitor' input type.
Additional types will be added soon.

## Setup

### What splunkforwarder affects

* Install the splunk universal forwarder on \*nix and Windows hosts.
* Allow easy, programatic configuration of inputs to tail

### Setup Requirements

Make sure the required pre-requsite modules are available on the target system.

### Beginning with splunkforwarder

The very basic steps needed for a user to get the module up and running.

## Usage

```
$splunk_monitors = {
  '/home/apps/log1' => {
    index => 'index1',
    sourcetype => 'my_src_type',
    tcp_routing => [ 'group1', 'group2' ],
  }
}

include ::splunkforwarder
splunkforwarder::ta { 'MyCustomTa':
  source => 'http://path/to/ta.zip',
}

create_resources('splunkforwarder::inputs::monitor', $splunk_monitors)
```

## Reference

Check each source file for embedded documentation.

## Limitations

This module has only been tested on CentOS/RHEL 6 and Windows 7.

## Development

Fork the module, create a branch, do awesome things, submit a PR.
