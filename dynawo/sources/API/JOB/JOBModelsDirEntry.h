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
 * @file JOBModelsDirEntry.h
 * @brief ModelsDir entries description : interface file
 *
 */

#ifndef API_JOB_JOBMODELSDIRENTRY_H_
#define API_JOB_JOBMODELSDIRENTRY_H_

#include <string>
#include <vector>
#include "DYNFileSystemUtils.h"

#include "JOBExport.h"

namespace job {

/**
 * @class ModelsDirEntry
 * @brief ModelsDir entries container class
 */
class __DYNAWO_JOB_EXPORT ModelsDirEntry {
 public:
  /**
   * @brief get the extension of model to parse
   * @return extension of model
   */
  virtual std::string getModelExtension() const = 0;

  /**
   * @brief get the value of the attribute useStandardModels
   * @return @b true if standard models should be used
   */
  virtual bool getUseStandardModels() const = 0;

  /**
   * @brief get the list of user defined directories
   * @return the list of user defined directories
   */
  virtual std::vector<UserDefinedDirectory> getDirectories() const = 0;

  /**
   * @brief clear the list of user defined directories
   */
  virtual void clearDirectories() = 0;

  /**
   * @brief set the extension of model to parse
   * @param modelExtension : the extension of model to parse
   */
  virtual void setModelExtension(const std::string& modelExtension) = 0;

  /**
   * @brief set the value of the attribute useStandardModels
   * @param useStandardModels : the value of the attribute useStandardModels
   */
  virtual void setUseStandardModels(const bool useStandardModels) = 0;

  /**
   * @brief add directory to the directories list
   * @param directory : the list of user defined directories
   */
  virtual void addDirectory(const UserDefinedDirectory& directory) = 0;

  class Impl;  ///< implemented class
};

}  // namespace job

#endif  // API_JOB_JOBMODELSDIRENTRY_H_
