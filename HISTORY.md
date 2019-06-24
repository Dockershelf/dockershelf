# Changelog


## 2.2.0 (2019-06-24)

### Changes

* Improving PHP shelves. [Luis Alejandro Martínez Faneyth]

* Adding PHP shelves. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing build. [Luis Alejandro Martínez Faneyth]


## 2.1.5 (2019-05-19)

### Changes

* Updating new versions of Node and Python. [Luis Alejandro Martínez Faneyth]

* Improving update scripts. [Luis Alejandro Martínez Faneyth]

* Allow expired resources on debian mirrors. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing Python 3.8 build. [Luis Alejandro Martínez Faneyth]

* Fixing erasing of wheezy and jessie from main debian archive. [Luis Alejandro Martínez Faneyth]


## 2.1.4 (2019-03-07)

### Changes

* Updating Node versions. [FIX] Fixing python 3.7 build. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing repository authorization. [Luis Alejandro Martínez Faneyth]


## 2.1.3 (2019-01-28)

### Fix

* Fixing Python 3.6 build. [Luis Alejandro Martínez Faneyth]


## 2.1.2 (2018-12-14)

### Changes

* Updating license file to match github's automatic recognition. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing python 2.7 tests. [Luis Alejandro Martínez Faneyth]

* Fixing python 3.6 & 3.7 tests. [Luis Alejandro Martínez Faneyth]


## 2.1.1 (2018-12-12)

### Changes

* Updating Odoo and Mongo versions. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing Odoo build. [Luis Alejandro Martínez Faneyth]


## 2.1.0 (2018-08-07)

### New

* Adding docker entrypoint and configuration for Odoo. [REF] Improving Odoo documentation. [Luis Alejandro Martínez Faneyth]

### Changes

* Improving documentation. [Luis Alejandro Martínez Faneyth]

* Finishing Odoo images (closes #30). [Luis Alejandro Martínez Faneyth]

* Adding 'latest' tags (closes #32). [Luis Alejandro Martínez Faneyth]

* Adding full version image for Latex (closes #31). [Luis Alejandro Martínez Faneyth]

* Improving Dockerfiles. [Luis Alejandro Martínez Faneyth]

* Update Odoo Dockerfiles. [Luis Alejandro Martínez Faneyth]

* Updating odoo images versions. [REF] Improving generation scripts. [Luis Alejandro Martínez Faneyth]

* Adding Odoo image. [REF] Adding requirements.txt. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing latex build. [Luis Alejandro Martínez Faneyth]


## 2.0.2 (2018-08-02)

### Fix

* Fixing badges. [Luis Alejandro Martínez Faneyth]


## 2.0.1 (2018-08-01)

### Changes

* Improving documentation and graphics in general. [REF] Adding dummy hooks to trigger an automatic build on Docker Hub with the purpose of updating full description. [REF] Replacing gitcdn.xyz with cdn.rawgit.com. [Luis Alejandro Martínez Faneyth]

* Improving gitchangelog parsing. [REF] Improving README. [Luis Alejandro Martínez Faneyth]


## 2.0.0 (2018-07-31)

### New

* Adding Python 3.7. [ADD] Adding Mongo 4.0. [ADD] Adding Postgres images. [Luis Alejandro Martínez Faneyth]

### Changes

* Improving README. [Luis Alejandro Martínez Faneyth]

* Improving documentation. [FIX] Fixing Postgres build. [Luis Alejandro Martínez Faneyth]

* Removing the behavior of nor creating the main cluster [postgres]. [REF] Adding Postgres tests. [Luis Alejandro Martínez Faneyth]

* Configuring aptitude to not ask questions and trust everything. [Luis Alejandro Martínez Faneyth]

* Moving images to a folder. [REF] Moving python script to folder. [REF] Changing paths. [FIX] Fixing Mongo 4.0 build. [Luis Alejandro Martínez Faneyth]

* Copy Mongo test files if we are building it. [REF] Add more test cases for Latex image. [REF] Improve package version pinning when installing from foreign repositories. [REF] Add more test cases for Mongo image. [REF] Add more test cases for Node image. [REF] Installing python3-distutils in python 3.6. [Luis Alejandro Martínez Faneyth]

* Sorting versions in descending order on .travis.yml. [REF] Improving Readme. [REF] Adding entrypoint to Mongo. [REF] Completing ruby configuration. [Luis Alejandro Martínez Faneyth]

* Improving documentation and scripts. [Luis Alejandro Martínez Faneyth]

* Adding ruby images based in python images. [Luis Alejandro Martínez Faneyth]

* Removing debian stable images. [Luis Alejandro Martínez Faneyth]

* Changing the way that python images are built. [REF] Changing image maintainer email. [REF] Improving test cases. [Luis Alejandro Martínez Faneyth]

* Changing image maintainer email. [REF] Removing debian stable images. [Luis Alejandro Martínez Faneyth]

* Removing unstable versions of Mongo. [REF] Completing development of Mongo shelf build script. [Luis Alejandro Martínez Faneyth]

* Changing maintainer email. [Luis Alejandro Martínez Faneyth]

* Removing debian stable python versions. [REF] Rolling back to compiling of python. [Luis Alejandro Martínez Faneyth]

* Configuring iproute package for Wheezy and iproute2 for the rest. [REF] Building minimal base (debootstrap) with docker except for Wheezy. [Luis Alejandro Martínez Faneyth]

* Adding scripts to automate the generarion of Dockerfiles and Readmes. [REF] Adding Mongo and Node images. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing Postgres 11 & 12 build. [Luis Alejandro Martínez Faneyth]

* Fixing Postgres build. [Luis Alejandro Martínez Faneyth]

* Fixing Postgres build. [Luis Alejandro Martínez Faneyth]

* Fixing Postgres build. [Luis Alejandro Martínez Faneyth]

* Fixing Mongo test. [Luis Alejandro Martínez Faneyth]

* Fixing typo in Dockerfiles. [Luis Alejandro Martínez Faneyth]

### Other

* [DEL] Removing Mongo 3.0 because is too much difficult to make it work and Postgres 12 because is not ready yet. [Luis Alejandro Martínez Faneyth]

* [DEL] Removing python 3.7 because is not stable yet. [ADD] Including js scripts to test mongo. [REF] Improving bash prompt design and colors. [REF] Improving documentation. [FIX] Fixing pip installation. [Luis Alejandro Martínez Faneyth]


## 0.1.5 (2017-07-08)

### Fix

* Fixing debian stretch test case. [FIX] The package latex-xcolor doesn't exist anymore, xcolor is now provided by texlive-latex-recommended. [Luis Alejandro martínez Faneyth]


## 0.1.4 (2017-05-04)

### Changes

* Fixing location of python 3.6 source package. Fixes #15. [Luis Alejandro Martínez Faneyth]

* Adding build script for latex image to avoid apt timeouts. [REF] Various improvements. [Luis Alejandro Martínez Faneyth]

* Adding routine to avoid errors on downloading packages. [REF] Installing PyPIContents for python 3.5 in dockershelf/pypicontents:2.7-3.5 (closes: #13). [Luis Alejandro Martínez Faneyth]


## 0.1.3 (2017-01-04)

### Fix

* Correcting typo for python:2.7-3.5 image (closes #10). [Luis Alejandro Martínez Faneyth]


## 0.1.2 (2017-01-03)

### New

* Adding Maintainer notes. [Luis Alejandro Martínez Faneyth]

* Adding maintainer notes. [DEL] Removing bumpversion configuration. [REF] Improving READMEs. [REF] Improving test scripts. [Luis Alejandro Martínez Faneyth]

### Changes

* Fixing build, improving test scripts. [Luis Alejandro Martínez Faneyth]

* Updating date on copyright boilerplate. [REF] Adding sample tex file for latex image. [REF] Finishing test scripts (closes #2). [Luis Alejandro Martínez Faneyth]

* Limiting travis build to develop and master branches. [REF] Adding case for -dev images. [Luis Alejandro Martínez Faneyth]

* Adding functionality for pushing to an alternate development version tag for when not pushing from master branch. [REF] Restoring force-overwrite config because som images fail to build. [REF] Adding test scripts for latex and pypicontents. [REF] Improving Debian & Python test scripts. [REF] Adding default CMD to dockerfiles. [Luis Alejandro Martínez Faneyth]

* Improving test script. [Luis Alejandro Martínez Faneyth]

* Reorganizing code. [ADD] Adding project boilerplate (CLA.md, AUTHORS.md, etc). [Luis Alejandro Martínez Faneyth]

* First working version of Docker file unit tests. [Luis Alejandro Martínez Faneyth]

* Changing name and graphical image to Dockershelf! [Luis Alejandro Martínez Faneyth]

* Extending no-output restriction to 40min on Travis. [REF] Installing setuptools<30 for python 3.2. [Luis Alejandro Martínez Faneyth]

### Fix

* Replacing pypicontents for virtualenv because it breaks tests. [Luis Alejandro Martínez Faneyth]

* Fixing dockershelf/debian:stretch test. [Luis Alejandro Martínez Faneyth]

* Folder names changed. Correcting. [REF] Changing rspec report format. [Luis Alejandro Martínez Faneyth]

* Fixing typo. [Luis Alejandro Martínez Faneyth]

* Fixing installation of pip in python 3.2. [Luis Alejandro Martínez Faneyth]

* Fixing cmdretry. [Luis Alejandro Martínez Faneyth]

* Removing reinstall of pip because causes to install a new version on 3.2 image which breaks pip. [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* Changing tag 2.7+3.5 -> 2.7and3.5 because its invalid. [REF] Rewriting process of installing runtime dependencies because sometimes fails. [Luis Alejandro Martínez Faneyth]


## 0.1.1 (2016-12-29)

### Changes

* Updating Changelog and version. [Luis Alejandro Martínez Faneyth]

* Adding version to README. [Luis Alejandro Martínez Faneyth]

* Only pushing images if they come from a cron and the master branch (closes #7). [Luis Alejandro Martínez Faneyth]

* Changing dockershelf/python:2.7and3.5 to dockershelf/python:2.7-3.5 because it was too long. [REF] Changing SVG files location to root folder. [REF] Improving README file, adding README's to every type of image because its useful and to reuse in Docker Hub long description. [REF] Improving build scripts. [REF] Changing label-schema namespace. [REF] Adding default CMD to Dockerfiles. [Luis Alejandro Martínez Faneyth]

* Updating docker hub password. [Luis Alejandro Martínez Faneyth]

* Adding logo. [REF] Removing curl to MicroBadger API because it can be configured as a webhook in docker hub. [REF] Improving scripts. [Luis Alejandro Martínez Faneyth]

* Changing namespace of images from luisalejandro to dockershelf. [REF] Using debootstrap to generate base image instead of reusing tianon's image (closes #8). [REF] Adding fancy Motd, installing bash-completion and modifying prompt (closes #6). [REF] General improvements for debian images build script. [Luis Alejandro Martínez Faneyth]

* Removing unnecessary code. [Luis Alejandro Martínez Faneyth]

* Removing unnecessary code. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing cleartext password on Travis. [Luis Alejandro Martínez Faneyth]

* Fixing build. [Luis Alejandro Martínez Faneyth]


## 0.1.0 (2016-12-21)

### New

* .travis.yml: Trigger a build on hub.docker.com if the cron tells us to. [REF] README.md: Start to write the readme. [ADD] banner.svg: Give us a nice banner. [REF] Importing Dockerfiles of pypicontents and curriculum-vitae. [REF] Making use of Docker hooks to allow building the chroot in the docker hub. [Luis Alejandro Martínez Faneyth]

* Adding scripts for building sid image. [Luis Alejandro Martínez Faneyth]

* Adding Dockerfile for python image. [Luis Alejandro Martínez Faneyth]

### Changes

* Reorganizing code. [ADD] Adding project boilerplate (CLA.md, AUTHORS.md, etc). [Luis Alejandro Martínez Faneyth]

* Changing name and graphical image to Dockershelf! [Luis Alejandro Martínez Faneyth]

* Extending no-output restriction to 40min on Travis. [REF] Installing setuptools<30 for python 3.2. [Luis Alejandro Martínez Faneyth]

* Adding initial codebase for 2.7+3.5 Python image. [Luis Alejandro Martínez Faneyth]

* Improving discovery and installation of Build-Depends and Depends (closes #1). [Luis Alejandro Martínez Faneyth]

* Removing duplicate scripts because they are no longer necessary. [ADD] Creating travis-build-image.sh for building the image in Travis. [REF] Refactoring .travis.yml to build and push images to Docker Hub (closes #5). [Luis Alejandro Martínez Faneyth]

* Removing duplicate scripts because they are no longer necessary. [ADD] Creating travis-build-image.sh for building the image in Travis. [Luis Alejandro Martínez Faneyth]

* Improving method for getting Build-Depends and Depends. [REF] Unifying PIPURL. [Luis Alejandro Martínez Faneyth]

* Improving installation of build dependencies on python images. [Luis Alejandro Martínez Faneyth]

* Improving README. [REF] Updating MicroBadger and Docker Hub triggers. [REF] Adding security and updates mirrors to debian images. [FIX] Correct build hooks for some images. [Luis Alejandro Martínez Faneyth]

* Changing name to tags. [Luis Alejandro Martínez Faneyth]

* Adjusting dependencies and removing path-exclude config from dpkg because it fucks up locales configuration. [Luis Alejandro Martínez Faneyth]

* Improving build scripts. [Luis Alejandro Martínez Faneyth]

* Converting generation of images to a more standard method to avoid borderline issues. [Luis Alejandro Martínez Faneyth]

* Configuring DNS. [Luis Alejandro Martínez Faneyth]

* Fixing debian suites. [Luis Alejandro Martínez Faneyth]

* Changing mirror. [Luis Alejandro Martínez Faneyth]

* Fixing build. [Luis Alejandro Martínez Faneyth]

* Fixing build. [Luis Alejandro Martínez Faneyth]

* Correcting temporary failure of debian cdn. [Luis Alejandro Martínez Faneyth]

* Adding wheezy-min and jessie-min to compyle python 2.6, 3.2 and 3.4. [Luis Alejandro Martínez Faneyth]

* Python: Adding suite dependecies to sources.list. [Luis Alejandro Martínez Faneyth]

* Removing push of base tarball from Travis. [Luis Alejandro Martínez Faneyth]

* Moving the build script to a pre_build hook. [Luis Alejandro Martínez Faneyth]

* Changing label schema for dockerfiles. [REF] Adding curl and ca-certificates to base image. [REF] Fixing typo on DEB_BUILD_OPTIONS. [REF] Installing runtime dependencies for Python. [REF] .travis.yml: Adding an encrypted access key fro github, to be able to push from Travis. [REF] debian/sid-min/base.tar.xz: Adding a base tarball to be used in the Dockerfile. [REF] debian/sid-min/build-base.sh: Improving base build script. [REF] Removing the need for wget in python images. [Luis Alejandro Martínez Faneyth]

* .travis.yml: adding POST to MicroBadger API so that they stop being lazy. [REF] Improving README. [REF] Testing if Docker Hub likes my hooks/pre_build. [Luis Alejandro Martínez Faneyth]

* Removing --merged-usr because hub.docker.com doesn't support it. [Luis Alejandro Martínez Faneyth]

### Fix

* Fixing typo. [Luis Alejandro Martínez Faneyth]

* Fixing installation of pip in python 3.2. [Luis Alejandro Martínez Faneyth]

* Fixing cmdretry. [Luis Alejandro Martínez Faneyth]

* Removing reinstall of pip because causes to install a new version on 3.2 image which breaks pip. [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

* Changing tag 2.7+3.5 -> 2.7and3.5 because its invalid (closes #4). [REF] Rewriting process of installing runtime dependencies because sometimes fails. [Luis Alejandro Martínez Faneyth]

* Fixing sourcing library.sh. [REF] Improving build scripts. [Luis Alejandro Martínez Faneyth]

* Travis_retry doesn't work on scripts. Reimplementing. [Luis Alejandro Martínez Faneyth]

* Wheezy doesn't build because iproute2 doesn't exist. Replacing with iproute which is a dummy package. [REF] Adding travis_retry because sometimes network times out. [FIX] Adding dpkg-dev to DPKG_PRE_DEPENDS in luisalejandro/python because apt-get source can't work without it. [Luis Alejandro Martínez Faneyth]

* Fixing luisalejandro/latex build. [REF] Changing location of scripts inside image. [Luis Alejandro Martínez Faneyth]

* Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

* Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

* Fixing docker hub password. [FIX] Fixing processing of MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro Martínez Faneyth]

* Fixing luisalejandro/latex build. [REF] Changing location of scripts inside image. [Luis Alejandro Martínez Faneyth]

* Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

* Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

* Fixing docker hub password. [FIX] Fixing processing of MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro Martínez Faneyth]

* PyPIrazzi no longer exists, renaming to pypicontents. [Luis Alejandro Martínez Faneyth]

* Fixing build of 3.2 and 2.6. [Luis Alejandro Martínez Faneyth]

* Fixing build for early versions of python (2.6, 3.2). [Luis Alejandro Martínez Faneyth]

* Fixing installation of build dependencies. [Luis Alejandro Martínez Faneyth]

* Fixing typo. [Luis Alejandro Martínez Faneyth]

* Fixing wheezy build. [Luis Alejandro Martínez Faneyth]

### Other

* Adding debootstrap to sid-build dependencies. [Luis Alejandro Martínez Faneyth]

* Redifining structure of pypicontents to be able to use hooks at hub.docker.com. [Luis Alejandro Martínez Faneyth]

* Testing if docker pre_build accepts installing packages. [Luis Alejandro Martínez Faneyth]

* Initial commit. [Luis Alejandro Martínez Faneyth]


