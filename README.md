Continuous OCI image builds for [mcrouter](https://github.com/facebook/mcrouter).

## Motivation
While mcrouter is actively developed by Meta, its last official binary release was in 2019.
Building mcrouter from source can be nettlesome due to the amount of native dependencies required
and the long build times. This project aims to provide automated, regular OCI image builds for mcrouter
to make recent mcrouter versions more accessible to third parties.

This project utilizes a [custom CMake build system](https://github.com/facebook/mcrouter/pull/449)&mdash;hopefully to be merged by upstream eventually
&mdash;instead of the original autotools-based mechanism. The reasons for this are twofold:

* Ability to run unit and integration tests to have some confidence that the built version of mcrouter actually works.
* Integration with `fbcode_builder` to automatically fetch and build dependencies while utilizing system packages where applicable,
  instead of relying on a set of bespoke and unmaintained in-repo scripts.
