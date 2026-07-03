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
add_subdirectory(InertialGrid IG)

set(MODEL_FILES
  # Sources models
  package.mo
  package.order
  Converter.mo
  Converter.extvar
  Converter.mandatoryParam
  Converter_INIT.mo
  Converter_INIT.mandatoryParam
  InjectorBG.mo
  InjectorBG.extvar
  InjectorBG.mandatoryParam
  InjectorBG_INIT.mo
  InjectorBG_INIT.mandatoryParam
  InjectorIDQ.mo
  InjectorIDQ.extvar
  InjectorIDQ_INIT.mo
  InjectorIDQ_INIT.mandatoryParam
  InjectorURI.mo
  InjectorURI.extvar
  ConverterCurrentSourceIEC63406.mo
  ConverterCurrentSourceIEC63406_INIT.mo
  ConverterCurrentSourceIEC63406.extvar
  ConverterVoltageSourceIEC63406.mo
  ConverterVoltageSourceIEC63406_INIT.mo
  ConverterVoltageSourceIEC63406.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
