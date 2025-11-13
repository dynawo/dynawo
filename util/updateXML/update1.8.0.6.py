# -*- coding: utf-8 -*-

# Copyright (c) 2025, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite
# of simulation tools for power systems.

from content.Ticket import ticket

# Add new mandatory parameters following upgrade to OpenModelica 1.24.5
@ticket(2292)
def update(jobs):
    for bbm in jobs.dyds.get_bbms(lambda bbm: "Generator" in bbm.get_lib_name()):
        if not bbm.parset.check_if_param_exists("generator_iStart0Pu_im"):
            bbm.parset.add_param("DOUBLE", "generator_iStart0Pu_re", 0.)
            bbm.parset.add_param("DOUBLE", "generator_iStart0Pu_im", 0.)
        if "IEEX2A" in bbm.get_lib_name() and not bbm.parset.check_if_param_exists("voltageRegulator_EfdMinPu"):
            bbm.parset.add_param("DOUBLE", "voltageRegulator_EfdMinPu", 0.)

    for bbm in jobs.dyds.get_modelica_models(lambda _: True):
        for unit in bbm.get_unit_dynamic_models(lambda unit: "Generator" in unit.get_name()):
            if not unit.parset.check_if_param_exists("iStart0Pu_re"):
                unit.parset.add_param("DOUBLE", "iStart0Pu_re", 0.)
                unit.parset.add_param("DOUBLE", "iStart0Pu_im", 0.)

    for model_template_expansions in jobs.dyds.get_model_template_expansions(lambda _: True):
        model_templates = jobs.dyds.get_model_templates(lambda template: template.get_id() == model_template_expansions.get_template_id())
        for model_template in model_templates:
            for unit in model_template.get_unit_dynamic_models(lambda unit: "Generator" in unit.get_name()):
                if not model_template_expansions.parset.check_if_param_exists(unit.get_id() + "_iStart0Pu_im"):
                    model_template_expansions.parset.add_param("DOUBLE", unit.get_id() + "_iStart0Pu_re", 0.)
                    model_template_expansions.parset.add_param("DOUBLE", unit.get_id() + "_iStart0Pu_im", 0.)

    for bbm in jobs.dyds.get_modelica_models(lambda _: True):
        for unit in bbm.get_unit_dynamic_models(lambda unit: "Generator" in unit.get_name()):
            if not unit.parset.check_if_param_exists("generator_iStart0Pu_im"):
                unit.parset.add_param("DOUBLE", "iStart0Pu_re", 0.)
                unit.parset.add_param("DOUBLE", "iStart0Pu_im", 0.)

    for bbm in jobs.dyds.get_bbms(lambda bbm: "PhaseShifter" in bbm.get_lib_name()):
        if not bbm.parset.check_if_param_exists("phaseShifter_running0"):
            bbm.parset.add_param("BOOL", "phaseShifter_running0", True)
        if not bbm.parset.check_if_param_exists("phaseShifter_UNom") and not bbm.parset.check_if_ref_exists("phaseShifter_UNom"):
            bbm.parset.add_param("DOUBLE", "phaseShifter_UNom", 0)

    for bbm in jobs.dyds.get_bbms(lambda bbm: "StaticVarCompensator" in bbm.get_lib_name()):
        if bbm.parset.check_if_param_exists("SVarC_selectModeAuto0"):
            bbm.parset.change_param_or_ref_name("SVarC_selectModeAuto0", "SVarC_SelectModeAuto0")
        elif not bbm.parset.check_if_param_exists("SVarC_SelectModeAuto0"):
            bbm.parset.add_param("BOOL", "SVarC_SelectModeAuto0", True)

    for bbm in jobs.dyds.get_bbms(lambda bbm: "Hvdc" in bbm.get_lib_name() and "Emulation" in bbm.get_lib_name()):
        if not bbm.parset.check_if_param_exists("acemulation_Enabled0"):
            bbm.parset.add_param("BOOL", "acemulation_Enabled0", True)

    for bbm in jobs.dyds.get_bbms(lambda bbm: "TapChangerAutomaton" in bbm.get_lib_name()):
        if not bbm.parset.check_if_param_exists("tapChanger_increaseTapToIncreaseValue"):
            bbm.parset.add_param("BOOL", "tapChanger_increaseTapToIncreaseValue", True)
            bbm.parset.add_param("BOOL", "tapChanger_running0", True)

    for bbm in jobs.dyds.get_bbms(lambda bbm: "DistanceProtection" in bbm.get_lib_name()):
        if not bbm.parset.check_if_param_exists("distance_BlinderAnglePu"):
            bbm.parset.add_param("DOUBLE", "distance_BlinderAnglePu", 0.)
            bbm.parset.add_param("DOUBLE", "distance_BlinderReachPu", 0.)

    for lib_name in ["St4b", "St6b"]:
        for bbm in jobs.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            if not bbm.parset.check_if_param_exists("voltageRegulator_Sw1"):
                bbm.parset.add_param("BOOL", "voltageRegulator_Sw1", True)

    for lib_name in ["Ac7b", "St6b"]:
        for bbm in jobs.dyds.get_bbms(lambda bbm: lib_name in bbm.get_lib_name()):
            if not bbm.parset.check_if_param_exists("voltageRegulator_Ki"):
                bbm.parset.add_param("DOUBLE", "voltageRegulator_Ki", 0.)
                bbm.parset.add_param("DOUBLE", "voltageRegulator_Thetap", 0.)
                bbm.parset.add_param("DOUBLE", "voltageRegulator_XlPu", 0.)
