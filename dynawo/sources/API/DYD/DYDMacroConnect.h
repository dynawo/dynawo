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
 * @file DYDMacroConnect.h
 * @brief Dynawo macro connect description : interface file
 *
 */

#ifndef API_DYD_DYDMACROCONNECT_H_
#define API_DYD_DYDMACROCONNECT_H_

#include <string>

namespace dynamicdata {

/**
 * @class MacroConnect
 * @brief Dynawo MacroConnect interface class
 *
 */
class MacroConnect {
 public:
  /**
   * @brief MacroConnect::Impl constructor
   *
   * MacroConnect::Impl constructor.
   *
   * @param connector id of the connector
   * @param model1  id of the first model
   * @param model2  id of the second model
   */
  MacroConnect(const std::string & connector, const std::string & model1, const std::string & model2);

  /**
   * @brief First model getter
   *
   * @return First model id
   */
  const std::string& getFirstModelId() const;

  /**
   * @brief Second model getter
   *
   * @return Second model id
   */
  const std::string& getSecondModelId() const;

  /**
   * @brief Connector id getter
   *
   * @return id of the connector
   */
  const std::string& getConnector() const;

  /**
   * @brief set the index of the first model
   * @param index1 index of the first model to replace \@INDEX\@
   */
  void setIndex1(const std::string& index1);

  /**
   * @brief set the index of the second model
   * @param index2 index of the second model to replace \@INDEX\@
   */
  void setIndex2(const std::string& index2);

  /**
   * @brief set the name of the first model
   * @param name1 name of the first model to replace \@NAME\@
   */
  void setName1(const std::string& name1);

  /**
   * @brief set the name of the second model
   * @param name2 name of the second model to replace \@NAME\@
   */
  void setName2(const std::string& name2);

  /**
   * @brief get the index of the first model
   * @return index of the first model to replace \@INDEX\@
   */
  const std::string& getIndex1() const;

  /**
   * @brief get the index of the second model
   * @return index of the second model to replace \@INDEX\@
   */
  const std::string& getIndex2() const;

  /**
   * @brief get the name of the first model
   * @return name of the first model to replace \@NAME\@
   */
  const std::string& getName1() const;

  /**
   * @brief get the name of the second model
   * @return name of the second model to replace \@NAME\@
   */
  const std::string& getName2() const;

 private:
  std::string connectorId_;    ///< id of the connector
  std::string firstModelId_;   ///< Model name for the first Model
  std::string secondModelId_;  ///< Model name for the second Model
  std::string index1_;         ///< index of the first model to replace \@INDEX\@
  std::string index2_;         ///< index of the second model to replace \@INDEX\@
  std::string name1_;          ///< name of the first model to replace \@NAME\@
  std::string name2_;          ///< name of the second model to replace \@NAME\@
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDMACROCONNECT_H_
