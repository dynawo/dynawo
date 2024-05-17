# Copyright (c) 2022, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

set(MODEL_FILES
  CurrentLimiter2015.mo
  CurrentLimiter2020.mo
  Mechanical.mo
  package.mo
  package.order
  PControl4A2015.mo
  PControl4A2020.mo
  PControl4B2015.mo
  PControl4B2020.mo
  QControl2015.mo
  QControl2020.mo
  QLimiter2015.mo
  QLimiter2020.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
