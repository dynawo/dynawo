# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

# Transformers models

set(MODEL_FILES
  package.mo
  package.order
  BaseClasses.mo
  BaseClasses_INIT.mo
  TransformerFixedRatio.mo
  TransformerFixedRatio.extvar
  TransformerVariableTap.mo
  TransformerVariableTap.extvar
  TransformerVariableTapXtdPu.mo
  TransformerVariableTapXtdPu.extvar
  TransformerVariableTapPQ_INIT.mo
  TransformerVariableTapI_INIT.mo
  GeneratorTransformer.mo
  GeneratorTransformer.extvar
  GeneratorTransformer_INIT.mo
  IdealTransformerVariableTap.mo
  IdealTransformerVariableTap.extvar
  IdealTransformerVariableTapPQ_INIT.mo
  IdealTransformerVariableTapI_INIT.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
