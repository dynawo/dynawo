# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(Common)
add_subdirectory(ModelFrequency)
add_subdirectory(Components/ModelLoadRestorativeWithLimits)
add_subdirectory(Controls/Shunts/ModelCentralizedShuntsSectionControl)
add_subdirectory(Controls/Voltage/ModelVoltageMeasurementsUtilities)
add_subdirectory(Events/ModelVariationArea)
add_subdirectory(Events/ModelVoltageSetPointChange)
add_subdirectory(ModelNetwork)
