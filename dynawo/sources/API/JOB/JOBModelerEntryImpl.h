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
 * @file JOBModelerEntryImpl.h
 * @brief Appender entries description : header file
 *
 */

#ifndef API_JOB_JOBMODELERENTRYIMPL_H_
#define API_JOB_JOBMODELERENTRYIMPL_H_

#include <string>
#include <vector>

#include "JOBModelerEntry.h"

namespace job {

/**
 * @class ModelerEntry::Impl
 * @brief ModelerEntry implemented class
 */
class ModelerEntry::Impl : public ModelerEntry {
 public:
  /**
   * @brief Default constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc ModelerEntry::setPreCompiledModelsDirEntry()
   */
  void setPreCompiledModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& preCompiledModelsDirEntry);

  /**
   * @copydoc ModelerEntry::setModelicaModelsDirEntry()
   */
  void setModelicaModelsDirEntry(const boost::shared_ptr<ModelsDirEntry>& modelicaModelsDirEntry);

  /**
   * @copydoc ModelerEntry::getPreCompiledModelsDirEntry()
   */
  boost::shared_ptr<ModelsDirEntry> getPreCompiledModelsDirEntry() const;

  /**
   * @copydoc ModelerEntry::getModelicaModelsDirEntry()
   */
  boost::shared_ptr<ModelsDirEntry> getModelicaModelsDirEntry() const;

  /**
   * @copydoc ModelerEntry::setCompileDir()
   */
  void setCompileDir(const std::string& compileDir);

  /**
   * @copydoc ModelerEntry::getCompileDir()
   */
  std::string getCompileDir() const;

  /**
   * @copydoc ModelerEntry::setNetworkEntry()
   */
  void setNetworkEntry(const boost::shared_ptr<NetworkEntry>& networkEntry);

  /**
   * @copydoc ModelerEntry::getNetworkEntry()
   */
  boost::shared_ptr<NetworkEntry> getNetworkEntry() const;

  /**
   * @copydoc ModelerEntry::addDynModelsEntry()
   */
  void addDynModelsEntry(const boost::shared_ptr<DynModelsEntry>& dynModelsEntry);

  /**
   * @copydoc ModelerEntry::getDynModelsEntries()
   */
  std::vector<boost::shared_ptr<DynModelsEntry> > getDynModelsEntries() const;

  /**
   * @copydoc ModelerEntry::setInitialStateEntry()
   */
  void setInitialStateEntry(const boost::shared_ptr<InitialStateEntry>& initialStateEntry);

  /**
   * @copydoc ModelerEntry::getInitialStateEntry()
   */
  boost::shared_ptr<InitialStateEntry> getInitialStateEntry() const;

  /**
   * @copydoc ModelerEntry::clone()
   */
  boost::shared_ptr<ModelerEntry> clone() const;

 private:
  std::string compileDir_;  ///< Compiling directory for the simulation
  boost::shared_ptr<ModelsDirEntry> preCompiledModelsDirEntry_;  ///< preCompiled models directories
  boost::shared_ptr<ModelsDirEntry> modelicaModelsDirEntry_;  ///< modelica models directories
  boost::shared_ptr<NetworkEntry> networkEntry_;  ///< static network description
  std::vector<boost::shared_ptr<DynModelsEntry> > dynModelsEntries_;  ///< multiple .dyd dynamic modelling files
  boost::shared_ptr<InitialStateEntry> initialStateEntry_;  ///< initial state data
};

}  // namespace job

#endif  // API_JOB_JOBMODELERENTRYIMPL_H_
