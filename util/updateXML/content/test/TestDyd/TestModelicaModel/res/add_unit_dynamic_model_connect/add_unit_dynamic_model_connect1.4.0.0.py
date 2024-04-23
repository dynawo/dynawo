# Copyright (c) 2024, RTE (http://www.rte-france.com)
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
    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator")
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.init_connects.add_connect("Efd0PuLF", "generator", "Efd0Pu")
            unit_dynamic_model.init_connects.add_connect("Us0Pu", "generator", "UStator0Pu")
            unit_dynamic_model.connects.add_connect("EfdPu", "generator", "efdPu.value")
            unit_dynamic_model.connects.add_connect("UsPu", "generator", "UStatorPu.value")
