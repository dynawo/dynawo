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
 * @file JOBJobEntry.h
 * @brief Job entries description : interface file
 * A job contains all the needed informations and data to define a
 * simulation task for Dynawo.
 */

#ifndef API_JOB_JOBJOBENTRY_H_
#define API_JOB_JOBJOBENTRY_H_

#include "JOBModelerEntry.h"
#include "JOBOutputsEntry.h"
#include "JOBSimulationEntry.h"
#include "JOBSolverEntry.h"
#include "JOBLocalInitEntry.h"

#include <boost/shared_ptr.hpp>
#include <string>

namespace job {

/**
 * @class JobEntry
 * @brief Job entries container class
 */
class JobEntry {
 public:
  /**
   * @brief Modeler entries container setter
   * @param modelerEntry : Modeler entries container for the job
   */
  void setModelerEntry(const boost::shared_ptr<ModelerEntry>& modelerEntry);

  /**
   * @brief Modeler entries container getter
   * @return Modeler entries container for the job
   */
  boost::shared_ptr<ModelerEntry> getModelerEntry() const;

  /**
   * @brief Solver entries container setter
   * @param solverEntry : Solver entries container for the job
   */
  void setSolverEntry(const boost::shared_ptr<SolverEntry>& solverEntry);

  /**
   * @brief Solver entries container getter
   * @return Solver entries container for the job
   */
  boost::shared_ptr<SolverEntry> getSolverEntry() const;

  /**
   * @brief Simulation entries container setter
   * @param simulationEntry : Simulation entries container for the job
   */
  void setSimulationEntry(const boost::shared_ptr<SimulationEntry>& simulationEntry);

  /**
   * @brief Simulation entries container getter
   * @return the simulation entry container
   */
  boost::shared_ptr<SimulationEntry> getSimulationEntry() const;

  /**
   * @brief Outputs entries container setter
   * @param outputsEntry : outputs entries container for the job
   */
  void setOutputsEntry(const boost::shared_ptr<OutputsEntry>& outputsEntry);

  /**
   * @brief Outputs entries container getter
   * @return the outputs entry container
   */
  boost::shared_ptr<OutputsEntry> getOutputsEntry() const;

  /**
   * @brief Local init entries container setter
   * @param localInitEntry : Local init entries container for the job
   */
  void setLocalInitEntry(const boost::shared_ptr<LocalInitEntry> & localInitEntry);

  /**
   * @brief Local init entries container getter
   * @return Local init entries container for the job
   */
  boost::shared_ptr<LocalInitEntry> getLocalInitEntry() const;

  /**
   * @brief Name setter
   * @param name : Name of the job
   */
  void setName(const std::string& name);

  /**
   * @brief Name getter
   * @return Name of the job
   */
  const std::string& getName() const;

  /**
   * @brief Default constructor
   */
  JobEntry();

  /// @brief Destructor
  ~JobEntry();

  /**
   * @brief Copy assignment operator
   * @param other the job entry to copy
   * @returns reference to this
   */
  JobEntry& operator=(const JobEntry& other);

  /**
   * @brief Copy constructor
   * @param other the job entry to copy
   */
  JobEntry(const JobEntry& other);

 private:
  boost::shared_ptr<ModelerEntry> modelerEntry_;        ///< Modeler entries container
  boost::shared_ptr<SolverEntry> solverEntry_;          ///< Solver entries container
  boost::shared_ptr<SimulationEntry> simulationEntry_;  ///< Simulation entries container
  boost::shared_ptr<OutputsEntry> outputsEntry_;        ///< Outputs entries container
  boost::shared_ptr<LocalInitEntry> localInitEntry_;    ///< Local init entries container
  std::string name_;                                    ///< Name of the job used for description and logs purpose
};

}  // namespace job

#endif  // API_JOB_JOBJOBENTRY_H_
