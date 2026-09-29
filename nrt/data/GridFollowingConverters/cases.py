# -*- coding: utf-8 -*-

# Copyright (c) 2026, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source suite of
# simulation tool for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

##############################################################
#       Grid Following Converters - FourVSC - DynPlantQCtrl  #
##############################################################

case_name = "Grid Following Converters - FourVSC - DynPlantQCtrl"
case_description = "Grid Following Converters - FourVSC - DynPlantQCtrl"
job_file = os.path.join(os.path.dirname(__file__),"FourVSC", "FourVSCStaticLinesPlant", "4VSC_OP1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################################
#       Grid Following Converters - FourVSC - DynConvUCtrl   #
##############################################################

case_name = "Grid Following Converters - FourVSC - DynConvUCtrl"
case_description = "Grid Following Converters - FourVSC - DynConvUCtrl"
job_file = os.path.join(os.path.dirname(__file__),"FourVSC", "FourVSCStaticLinesConv", "4VSC_OP1.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################################
#       Grid Following Converters - SMIB - DynGFLConvQ       #
##############################################################

case_name = "Grid Following Converters - SMIB - DynGFLConvQ"
case_description = "Grid Following Converters - SMIB - DynGFLConvQ"
job_file = os.path.join(os.path.dirname(__file__),"SMIB", "DynGFLConvQ", "GFLAverageModel.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##################################################################
#       Grid Following Converters - SMIB - DynGFLConvQBandWidth  #
##################################################################

case_name = "Grid Following Converters - SMIB - DynGFLConvQBandWidth"
case_description = "Grid Following Converters - SMIB - DynGFLConvQBandWidth"
job_file = os.path.join(os.path.dirname(__file__),"SMIB", "DynGFLConvQBandWidth", "GFLAverageModel.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################################
#       Grid Following Converters - SMIB - DynGFLConvU       #
##############################################################

case_name = "Grid Following Converters - SMIB - DynGFLConvU"
case_description = "Grid Following Converters - SMIB - DynGFLConvU"
job_file = os.path.join(os.path.dirname(__file__),"SMIB", "DynGFLConvU", "GFLAverageModel.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

##############################################################
#       Grid Following Converters - SMIB - DynGFLPlantQ      #
##############################################################

case_name = "Grid Following Converters - SMIB - DynGFLPlantQ"
case_description = "Grid Following Converters - SMIB - DynGFLPlantQ"
job_file = os.path.join(os.path.dirname(__file__),"SMIB", "DynGFLPlantQ", "GFLAverageModel.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###################################################################
#       Grid Following Converters - SMIB - DynGFLPlantQBandWidth  #
###################################################################

case_name = "Grid Following Converters - SMIB - DynGFLPlantQBandWidth"
case_description = "Grid Following Converters - SMIB - DynGFLPlantQBandWidth"
job_file = os.path.join(os.path.dirname(__file__),"SMIB", "DynGFLPlantQBandWidth", "GFLAverageModel.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

###################################################################
#       Grid Following Converters - Two Converters - StaticLine   #
###################################################################

case_name = "Grid Following Converters - Two Converters - StaticLine"
case_description = "Grid Following Converters - Two Converters - StaticLine"
job_file = os.path.join(os.path.dirname(__file__),"TwoConverters", "TwoConvertersStaticLine", "fic.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

#######################################################################
#       Grid Following Converters - Two Converters - StaticLine 7Hz   #
#######################################################################

case_name = "Grid Following Converters - Two Converters - StaticLine 7Hz"
case_description = "Grid Following Converters - Two Converters - StaticLine 7Hz"
job_file = os.path.join(os.path.dirname(__file__),"TwoConverters", "TwoConvertersStaticLine7Hz", "fic.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))
