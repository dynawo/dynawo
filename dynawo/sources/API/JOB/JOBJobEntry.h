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

#include <string>
#include <boost/shared_ptr.hpp>

#include "JOBExport.h"

namespace job {
class ModelerEntry;
class SolverEntry;
class SimulationEntry;
class OutputsEntry;


/**
 * @class JobEntry
 * @brief Job entries container class
 */
class __DYNAWO_JOB_EXPORT JobEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~JobEntry() {}

  /**
   * @brief Modeler entries container setter
   * @param modelerEntry : Modeler entries container for the job
   */
  virtual void setModelerEntry(const boost::shared_ptr<ModelerEntry> & modelerEntry) = 0;

  /**
   * @brief Modeler entries container getter
   * @return Modeler entries container for the job
   */
  virtual boost::shared_ptr<ModelerEntry> getModelerEntry() const = 0;

  /**
   * @brief Solver entries container setter
   * @param solverEntry : Solver entries container for the job
   */
  virtual void setSolverEntry(const boost::shared_ptr<SolverEntry> & solverEntry) = 0;

  /**
   * @brief Solver entries container getter
   * @return Solver entries container for the job
   */
  virtual boost::shared_ptr<SolverEntry> getSolverEntry() const = 0;

  /**
   * @brief Simulation entries container setter
   * @param simulationEntry : Simulation entries container for the job
   */
  virtual void setSimulationEntry(const boost::shared_ptr<SimulationEntry> & simulationEntry) = 0;

  /**
   * @brief Simulation entries container getter
   * @return the simulation entry container
   */
  virtual boost::shared_ptr<SimulationEntry> getSimulationEntry() const = 0;

  /**
   * @brief Outputs entries container setter
   * @param outputsEntry : outputs entries container for the job
   */
  virtual void setOutputsEntry(const boost::shared_ptr<OutputsEntry> & outputsEntry) = 0;

  /**
   * @brief Outputs entries container getter
   * @return the outputs entry container
   */
  virtual boost::shared_ptr<OutputsEntry> getOutputsEntry() const = 0;

  /**
   * @brief Name setter
   * @param name : Name of the job
   */
  virtual void setName(const std::string & name) = 0;

  /**
   * @brief Name getter
   * @return Name of the job
   */
  virtual std::string getName() const = 0;

  class Impl;  ///< Implemented class
};

}  // namespace job

#endif  // API_JOB_JOBJOBENTRY_H_
