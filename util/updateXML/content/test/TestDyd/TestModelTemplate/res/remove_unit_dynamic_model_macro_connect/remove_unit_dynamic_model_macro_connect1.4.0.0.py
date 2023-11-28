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
   model_templates = jobs.dyds.get_model_templates(
      lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
   )
   for model_template in model_templates:
      unit_dynamic_models = model_template.get_unit_dynamic_models(
         lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
      )
      for unit_dynamic_model in unit_dynamic_models:
         unit_dynamic_model.macro_connects.remove_macro_connect("GEN_VOLTAGE_REGULATOR_CONNECTOR_1")
         unit_dynamic_model.macro_connects.remove_macro_connect("GEN_VOLTAGE_REGULATOR_CONNECTOR_2")
