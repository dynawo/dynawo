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
 * @file JOBJobEntryImpl.h
 * @brief Job entries description : header file
 *
 */

#ifndef API_JOB_JOBJOBENTRYIMPL_H_
#define API_JOB_JOBJOBENTRYIMPL_H_

#include <string>
#include "JOBJobEntry.h"

namespace job {

/**
 * @class JobEntry::Impl
 * @brief JobEntry implemented class
 */
class JobEntry::Impl : public JobEntry {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  virtual ~Impl();

  /**
   * @copydoc JobEntry::setModelerEntry()
   */
  void setModelerEntry(const boost::shared_ptr<ModelerEntry> & modelerEntry);

  /**
   * @copydoc JobEntry::getModelerEntry()
   */
  boost::shared_ptr<ModelerEntry> getModelerEntry() const;

  /**
   * @copydoc JobEntry::setSolverEntry()
   */
  void setSolverEntry(const boost::shared_ptr<SolverEntry> & solverEntry);

  /**
   * @copydoc JobEntry::getSolverEntry()
   */
  boost::shared_ptr<SolverEntry> getSolverEntry() const;

  /**
   * @copydoc JobEntry::setSimulationEntry()
   */
  void setSimulationEntry(const boost::shared_ptr<SimulationEntry> & simulationEntry);

  /**
   * @copydoc JobEntry::getSimulationEntry()
   */
  boost::shared_ptr<SimulationEntry> getSimulationEntry() const;

  /**
   * @copydoc JobEntry::setOutputsEntry()
   */
  void setOutputsEntry(const boost::shared_ptr<OutputsEntry> & outputsEntry);

  /**
   * @copydoc JobEntry::getOutputsEntry()
   */
  boost::shared_ptr<OutputsEntry> getOutputsEntry() const;

  /**
   * @copydoc JobEntry::setLineariseEntry()
   */

  void setLineariseEntry(const boost::shared_ptr<LineariseEntry> & lineariseEntry);

  /**
   * @copydoc JobEntry::getLineariseEntry()
   */
  boost::shared_ptr<LineariseEntry> getLineariseEntry() const;

  /**
   * @copydoc JobEntry::setName()
   */
  void setName(const std::string & name);

  /**
   * @copydoc JobEntry::getName()
   */
  std::string getName() const;

 private:
  boost::shared_ptr<ModelerEntry> modelerEntry_;  ///< Modeler entries container
  boost::shared_ptr<SolverEntry> solverEntry_;  ///< Solver entries container
  boost::shared_ptr<SimulationEntry> simulationEntry_;  ///< Simulation entries container
  boost::shared_ptr<OutputsEntry> outputsEntry_;  ///< Outputs entries container
  boost::shared_ptr<LineariseEntry> lineariseEntry_;  ///< Linearise entries container
  std::string name_;  ///< Name of the job used for description and logs purpose
};

}  // namespace job

#endif  // API_JOB_JOBJOBENTRYIMPL_H_
