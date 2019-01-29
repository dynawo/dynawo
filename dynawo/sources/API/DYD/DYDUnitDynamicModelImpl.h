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
 * @file DYDUnitDynamicModelImpl.h
 * @brief Modelica dynamic models description : header file
 *
 */

#ifndef API_DYD_DYDUNITDYNAMICMODELIMPL_H_
#define API_DYD_DYDUNITDYNAMICMODELIMPL_H_

#include "DYDUnitDynamicModel.h"

namespace dynamicdata {

/**
 * @class UnitDynamicModel::Impl
 * @brief Modelica dynamic model implemented class
 *
 * Implementation of UnitDynamicModel interface.
 */
class UnitDynamicModel::Impl : public UnitDynamicModel {
 public:
  /**
   * @brief UnitDynamicModel constructor
   *
   * UnitDynamicModel constructor.
   *
   * @param id Dynamic model ID
   * @param name name of the model
   *
   * @returns New UnitDynamicModel::Impl instance with given attributes
   */
  Impl(const std::string& id, const std::string& name);

  /**
   * @brief UnitDynamicModel destructor
   */
  ~Impl();

  /**
   * @copydoc UnitDynamicModel::getId()
   */
  std::string getId() const;

  /**
   * @copydoc UnitDynamicModel::getParFile()
   */
  std::string getParFile() const;

  /**
   * @copydoc UnitDynamicModel::getParId()
   */
  std::string getParId() const;

  /**
   * @copydoc UnitDynamicModel::getDynamicModelName()
   */
  std::string getDynamicModelName() const;

  /**
   * @copydoc UnitDynamicModel::getDynamicFileName()
   */
  std::string getDynamicFileName() const;

  /**
   * @copydoc UnitDynamicModel::getInitModelName()
   */
  std::string getInitModelName() const;

  /**
   * @copydoc UnitDynamicModel::getInitFileName()
   */
  std::string getInitFileName() const;

  /**
   * @copydoc UnitDynamicModel::setParFile()
   */
  UnitDynamicModel& setParFile(const std::string& parFile);

  /**
   * @copydoc UnitDynamicModel::setParId()
   */
  UnitDynamicModel& setParId(const std::string& parId);

  /**
   * @copydoc UnitDynamicModel::setDynamicFileName()
   */
  UnitDynamicModel& setDynamicFileName(const std::string& path);

  /**
   * @copydoc UnitDynamicModel::setInitModelName()
   */
  UnitDynamicModel& setInitModelName(const std::string& name);

  /**
   * @copydoc UnitDynamicModel::setInitFileName()
   */
  UnitDynamicModel& setInitFileName(const std::string& path);

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  std::string id_;  ///< Unit dynamic model id;
  std::string parFile_;  ///< name of the parameter file
  std::string parId_;  ///< id of the set of parameter for the unit dynamic model
  std::string dynamicModelName_;  ///< Name of the model's Modelica dynamic class
  std::string dynamicFileName_;  ///< Name of the model's Modelica dynamic file
  std::string initModelName_;  ///< Name of the model's Modelica init class
  std::string initFileName_;  ///< Name of the model's Modelica init file
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDUNITDYNAMICMODELIMPL_H_
