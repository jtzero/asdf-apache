# asdf-apache

[![tests](https://github.com/jtzero/asdf-apache/workflows/tests/badge.svg)](https://github.com/jtzero/asdf-apache/actions)

apache flink|zeppelin|kakfa... in theory anything in https://archive.apache.org/dist/, plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin-add flink https://github.com/jtzero/asdf-apache.git
```
```
asdf plugin-add zeppelin https://github.com/jtzero/asdf-apache.git
```
```
asdf plugin-add pulsar https://github.com/jtzero/asdf-apache.git
```
```
asdf plugin-add kafka https://github.com/jtzero/asdf-apache.git
```
=======

### Unsupported
* openoffice


## Use

Check out the [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install and manage asdf plugin versions

### Including source versions
`INCLUDE_SRC=true asdf list-all pulsar`

### Including site-docs versions
`INCLUDE_SITE_DOCS=true asdf list-all kafka`

### Apache use
  Zeppelin
    - make sure you have java installed [asdf-java](https://github.com/halcyon/asdf-java)
    - install zeppelin: `asdf install zeppelin ${SOME_VERSION}`
    - then once zeppelin is installed: `asdf global zeppelin ${SOME_VERSION}`
    - `zeppelin-daemon.sh start`
    - more information on zeppelin: https://zeppelin.apache.org/docs/latest/quickstart/install.html
