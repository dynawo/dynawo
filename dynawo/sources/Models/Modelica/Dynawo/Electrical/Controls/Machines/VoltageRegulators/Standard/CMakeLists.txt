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
  Ac1c_INIT.mo
  BbSex1.mo
  BbSex1.extvar
  Dc1a.mo
  Dc1a.extvar
  Dc1c.mo
  Dc1c.extvar
  ExcIEEEAC1A.mo
  ExcIEEEAC1A.extvar
  ExcIEEEAC1A_INIT.mo
  ExcIEEEST4B.mo
  ExcIEEEST4B.extvar
  ExcIEEEST4B_INIT.mo
  IEEET1.mo
  IEEET1.extvar
  IEEET1_INIT.mo
  IEEEX2.mo
  IEEEX2.extvar
  IEEX2A.mo
  IEEX2A.extvar
  MAXEX2.mo
  MAXEX2.extvar
  MAXEX2_INIT.mo
  Scrx.mo
  Scrx.extvar
  Scrx_INIT.mo
  SCRX1.mo
  SCRX1.extvar
  SCRX1_INIT.mo
  SEXS.mo
  SEXS.extvar
  SEXS_INIT.mo
  St1a.mo
  St1a.extvar
  St1c.mo
  St1c.extvar
  St1c_INIT.mo
  St4b.mo
  St4b.extvar
  St4b_INIT.mo
  St4c.mo
  St4c.extvar
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
