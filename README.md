<!--
    Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
    See AUTHORS.txt
    All rights reserved.
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, you can obtain one at http://mozilla.org/MPL/2.0/.
    SPDX-License-Identifier: MPL-2.0

    This file is part of Dynawo, an hybrid C++/Modelica open source time domain
    simulation tool for power systems.
-->
# Dyna&omega;o - An hybrid C++/Modelica time-domain simulation tool for power systems
[![Build Status](https://travis-ci.com/dynawo/dynawo.svg?branch=master)](https://travis-ci.com/dynawo/dynawo)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=dynawo_dynawo&metric=alert_status)](https://sonarcloud.io/dashboard?id=dynawo_dynawo)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=dynawo_dynawo&metric=coverage)](https://sonarcloud.io/dashboard?id=dynawo_dynawo)
[![MPL-2.0 License](https://img.shields.io/badge/license-MPL_2.0-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0/)

[http://dynawo.org](http://dynawo.org)

This repository contains Dyna&omega;o's simulation tool code.

## Table of Contents

- [About Dyna&omega;o](#about)
- [Building requirements on Unix/Linux](#requirements)
- [Building Dyna&omega;o](#build)
- [Launch Dyna&omega;o](#launch)
- [Dyna&omega;o Documentation](#documentation)
- [Get involved](#contributions)
- [Quoting Dyna&omega;o](#quoting)
- [License](#license)
- [Maintainers](#maintainers)
- [Roadmap](#roadmap)
- [Links](#links)

<a name="about"></a>
## About Dyna&omega;o

**Dyna&omega;o is an open source time domain simulation tool for power systems using the Modelica language. It aims at providing power system stakeholders with a transparent, flexible, interoperable and robust simulation tool that could ease collaboration and cooperation in the power system community**.

The nature of power system dynamics is deeply evolving towards a more diverse and difficult to predict behavior due to the massive changes going on in the power system (large penetration of power-electronic based components such as Renewable Energies Sources - RES - or High Voltage Direct Current - HVDC - lines, booming use of complex automata, control strategies or smart grids). Due to this radical change from physically-driven to numerically-driven dynamics, being able to assess the system stability becomes harder but is still essential as any generalized incident will be unacceptable for the economy and the consumers. This requires to have access to a transparent, flexible, robust and easy to use simulation tool that will allow to run collaborative studies in a very simple way by sharing not only the same data but also the same modeling and solving choices in an open-source frame. Such tools will ensure to get similar results and to agree upon optimal and shared actions on the system to accompany the ongoing changes in the best possible way. This analysis has motivated us to launch a new effort on time-domain simulation tools that finally ends up in the development of the Dyna&omega;o's software.

**To achieve this goal, Dyna&omega;o is based on two mains principles: the use of a high-level modeling language Modelica and a strict separation between modeling and solving parts**. Modelica is an equation-based, declarative and object-oriented modeling language that is easy to read and understand (the equations are written in a similar way than they are written in textbooks for example) and already used in different and various industrial sectors. Using this language enables to easily share and discuss the modeling choices done because the final models implementation is available in an understandable way, even for the end-user. It is important to mention that Modelica-based tools already exist (Dymola, OpenModelica, JModelica, etc.) but they are not efficient enough for large-scale simulation of power system, which was one of the motivation for Dyna&omega;o. In addition to this, the Modelica language itself has some limitations that are adressed in Dyna&omega;o by the possibility to use C++ models in a similar way than Modelica models. The second important point in Dyna&omega;o is the strict separation between modeler and solvers - it means that the models only expose a few methods to the solvers such as the residual evaluation, the Jacobian evaluation or the zero-crossing functions or in other words that the numerical resolution method doesn't interfere in the modeling part. This feature has several advantages: it enables to easily test or use new solvers, it eases the addition of new model and it allows modeling expert not to bother about numerical difficulties and vice versa.

**Dyna&omega;o's primary focus has been on RMS simulations and most of the tests done until now have been for long-term and short-term stability studies.** However, the simulation tool structure offers great flexibility and makes it also possible to run other types of power system simulations, as long as the user provides the necessary models and solvers. Different initiatives are under discussion or submission to test the possibility to use Dyna&omega;o for EMT simulations or multi-system simulations.
**Only validated models are included into the library that is still under construction.** We plan to be able to release a new set of models in the near future, with for example HVDC, wind and solar power plants models or more different standard regulation models, etc.

<a name="requirements"></a>
## Building requirements on Unix/Linux

For the moment Dyna&omega;o has only be tested on **Linux** platforms (Centos and Debian based) and provided that you can install system packages there should be no problem on other Linux distributions. For **MacOS** and **Windows** users we provide a [Docker](https://github.com/dynawo/dynawo-docker) solution (also on [Docker Hub](https://hub.docker.com/r/dynawo/dynawo)) to either download a [pre-build image](https://github.com/dynawo/dynawo-docker#users) with Dyna&omega;o embedded or create your [own image](https://github.com/dynawo/dynawo-docker#developer) for developers. We also plan to provide compilation compatibility for Windows. If you have any issue building Dyna&omega;o don't hesitate to send us an [email](mailto:rte-des-simulation-dynamique@rte-france.com) with your errors and we will try to answer you back quickly.

In the following we give a list of requirements needed to build Dyna&omega;o and its dependencies.

### Global
- Compilers: C and C++ ([gcc](https://www.gnu.org/software/gcc/) or [clang](https://clang.llvm.org/)), c++98 or c++11 compatible for C++ standard

### OpenModelica Compiler
- Compiler: Fortran ([gfortran](https://gcc.gnu.org/fortran/))
- Build systems: [autoconf](https://www.gnu.org/software/autoconf/), [automake](https://www.gnu.org/software/autoconf/), [libtool](https://www.gnu.org/software/libtool/), [pkgconf](http://pkgconf.org/), make, [CMake](https://cmake.org/)
- Binary utilities: [xz](https://tukaani.org/xz/), patch, [GNU sed](https://www.gnu.org/software/sed/), msgfmt from [gettext](https://www.gnu.org/software/gettext/), [rsync](https://rsync.samba.org/)
- Java ([openjdk](https://openjdk.java.net/) for example)
- Libraries: [expat](https://libexpat.github.io/), [BLAS](http://www.netlib.org/blas/index.html), [LAPACK](http://www.netlib.org/lapack/index.html)
- [lpsolve55](http://lpsolve.sourceforge.net/) or [bison](https://www.gnu.org/software/bison/) and [flex](https://www.gnu.org/software/flex/) (to let OpenModelica compiles lpsolve itself)

### Dyna&omega;o user
- [CMake](https://cmake.org/): minimum version 3.9.6 (last version to compile with c++98 compiler)
- Libraries:
  * [libarchive](https://www.libarchive.org/): minimum version 2.8.0, latest 3.3.3 version has been tested and works fine
  * [Boost](https://www.boost.org/): minimum version 1.59, up to 1.69 multiple versions have been tested and work fine
- Python
- Python packages: [lxml](https://lxml.de/)
- Binary utilities: [curl](https://curl.haxx.se/) or [wget](https://www.gnu.org/software/wget/), [xmllint](http://xmlsoft.org/xmllint.html)

### Dyna&omega;o developer
- [Doxygen](http://www.doxygen.nl/): minimum version 1.8, [Graphviz](https://graphviz.readthedocs.io/en/stable/) and LaTeX to build full documentation
- Python packages: [psutil](https://psutil.readthedocs.io/en/latest/)
- [GoogleTest](https://github.com/google/googletest): minimum version 1.5.0, latest 1.8.1 version has been tested and works fine on recent OS
- [LCOV](http://ltp.sourceforge.net/coverage/lcov.php): 1.7 to 1.13 versions work fine

<a name="build"></a>
## Building Dyna&omega;o

You can install the following packages to have no dependency problem in the following steps. This example works for Ubuntu:

``` bash
$> apt-get install -y git gcc g++ gfortran autoconf pkgconf automake make libtool cmake hwloc openjdk-8-jdk libblas-dev liblpsolve55-dev libarchive-dev doxygen doxygen-latex liblapack-dev libexpat1-dev libsqlite3-dev zlib1g-dev gettext patch clang python-pip libncurses5-dev libreadline-dev libdigest-perl-md5-perl unzip gcovr lcov libboost-all-dev qt4-qmake qt4-dev-tools lsb-release libxml2-utils python-lxml python-psutil wget libcurl4-openssl-dev rsync
```

This one works for Fedora:
``` bash
$> dnf install -y git gcc gcc-c++ gcc-gfortran autoconf automake make libtool cmake hwloc java-1.8.0-openjdk-devel blas-devel lapack-devel lpsolve-devel expat-devel glibc-devel sqlite-devel libarchive-devel zlib-devel doxygen doxygen-latex qt-devel gettext patch wget python-devel clang llvm-devel ncurses-devel readline-devel unzip perl-Digest-MD5 vim gcovr python-pip python-psutil boost-devel lcov gtest-devel gmock-devel xz rsync python-lxml graphviz libcurl-devel
```

To build Dyna&omega;o you need to clone this repository and launch the following commands in the source code directory:

``` bash
$> git clone https://github.com/dynawo/dynawo.git dynawo
$> cd dynawo
$> echo '#!/bin/bash
export DYNAWO_HOME=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

export SRC_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Source
export INSTALL_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Install

export DYNAWO_LOCALE=en_GB
export RESULTS_SHOW=true
export BROWSER=xdg-open

export NB_PROCESSORS_USED=$(($(nproc --all)/2))

export BUILD_TYPE=Release
export CXX11_ENABLED=YES

$DYNAWO_HOME/util/envDynawo.sh $@' > myEnvDynawo.sh
$> chmod +x myEnvDynawo.sh
$> ./myEnvDynawo.sh build-user
```

You can have more information about compilation options [here](https://dynawo.github.io/install/compilation_options).

**Warning**: If you're working behind a proxy make sure you have exported the following proxy environment variables
``` bash
$> export http_proxy=http://login:mdp@proxy_address:proxy_port/
$> export https_proxy=https://login:mdp@proxy_address:proxy_port/
$> export no_proxy=localhost,127.0.0.0/8,::1
$> export HTTP_PROXY=$http_proxy;export HTTPS_PROXY=$https_proxy;export NO_PROXY=$no_proxy;
```

<a name="launch"></a>
## Launch Dyna&omega;o

Once you have build Dyna&omega;o you can start launching a simulation with the command:
``` bash
$> ./myEnvDynawo.sh jobs-with-curves nrt/data/IEEE14/IEEE14_BasicTestCases/IEEE14_DisconnectLine/IEEE14.jobs
```

You can also list all available commands with:
``` bash
$> ./myEnvDynawo.sh help
```

**We advise you to deploy our autocompletion** script to help you with the available commands, it will also set an alias (`dynawo`) in your bashrc or zshrc to be able to call Dyna&omega;o from anywhere. You can launch one of the two following commands:
``` bash
$> ./myEnvDynawo.sh deploy-autocompletion --deploy --shell-type bash
$> ./myEnvDynawo.sh deploy-autocompletion --deploy --shell-type zsh
```

Then you can launch:
``` bash
$> dynawo help
```

<a name="documentation"></a>
## Dyna&omega;o Documentation
You can download Dyna&omega;o documentation [here](https://github.com/dynawo/dynawo/releases/download/v0.1.0/DynawoDocumentation.pdf).

<a name="contributions"></a>
## Get involved!

Dyna&omega;o is an open-source project and as such, questions, discussions, contributions and feedbacks are very welcome. It is also an ongoing project and we are actively working on improving it and making it better so we encourage you to regularly check the project status and progresses.

Regarding contributions, the final details, methodology and testing procedures for accepting a contribution is still under discussion. Until it is defined, we recommend to proceed in the following way: first report the problem or explain the planned modifications in an e-mail to [rte-des-simulation-dynamique@rte-france.com](mailto:rte-des-simulation-dynamique@rte-france.com) in order to get a first feedback from us (we will check if efforts are already conducted on the topic on our side and if your proposition is in phase with the project evolution) and then submit a pull-request that will serve as the basis for final discussions and review.

<a name="quoting"></a>
## Quoting Dyna&omega;o

If you use Dyna&omega;o in your work or research, it is not mandatory but we kindly ask you to quote the following paper in your publications or presentations:
A. Guironnet, M. Saugier, S. Petitrenaud, F. Xavier, and P. Panciatici, “Towards an Open-Source Solution using Modelica for Time-Domain Simulation of Power Systems,” 2018 IEEE PES Innovative Smart Grid Technologies Conference Europe (ISGT-Europe), Oct. 2018.

<a name="license"></a>
## License

Dyna&omega;o is licensed under the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0. You can also see the [LICENSE](LICENSE.txt) file for more information.

Dyna&omega;o is using some external libraries to run simulations:
* [OpenModelica](https://www.openmodelica.org/), a Modelica environment developed and maintained by the Open Source Modelica Consortium distributed under a GPL V3.0 or OSMC Public License V1.2. The current version used is V1.9.4.
* [SUNDIALS](https://computation.llnl.gov/projects/sundials), a suite of solvers developed and maintained by the Lawrence Livermore National Lab and distributed under a BSD-3-Clause license. The 4.1.0 version is currently used.
* [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html), and in particular KLU, a LU decomposition library that is part of the suite sparse project, developed and maintained by T. A. Davis et al. at the University of Florida distributed under a LGPL-2.1+. The version 4.5.4 of suite sparse is the one used by Dyna&omega;o.
* [Adept](http://www.met.reading.ac.uk/clouds/adept/), an automatic differentiation library that has been developed and maintained at the University of Reading by R.J. Hogan distributed under Apache-2.0. It is the version 2.0.5 that is integrated into Dyna&omega;o.
* [Xerces-C++](http://xerces.apache.org/xerces-c/) a validating XML parser written in a portable subset of C++ and distributed under the Apache Software License, Version 2.0. The current version used is 3.2.2.
* [NICSLU](http://nicslu.weebly.com/) which is another LU decomposition library. It is developed and maintained by Tsinghua University and is optional at the moment into Dyna&omega;o. It is distributed under a GNU LGPL license.
* [jQuery](https://jquery.com/) that is distributed into Dyna&omega;o to display results into a minimalistic GUI after the simulation. The current version used is the 1.3.4 distributed under both a MIT and a GPL license.
* [cpplint](https://github.com/google/styleguide/tree/gh-pages/cpplint), a tool used during Dyna&omega;o compilation process to ensure that the C++ files follow the Google's C++ style. It is distributed under a CC-By 3.0 License.

<a name="maintainers"></a>
## Maintainers

Dyna&omega;o is currently maintained by the following people in RTE:

* Gautier Bureau, [gautier.bureau@rte-france.com](mailto:gautier.bureau@rte-france.com)
* Adrien Guironnet, [adrien.guironnet@rte-france.com](mailto:adrien.guironnet@rte-france.com)
* Romain Losseau, [romain.losseau@rte-france.com](mailto:romain.losseau@rte-france.com)
* Florentine Rosiere, [florentine.rosiere@rte-france.com](mailto:florentine.rosiere@rte-france.com)
* Marianne Saugier, [marianne.saugier@rte-france.com](mailto:marianne.saugier@rte-france.com)

In case of questions or issues, you can also send an e-mail to rte-des-simulation-dynamique@rte-france.com.

<a name="roadmap"></a>
## Roadmap
Below are the major development axis identified for Dyna&omega;o for the next few months, with associated contents and due date. It is important to notice that the development content and the due dates may be subject to change due to unforeseen complexity in implementing features or priority changes.

### Axis 1 - Test cases and models development - Expected July 2019

* Adding larger IEEE cases
* Adding large scale test cases (national and panEuropean ones)
* Adding new models (standard regulations for generators, static var compensator, etc.)

### Axis 2 - Dependencies upgrade - Expected September 2019

* Switch to OpenModelica V1.13 version and DAE mode use
* Switch to SUNDIALS V4.0 version
* Switch to a newer IIDM library version

### Axis 3 - Dyna&omega;o structure evolution - Expected February 2020
* New initialization strategy: using Modelica initEquations section into Dyna&omega;o
* Dyna&omega;o connectivity analysis improvement (system splitting)

<a name="links"></a>
## Links

For more information about Dyna&omega;o:

* Consult [Dyna&omega;o website](http://dynawo.org)
* Contact us at [rte-des-simulation-dynamique@rte-france.com](mailto:rte-des-simulation-dynamique@rte-france.com)
