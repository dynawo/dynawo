# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

# Transformers models

set(MODEL_FILES
  package.mo
  package.order
  TransformerVariableTap.mo
  TransformerVariableTap.extvar
  TransformerVariableTap.mandatoryParam
  TransformerVariableTapXtdPu.mo
  TransformerVariableTapXtdPu.extvar
  TransformerVariableTapPQ_INIT.mo
  TransformerVariableTapPQ_INIT.mandatoryParam
  TransformerVariableTapI_INIT.mo
  TransformerVariableTapI_INIT.mandatoryParam
  IdealTransformerVariableTap.mo
  IdealTransformerVariableTap.extvar
  IdealTransformerVariableTapPQ_INIT.mo
  IdealTransformerVariableTapI_INIT.mo
  TransformerPhaseTapChanger.mo
  TransformerPhaseTapChanger.extvar
  TransformerPhaseTapChanger.mandatoryParam
  TransformerPhaseTapChanger_INIT.mo
  TransformerPhaseTapChanger_INIT.mandatoryParam
  TransformerRatioTapChanger.mo
  TransformerRatioTapChanger.extvar
  TransformerRatioTapChanger.mandatoryParam
  TransformerRatioTapChanger_INIT.mo
  TransformerRatioTapChanger_INIT.mandatoryParam
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
