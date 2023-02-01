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
# Dyna&omega;o - An hybrid C++/Modelica suite of simulation tools for power systems

[![Build Status](https://github.com/dynawo/dynawo/workflows/CI/badge.svg)](https://github.com/dynawo/dynawo/actions)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=dynawo_dynawo&metric=alert_status)](https://sonarcloud.io/dashboard?id=dynawo_dynawo)
[![Coverage](https://sonarcloud.io/api/project_badges/measure?project=dynawo_dynawo&metric=coverage)](https://sonarcloud.io/dashboard?id=dynawo_dynawo)
[![MPL-2.0 License](https://img.shields.io/badge/license-MPL_2.0-blue.svg)](https://www.mozilla.org/en-US/MPL/2.0/)
[![Documentation](https://dynawo.github.io/assets/images/doxygen_badge.svg)](https://dynawo.github.io/dynawo/index.html)
[![OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/projects/6730/badge)](https://bestpractices.coreinfrastructure.org/projects/6730)
[http://dynawo.org](http://dynawo.org)

This repository contains Dyna&omega;o's project code.

<p align="center">
  <img src="documentation/resources/Dynawo-Logo-Color.png" width="400"/>
</p>

## Table of Contents

- [Get involved!](#contributions)
- [About Dyna&omega;o](#about)
- [Getting started!](#start)
- [Installation](#installation)
  * [Dyna&omega;o Binaries](#distribution)
  * [Building requirements](#requirements)
    * [Linux](#requirements_linux)
    * [Windows](#requirements_windows)
  * [Building Dyna&omega;o](#build)
    * [Linux](#build_linux)
    * [Windows](#build_windows)
  * [Launch Dyna&omega;o](#launch)
    * [Linux](#launch_linux)
    * [Windows](#launch_windows)
  * [Docker Dyna&omega;o](#docker)
- [Dyna&omega;o Documentation](#documentation)
  * [Doxygen](#doxygen)
- [Quoting Dyna&omega;o](#quoting)
- [License](#license)
- [Maintainers](#maintainers)
- [Roadmap](#roadmap)
- [Links](#links)

<a name="contributions"></a>
## Get involved!
Dyna&omega;o is an open-source project and as such, questions, discussions, feedbacks and more generally any form of contribution are very welcome and greatly appreciated!

For further informations about contributing guidelines, please refers to the [contributing documentation](https://github.com/dynawo/.github/blob/master/CONTRIBUTING.md).

<a name="about"></a>
## About Dyna&omega;o

**Dyna&omega;o is an hybrid C++/Modelica open source suite of simulation tools for power systems. It aims at providing power system stakeholders with a transparent, flexible, interoperable and robust suite of simulation tools that could ease collaboration and cooperation in the power system community.**

The nature of power system dynamics is deeply evolving towards a more diverse and difficult to predict behavior due to the massive changes going on in the power system (large penetration of power-electronic based components such as Renewable Energies Sources - RES - or High Voltage Direct Current - HVDC - lines, booming use of complex automata, control strategies or smart grids). Due to this radical change from physically-driven to numerically-driven dynamics, being able to assess the system stability becomes harder but is still essential as any generalized incident will be unacceptable for the economy and the consumers. This requires to have access to a transparent, flexible, robust and easy to use suite of simulation tools that will allow to run collaborative studies in a very simple way by sharing not only the same data but also the same modeling and solving choices in an open-source frame. Such tools will ensure to get similar results and to agree upon optimal and shared actions on the system to accompany the ongoing changes in the best possible way. This analysis has motivated us to launch a new effort on simulation tools that finally ends up in the development of the Dyna&omega;o's software.

**To achieve this goal, Dyna&omega;o is based on two mains principles: the use of a high-level modeling language Modelica and a strict separation between modeling and solving parts**. Modelica is an equation-based, declarative and object-oriented modeling language that is easy to read and understand (the equations are written in a similar way than they are written in textbooks for example) and already used in different and various industrial sectors. Using this language enables to easily share and discuss the modeling choices done because the final models implementation is available in an understandable way, even for the end-user. It is important to mention that Modelica-based tools already exist (Dymola, OpenModelica, JModelica, etc.) but they are not efficient enough for large-scale simulation of power system, which was one of the motivation for Dyna&omega;o. In addition to this, the Modelica language itself has some limitations that are addressed in Dyna&omega;o by the possibility to use C++ models in a similar way than Modelica models. The second important point in Dyna&omega;o is the strict separation between modeler and solvers - it means that the models only expose a few methods to the solvers such as the residual evaluation, the Jacobian evaluation or the zero-crossing functions or in other words that the numerical resolution method doesn't interfere in the modeling part. This feature has several advantages: it enables to easily test or use new solvers, it eases the addition of new model and it allows modeling expert not to bother about numerical difficulties and vice versa.

![image](documentation/resources/DynawoModelSolverLight.png "Dyna&omega;o's two main principles")

**Dyna&omega;o's primary focus has been on long-term and short-term stability studies** but the very encouraging results obtained and the flexibility of the approach led to **an extension of the initiative. Dyna&omega;o is now evolving towards a complete and coherent suite of simulation tools**, sharing the same philosophy:
  - **[DynaFlow](http://dynawo.org/about/dynaflow)** for steady-state calculations
  - **[DySym](http://dynawo.org/about/dysym)** for short-circuit calculations
  - **[DynaWaltz](http://dynawo.org/about/dynawaltz)** for long-term stability simulations
  - **[DynaSwing](http://dynawo.org/about/dynaswing)** for short-term stability studies
  - **[DynaWave](http://dynawo.org/about/dynawave)** for stability studies and system design with a high-penetration of power-electronics based components (quasi-EMT)

![image](documentation/resources/DynawoLogos.png "Dyna&omega;o's suite of simulation tools")

![image](documentation/resources/DynawoInitiative.png "Dyna&omega;o's high-level vision")
<p align="center"> High level vision of the Dyna&omega;o initiative </p>

<a name="start"></a>
## Getting started!

To get started with Dyna&omega;o you have different possibilities, depending on your background and what you want to do:
- If you are interested in the models available and want to have a quick look to them, please open the [Dyna&omega;o Modelica library](https://github.com/dynawo/dynawo/releases/download/v1.4.0/Dynawo_Modelica_library_v1.4.0.zip) in OpenModelica for example.
- If you want to launch simulations and examples with Dyna&omega;o and observe the performances, you can use the [pre-built distribution](#distribution) and the examples directory.
- If you want to checkout the repository and build it yourself to be able to modify the tool, please follow the build instructions available [here](#build)

**All validated models are included into the [Dyna&omega;o Modelica library](https://github.com/dynawo/dynawo/releases/download/v1.4.0/Dynawo_Modelica_library_v1.4.0.zip). Don't hesitate to open it in [OpenModelica](https://www.openmodelica.org/) to see what are the available models and simulate the simple full Modelica illustrative examples we provide.**

**In addition, we also provide an example directory containing validated test cases for DynaFlow, DynaWaltz and DynaSwing. Don't hesitate to simulate them and open the [associated documentation](https://github.com/dynawo/dynawo/releases/download/v1.4.0/DynawoDocumentation.zip).**

<a name="installation"></a>
## Installation
<a name="distribution"></a>
### Dyna&omega;o Distribution

You can download a pre-built Dyna&omega;o release to start testing it. Pre-built releases are available for **Linux** and **Windows**:
- [Linux](https://github.com/dynawo/dynawo/releases/download/v1.4.0/Dynawo_Linux_v1.4.0.zip)
- [Windows](https://github.com/dynawo/dynawo/releases/download/v1.4.0/Dynawo_Windows_v1.4.0.zip)

If you are on **MacOS** you can use [Docker](#docker).

#### Linux Requirements for Distribution

- Compilers: C and C++ ([gcc](https://www.gnu.org/software/gcc/) or [clang](https://clang.llvm.org/)), C++11 compatible for C++ standard
- Python2 or Python3
- Binary utilities: [curl](https://curl.haxx.se/) and unzip
- [CMake](https://cmake.org/)

**Note** For Python you need to have the `python` command available in your PATH. If you don't have one, you can use an environment variable to point to your Python version with `export DYNAWO_PYTHON_COMMAND="python3"`.

You can install the dependencies for Ubuntu or Fedora with:

``` bash
$> apt install -y g++ unzip curl python
$> dnf install -y gcc-c++ unzip curl python
```

### Windows Requirements for Distribution

On Windows you can either run Dyna&omega;o with distribution models and in this case nothing is required. If you want to be able to add new models you will need:

- [Visual Studio 2019](https://visualstudio.microsoft.com)
- [CMake](https://cmake.org/)
- [Python2](https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi) or [Python3](https://www.python.org/ftp/python/3.8.2/python-3.8.2-amd64.exe)

**Note** For Python you need to have the `python` command available in your PATH. If you don't have one you can use an environment variable to point to your Python version with `set DYNAWO_PYTHON_COMMAND=python3`.

### Using a distribution

#### Linux

You can launch the following commands to download and test the latest distribution:

``` bash
$> curl -L $(curl -s -L -X GET https://api.github.com/repos/dynawo/dynawo/releases/latest | grep "Dynawo_Linux" | grep url | cut -d '"' -f 4) -o Dynawo_Linux_latest.zip
$> unzip Dynawo_Linux_latest.zip
$> cd dynawo
$> ./dynawo.sh jobs-with-curves sources/examples/DynaWaltz/IEEE14/IEEE14_GeneratorDisconnections/IEEE14.jobs
$> ./dynawo.sh help
$> ./dynawo.sh jobs-help
```

#### Windows

Download the zip of the distribution and unzip it somewhere. Then open either `Command Prompt` or `x64 Native Tools Command Prompt for VS2019` (to be able to use your own models) and use `cd` to go into the directory you previously unzipped. You should see a `dynawo.cmd` file at the top of the folder. You can then launch a simulation with:

``` batch
> dynawo jobs sources\examples\DynaWaltz\IEEE14\IEEE14_GeneratorDisconnections\IEEE14.jobs
> dynawo jobs-with-curves sources\examples\DynaWaltz\IEEE14\IEEE14_GeneratorDisconnections\IEEE14.jobs
```

You can set up the curves to open in your preferred browser with `set DYNAWO_BROWSER=C:\Program Files (x86)\Mozilla Firefox\firefox.exe` for example.

<a name="requirements"></a>
### Building requirements

You can build Dyna&omega;o from sources. Dyna&omega;o is available on two platforms **Linux** and **Windows**. **Linux** has been tested on Centos and Debian based distributions, for other distributions don't hesitate to contact us if you run in problems. Only **Windows 10** has been tested for Windows. If you are on **MacOS** we recommend you to use a [Docker solution](#docker). <br>
If you have any issue building Dyna&omega;o don't hesitate to send us an [email](mailto:rte-dynawo@rte-france.com) with your errors and we will try to answer you back quickly.

In the following we give a list of requirements needed to build Dyna&omega;o and its dependencies.

<a name="requirements_linux"></a>
#### Linux

##### Global
- Compilers: C and C++ ([gcc](https://www.gnu.org/software/gcc/), [clang](https://clang.llvm.org/) or Apple Clang with Xcode or Command Line Tools), C++11 compatible for C++ standard

##### OpenModelica Compiler
- Compiler: Fortran ([gfortran](https://gcc.gnu.org/fortran/))
- Build systems: [autoconf](https://www.gnu.org/software/autoconf/), [automake](https://www.gnu.org/software/autoconf/), [libtool](https://www.gnu.org/software/libtool/), [pkgconf](http://pkgconf.org/), make, [CMake](https://cmake.org/)
- Binary utilities: [xz](https://tukaani.org/xz/), patch, [GNU sed](https://www.gnu.org/software/sed/), msgfmt from [gettext](https://www.gnu.org/software/gettext/), [rsync](https://rsync.samba.org/)
- Java ([openjdk](https://openjdk.java.net/) for example)
- Libraries: [expat](https://libexpat.github.io/), [BLAS](http://www.netlib.org/blas/index.html), [LAPACK](http://www.netlib.org/lapack/index.html)
- [lpsolve55](http://lpsolve.sourceforge.net/) or [bison](https://www.gnu.org/software/bison/) and [flex](https://www.gnu.org/software/flex/) (to let OpenModelica compiles lpsolve itself)

##### Dyna&omega;o user
- [CMake](https://cmake.org/): minimum version 3.9.6
- Python2 or Python3
- Python packages: [lxml](https://lxml.de/)
- Binary utilities: [curl](https://curl.haxx.se/) or [wget](https://www.gnu.org/software/wget/), [xmllint](http://xmlsoft.org/xmllint.html)

**Note** For Python you need to have the `python` command available in your PATH. If you don't have one you can use an environment variable to point to your Python version with `export DYNAWO_PYTHON_COMMAND="python3"`.

##### Dyna&omega;o developer
- [Doxygen](http://www.doxygen.nl/): minimum version 1.8, [Graphviz](https://graphviz.readthedocs.io/en/stable/) and LaTeX to build full documentation
- Python packages: [psutil](https://psutil.readthedocs.io/en/latest/)
- [LCOV](http://ltp.sourceforge.net/coverage/lcov.php): 1.7 to 1.13 versions work fine

<a name="requirements_windows"></a>
#### Windows

- [Visual Studio 2019](https://visualstudio.microsoft.com/), Visual Studio 2015 was also tested
- [CMake](https://cmake.org/)
- Java ([openjdk](https://openjdk.java.net/) for example) to build OpenModelica Compiler
- [Python2](https://www.python.org/ftp/python/2.7.18/python-2.7.18.amd64.msi) or [Python3](https://www.python.org/ftp/python/3.8.2/python-3.8.2-amd64.exe)

**Note** For Python you need to have the `python` command available in your PATH. If you don't have one you can use an environment variable to point to your Python version with `set DYNAWO_PYTHON_COMMAND=python3`.

<a name="build"></a>
### Building Dyna&omega;o

<a name="build_linux"></a>
#### Linux

You can install the following packages to have no dependency problem in the following steps. This example works for Ubuntu until 19.04 included:

``` bash
$> apt-get install -y git gcc g++ gfortran autoconf pkgconf automake make libtool cmake hwloc openjdk-8-jdk libblas-dev liblpsolve55-dev libarchive-dev doxygen doxygen-latex liblapack-dev libexpat1-dev libsqlite3-dev zlib1g-dev gettext patch clang python-pip libncurses5-dev libreadline-dev libdigest-perl-md5-perl unzip gcovr lcov libboost-all-dev qt4-qmake qt4-dev-tools lsb-release libxml2-utils python-lxml python-psutil wget libcurl4-openssl-dev rsync bash-completion
```

For Ubuntu 20.04 use:
``` bash
$> apt install -y git gcc g++ gfortran autoconf pkgconf automake make libtool cmake hwloc openjdk-8-jdk libblas-dev liblpsolve55-dev libarchive-dev doxygen doxygen-latex liblapack-dev libexpat1-dev libsqlite3-dev zlib1g-dev gettext patch clang python3-pip libncurses5-dev libreadline-dev libdigest-perl-md5-perl unzip gcovr lcov libboost-all-dev qt5-default lsb-release libxml2-utils python-lxml python-psutil wget libcurl4-openssl-dev rsync libopenblas-openmp-dev
```

For Ubuntu 22.04 use:
``` bash
$> apt install -y git gcc g++ gfortran autoconf pkgconf automake make libtool cmake hwloc openjdk-8-jdk libblas-dev liblpsolve55-dev libarchive-dev doxygen doxygen-latex liblapack-dev libexpat1-dev libsqlite3-dev zlib1g-dev gettext patch clang python3-pip libncurses5-dev libreadline-dev libdigest-perl-md5-perl unzip gcovr lcov libboost-all-dev  lsb-release libxml2-utils python3-lxml python3-psutil wget libcurl4-openssl-dev rsync libopenblas-openmp-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools
```

And for Fedora:
``` bash
$> dnf install -y git gcc gcc-c++ gcc-gfortran autoconf automake make libtool cmake hwloc java-1.8.0-openjdk-devel blas-devel lapack-devel lpsolve-devel expat-devel glibc-devel sqlite-devel libarchive-devel zlib-devel doxygen doxygen-latex qt-devel gettext patch wget python-devel clang llvm-devel ncurses-devel readline-devel unzip perl-Digest-MD5 vim gcovr python-pip python-psutil boost-devel lcov gtest-devel gmock-devel xz rsync python-lxml graphviz libcurl-devel bash-completion
```

To build Dyna&omega;o you need to clone this repository and launch the following commands in the source code directory, it will create a `myEnvDynawo.sh` file that will be your personal entrypoint to launch Dyna&omega;o and parametrise some options.

``` bash
$> git clone https://github.com/dynawo/dynawo.git dynawo
$> cd dynawo
$> echo '#!/bin/bash
export DYNAWO_HOME=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

export DYNAWO_SRC_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Source
export DYNAWO_INSTALL_OPENMODELICA=$DYNAWO_HOME/OpenModelica/Install

export DYNAWO_LOCALE=en_GB
export DYNAWO_RESULTS_SHOW=true
export DYNAWO_BROWSER=firefox

export DYNAWO_NB_PROCESSORS_USED=1

export DYNAWO_BUILD_TYPE=Release

$DYNAWO_HOME/util/envDynawo.sh $@' > myEnvDynawo.sh
$> chmod +x myEnvDynawo.sh
$> ./myEnvDynawo.sh build-user
```

Below is a description of some environment variables that might be changed in `myEnvDynawo.sh`:

| Variable | Description |
|:----|:----|
| DYNAWO_BROWSER | Default browser command |
| DYNAWO_NB_PROCESSORS_USED | Maximum number of cores to use |
| DYNAWO_BUILD_TYPE | Build type: Release or Debug |
| DYNAWO_COMPILER | Compiler: GCC (default) or CLANG |

You can have more information about compilation options [here](https://dynawo.github.io/install/compilation_options).

**Warning**: If you're working behind a proxy make sure you have exported the following proxy environment variables
``` bash
$> export http_proxy=http://login:mdp@proxy_address:proxy_port/
$> export https_proxy=https://login:mdp@proxy_address:proxy_port/
$> export no_proxy=localhost,127.0.0.0/8,::1
$> export HTTP_PROXY=$http_proxy;export HTTPS_PROXY=$https_proxy;export NO_PROXY=$no_proxy;
```

<a name="build_windows"></a>
#### Windows

Open `x64 Native Tools Command Prompt for VS2019` and run the following commands:

``` batch
> git config --global core.eol lf
> git config --global core.autocrlf input
> set OPENMODELICAHOME=
> set OPENMODELICALIBRARY=
> md dynawo-project && cd dynawo-project
> git clone https://github.com/dynawo/dynawo.git dynawo
> cd dynawo
> cmake -S dynawo/3rdParty -B b-3-p -DCMAKE_INSTALL_PREFIX=../d-3-p -DOPENMODELICA_INSTALL=../OpenModelica/Install -DOPENMODELICA_SRC=../OpenModelica/Source -DOMDEV_HOME=../OMDev -G "NMake Makefiles"
> cmake --build b-3-p
> cmake -S dynawo -B b -DCMAKE_INSTALL_PREFIX=../d-i -DDYNAWO_HOME=.. -DINSTALL_OPENMODELICA=../../OpenModelica/Install -DDYNAWO_THIRD_PARTY_DIR=../../d-3-p -G "NMake Makefiles
> cmake --build b --target install
> cmake --build b --target models
> cmake --build b --target solvers
```

**Warning** We try to limit as far as possible the name of the build and install folders (for example d-i instead of dynawo-install or b-3-p for build-3rd-parties) because of Windows limitation of length of path for folders. We know it causes problems and the only solution is to install Dyna&omega;o in a shorter length directory path.

**Warning** Only the build directories (b and b-3-p) can be located in the `dynawo` folder, the install (d-i and d-3-p), OMDev and OpenModelica folders should be located outside to avoid problems with CMake.

<a name="launch"></a>
### Launch Dyna&omega;o

<a name="launch_linux"></a>
#### Linux

Once you have build Dyna&omega;o you can start launching a simulation with the command:
``` bash
$> ./myEnvDynawo.sh jobs-with-curves examples/DynaWaltz/IEEE14/IEEE14_GeneratorDisconnections/IEEE14.jobs
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
$> dynawo jobs-with-curves examples/DynaWaltz/IEEE14/IEEE14_GeneratorDisconnections/IEEE14.jobs
```

<a name="launch_windows"></a>
#### Windows

Once you have build Dyna&omega;o you can start launching a simulation with the command:

``` batch
> cd ..\d-i
> dynawo jobs ..\dynawo\examples\DynaWaltz\IEEE14\IEEE14_GeneratorDisconnections\IEEE14.jobs
> dynawo jobs-with-curves ..\dynawo\examples\DynaWaltz\IEEE14\IEEE14_GeneratorDisconnections\IEEE14.jobs
```

You can set up the curves to open in your preferred browser with `set DYNAWO_BROWSER=C:\Program Files (x86)\Mozilla Firefox\firefox.exe` for example. Use also `set DYNAWO_PYTHON_COMMAND=python3` for example to setup your python command.

<a name="docker"></a>
### Docker

We provide on [Docker Hub](https://hub.docker.com/r/dynawo/dynawo) an image of Dyna&omega;o master. You can use it by launching the following command:

``` bash
$> docker run -it dynawo/dynawo
```

You can have more information on how to use Docker to build and try Dyna&omega;o [here](https://github.com/dynawo/dynawo-docker).

<a name="documentation"></a>
## Dyna&omega;o Documentation
You can download Dyna&omega;o documentation [here](https://github.com/dynawo/dynawo/releases/download/v1.4.0/DynawoDocumentation.zip).

<a name="doxygen"></a>
### Doxygen

You can consult Doxygen documentation of the master branch [here](https://dynawo.github.io/dynawo/).

<a name="quoting"></a>
## Quoting Dyna&omega;o

If you use Dyna&omega;o in your work or research, it is not mandatory but we kindly ask you to quote the following paper in your publications or presentations:

A. Guironnet, M. Saugier, S. Petitrenaud, F. Xavier, and P. Panciatici, “Towards an Open-Source Solution using Modelica for Time-Domain Simulation of Power Systems,” 2018 IEEE PES Innovative Smart Grid Technologies Conference Europe (ISGT-Europe), Oct. 2018.

<a name="license"></a>
## License

Dyna&omega;o is licensed under the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0. You can also see the [LICENSE](LICENSE.txt) file for more information.

Dyna&omega;o is using some external libraries to run simulations:
* [OpenModelica](https://www.openmodelica.org/), a Modelica environment developed and maintained by the Open Source Modelica Consortium distributed under a GPL V3.0 or OSMC Public License V1.2. The current version used is V1.13.2.
* [SUNDIALS](https://computation.llnl.gov/projects/sundials), a suite of solvers developed and maintained by the Lawrence Livermore National Lab and distributed under a BSD-3-Clause license. The 4.1.0 version is currently used.
* [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html), and in particular KLU, a LU decomposition library that is part of the suite sparse project, developed and maintained by T. A. Davis et al. at the University of Florida distributed under a LGPL-2.1+. The version 4.5.4 of suite sparse is the one used by Dyna&omega;o.
* [Adept](http://www.met.reading.ac.uk/clouds/adept/), an automatic differentiation library that has been developed and maintained at the University of Reading by R.J. Hogan distributed under Apache-2.0. It is the version 2.1.1 that is integrated into Dyna&omega;o.
* [Xerces-C++](http://xerces.apache.org/xerces-c/) a validating XML parser written in a portable subset of C++ and distributed under the Apache Software License, Version 2.0. The current version used is 3.2.2.
* [Libxml2](http://xmlsoft.org/), a XML C parser and toolkit distributed under the MIT License. The current version used is 2.9.4.
* [PowSyBl - iidm4cpp](https://www.powsybl.org/pages/documentation/developer/repositories/powsybl-iidm4cpp.html), a C++ implementation of the IIDM grid model and distributed under the MPL License, Version 2.0. The current version used is 1.4.0.
* [NICSLU](http://nicslu.weebly.com/) which is another LU decomposition library. It is developed and maintained by Tsinghua University and is optional at the moment into Dyna&omega;o. It is distributed under a GNU LGPL license.
* [jQuery](https://jquery.com/) that is distributed into Dyna&omega;o to display results into a minimalistic GUI after the simulation. The current version used is the 1.3.4 distributed under both a MIT and a GPL license.
* [cpplint](https://github.com/google/styleguide/tree/gh-pages/cpplint), a tool used during Dyna&omega;o compilation process to ensure that the C++ files follow the Google's C++ style. It is distributed under a CC-By 3.0 License.

<a name="maintainers"></a>
## Maintainers

Dyna&omega;o is currently maintained by the following people in RTE:

* Gautier Bureau, [gautier.bureau@rte-france.com](mailto:gautier.bureau@rte-france.com)
* Marco Chiaramello, [marco.chiaramello@rte-france.com](mailto:marco.chiaramello@rte-france.com)
* Quentin Cossart, [quentin.cossart@rte-france.com](mailto:quentin.cossart@rte-france.com)
* Adrien Guironnet, [adrien.guironnet@rte-france.com](mailto:adrien.guironnet@rte-france.com)
* Ian Menezes, [ian.menezes@rte-france.com](mailto:ian.menezes@rte-france.com)
* Florentine Rosiere, [florentine.rosiere@rte-france.com](mailto:florentine.rosiere@rte-france.com)

In case of questions or issues, you can also send an e-mail to [rte-dynawo@rte-france.com](mailto:rte-dynawo@rte-france.com).

<a name="roadmap"></a>
## Roadmap
Below are the major development axis identified for Dyna&omega;o for the next few months, with associated contents and due date. It is important to notice that the development content and the due dates may be subject to change due to unforeseen complexity in implementing features or priority changes.

### Axis 1 - Models development

* PV and Wind WECC model: under final validation and integration, September 2021
* ~~HVDC standard model: expected September 2020~~: Available since V1.2.0
* ~~Additional models for steady-state calculations (Static Var Compensator, voltage regulation, etc.)~~: Available in the master
* Standard regulation models (governors, voltage regulators, power system stabilizers): under progress
* IEC 61400 Wind model: December 2021

### Axis 2 - Test cases
* Adding large scale test cases (national and panEuropean ones): internally ready but postponed to December 2021 (anonymisation) for public availability
* ~~New examples section~~: Available since V1.2.0.
* [NordicTestSystem case](https://www.researchgate.net/publication/339572493_Test_Systems_for_Voltage_Stability_Studies_IEEE_Task_Force_on_Test_Systems_for_Voltage_Stability_Analysis_and_Security_Assessment): under validation for Dyna&omega;o and delayed in Modelica (waiting for updates in OpenModelica), September 2021
* [ENTSO-E controller test case](https://eepublicdownloads.entsoe.eu/clean-documents/pre2015/publications/entsoe/RG_SOC_CE/131127_Controller_Test_Report.pdf): under validation for Dyna&omega;o and Modelica, June 2021

### Axis 3 - Dependencies, architecture and performances
* ~~Switch to Sundials V5.0.0 and Suitesparse V5.3.0~~: Available in the master
* ~~Switch to a newer IIDM library version~~: Available in the master
* ~~Performances improvements~~: Available in the master
* Ancilarry services - contingency analysis and margin calculation: under progress, new repository [dynawo-algorithms](https://github.com/dynawo/dynawo-algorithms)
* Dyna&omega;o connectivity analysis improvement (system splitting): postponed 2021
* Symbolic Jacobian use for Modelica models: waiting for OpenModelica update

<a name="links"></a>
## Links

For more information about Dyna&omega;o:

* Consult [Dyna&omega;o website](http://dynawo.org)
* Contact us at [rte-dynawo@rte-france.com](mailto:rte-dynawo@rte-france.com)
