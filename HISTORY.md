# Changelog


## 0.1.5 (2017-07-08)

### Other

* [FIX] Fixing debian stretch test case. [FIX] The package latex-xcolor doesn't exist anymore, xcolor is now provided by texlive-latex-recommended. [Luis Alejandro martínez Faneyth]


## 0.1.4 (2017-05-04)

### Other

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [REF] Fixing location of python 3.6 source package. Fixes #15. [Luis Alejandro Martínez Faneyth]

* [REF] Adding build script for latex image to avoid apt timeouts. [REF] Various improvements. [Luis Alejandro Martínez Faneyth]

* [REF] Adding routine to avoid errors on downloading packages. [REF] Installing PyPIContents for python 3.5 in dockershelf/pypicontents:2.7-3.5 (closes: #13). [Luis Alejandro Martínez Faneyth]


## 0.1.3 (2017-01-04)

### Other

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [FIX] Correcting typo for python:2.7-3.5 image (closes #10). [Luis Alejandro Martínez Faneyth]


## 0.1.2 (2017-01-03)

### Other

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [ADD] Adding Maintainer notes. [Luis Alejandro Martínez Faneyth]

* [FIX] Replacing pypicontents for virtualenv because it breaks tests. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing dockershelf/debian:stretch test. [Luis Alejandro Martínez Faneyth]

* [REF] Fixing build, improving test scripts. [Luis Alejandro Martínez Faneyth]

* [REF] Updating date on copyright boilerplate. [REF] Adding sample tex file for latex image. [REF] Finishing test scripts (closes #2). [Luis Alejandro Martínez Faneyth]

* [REF] Limiting travis build to develop and master branches. [REF] Adding case for -dev images. [Luis Alejandro Martínez Faneyth]

* [REF] Adding functionality for pushing to an alternate development version tag for when not pushing from master branch. [REF] Restoring force-overwrite config because som images fail to build. [REF] Adding test scripts for latex and pypicontents. [REF] Improving Debian & Python test scripts. [REF] Adding default CMD to dockerfiles. [Luis Alejandro Martínez Faneyth]

* [ADD] Adding maintainer notes. [DEL] Removing bumpversion configuration. [REF] Improving READMEs. [REF] Improving test scripts. [Luis Alejandro Martínez Faneyth]

* [REF] Improving test script. [Luis Alejandro Martínez Faneyth]

* [FIX] Folder names changed. Correcting. [REF] Changing rspec report format. [Luis Alejandro Martínez Faneyth]

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* [REF] Reorganizing code. [ADD] Adding project boilerplate (CLA.md, AUTHORS.md, etc). [Luis Alejandro Martínez Faneyth]

* [REF] First working version of Docker file unit tests. [Luis Alejandro Martínez Faneyth]

* [REF] Changing name and graphical image to Dockershelf! [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing installation of pip in python 3.2. [Luis Alejandro Martínez Faneyth]

* [REF] Extending no-output restriction to 40min on Travis. [REF] Installing setuptools<30 for python 3.2. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing cmdretry. [Luis Alejandro Martínez Faneyth]

* [FIX] Removing reinstall of pip because causes to install a new version on 3.2 image which breaks pip. [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* [FIX] Changing tag 2.7+3.5 -> 2.7and3.5 because its invalid. [REF] Rewriting process of installing runtime dependencies because sometimes fails. [Luis Alejandro Martínez Faneyth]


## 0.1.1 (2016-12-29)

### Other

* [REF] Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [REF] Adding version to README. [Luis Alejandro Martínez Faneyth]

* [REF] Only pushing images if they come from a cron and the master branch (closes #7). [Luis Alejandro Martínez Faneyth]

* [REF] Changing dockershelf/python:2.7and3.5 to dockershelf/python:2.7-3.5 because it was too long. [REF] Changing SVG files location to root folder. [REF] Improving README file, adding README's to every type of image because its useful and to reuse in Docker Hub long description. [REF] Improving build scripts. [REF] Changing label-schema namespace. [REF] Adding default CMD to Dockerfiles. [Luis Alejandro Martínez Faneyth]

* [REF] Updating docker hub password. [Luis Alejandro Martínez Faneyth]

* [REF] Adding logo. [REF] Removing curl to MicroBadger API because it can be configured as a webhook in docker hub. [REF] Improving scripts. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing cleartext password on Travis. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing build. [Luis Alejandro Martínez Faneyth]

* [REF] Changing namespace of images from luisalejandro to dockershelf. [REF] Using debootstrap to generate base image instead of reusing tianon's image (closes #8). [REF] Adding fancy Motd, installing bash-completion and modifying prompt (closes #6). [REF] General improvements for debian images build script. [Luis Alejandro Martínez Faneyth]

* [REF] Removing unnecessary code. [Luis Alejandro Martínez Faneyth]

* [REF] Removing unnecessary code. [Luis Alejandro Martínez Faneyth]


## 0.1.0 (2016-12-21)

### Other

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* [REF] Reorganizing code. [ADD] Adding project boilerplate (CLA.md, AUTHORS.md, etc). [Luis Alejandro Martínez Faneyth]

* [REF] Changing name and graphical image to Dockershelf! [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing installation of pip in python 3.2. [Luis Alejandro Martínez Faneyth]

* [REF] Extending no-output restriction to 40min on Travis. [REF] Installing setuptools<30 for python 3.2. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing cmdretry. [Luis Alejandro Martínez Faneyth]

* [FIX] Removing reinstall of pip because causes to install a new version on 3.2 image which breaks pip. [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* [FIX] Changing tag 2.7+3.5 -> 2.7and3.5 because its invalid (closes #4). [REF] Rewriting process of installing runtime dependencies because sometimes fails. [Luis Alejandro Martínez Faneyth]

* [REF] Adding initial codebase for 2.7+3.5 Python image. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing sourcing library.sh. [REF] Improving build scripts. [Luis Alejandro Martínez Faneyth]

* [FIX] travis_retry doesn't work on scripts. Reimplementing. [Luis Alejandro Martínez Faneyth]

* [FIX] Wheezy doesn't build because iproute2 doesn't exist. Replacing with iproute which is a dummy package. [REF] Adding travis_retry because sometimes network times out. [FIX] Adding dpkg-dev to DPKG_PRE_DEPENDS in luisalejandro/python because apt-get source can't work without it. [Luis Alejandro Martínez Faneyth]

* [REF] Improving discovery and installation of Build-Depends and Depends (closes #1). [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing luisalejandro/latex build. [REF] Changing location of scripts inside image. [Luis Alejandro Martínez Faneyth]

* [FIX] Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing docker hub password. [FIX] Fixing processing of MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro Martínez Faneyth]

* [REF] Removing duplicate scripts because they are no longer necessary. [ADD] Creating travis-build-image.sh for building the image in Travis. [REF] Refactoring .travis.yml to build and push images to Docker Hub (closes #5). [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing luisalejandro/latex build. [REF] Changing location of scripts inside image. [Luis Alejandro Martínez Faneyth]

* [FIX] Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing docker hub password. [FIX] Fixing processing of MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro Martínez Faneyth]

* [REF] Removing duplicate scripts because they are no longer necessary. [ADD] Creating travis-build-image.sh for building the image in Travis. [Luis Alejandro Martínez Faneyth]

* [REF] Improving method for getting Build-Depends and Depends. [REF] Unifying PIPURL. [Luis Alejandro Martínez Faneyth]

* [FIX] PyPIrazzi no longer exists, renaming to pypicontents. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing build of 3.2 and 2.6. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing build for early versions of python (2.6, 3.2). [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing installation of build dependencies. [Luis Alejandro Martínez Faneyth]

* [REF] Improving installation of build dependencies on python images. [Luis Alejandro Martínez Faneyth]

* [REF] Improving README. [REF] Updating MicroBadger and Docker Hub triggers. [REF] Adding security and updates mirrors to debian images. [FIX] Correct build hooks for some images. [Luis Alejandro Martínez Faneyth]

* [REF] Changing name to tags. [Luis Alejandro Martínez Faneyth]

* [REF] Adjusting dependencies and removing path-exclude config from dpkg because it fucks up locales configuration. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* [REF] Improving build scripts. [Luis Alejandro Martínez Faneyth]

* [REF] Converting generation of images to a more standard method to avoid borderline issues. [Luis Alejandro Martínez Faneyth]

* [FIX] Fixing wheezy build. [Luis Alejandro Martínez Faneyth]

* [REF] Configuring DNS. [Luis Alejandro Martínez Faneyth]

* [REF] Fixing debian suites. [Luis Alejandro Martínez Faneyth]

* [REF] Changing mirror. [Luis Alejandro Martínez Faneyth]

* [REF] Fixing build. [Luis Alejandro Martínez Faneyth]

* [REF] Fixing build. [Luis Alejandro Martínez Faneyth]

* [REF] Correcting temporary failure of debian cdn. [Luis Alejandro Martínez Faneyth]

* [REF] Adding wheezy-min and jessie-min to compyle python 2.6, 3.2 and 3.4. [Luis Alejandro Martínez Faneyth]

* [REF] python: Adding suite dependecies to sources.list. [Luis Alejandro Martínez Faneyth]

* [REF] Removing push of base tarball from Travis. [Luis Alejandro Martínez Faneyth]

* [REF] Moving the build script to a pre_build hook. [Luis Alejandro Martínez Faneyth]

* [REF] Changing label schema for dockerfiles. [REF] Adding curl and ca-certificates to base image. [REF] Fixing typo on DEB_BUILD_OPTIONS. [REF] Installing runtime dependencies for Python. [REF] .travis.yml: Adding an encrypted access key fro github, to be able to push from Travis. [REF] debian/sid-min/base.tar.xz: Adding a base tarball to be used in the Dockerfile. [REF] debian/sid-min/build-base.sh: Improving base build script. [REF] Removing the need for wget in python images. [Luis Alejandro Martínez Faneyth]

* [REF] .travis.yml: adding POST to MicroBadger API so that they stop being lazy. [REF] Improving README. [REF] Testing if Docker Hub likes my hooks/pre_build. [Luis Alejandro Martínez Faneyth]

* Adding debootstrap to sid-build dependencies. [Luis Alejandro Martínez Faneyth]

* [REF] Removing --merged-usr because hub.docker.com doesn't support it. [Luis Alejandro Martínez Faneyth]

* Redifining structure of pypicontents to be able to use hooks at hub.docker.com. [Luis Alejandro Martínez Faneyth]

* Testing if docker pre_build accepts installing packages. [Luis Alejandro Martínez Faneyth]

* [ADD] .travis.yml: Trigger a build on hub.docker.com if the cron tells us to. [REF] README.md: Start to write the readme. [ADD] banner.svg: Give us a nice banner. [REF] Importing Dockerfiles of pypicontents and curriculum-vitae. [REF] Making use of Docker hooks to allow building the chroot in the docker hub. [Luis Alejandro Martínez Faneyth]

* [ADD] Adding scripts for building sid image. [Luis Alejandro Martínez Faneyth]

* [ADD] Adding Dockerfile for python image. [Luis Alejandro Martínez Faneyth]

* Initial commit. [Luis Alejandro Martínez Faneyth]


