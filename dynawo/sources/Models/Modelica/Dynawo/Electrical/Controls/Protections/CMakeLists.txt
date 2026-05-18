# Copyright (c) 2023, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

add_subdirectory(BaseClasses B)

set(MODEL_FILES
  package.mo
  package.order
  DistanceProtectionLineFourZones.mo
  DistanceProtectionLineFourZones.extvar
  DistanceProtectionLineFourZones.mandatoryParam
  DistanceProtectionLineFourZonesWithBlinder.mo
  DistanceProtectionLineFourZonesWithBlinder.extvar
  DistanceProtectionLineFourZonesWithBlinder.mandatoryParam
  DistanceProtectionLineTwoZones.mo
  DistanceProtectionLineTwoZones.extvar
  DistanceProtectionLineTwoZones.mandatoryParam
  DistanceProtectionLineTwoZonesWithBlinder.mo
  DistanceProtectionLineTwoZonesWithBlinder.extvar
  DistanceProtectionLineTwoZonesWithBlinder.mandatoryParam
  UFLS3Steps.mo
  UFLS3Steps.extvar
  UFLS3Steps.mandatoryParam
  UFLS10Steps.mo
  UFLS10Steps.extvar
  UFLS10Steps.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
