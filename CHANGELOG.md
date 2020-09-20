# Changelog

# [1.1.0](https://github.com/saltstack-formulas/jetbrains-rider-formula/compare/v1.0.2...v1.1.0) (2020-09-20)


### Features

* **windows:** basic windows support ([0c4e6ce](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/0c4e6ce89daf8f908cd330955d2e88c6b0888473))

## [1.0.2](https://github.com/saltstack-formulas/jetbrains-rider-formula/compare/v1.0.1...v1.0.2) (2020-07-28)


### Bug Fixes

* **cmd.run:** wrap url in quotes (zsh) ([cfb5bba](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/cfb5bba642f978cb27d5970651421626587f6387))
* **macos:** correct syntax ([e6e8cea](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/e6e8ceab64026d3d31f651f5408ab319b5c9a31f))
* **macos:** do not create shortcut file ([5f2228e](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/5f2228e530d0c483dd3339cf332f15da79fc69a5))
* **macos:** do not create shortcut file ([42a7b88](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/42a7b889dda10f9cabdae81e01cb2fad411c608d))
* **macos:** do not create shortcut file ([b07e7ba](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/b07e7badf3013620a864f9166c5bf449825e7cb2))


### Code Refactoring

* **jetbrains:** align jetbrains formulas ([00c7967](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/00c79672fedae7eeb2dc0ed2c8b35121dc78e584))
* **path:** consistent path vars ([7a53c74](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/7a53c74486c8f27f971202783c40491f6ebc41a3))


### Continuous Integration

* **kitchen:** use `saltimages` Docker Hub where available [skip ci] ([f3c358f](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/f3c358f7b075fe9c3a2ed7a9cbd43422f3e1fd46))


### Documentation

* **readme:** minor update ([e448d06](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/e448d069771c7e9b67dbd04ab080630c6356e2d3))


### Styles

* **libtofs.jinja:** use Black-inspired Jinja formatting [skip ci] ([ef0024d](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/ef0024db97eacf3840102498f2573403ea690834))

## [1.0.1](https://github.com/saltstack-formulas/jetbrains-rider-formula/compare/v1.0.0...v1.0.1) (2020-06-15)


### Bug Fixes

* **edition:** better edition jinja code ([ef93437](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/ef934370c91bd4ba7bd48f7a458f50ba524062a9))


### Continuous Integration

* **kitchen+travis:** add new platforms [skip ci] ([9ea7137](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/9ea7137aa076b6739cc0c672ad95d2f18b977e88))
* **travis:** add notifications => zulip [skip ci] ([89c56b8](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/89c56b855fba5836a93af941cf1418fc128cd55f))


### Documentation

* **readme:** updated formatting ([0af6a34](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/0af6a346afc9cbad6d21f35f92a58c9d83c2bce4))

# [1.0.0](https://github.com/saltstack-formulas/jetbrains-rider-formula/compare/v0.2.0...v1.0.0) (2020-05-18)


### Continuous Integration

* **kitchen+travis:** adjust matrix to add `3000.3` ([26c3122](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/26c3122ed7176c72ea3a9efa7b1d81c69215ba41))


### Documentation

* **readme:** add depth one ([e0ce7f6](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/e0ce7f6b3572f93d85ab53c4b79303c3b74f6ac5))


### Features

* **formula:** align to template-formula; add ci ([ca4a346](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/ca4a346364c6583cb5bb1ea958073bdfff44a125))
* **formula:** align to template-formula; add ci ([d24b311](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/d24b3111f76543a76412eefa828212bc019c73b0))
* **semantic-release:** standardise for this formula ([a666df8](https://github.com/saltstack-formulas/jetbrains-rider-formula/commit/a666df821e1e6a7d4fc78c16641ce6a7d7f2ea37))


### BREAKING CHANGES

* **formula:** Major refactor of formula to bring it in alignment with the
template-formula. As with all substantial changes, please ensure your
existing configurations work in the ways you expect from this formula.
