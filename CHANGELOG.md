# Changelog

All notable changes to this project will be documented in this file.

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
