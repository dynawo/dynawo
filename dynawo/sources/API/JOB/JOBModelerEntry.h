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

#include "DYNFileSystemUtils.h"
#include "JOBDynModelsEntry.h"
#include "JOBInitialStateEntry.h"
#include "JOBModelsDirEntry.h"
#include "JOBNetworkEntry.h"

#include <boost/shared_ptr.hpp>
#include <string>
#include <vector>

namespace job {

/**
 * @class ModelerEntry
 * @brief Modeler entries container class
 */
class ModelerEntry {
 public:
  /**
   * @brief Precompiled models directories entry setter
   * @param preCompiledModelsDirEntry : PreCompiledModelsDirEntry for the job
   */
  void setPreCompiledModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& preCompiledModelsDirEntry);

  /**
   * @brief Modelica models directories entry setter
   * @param modelicaModelsDirEntry : ModelicaModelsDirEntry for the job
   */
  void setModelicaModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& modelicaModelsDirEntry);

  /**
   * @brief Precompiled models directories entry getter
   * @return PreCompiledModelsDirEntry for the job
   */
  boost::shared_ptr<ModelsDirEntry> getPreCompiledModelsDirEntry() const;

  /**
   * @brief Modelica models directories entry getter
   * @return ModelicaModelsDirEntry for the job
   */
  boost::shared_ptr<ModelsDirEntry> getModelicaModelsDirEntry() const;

  /**
   * @brief Compiling directory setter
   * @param compileDir : Compiling directory for the job
   */
  void setCompileDir(const std::string& compileDir);

  /**
   * @brief Compiling directory getter
   * @return Compiling directory for the job
   */
  const std::string& getCompileDir() const;

  /**
   * @brief Network entries container setter
   * @param networkEntry : Network entries container for the job
   */
  void setNetworkEntry(const boost::shared_ptr<NetworkEntry>& networkEntry);

  /**
   * @brief Network entries container getter
   * @return Network entries container for the job
   */
  boost::shared_ptr<NetworkEntry> getNetworkEntry() const;

  /**
   * @brief Dynamic modelisation entries container adder
   * @param dynModelsEntry : Dynamic modelisation entries container for the job
   */
  void addDynModelsEntry(const boost::shared_ptr<DynModelsEntry>& dynModelsEntry);

  /**
   * @brief Dynamic modelisation entries container getter
   * @return Dynamic modelisation entries container for the job
   */
  std::vector<boost::shared_ptr<DynModelsEntry> > getDynModelsEntries() const;

  /**
   * @brief Initial state entries container setter
   * @param initialStateEntry : initial state entries container for the job
   */
  void setInitialStateEntry(const boost::shared_ptr<InitialStateEntry>& initialStateEntry);

  /**
   * @brief Initial state entries container getter
   * @return Initial state entries container for the job
   */
  boost::shared_ptr<InitialStateEntry> getInitialStateEntry() const;

  /**
   * @brief Default constructor
   */
  ModelerEntry();

  /**
   * @brief Copy constructor
   * @param other the modeler entry to copy
   */
  ModelerEntry(const ModelerEntry& other);

  /**
   * @brief Copy assignment operator
   * @param other the modeler entry to copy
   * @returns reference to this
   */
  ModelerEntry& operator=(const ModelerEntry& other);

  /// @brief Destructor
  ~ModelerEntry();

 private:
  std::string compileDir_;                                            ///< Compiling directory for the simulation
  boost::shared_ptr<ModelsDirEntry> preCompiledModelsDirEntry_;       ///< preCompiled models directories
  boost::shared_ptr<ModelsDirEntry> modelicaModelsDirEntry_;          ///< modelica models directories
  boost::shared_ptr<NetworkEntry> networkEntry_;                      ///< static network description
  std::vector<boost::shared_ptr<DynModelsEntry> > dynModelsEntries_;  ///< multiple .dyd dynamic modelling files
  boost::shared_ptr<InitialStateEntry> initialStateEntry_;            ///< initial state data
};

}  // namespace job

#endif  // API_JOB_JOBMODELERENTRY_H_
