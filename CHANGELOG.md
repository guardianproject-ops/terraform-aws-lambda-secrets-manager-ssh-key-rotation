# Changelog

All notable changes to this project will be documented in this file. See [standard-version](https://github.com/conventional-changelog/standard-version) for commit guidelines.

### [2.0.1](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/compare/2.0.0...2.0.1) (2021-10-04)


### Bug Fixes

* Pin lambda module version ([82baf1d](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/82baf1d8fb03a896b88e997e1e3221e0b473d1b3))

## [2.0.0](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/compare/1.0.0...2.0.0) (2021-03-02)


### ⚠ BREAKING CHANGES

* build the lambda locally using docker for maximum compatibility

### Features

* build the lambda locally using docker for maximum compatibility ([6c5a022](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/6c5a02294eb1e1452e3d3e817316572813e1b57c))


### Bug Fixes

* add debug logging to test phase ([49f62f9](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/49f62f9817e98648ca151cfa233c88de0bf117eb))

## [1.0.0](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/compare/0.1.2...1.0.0) (2021-02-05)


### ⚠ BREAKING CHANGES

* improve reliability of lambda deployment

### Features

* remove the initial boot key if it exists ([1ea359c](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/1ea359c3be19ca1738fbd4405b88b6532261d4c0))
* Support running lambda in private vpc ([af03efd](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/af03efd0bd3521a89fe76f0e94097096fa214234))
* support user config of log level and function timeout ([04fd6d3](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/04fd6d3ea2cf95857ca28d94b7fc82d4f38abb34))


### Bug Fixes

* do not publish a version, but always use LATEST ([2b1c999](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/2b1c999b47227f77a8b95d3032c1d14ab92de44b))
* improve debug logging ([5f7a4fa](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/5f7a4fa13c9ca44d6c6669fe06da090ca6ed6609))
* improve debug, info and error logging of lambda ([e9b59b9](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/e9b59b96eeb004de8b5d54c68e19f1f63a4066e8))
* improve reliability of lambda deployment ([8e83ab0](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/8e83ab011b78461918e67d1d993d64cc72266fbd))
* increase lambda timeout to 5 minutes ([cbe65f6](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/cbe65f6a33523049218df6b02d3bced44890582c))
* runshellscript permission doesn't need account id ([1b36b37](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/1b36b372146fb6c6c96531fcef098fd6d6791b0d))
* update null-label to 0.24.1 ([394a26f](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/394a26f86cbfaa64289e6fdf6b2b5c6ce3acfc26))

### [0.1.2](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/compare/0.1.1...0.1.2) (2021-01-28)


### Bug Fixes

* allow newer versions of aws provider ([b2c0c42](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/b2c0c42b8d8fbe10395f20b2960269c109275365))
* update null-label to support terraform 0.14 ([4a3f872](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/4a3f87223a47259e5ef24ccc55dd66068f645966))

### [0.1.1](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/compare/0.1.0...0.1.1) (2020-09-09)


### Features

* allow for conditional rebuild ([df6f1c5](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/df6f1c5d3c4f4e77e0805054bf1e0d9751e45e95))

## 0.1.0 (2020-09-09)


### Features

* generate 4096 bit keys ([11b900c](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/11b900c75586e2a75498164891d3da9b562bf12b))
* Update to context.tf ([eaca345](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/eaca345b58a805ae2067f030053d527074f5bb15))


### Bug Fixes

* project url and pwd for build process ([5d3008d](https://gitlab.com/guardianproject-ops/terraform-aws-lambda-secrets-manager-ssh-key-rotation/commit/5d3008d54bc1399046fefacb620f572ea083801a))
