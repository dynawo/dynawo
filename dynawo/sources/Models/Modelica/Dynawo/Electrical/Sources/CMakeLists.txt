# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(IEC I)

set(MODEL_FILES
  # Sources models
  package.mo
  package.order
  Converter.mo
  Converter.extvar
  Converter_INIT.mo
  InjectorBG.mo
  InjectorBG.extvar
  InjectorBG_INIT.mo
  InjectorIDQ.mo
  InjectorIDQ.extvar
  InjectorIDQ_INIT.mo
  InjectorURI.mo
  InjectorURI.extvar
  InjectorGFL.mo
  InjectorGFL_INIT.mo
  InjectorGFL.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
