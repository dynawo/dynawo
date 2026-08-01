# Copyright (c) 2021, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.

# Standard steam governor models

set(MODEL_FILES
  package.mo
  package.order
  Gast.mo
  Gast.extvar
  Gast.mandatoryParam
  GovSteam1.mo
  GovSteam1.extvar
  GovSteam1.mandatoryParam
  GovSteam1_INIT.mo
  GovSteam1_INIT.mandatoryParam
  GovSteamEu.mo
  GovSteamEu.extvar
  GovSteamEu.mandatoryParam
  IEEEG1.mo
  IEEEG1.extvar
  IEEEG1.mandatoryParam
  IEEEG2.mo
  IEEEG2.extvar
  IEEEG2.mandatoryParam
  TGov1.mo
  TGov1.extvar
  TGov1.mandatoryParam
  TGov3.mo
  TGov3.extvar
  TGov3.mandatoryParam
  TGov3_INIT.mo
  TGov3_INIT.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
