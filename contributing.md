# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test apache https://github.com/jtzero/asdf-apache.git "asdf-apache --help"
```

Tests are automatically run in GitHub Actions on push and PR.
