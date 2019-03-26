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
 * @file JOBModelerEntry.h
 * @brief Modeler entries description : interface file
 *
 */

#ifndef API_JOB_JOBMODELERENTRY_H_
#define API_JOB_JOBMODELERENTRY_H_

#include <string>
#include <boost/shared_ptr.hpp>

#include "JOBExport.h"
#include "DYNFileSystemUtils.h"

namespace job {
class NetworkEntry;
class DynModelsEntry;
class InitialStateEntry;
class ModelsDirEntry;

/**
 * @class ModelerEntry
 * @brief Modeler entries container class
 */
class __DYNAWO_JOB_EXPORT ModelerEntry {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ModelerEntry() {}

  /**
   * @brief Precompiled models directories entry setter
   * @param preCompiledModelsDirEntry : PreCompiledModelsDirEntry for the job
   */
  virtual void setPreCompiledModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& preCompiledModelsDirEntry) = 0;

  /**
   * @brief Modelica models directories entry setter
   * @param modelicaModelsDirEntry : ModelicaModelsDirEntry for the job
   */
  virtual void setModelicaModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& modelicaModelsDirEntry) = 0;

  /**
   * @brief Precompiled models directories entry getter
   * @return PreCompiledModelsDirEntry for the job
   */
  virtual boost::shared_ptr<ModelsDirEntry> getPreCompiledModelsDirEntry() const = 0;

  /**
   * @brief Modelica models directories entry getter
   * @return ModelicaModelsDirEntry for the job
   */
  virtual boost::shared_ptr<ModelsDirEntry> getModelicaModelsDirEntry() const = 0;

  /**
   * @brief Compiling directory setter
   * @param compileDir : Compiling directory for the job
   */
  virtual void setCompileDir(const std::string& compileDir)  = 0;

  /**
   * @brief Compiling directory getter
   * @return Compiling directory for the job
   */
  virtual std::string getCompileDir() const = 0;

  /**
   * @brief Network entries container setter
   * @param networkEntry : Network entries container for the job
   */
  virtual void setNetworkEntry(const boost::shared_ptr<NetworkEntry>& networkEntry) = 0;

  /**
   * @brief Network entries container getter
   * @return Network entries container for the job
   */
  virtual boost::shared_ptr<NetworkEntry> getNetworkEntry() const = 0;

  /**
   * @brief Dynamic modelisation entries container adder
   * @param dynModelsEntry : Dynamic modelisation entries container for the job
   */
  virtual void addDynModelsEntry(const boost::shared_ptr<DynModelsEntry>& dynModelsEntry) = 0;

  /**
   * @brief Dynamic modelisation entries container getter
   * @return Dynamic modelisation entries container for the job
   */
  virtual std::vector<boost::shared_ptr<DynModelsEntry> > getDynModelsEntries() const = 0;

  /**
   * @brief Initial state entries container setter
   * @param initialStateEntry : initial state entries container for the job
   */
  virtual void setInitialStateEntry(const boost::shared_ptr<InitialStateEntry>& initialStateEntry) = 0;

  /**
   * @brief Initial state entries container getter
   * @return Initial state entries container for the job
   */
  virtual boost::shared_ptr<InitialStateEntry> getInitialStateEntry() const = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBMODELERENTRY_H_
