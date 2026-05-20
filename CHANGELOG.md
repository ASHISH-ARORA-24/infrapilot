# CHANGELOG

<!-- version list -->

## v1.4.0 (2026-05-20)

### Bug Fixes

- Move os import to top and suppress noqa for settings wildcard import
  ([`bebbe68`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/bebbe6830bfdf7837a73785e144fd5d54f3c6a9d))

### Chores

- Remove ghcr.io push, use ACR as sole image registry
  ([`936c6cb`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/936c6cbd47204a1360456e3d3533f8bd928ba8e7))

### Features

- Add AAS Django settings and SQLite on persistent storage
  ([`7e05827`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/7e0582732a534da31996c63b064499053e37431e))

- Add bootstrap secrets script and document prerequisites
  ([`5a84e90`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/5a84e90fb5df91709b33482d8a7b7da7322f2ef5))

- Add per-environment Django secret keys with AAS naming
  ([`434bed8`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/434bed816b393eba834e77e8e20b190acc89c395))


## v1.3.0 (2026-05-20)

### Bug Fixes

- Allow rg deletion with untracked resources and extend asp create timeout
  ([`ebb95e8`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/ebb95e820900ae652c235264f88c7300537104d2))

- Change all env locations to southindia
  ([`6a39da9`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/6a39da985d039ac8205047271a587723a3ba9218))

- Complete paths-ignore for app and PR pipelines
  ([`f96ff80`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/f96ff80bd2d977389b710848dc2dd1725286ae30))

- Set DEFAULT_AUTO_FIELD to suppress Django warnings
  ([`c7c8edc`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/c7c8edc99a2c0200a056a15b7f164f214ffd53ad))

### Continuous Integration

- Add aas destroy and apply pipelines
  ([`9069046`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/9069046a1a7fb87e50147a5659a74583f09eb466))

### Features

- Add ACR bootstrap pipeline and app service module
  ([`07eea1c`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/07eea1c446a6b9ed6cfd6895b5b378057c59fc37))

- Add app_service_plan terraform module
  ([`03c0e1a`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/03c0e1aa715228a4fafc0a6e1e2320f42d593404))

- Wire app_service_plan module into dev environment
  ([`b3e42a0`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/b3e42a0901de22f375ec9a125bcc8629613f7deb))


## v1.2.1 (2026-05-18)

### Bug Fixes

- Exclude deployment changes from app pipeline
  ([`2bda59b`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/2bda59b514fffa5b9a7630aae0a2281f2213fee3))


## v1.2.0 (2026-05-18)

### Bug Fixes

- Add pull-requests write permission to aas pipeline
  ([`a43b56f`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/a43b56f471d8efbe49ad6910f95a7c3fd54d01da))

### Features

- Add aas terraform pipeline with reusable workflow
  ([`a21b8ac`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/a21b8acd0ee3f0c7da651ace639f180fdcbc537e))

- Add resource group terraform module and aas sandbox config
  ([`b202826`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/b202826d6c4e481a58d782d48ecdcf8fe6992fa9))

- Post terraform plan results as PR comments
  ([`f406dd2`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/f406dd263ec174ef65e15da9035390bc8344d69e))


## v1.1.1 (2026-05-18)

### Bug Fixes

- Lowercase image owner in docker push
  ([`038fc69`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/038fc69935f999aec89b79636cb1185878cf5a0f))


## v1.1.0 (2026-05-18)

### Features

- Add Dockerfile and Docker build pipeline
  ([`6b83407`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/6b834077574abb3bc784502717490272d91d59aa))


## v1.0.1 (2026-05-18)

### Bug Fixes

- Correct build_command type in semantic-release config
  ([`7806016`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/78060161d48baaaa35b323e118ae5ca380c96893))


## v1.0.0 (2026-05-18)

- Initial Release
