//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file JOBModelsDirEntry.h
 * @brief ModelsDir entries description : interface file
 *
 */

#ifndef API_JOB_JOBMODELSDIRENTRY_H_
#define API_JOB_JOBMODELSDIRENTRY_H_

#include "DYNFileSystemUtils.h"

#include <string>
#include <vector>

namespace job {

/**
 * @class ModelsDirEntry
 * @brief ModelsDir entries container class
 */
class ModelsDirEntry {
 public:
  /**
   * @brief constructor
   */
  ModelsDirEntry();

  /**
   * @brief get the extension of model to parse
   * @return extension of model
   */
  const std::string& getModelExtension() const;

  /**
   * @brief get the value of the attribute useStandardModels
   * @return @b true if standard models should be used
   */
  bool getUseStandardModels() const;

  /**
   * @brief get the list of user defined directories
   * @return the list of user defined directories
   */
  std::vector<UserDefinedDirectory> getDirectories() const;

  /**
   * @brief clear the list of user defined directories
   */
  void clearDirectories();

  /**
   * @brief set the extension of model to parse
   * @param modelExtension : the extension of model to parse
   */
  void setModelExtension(const std::string& modelExtension);

  /**
   * @brief set the value of the attribute useStandardModels
   * @param useStandardModels : the value of the attribute useStandardModels
   */
  void setUseStandardModels(const bool useStandardModels);

  /**
   * @brief add directory to the directories list
   * @param directory : the list of user defined directories
   */
  void addDirectory(const UserDefinedDirectory& directory);

 private:
  std::string modelExtension_;              ///< extension of model to used
  bool useStandardModels_;                  ///< @b true if standard models should be used
  std::vector<UserDefinedDirectory> dirs_;  ///< list of user defined directory
};

}  // namespace job

#endif  // API_JOB_JOBMODELSDIRENTRY_H_
