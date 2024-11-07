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
  Ac1a.mo
  Ac1a.extvar
  Ac1a_INIT.mo
  Ac1c.mo
  Ac1c.extvar
  Ac16c_INIT.mo
  Ac6a.mo
  Ac6a.extvar
  Ac6c.mo
  Ac6c.extvar
  Ac7b.mo
  Ac7b.extvar
  Ac7b_INIT.mo
  Ac7c.mo
  Ac7c.extvar
  Ac78c_INIT.mo
  Ac8b.mo
  Ac8b.extvar
  Ac8b_INIT.mo
  Ac8c.mo
  Ac8c.extvar
  BbSex1.mo
  BbSex1.extvar
  Dc1a.mo
  Dc1a.extvar
  Dc1c.mo
  Dc1c.extvar
  ExAc1.mo
  ExAc1.extvar
  ExAc1_INIT.mo
  IEEET1.mo
  IEEET1.extvar
  IEEEX2.mo
  IEEEX2.extvar
  IEEX2A.mo
  IEEX2A.extvar
  MAXEX2.mo
  MAXEX2.extvar
  MAXEX2_INIT.mo
  SCRX.mo
  SCRX.extvar
  SCRX_INIT.mo
  SEXS.mo
  SEXS.extvar
  St1a.mo
  St1a.extvar
  St1c.mo
  St1c.extvar
  St15c_INIT.mo
  St4b.mo
  St4b.extvar
  St4b_INIT.mo
  St4c.mo
  St4c.extvar
  St5b.mo
  St5b.extvar
  St5c.mo
  St5c.extvar
  St6b.mo
  St6b.extvar
  St6b_INIT.mo
  St6c.mo
  St6c.extvar
  St7b.mo
  St7b.extvar
  St7c.mo
  St7c.extvar
  St7c_INIT.mo
  St9c.mo
  St9c.extvar
  Stxc_INIT.mo
  VRKundur.mo
  VRKundur.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
