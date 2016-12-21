Changelog
=========

0.1.0 (2016-12-21)
------------------

- [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

- [REF] Reorganizing code. [ADD] Adding project boilerplate (CLA.md,
  AUTHORS.md, etc). [Luis Alejandro Martínez Faneyth]

- [REF] Changing name and graphical image to Dockershelf! [Luis
  Alejandro Martínez Faneyth]

- Merge branch 'feature/add-2.7+3.5-image-luisalejandro' into develop.
  [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing installation of pip in python 3.2. [Luis Alejandro
  Martínez Faneyth]

- [REF] Extending no-output restriction to 40min on Travis. [REF]
  Installing setuptools<30 for python 3.2. [Luis Alejandro Martínez
  Faneyth]

- [FIX] Fixing cmdretry. [Luis Alejandro Martínez Faneyth]

- [FIX] Removing reinstall of pip because causes to install a new
  version on 3.2 image which breaks pip. [FIX] Fixing typo. [Luis
  Alejandro Martínez Faneyth]

- [FIX] Changing tag 2.7+3.5 -> 2.7and3.5 because its invalid. [REF]
  Rewriting process of installing runtime dependencies because sometimes
  fails. [Luis Alejandro Martínez Faneyth]

- [REF] Adding initial codebase for 2.7+3.5 Python image. [Luis
  Alejandro Martínez Faneyth]

- Merge branch 'feature/improve-build-depends-discovery-luisalejandro'
  into develop. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing sourcing library.sh. [REF] Improving build scripts. [Luis
  Alejandro Martínez Faneyth]

- [FIX] travis_retry doesn't work on scripts. Reimplementing. [Luis
  Alejandro Martínez Faneyth]

- [FIX] Wheezy doesn't build because iproute2 doesn't exist. Replacing
  with iproute which is a dummy package. [REF] Adding travis_retry
  because sometimes network times out. [FIX] Adding dpkg-dev to
  DPKG_PRE_DEPENDS in luisalejandro/python because apt-get source can't
  work without it. [Luis Alejandro Martínez Faneyth]

- [REF] Improving discovery and installation of Build-Depends and
  Depends (closes #1). [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing luisalejandro/latex build. [REF] Changing location of
  scripts inside image. [Luis Alejandro Martínez Faneyth]

- [FIX] Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing docker hub password. [FIX] Fixing processing of
  MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro
  Martínez Faneyth]

- [REF] Removing duplicate scripts because they are no longer necessary.
  [ADD] Creating travis-build-image.sh for building the image in Travis.
  [REF] Refactoring .travis.yml to build and push images to Docker Hub
  (closes #5). [Luis Alejandro Martínez Faneyth]

- Merge branch 'feature/build-push-in-travis-luisalejandro' into
  develop. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing luisalejandro/latex build. [REF] Changing location of
  scripts inside image. [Luis Alejandro Martínez Faneyth]

- [FIX] Updating Docker Hub password. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing /etc/apt/sources.list. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing docker hub password. [FIX] Fixing processing of
  MicroBadger API end. [FIX] Fixing debian build script. [Luis Alejandro
  Martínez Faneyth]

- [REF] Removing duplicate scripts because they are no longer necessary.
  [ADD] Creating travis-build-image.sh for building the image in Travis.
  [Luis Alejandro Martínez Faneyth]

- [FIX] PyPIrazzi no longer exists, renaming to pypicontents. [Luis
  Alejandro Martínez Faneyth]

- [FIX] Fixing build of 3.2 and 2.6. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing build for early versions of python (2.6, 3.2). [Luis
  Alejandro Martínez Faneyth]

- [FIX] Fixing installation of build dependencies. [Luis Alejandro
  Martínez Faneyth]

- [REF] Improving installation of build dependencies on python images.
  [Luis Alejandro Martínez Faneyth]

- [REF] Improving README. [REF] Updating MicroBadger and Docker Hub
  triggers. [REF] Adding security and updates mirrors to debian images.
  [FIX] Correct build hooks for some images. [Luis Alejandro Martínez
  Faneyth]

- [REF] Changing name to tags. [Luis Alejandro Martínez Faneyth]

- [REF] Adjusting dependencies and removing path-exclude config from
  dpkg because it fucks up locales configuration. [Luis Alejandro
  Martínez Faneyth]

- [FIX] Fixing typo. [Luis Alejandro Martínez Faneyth]

- [REF] Improving build scripts. [Luis Alejandro Martínez Faneyth]

- [REF] Converting generation of images to a more standard method to
  avoid borderline issues. [Luis Alejandro Martínez Faneyth]

- [FIX] Fixing wheezy build. [Luis Alejandro Martínez Faneyth]

- [REF] Configuring DNS. [Luis Alejandro Martínez Faneyth]

- [REF] Fixing debian suites. [Luis Alejandro Martínez Faneyth]

- [REF] Changing mirror. [Luis Alejandro Martínez Faneyth]

- [REF] Fixing build. [Luis Alejandro Martínez Faneyth]

- [REF] Fixing build. [Luis Alejandro Martínez Faneyth]

- [REF] Correcting temporary failure of debian cdn. [Luis Alejandro
  Martínez Faneyth]

- [REF] Adding wheezy-min and jessie-min to compyle python 2.6, 3.2 and
  3.4. [Luis Alejandro Martínez Faneyth]

- [REF] python: Adding suite dependecies to sources.list. [Luis
  Alejandro Martínez Faneyth]

- [REF] Removing push of base tarball from Travis. [Luis Alejandro
  Martínez Faneyth]

- [REF] Moving the build script to a pre_build hook. [Luis Alejandro
  Martínez Faneyth]

- [REF] Changing label schema for dockerfiles. [REF] Adding curl and ca-
  certificates to base image. [REF] Fixing typo on DEB_BUILD_OPTIONS.
  [REF] Installing runtime dependencies for Python. [REF] .travis.yml:
  Adding an encrypted access key fro github, to be able to push from
  Travis. [REF] debian/sid-min/base.tar.xz: Adding a base tarball to be
  used in the Dockerfile. [REF] debian/sid-min/build-base.sh: Improving
  base build script. [REF] Removing the need for wget in python images.
  [Luis Alejandro Martínez Faneyth]

- [REF] .travis.yml: adding POST to MicroBadger API so that they stop
  being lazy. [REF] Improving README. [REF] Testing if Docker Hub likes
  my hooks/pre_build. [Luis Alejandro Martínez Faneyth]

- Adding debootstrap to sid-build dependencies. [Luis Alejandro Martínez
  Faneyth]

- [REF] Removing --merged-usr because hub.docker.com doesn't support it.
  [Luis Alejandro Martínez Faneyth]

- Redifining structure of pypicontents to be able to use hooks at
  hub.docker.com. [Luis Alejandro Martínez Faneyth]

- Testing if docker pre_build accepts installing packages. [Luis
  Alejandro Martínez Faneyth]

- [ADD] .travis.yml: Trigger a build on hub.docker.com if the cron tells
  us to. [REF] README.md: Start to write the readme. [ADD] banner.svg:
  Give us a nice banner. [REF] Importing Dockerfiles of pypicontents and
  curriculum-vitae. [REF] Making use of Docker hooks to allow building
  the chroot in the docker hub. [Luis Alejandro Martínez Faneyth]

- [ADD] Adding scripts for building sid image. [Luis Alejandro Martínez
  Faneyth]

- [ADD] Adding Dockerfile for python image. [Luis Alejandro Martínez
  Faneyth]

- Initial commit. [Luis Alejandro Martínez Faneyth]


