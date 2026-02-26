# -*- coding: utf-8 -*-

# Copyright (c) 2024, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, a hybrid C++/Modelica open source suite
# of simulation tools for power systems.

import os

test_cases = []
standardReturnCode = [0]
standardReturnCodeType = "ALLOWED"
forbiddenReturnCodeType = "FORBIDDEN"

########################################
#           BaseCase                   #
########################################

case_name = "Network Load"
case_description = "Test the basic behavior of the Network Load"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "BaseCase", "DisconnectLoad.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           VoltageVariation           #
########################################

case_name = "Network Load with voltage variation"
case_description = "Test the basic behavior of the Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "VoltageVariation", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits                     #
########################################

case_name = "Network Load with voltage variation and limit not reached"
case_description = "Test the basic behavior of the Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "Limits", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits2                    #
########################################

case_name = "Network Load with voltage variation and limit not reached with two restorations"
case_description = "Test the basic behavior of the Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "Limits2", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits3                    #
########################################

case_name = "Network Load with voltage variation and limit reached"
case_description = "Test the basic behavior of the Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "Limits3", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits4                    #
########################################

case_name = "Network Load with an increase voltage variation and limit not reached"
case_description = "Test the basic behavior of the Restorative Network Load to an increase voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "CPP", "Limits4", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           BaseCase Modelica          #
########################################

case_name = "Modelica Network Load"
case_description = "Test the basic behavior of the Modelica Network Load"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "BaseCase", "DisconnectLoad.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           FullModelica               #
########################################

case_name = "Base case in full Modelica Network Load"
case_description = "Test the basic behavior of the Modelica Network Load"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "FullModelica", "DisconnectLoad.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           FullModelica2              #
########################################

case_name = "Base case in full Modelica Network Load variant"
case_description = "Second test the basic behavior of the Modelica Network Load variant"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "FullModelica2", "DisconnectLoadFullModelica.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits Modelica            #
########################################

case_name = "Modelica Network Load with voltage variation and limit not reached"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits2 Modelica           #
########################################

case_name = "Modelica Network Load with voltage variation and limit not reached with two restorations"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits2", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits3 Modelica           #
########################################

case_name = "Modelica Network Load with voltage variation and limit reached"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits3", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits3-1 Modelica         #
########################################

case_name = "Modelica Network Load with voltage variation and limit reached variant 1"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to a voltage variation variant 1"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits3-1", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits3-2 Modelica         #
########################################

case_name = "Modelica Network Load with voltage variation and limit reached variant 2"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to a voltage variation variant 2"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits3-2", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           Limits4 Modelica           #
########################################

case_name = "Modelica Network Load with an increase voltage variation and limit not reached"
case_description = "Test the basic behavior of the Modelica Restorative Network Load to an increase voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "Limits4", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           VoltageVariation           #
########################################

case_name = "Modelica Network Load with voltage variation"
case_description = "Test the basic behavior of the Modelica Network Load to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Load", "Modelica", "VoltageVariation", "DisconnectLoad_VoltageVariation.jobs")

test_cases.append((case_name, case_description, job_file, 1, standardReturnCodeType, standardReturnCode))

########################################
#           BaseCase                   #
########################################

case_name = "Network Transformer"
case_description = "Test the basic behavior of the Network Transformer"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "CPP", "BaseCase", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

########################################
#           VoltageVariation           #
########################################

case_name = "Network Transformer with voltage variation"
case_description = "Test the basic behavior of the Network Transformer to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "CPP", "Variation", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

########################################
#           Ratio                      #
########################################

case_name = "Network Transformer with voltage variation and two different voltages"
case_description = "Test the basic behavior of the Network Transformer to a voltage variation and two different voltages"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "CPP", "Ratio", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

########################################
#           BaseCase                   #
########################################

case_name = "Modelica Network Transformer"
case_description = "Test the basic behavior of the Modelica Network Transformer"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "Modelica", "BaseCase", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

########################################
#           VoltageVariation           #
########################################

case_name = "Modelica Network Transformer with voltage variation"
case_description = "Test the basic behavior of the Modelica Network Transformer to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "Modelica", "Variation", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

########################################
#           Ratio                      #
########################################

case_name = "Modelica Network Transformer with voltage variation and two different voltages"
case_description = "Test the basic behavior of the Modelica Network Transformer to a voltage variation and two different voltages"
job_file = os.path.join(os.path.dirname(__file__), "Transformer", "Modelica", "Ratio", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))

############################################
#           Generator                      #
############################################

case_name = "Network alpha beta voltage dependant generator model"
case_description = "Test the basic behavior of the Alpha beta voltage dependant network generator model to a voltage variation"
job_file = os.path.join(os.path.dirname(__file__), "Generator", "CPP", "Test.jobs")

test_cases.append((case_name, case_description, job_file, 3, standardReturnCodeType, standardReturnCode))
