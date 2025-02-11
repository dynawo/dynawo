//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNSimulationLauncher.h
 *
 * @brief function to launch a Dynawo simulation
 *
 */

#ifndef SIMULATION_DYNSIMULATIONLAUNCHER_H_
#define SIMULATION_DYNSIMULATIONLAUNCHER_H_

#include <string>

/**
 * @brief launch a simulation thanks to a description contains in jobsFileName
 *
 *
 * @param jobsFileName file describing the job(s) to launch
 */
void launchSimu(const std::string& jobsFileName);

/**
 * @brief launch an interactive simulation thanks to a description contains in jobsFileName
 *
 *
 * @param jobsFileName file describing the job(s) to launch
 */
void launchSimuInteractive(const std::string& jobsFileName);


#endif  // SIMULATION_DYNSIMULATIONLAUNCHER_H_
