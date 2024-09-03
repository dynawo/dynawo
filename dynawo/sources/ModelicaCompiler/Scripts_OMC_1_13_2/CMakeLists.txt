# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# PYTHON scripts for OMC backend
set(PYTHON_SCRIPTS_OMC
  dataContainer.py
  factory.py
  headerPatternDefine.py
  modelicaScriptsExceptions.py
  modelWriter.py
  readerOMC.py
  scriptVarExt.py
  scriptVerifyModelList.py
  utils.py
  writeModel.py
  )
install(PROGRAMS ${PYTHON_SCRIPTS_OMC} DESTINATION ${SBINDIR_NAME})
