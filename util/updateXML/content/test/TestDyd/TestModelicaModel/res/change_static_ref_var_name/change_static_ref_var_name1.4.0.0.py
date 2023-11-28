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


def update(jobs):
   gens = jobs.dyds.get_modelica_models(
      lambda modelica_model: modelica_model.get_id() in ["GEN____1_SM",
                                                         "GEN____2_SM",
                                                         "GEN____3_SM",
                                                         "GEN____4_SM",
                                                         "GEN____5_SM"]
   )
   for gen in gens:
      gen.static_refs.change_var_name("generator_PGenPu", "generator_PGenPu_NAME_CHANGED")
      gen.static_refs.change_var_name("generator_QGenPu", "generator_QGenPu_NAME_CHANGED")
