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
add_subdirectory(BaseClasses_INIT BI)

set(MODEL_FILES
  package.mo
  package.order
  Ac168_INIT.mo
  Ac168_INIT.mandatoryParam
  Ac1a.mo
  Ac1a.extvar
  Ac1a.mandatoryParam
  Ac1a_INIT.mo
  Ac1a_INIT.mandatoryParam
  Ac1c.mo
  Ac1c.extvar
  Ac1c.mandatoryParam
  Ac6a.mo
  Ac6a.extvar
  Ac6a.mandatoryParam
  Ac6c.mo
  Ac6c.extvar
  Ac7b.mo
  Ac7b.extvar
  Ac7b.mandatoryParam
  Ac7b_INIT.mo
  Ac7b_INIT.mandatoryParam
  Ac7c.mo
  Ac7c.extvar
  Ac7c.mandatoryParam
  Ac78c_INIT.mo
  Ac78c_INIT.mandatoryParam
  Ac8b.mo
  Ac8b.extvar
  Ac8b.mandatoryParam
  Ac8c.mo
  Ac8c.extvar
  BbSex1.mo
  BbSex1.extvar
  BbSex1.mandatoryParam
  Dc1a.mo
  Dc1a.extvar
  Dc1a.mandatoryParam
  Dc1c.mo
  Dc1c.extvar
  ExAc1.mo
  ExAc1.extvar
  ExAc1.mandatoryParam
  ExAc1_INIT.mo
  IEEET1.mo
  IEEET1.extvar
  IEEET1.mandatoryParam
  IEEEX2.mo
  IEEEX2.extvar
  IEEEX2.mandatoryParam
  IEEX2A.mo
  IEEX2A.extvar
  IEEX2A.mandatoryParam
  MAXEX2.mo
  MAXEX2.extvar
  MAXEX2.mandatoryParam
  MAXEX2_INIT.mo
  SCRX.mo
  SCRX.extvar
  SCRX.mandatoryParam
  SCRX_INIT.mo
  SEXS.mo
  SEXS.extvar
  SEXS.mandatoryParam
  St1a.mo
  St1a.extvar
  St1a.mandatoryParam
  St1c.mo
  St1c.extvar
  St15c_INIT.mo
  St4b.mo
  St4b.extvar
  St4b.mandatoryParam
  St4b_INIT.mo
  St4b_INIT.mandatoryParam
  St4c.mo
  St4c.extvar
  St5b.mo
  St5b.extvar
  St5b.mandatoryParam
  St5c.mo
  St5c.extvar
  St5c.mandatoryParam
  St6b.mo
  St6b.extvar
  St6b.mandatoryParam
  St6b_INIT.mo
  St6b_INIT.mandatoryParam
  St6c.mo
  St6c.extvar
  St6c.mandatoryParam
  St7b.mo
  St7b.extvar
  St7b.mandatoryParam
  St7c.mo
  St7c.extvar
  St7c_INIT.mo
  St7c_INIT.mandatoryParam
  St9c.mo
  St9c.extvar
  St9c.mandatoryParam
  Stxc_INIT.mo
  Stxc_INIT.mandatoryParam
  VRKundur.mo
  VRKundur.extvar
  VRKundur.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
