<!--
    Copyright (c) 2024, RTE (http://www.rte-france.com)
    See AUTHORS.txt
    All rights reserved.
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, you can obtain one at http://mozilla.org/MPL/2.0/.
    SPDX-License-Identifier: MPL-2.0

    This file is part of Dynawo, an hybrid C++/Modelica open source time domain
    simulation tool for power systems.
-->

# Notice for Dyna&omega;o - A hybrid C++/Modelica suite of simulation tools for power systems

## License

Dyna&omega;o is licensed under the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, you can obtain one at http://mozilla.org/MPL/2.0. You can also see the [LICENSE](LICENSE.txt) file for more information.

## Third-party

Dyna&omega;o is using some external libraries to run simulations:
* [OpenModelica](https://www.openmodelica.org/), a Modelica environment developed and maintained by the Open Source Modelica Consortium distributed under a GPL V3.0 or OSMC Public License V1.2. **RTE is a Level 2 member of OSMC so the OpenModelica binary is being redistributed according to the terms of the OSMC-External-EPL license mode** (accordingly to [OpenModelica licenses](https://openmodelica.org/free-and-open-source-software/full-license/)).The current version used is V1.13.2.
* [SUNDIALS](https://computation.llnl.gov/projects/sundials), a suite of solvers developed and maintained by the Lawrence Livermore National Lab and distributed under a BSD-3-Clause license. The 6.3.0 version is currently used.
* [SuiteSparse](http://faculty.cse.tamu.edu/davis/suitesparse.html), and in particular KLU, a LU decomposition library that is part of the suite sparse project, developed and maintained by T. A. Davis et al. at the University of Florida distributed under a LGPL-2.1+. The version 5.10.1 of suite sparse is the one used by Dyna&omega;o.
* [Adept](http://www.met.reading.ac.uk/clouds/adept/), an automatic differentiation library that has been developed and maintained at the University of Reading by R.J. Hogan distributed under Apache-2.0. It is the version 2.1.1 that is integrated into Dyna&omega;o.
* [Xerces-C++](http://xerces.apache.org/xerces-c/) a validating XML parser written in a portable subset of C++ and distributed under the Apache Software License, Version 2.0. The current version used is 3.2.2.
* [Libxml2](http://xmlsoft.org/), a XML C parser and toolkit distributed under the MIT License. The current version used is 2.9.4.
* [PowSyBl - iidm4cpp](https://www.powsybl.org/pages/documentation/developer/repositories/powsybl-iidm4cpp.html), a C++ implementation of the IIDM grid model and distributed under the MPL License, Version 2.0. The current version used is 1.5.1.
* [jQuery](https://jquery.com/) that is distributed into Dyna&omega;o to display results into a minimalistic GUI after the simulation. The current version used is the 1.3.4 distributed under both a MIT and a GPL license.
* [cpplint](https://github.com/google/styleguide/tree/gh-pages/cpplint), a tool used during Dyna&omega;o compilation process to ensure that the C++ files follow the Google's C++ style. It is distributed under a CC-By 3.0 License.
