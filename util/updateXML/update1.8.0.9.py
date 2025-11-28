# -*- coding: utf-8 -*-

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

from content.Ticket import ticket

# initConnect : LoadAuxiliaries_INIT (P0Pu -> P0PuVar, Q0Pu -> Q0PuVar), BaseGeneratorParameters_INIT (U0Pu -> U0PuVar)
@ticket(3895)
def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_init_name() == "Dynawo.Electrical.Loads.LoadAuxiliaries_INIT")
    for modelica_model in modelica_models:
        modelica_model.init_connects.change_var_name("P0Pu", "P0PuVar")
        modelica_model.init_connects.change_var_name("Q0Pu", "Q0PuVar")

    init_models_OmegaRef = ["GeneratorPQ", "GeneratorPV", "GeneratorSynchronousExt3W", "GeneratorSynchronousExt4W", "GeneratorSynchronousInt"]
    init_models_SignalN = ["GeneratorPQPropDiagramPQSFR", "GeneratorPQPropDiagramPQ", "GeneratorPVDiagramPQSFR", "GeneratorPVDiagramPQ", \
    "GeneratorPVQNomAltParDiagram", "GeneratorPVRemoteDiagramPQSFR", "GeneratorPVRemoteDiagramPQ", "GeneratorPVTfoDiagramPQ", \
    "GeneratorPQPropSFR", "GeneratorPQProp", "GeneratorPVPropSFR", "GeneratorPVProp", "GeneratorPVQNomAltPar", "GeneratorPVRemoteSFR", \
    "GeneratorPVRemote", "GeneratorPVSFR", "GeneratorPVTfo"]
    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: \
    modelica_model.get_init_name().replace("Dynawo.Electrical.Machines.OmegaRef.", "").replace("_INIT", "") in init_models_OmegaRef or \
    modelica_model.get_init_name().replace("Dynawo.Electrical.Machines.SignalN.", "").replace("_INIT", "") in init_models_SignalN or \
    modelica_model.get_init_name() == "Dynawo.Electrical.Machines.Simplified.GeneratorSimplified_INIT")
    for modelica_model in modelica_models:
        modelica_model.init_connects.change_var_name("U0Pu", "U0PuVar")
