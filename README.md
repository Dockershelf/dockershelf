![Banner](https://gitcdn.xyz/repo/LuisAlejandro/dockerfiles/master/banner.svg)

*Dockerfiles* is a repository that serves as a collector for docker recipes that I've found useful for specific cases. All docker images are rebuilt weekly on Docker Hub via a Travis cron.

Here you can find instructions on how to use them. Enjoy!

# Debian images

These are images similar to the official, but with some slightly different configurations. Check out their Dockerfiles for more details.

### luisalejandro/debian:sid [![](https://img.shields.io/badge/Dockerfile-debian:sid-yellow.svg)](debian/sid/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/debian:sid.svg)](https://microbadger.com/images/luisalejandro/debian:sid)
### luisalejandro/debian:stretch [![](https://img.shields.io/badge/Dockerfile-debian:stretch-yellow.svg)](debian/stretch/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/debian:stretch.svg)](https://microbadger.com/images/luisalejandro/debian:stretch)
### luisalejandro/debian:jessie [![](https://img.shields.io/badge/Dockerfile-debian:jessie-yellow.svg)](debian/jessie/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/debian:jessie.svg)](https://microbadger.com/images/luisalejandro/debian:jessie)
### luisalejandro/debian:wheezy [![](https://img.shields.io/badge/Dockerfile-debian:wheezy-yellow.svg)](debian/wheezy/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/debian:wheezy.svg)](https://microbadger.com/images/luisalejandro/debian:wheezy)

&nbsp;

# Python images

These are python images compiled from source, using the `debian/rules` makefile from debian's python source. These images are then updated to Debian Sid. Check out their Dockerfiles for more details.

### luisalejandro/python:2.6 [![](https://img.shields.io/badge/Dockerfile-python:2.6-yellow.svg)](python/2.6/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:2.6.svg)](https://microbadger.com/images/luisalejandro/python:2.6)
### luisalejandro/python:2.7 [![](https://img.shields.io/badge/Dockerfile-python:2.7-yellow.svg)](python/2.7/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:2.7.svg)](https://microbadger.com/images/luisalejandro/python:2.7)
### luisalejandro/python:3.2 [![](https://img.shields.io/badge/Dockerfile-python:3.2-yellow.svg)](python/3.2/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:3.2.svg)](https://microbadger.com/images/luisalejandro/python:3.2)
### luisalejandro/python:3.4 [![](https://img.shields.io/badge/Dockerfile-python:3.4-yellow.svg)](python/3.4/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:3.4.svg)](https://microbadger.com/images/luisalejandro/python:3.4)
### luisalejandro/python:3.5 [![](https://img.shields.io/badge/Dockerfile-python:3.5-yellow.svg)](python/3.5/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:3.5.svg)](https://microbadger.com/images/luisalejandro/python:3.5)
### luisalejandro/python:3.6 [![](https://img.shields.io/badge/Dockerfile-python:3.6-yellow.svg)](python/3.6/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/python:3.6.svg)](https://microbadger.com/images/luisalejandro/python:3.6)

&nbsp;

# PyPIContents images

These are images based on `luisalejandro/python` images and are used to build the [PyPIContents Index](https://github.com/LuisAlejandro/pypicontents). Check out their Dockerfiles for more details.

### luisalejandro/pypicontents:2.6 [![](https://img.shields.io/badge/Dockerfile-pypicontents:2.6-yellow.svg)](pypicontents/2.6/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:2.6.svg)](https://microbadger.com/images/luisalejandro/pypicontents:2.6)
### luisalejandro/pypicontents:2.7 [![](https://img.shields.io/badge/Dockerfile-pypicontents:2.7-yellow.svg)](pypicontents/2.7/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:2.7.svg)](https://microbadger.com/images/luisalejandro/pypicontents:2.7)
### luisalejandro/pypicontents:3.2 [![](https://img.shields.io/badge/Dockerfile-pypicontents:3.2-yellow.svg)](pypicontents/3.2/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:3.2.svg)](https://microbadger.com/images/luisalejandro/pypicontents:3.2)
### luisalejandro/pypicontents:3.4 [![](https://img.shields.io/badge/Dockerfile-pypicontents:3.4-yellow.svg)](pypicontents/3.4/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:3.4.svg)](https://microbadger.com/images/luisalejandro/pypicontents:3.4)
### luisalejandro/pypicontents:3.5 [![](https://img.shields.io/badge/Dockerfile-pypicontents:3.5-yellow.svg)](pypicontents/3.5/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:3.5.svg)](https://microbadger.com/images/luisalejandro/pypicontents:3.5)
### luisalejandro/pypicontents:3.6 [![](https://img.shields.io/badge/Dockerfile-pypicontents:3.6-yellow.svg)](pypicontents/3.6/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/pypicontents:3.6.svg)](https://microbadger.com/images/luisalejandro/pypicontents:3.6)

&nbsp;

# Latex image

This is an image based on [`luisalejandro/debian:sid`](https://microbadger.com/images/luisalejandro/debian:sid) with `texlive-fonts-recommended`, `texlive-latex-base`, `texlive-latex-extra` and `latex-xcolor` packages installed. It should be enough to use the `pdflatex` binary for basic Latex to PDF conversion.

### luisalejandro/latex:sid [![](https://img.shields.io/badge/Dockerfile-latex:sid-yellow.svg)](latex/Dockerfile) [![](https://images.microbadger.com/badges/image/luisalejandro/latex:sid.svg)](https://microbadger.com/images/luisalejandro/latex:sid)

&nbsp;
&nbsp;

# Made with :heart: and :hamburger:

![Banner](http://huntingbears.com.ve/static/img/site/banner.svg)

&nbsp;
&nbsp;

My name is Luis ([@LuisAlejandro](https://github.com/LuisAlejandro)) and I'm a Free and Open-Source Software developer living in Maracay, Venezuela.

If you like what I do, please support me on [Patreon](https://www.patreon.com/luisalejandro),  [Flattr](https://flattr.com/profile/luisalejandro), or donate via [PayPal](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=B8LPXHQY8QE8Y), so that I can continue doing what I love.

> Blog [huntingbears.com.ve](http://huntingbears.com.ve) · GitHub [@LuisAlejandro](https://github.com/LuisAlejandro) · Twitter [@LuisAlejandro](https://twitter.com/LuisAlejandro)

&nbsp;
&nbsp;
