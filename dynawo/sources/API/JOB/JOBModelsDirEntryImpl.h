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
 * @file JOBModelsDirEntryImpl.h
 * @brief ModelsDir entries description : header file
 *
 */

#ifndef API_JOB_JOBMODELSDIRENTRYIMPL_H_
#define API_JOB_JOBMODELSDIRENTRYIMPL_H_

#include <string>
#include "JOBModelsDirEntry.h"

namespace job {

/**
 * @class ModelsDirEntry::Impl
 * @brief ModelsDir entries container class
 */
class ModelsDirEntry::Impl : public ModelsDirEntry {
 public:
  /**
   * @brief constructor
   */
  Impl();

  /**
   * @brief destructor
   */
  virtual ~Impl();

  /**
   * @copydoc ModelsDirEntry::getModelExtension()
   */
  std::string getModelExtension() const;

  /**
   * @copydoc ModelsDirEntry::getUseStandardModels()
   */
  bool getUseStandardModels() const;

  /**
   * @copydoc ModelsDirEntry::getDirectories()
   */
  std::vector<UserDefinedDirectory> getDirectories() const;

  /**
   * @copydoc ModelsDirEntry::clearDirectories()
   */
  void clearDirectories();

  /**
   * @copydoc ModelsDirEntry::setModelExtension()
   */
  void setModelExtension(const std::string& modelExtension);

  /**
   * @copydoc ModelsDirEntry::setUseStandardModels()
   */
  void setUseStandardModels(const bool useStandardModels);

  /**
   * @copydoc ModelsDirEntry::addDirectory()
   */
  void addDirectory(const UserDefinedDirectory& directory);

  /**
   * @copydoc ModelsDirEntry::clone()
   */
  boost::shared_ptr<ModelsDirEntry> clone() const;

 private:
  std::string modelExtension_;  ///< extension of model to used
  bool useStandardModels_;  ///< @b true if standard models should be used
  std::vector<UserDefinedDirectory> dirs_;  ///< list of user defined directory
};

}  // namespace job

#endif  // API_JOB_JOBMODELSDIRENTRYIMPL_H_
