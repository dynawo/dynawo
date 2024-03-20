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
 * @file EXTVARXmlHandler.h
 * @brief Handler for external variables collection
 * file : header file
 */

#ifndef API_EXTVAR_EXTVARXMLHANDLER_H_
#define API_EXTVAR_EXTVARXMLHANDLER_H_

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

#include "EXTVARVariablesCollection.h"

namespace externalVariables {

/**
 * @class VariableHandler
 * @brief external variable handler
 */
class VariableHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param[in] root_element the object XML location
   */
  explicit VariableHandler(elementName_type const& root_element);

  /**
   * @brief Variable getter
   * @return the Variable object
   */
  boost::shared_ptr<Variable> get() const;

 private:
  /**
   * @brief create a discrete Variable object
   * @param[in] attributes the object XML attributes
   */
  void create(attributes_type const& attributes);

  boost::shared_ptr<Variable> variable_;  ///< current external variable object
};

/**
 * @class XmlHandler
 * @brief external variables file handler class
 *
 * XmlHandler is the implementation of XML handler for parsing
 * external variables files.
 */
class XmlHandler : public xml::sax::parser::ComposableDocumentHandler {
 public:
  /**
   * @brief Default constructor
   */
  XmlHandler();

  /**
   * @brief Parsed parameters set collection getter
   *
   * @return Parameters set collection parsed.
   */
  boost::shared_ptr<VariablesCollection> getVariablesCollection();

  /**
   * @brief Set root directory
   *
   * @param root Root directory for files name completion.
   */
  void setRootDirectory(const std::string& root);

 private:
  /**
   * @brief add a discrete external variable to the external variables collection
   */
  void addVariable();

  boost::shared_ptr<VariablesCollection> variablesCollection_;  ///< external variables collection parsed
  VariableHandler variablesHandler_;  ///< handler used to read external variables
};

}  // namespace externalVariables

#endif  // API_EXTVAR_EXTVARXMLHANDLER_H_
