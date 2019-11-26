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
 * @file  FSXmlHandler.h
 *
 * @brief Handler for final state collection file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * final state input files
 *
 */
#ifndef API_FS_FSXMLHANDLER_H_
#define API_FS_FSXMLHANDLER_H_

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

namespace finalState {
class FinalStateCollection;
class FinalStateModel;
class Variable;

/**
 * @class ModelHandler
 * @brief Handler used to parse model element
 */
class ModelHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelHandler(elementName_type const& root_element);

  /**
   * @brief default destructor
   */
  ~ModelHandler() { }

  /**
   * @brief return the model object read in xml file
   * @return model object build thanks to infos read in xml file
   */
  boost::shared_ptr<FinalStateModel> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<FinalStateModel> modelRead_;  ///< current model object
};

/**
 * @class VariableHandler
 * @brief Handler used to parse variable element
 */
class VariableHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit VariableHandler(elementName_type const& root_element);

  /**
   * @brief default destructor
   */
  ~VariableHandler() { }

  /**
   * @brief return the variable object read in xml file
   * @return variable object build thanks to infos read in xml file
   */
  boost::shared_ptr<Variable> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<Variable> variableRead_;  ///< current variable object
};

/**
 * @class XmlHandler
 * @brief final state input file handler class
 *
 * XmlHandler is the implementation of XML handler for parsing
 * final state's input files.
 */
class XmlHandler : public xml::sax::parser::ComposableDocumentHandler {
 public:
  /**
   * @brief Default constructor
   */
  XmlHandler();

  /**
   * @brief Destructor
   */
  ~XmlHandler();

  /**
   * @brief Parsed final state collection getter
   *
   * @return final state collection parsed.
   */
  boost::shared_ptr<FinalStateCollection> getFinalStateCollection();

 private:
  /**
   * @brief Called when beginning to read a model element
   */
  void beginFinalStateModel();

  /**
   * @brief Called when ending to read a model element
   */
  void endFinalStateModel();

  /**
   * @brief add a model object to the final state collection
   */
  void addFinalStateModel();

  /**
   * @brief add a variable object to the final state collection
   */
  void addVariable();

  boost::shared_ptr<FinalStateCollection> finalStateCollection_;  ///< final state collection parsed
  ModelHandler modelHandler_;  ///< handler used to read a model element
  VariableHandler variableHandler_;  ///< handler used to read a variable element

  boost::shared_ptr<FinalStateModel> parsedModel_;  ///< current model parsed
  int level_;  ///< level in xml structure
  std::map<int, boost::shared_ptr<FinalStateModel> > modelByLevel_;  ///< model by level in structure
};
}  // namespace finalState

#endif  // API_FS_FSXMLHANDLER_H_
