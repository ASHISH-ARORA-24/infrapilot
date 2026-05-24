# CHANGELOG

<!-- version list -->

## v1.8.0 (2026-05-24)

### Features

- Add footer to dashboard
  ([`4e11b26`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/4e11b263e4858bcfcf44ba1720a1fd6935888cd8))


## v1.7.0 (2026-05-23)

### Bug Fixes

- Update dashboard subtitle to test slot swap
  ([`f6644a6`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/f6644a60efad84a38536fc4877c5da67ff104299))

### Features

- Add postgresql and keyvault to dev, qa, and prod environments
  ([`4f4910f`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/4f4910fbb72080848304e80294926eb0a33eb5fe))


## v1.6.1 (2026-05-23)

### Bug Fixes

- Add [skip ci] to semantic-release commit message to prevent duplicate pipeline runs
  ([`89f22bd`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/89f22bd06a84bb801bd1187b9380a59eded73e9a))


## v1.6.0 (2026-05-23)

### Chores

- Add CODEOWNERS to require ashish arora review on all PRs
  ([`229c573`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/229c573be01ec04cc93e2b97a8768f8a10ecfbbd))

- Add github environments setup to bootstrap script
  ([`e67b550`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/e67b550b521fe093374c5b1688db9f138df340dc))

### Continuous Integration

- Fix deploy pipeline job names to reflect slot swaps
  ([`a80630d`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/a80630d2da519483403b635d5185b5d127ac05ba))

### Features

- Add staging slots, upgrade sku to s1, add deploy pipeline
  ([`c5e4131`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/c5e4131f3b5d52a636f287dddd63a94a9f34a21b))

- Fix release pipeline token and update dashboard subtitle
  ([`188116a`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/188116aa16db673d06a5c3e9e7664c48fc10e4f9))

- Update dashboard branding to Wings
  ([`f702efb`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/f702efbe9c5363997b175464e344956d2c7b4a6d))


## v1.5.0 (2026-05-22)

### Continuous Integration

- Add scheduled sandbox destroy pipeline
  ([`4d32ae3`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/4d32ae3457a4ca6cd5d7cbb8fad334311a21234d))

- Automate aas tf state unlock to environment-only
  ([`cde5060`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/cde5060cf4e4bb520c31ac2a15cbd49579f0664c))

- Fix naming of the pipelines
  ([`aa62ff7`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/aa62ff7d1afae4bf95cea31553e9d29a0ac14130))

- Make destroy tf log level a manual input
  ([`8e863c7`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/8e863c75dfc945d530bae97eece21a5c9ecba2ea))

- Normalize workflow display names to title case
  ([`85e121b`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/85e121b4be8a5c6d816a0a389cd85492148b19b7))

- Reduce destroy schedule from every 4 hours to every hour
  ([`2b73ec5`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/2b73ec5cd1ac204cd83a1910ff370ce628657cf3))

- Rename workflows to <deployment>_<component>_<action> convention
  ([`e17d46d`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/e17d46dd539094770c42ec043a23223dedd6c7ce))

- Scope aas pipelines to dev/qa/prod and fix destroy secret
  ([`4c7a675`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/4c7a67569927c900d699559e96d684c1f6cacc0a))

### Features

- Add postgresql and keyvault modules, remove hardcoding from env configs
  ([`ce82d42`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/ce82d425a7f8e4e8775be55a1ccf0d010e1b26e3))


## v1.4.2 (2026-05-21)

### Bug Fixes

- Authenticate app service to acr via managed identity
  ([`5104d33`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/5104d33b7d2ae5a3dca950319398eea7c86320c5))

- Trust azure proxy for https and csrf in aas settings
  ([`439f9fe`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/439f9fe1d96182fdc1112ed57a9e8c7020958577))

### Continuous Integration

- Add manual terraform state unlock workflow
  ([`7d4984f`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/7d4984ff2deaab53a57481e20c55600344144f49))

- Serialize terraform runs per environment to prevent state lock collisions
  ([`8961eaf`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/8961eaff2a31f233d4e3e8c365dd900238f5cd83))

### Documentation

- Add teaching-after-code-changes workflow
  ([`5059c0b`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/5059c0b1b409afd2e4218f9d0cca0a04790a67ec))


## v1.4.1 (2026-05-20)

### Bug Fixes

- Add STATIC_ROOT to AAS deployment settings
  ([`fe93447`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/fe9344732e191ea144e5707af5cb01c3c4299986))

### Refactoring

- Split bootstrap job into bootstrap_acr and bootstrap_secrets
  ([`d34164c`](https://github.com/ASHISH-ARORA-24/infrapilot/commit/d34164c1d274b590a6690c415610e6da6bfbbafb))


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
