# Changelog

All notable changes to this project will be documented in this file.

## [1.6.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.5.0...v1.6.0) (2025-04-18)


### Features

* Push rules for subgroups ([0ac66c6](https://github.com/opsworks-co/terraform-gitlab/commit/0ac66c6bcf5c62b5be05611d63dab0ef5501b935))

## [1.5.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.4.0...v1.5.0) (2025-03-03)


### Features

* Add sensitive variables support, update provider ([58fdcf4](https://github.com/opsworks-co/terraform-gitlab/commit/58fdcf405e4ee1cdf9a91788b5f32e22305d7196))

## [1.4.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.3.0...v1.4.0) (2024-10-03)


### Features

* Add support for protected branches ([a4a6e0c](https://github.com/opsworks-co/terraform-gitlab/commit/a4a6e0c4ee4cfed8bb09f7111abb606f2fd0de96))

## [1.3.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.2.0...v1.3.0) (2024-10-01)


### Features

* Scheduled pipeline variables ([7d3ea73](https://github.com/opsworks-co/terraform-gitlab/commit/7d3ea73c227e29b82f8cce1b3bf9cb893e1a32a4))

## [1.2.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.1.0...v1.2.0) (2024-10-01)


### Features

* Fix provider version, jira integration fix, default branch protection ([b826b6e](https://github.com/opsworks-co/terraform-gitlab/commit/b826b6e6eccd78ccc650dde152bd69c4e5d59e86))

## [1.1.0](https://github.com/opsworks-co/terraform-gitlab/compare/v1.0.0...v1.1.0) (2024-09-06)


### Features

* GitLab variables based on access tokens ([5c94981](https://github.com/opsworks-co/terraform-gitlab/commit/5c949813b7e162b34afe97a4f7f3822335ab2027))


### Bug Fixes

* remove comments ([5ca4912](https://github.com/opsworks-co/terraform-gitlab/commit/5ca4912bf8186ba7c969e8e92d6ea8dba26123a4))

## [1.0.0](https://github.com/opsworks-co/terraform-gitlab/compare/v0.3.0...v1.0.0) (2024-09-04)


### ⚠ BREAKING CHANGES

* Refactor GitLab group management

### Features

* Refactor GitLab group management ([b382989](https://github.com/opsworks-co/terraform-gitlab/commit/b3829899af3eb004b3936e33ad8498f89e440767))

## [0.3.0](https://github.com/opsworks-co/terraform-gitlab/compare/v0.2.2...v0.3.0) (2024-09-03)


### Features

* Prevent recreation of resources ([41d1765](https://github.com/opsworks-co/terraform-gitlab/commit/41d176574c1da996582decbd7ca8e014c323766f))

## [0.2.2](https://github.com/opsworks-co/terraform-gitlab/compare/v0.2.1...v0.2.2) (2024-09-03)


### Bug Fixes

* Improve GitLab group sharing logic to handle parent groups and subgroups with proper key construction and ID resolution ([4d31ec2](https://github.com/opsworks-co/terraform-gitlab/commit/4d31ec294ca194c7aea723ede98e67612f72167f))

## [0.2.1](https://github.com/opsworks-co/terraform-gitlab/compare/v0.2.0...v0.2.1) (2024-09-03)


### Bug Fixes

* Add project namespace to prevent name conflicts across different namespaces ([35ef1f0](https://github.com/opsworks-co/terraform-gitlab/commit/35ef1f00aaf8d67737f2aaf1aba532052d00ef4a))

## [0.2.0](https://github.com/opsworks-co/terraform-gitlab/compare/v0.1.1...v0.2.0) (2024-09-03)


### Features

* Query gitlab_group resources directly ([0ea3924](https://github.com/opsworks-co/terraform-gitlab/commit/0ea39240ee5fc293b9b7b16ac11e20fe30fdb504))
* Release workflow ([c9f56ee](https://github.com/opsworks-co/terraform-gitlab/commit/c9f56ee7ee4f8840293a067b48247146b6d8336d))


### Bug Fixes

* Fixes [#3](https://github.com/opsworks-co/terraform-gitlab/issues/3) duplicate object key ([5600747](https://github.com/opsworks-co/terraform-gitlab/commit/56007479e5bd53eb73e8511ca37f48ab411c8139))
* Remvoves duplicates ([20942e5](https://github.com/opsworks-co/terraform-gitlab/commit/20942e5f12f4237af384c01e2135662f3b540045))
* Workflow repo owner ([d3ea815](https://github.com/opsworks-co/terraform-gitlab/commit/d3ea815c3d5e7f6d352a11ecf962cf7a8858a41a))

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [0.1.1] - 2024-09-02

### Bug Fixes

- Fixed invalid index during import ([#1](https://github.com/opsworks-co/terraform-gitlab/issues/1))

## [0.1.0] - 2024-09-02

### Added

- Everything! Initial release of the module.
