# Changelog

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] - Aftifact directory

- Move build artifacts to dist directory under BITBUCKET_CLONE_DIR
- Zip artifacts

## [2.1.0] - Added build arguments for node versions

- MyGet feed added to npmrc
- Added build argument for node version to dockerfiles
- Added [build-and-tag.sh](./build-and-tag.sh) file which houses the app -> version mappings and container build logic
- utilized the package.json file with some script to build different containers for different pieces of software

## [1.0.1] - Global quote

- Also exported built-time NODEVERSION as a runtime ENV variable.

## [2.0.0] - Ubuntu update

Ubuntu image version updated to kinetic.
Mono-complete replaced with mono-runtime.
Dockerfile changed to multistage build.
Nodejs is installed and managed with nvm.
globalquotebuild stage for global-quote builds.
defaultbuild stage for building the rest of TF2 application.
Build.sh config copying fixed.
Build.sh artifact copying fixed.
Build.sh selects and starts appropriate nodejs.

## [1.0.0] - init

First official version :)
