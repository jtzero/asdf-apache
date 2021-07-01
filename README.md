# asdf-apache

[![tests](https://github.com/jtzero/asdf-apache/workflows/tests/badge.svg)](https://github.com/jtzero/asdf-apache/actions)

apache flink|zeppelin|... in theory anytthing in https://archive.apache.org/dist/, plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

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


## Use

Check out the [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install and manage asdf plugin versions

### Including source versions
`INCLUDE_SRC=true asdf list-all pulsar`

