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
 * @file  DYNSimulationContext.h
 *
 * @brief Simulation Context header : class to store information about the context of the simulation
 */

#ifndef SIMULATION_DYNSIMULATIONCONTEXT_H_
#define SIMULATION_DYNSIMULATIONCONTEXT_H_

#include <string>

namespace DYN {

/**
 * @brief SimulationContext class
 *
 * SimulationContext class describes the configuration options of the simulation
 */
class SimulationContext {
 public:
  /**
   * @brief set the working directory of the simulation
   * @param directory directory to use for creating output file
   */
  void setWorkingDirectory(const std::string& directory);

  /**
   * @brief set the input directory of the simulation
   * @param directory directory where input files are located
   */
  void setInputDirectory(const std::string& directory);

  /**
   * @brief set the resources directory of the simulation
   * @param directory directory where resources files are located
   */
  void setResourcesDirectory(const std::string& directory);

  /**
   * @brief set the locale of the simulation
   * @param locale locale to use for log messages
   */
  void setLocale(const std::string& locale);

  /**
   * @brief get the working directory of the simulation
   * @return the working directory of the simulation
   */
  const std::string& getWorkingDirectory();

  /**
   * @brief get the input directory of the simulation
   * @return the input directory of the simulation
   */
  const std::string& getInputDirectory();

  /**
   * @brief get the resources directory of the simulation
   * @return the resources directory of the simulation
   */
  const std::string& getResourcesDirectory();

  /**
   * @brief get the locale of the simulation
   * @return locale of the simulation
   */
  const std::string& getLocale();

 private:
  std::string workingDirectory_;  ///< working directory of the simulation : where files should be created
  std::string inputDirectory_;  ///< input directory : where files describing the simulation are located
  std::string resourcesDirectory_;  ///< directory where resources files are located
  std::string locale_;  ///< locale to use for log messages
};

}  // end of namespace DYN

#endif  // SIMULATION_DYNSIMULATIONCONTEXT_H_
