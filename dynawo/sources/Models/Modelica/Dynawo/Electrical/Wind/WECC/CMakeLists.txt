# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.

add_subdirectory(BaseClasses B)

set(MODEL_FILES
  package.mo
  package.order
  WPP3CurrentSource1.mo
  WPP3CurrentSource1.extvar
  WPP3CurrentSource2.mo
  WPP3CurrentSource2.extvar
  WPP4ACurrentSource.mo
  WPP4ACurrentSource.extvar
  WPP4BCurrentSource.mo
  WPP4BCurrentSource.extvar
  WT3CurrentSource1.mo
  WT3CurrentSource1.extvar
  WT3CurrentSource2.mo
  WT3CurrentSource2.extvar
  WT4ACurrentSource.mo
  WT4ACurrentSource.extvar
  WT4BCurrentSource.mo
  WT4BCurrentSource.extvar
  )

#
# Modelica models install
#
foreach( MODEL_FILE ${MODEL_FILES} )
    install_model_file(${MODEL_FILE})
endforeach( MODEL_FILE )
