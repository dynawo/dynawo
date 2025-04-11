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

# add former default parameter values to .par
@ticket(3636)
def update(job):
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Pss2") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmega", 1)
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmegaRef", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Pss3") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmega", 1)
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmegaRef", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Pss6c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmega", 1)
        gen.parset.add_param("DOUBLE", "powerSystemStabilizer_KOmegaRef", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac1a") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac1c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac6a") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac6c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac7b") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac7c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Ac8c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Dc1a") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("Dc1c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St1a") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St1c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St4b") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St4c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St5b") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St5c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St6b") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St6c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St7b") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St7c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)

    gens = job.dyds.get_bbms(lambda bbm: bbm.get_lib_name().find("St9c") >= 0)
    for gen in gens:
        gen.parset.add_param("DOUBLE", "voltageRegulator_UOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclOel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_USclUel0Pu", 0)
        gen.parset.add_param("DOUBLE", "voltageRegulator_UUel0Pu", 0)
