Epistoleiro
===========

### Overview

Epistoleiro is a web application which manages events of a group. You can create group and subgroups and add users to it. Whenever you create an event, all users signed to that group will be warned by e-mail and required to confirm presence or absence.

### System requirements

- [Ruby] (http://www.ruby-lang.org)
- [Bundler] (http://gembundler.com)
- [MongoDB] (http://www.mongodb.org/)

### Preparing an application environment

If you want to prepare an environment for develop or execution only purpose and have no idea about how to do it, just take a look at [dev setup](https://github.com/aureliano/epistoleiro/wiki/preparing-application-environment) page.

### Get ready

After you get the project's source code, synchronize gems dependency with bundler `bundle install` in the root directory. Before you start server and deploy application you must make sure that some configuration were provided. Get a little closed with that stuff at this [wiki page](https://github.com/aureliano/epistoleiro/wiki/application-global-configuration). Now, all you need to do is start server up and deploy application by executing `rackup`.

[![Build Status](https://travis-ci.org/aureliano/epistoleiro.png?branch=master)](https://travis-ci.org/aureliano/epistoleiro)