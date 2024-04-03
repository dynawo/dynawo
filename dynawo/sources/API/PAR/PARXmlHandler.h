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
 * @file PARXmlHandler.h
 * @brief Handler for parameters collection file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * parameters collection files.
 *
 */

#ifndef API_PAR_PARXMLHANDLER_H_
#define API_PAR_PARXMLHANDLER_H_

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

#include "PARParametersSetCollection.h"
#include "PARParametersSet.h"
#include "PARMacroParameterSet.h"
#include "PARMacroParSet.h"

namespace parameters {

/**
 * @struct TableParameter
 * @brief structure defining a parameter element inside a table
 */
struct TableParameter {
  std::string value;  ///< value of the parameter
  std::string row;  ///< row of the parameter
  std::string column;  ///< column of the parameter
};

/**
 * @class ParInTableHandler
 * @brief Handler used to parse a par element inside a table element
 */
class ParInTableHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ParInTableHandler(elementName_type const & root_element);

  /**
   * @brief return the parameter in xml file
   * @return parameter object build thanks to infos read in xml file
   */
  TableParameter get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const & attributes);

 private:
  TableParameter par_;  ///< current parameter read
};

/**
 * @class ParTableHandler
 * @brief Handler used to parse parTable element
 */
class ParTableHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ParTableHandler(elementName_type const & root_element);

  /**
   * @brief get the type of the current parTable
   * @return type of the current parTable
   */
  inline std::string getType() const {
    return type_;
  }

  /**
   * @brief get the name of the current parTable
   * @return name of the current parTable
   */
  inline std::string getName() const {
    return name_;
  }

  /**
   * @brief set the type of the current parTable
   * @param type : type of the current parTable
   */
  inline void setType(const std::string& type) {
    type_ = type;
  }

  /**
   * @brief set the name of the current parTable
   * @param name : name of the current parTable
   */
  inline void setName(const std::string& name) {
    name_ = name;
  }

  /**
   * @brief add a parameter to the parTable
   */
  void addPar();

  /**
   * @brief get the list of parameter of the parTable
   * @return the list of parameter of the parTable
   */
  std::vector<TableParameter> getPars() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const & attributes);

 private:
  ParInTableHandler parInTableHandler_;  ///< handler used to read parameter inside parTable element
  std::vector<TableParameter> pars_;  ///< list of parameter of the parTable
  std::string type_;  ///< type of the parTable (DOUBLE, INTEGER, BOOL,...)
  std::string name_;  ///< name of the parTable
};

/**
 * @class ParHandler
 * @brief Handler used to parse parameter element
 */
class ParHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ParHandler(elementName_type const & root_element);

  /**
   * @brief return the parameter read in xml file
   * @return parameter object build thanks to infos read in xml file
   */
  boost::shared_ptr<Parameter> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const & attributes);

 private:
  boost::shared_ptr<Parameter> parameter_;  ///< current parameter object
};

/**
 * @class RefHandler
 * @brief Handler used to parse reference element
 */
class RefHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit RefHandler(elementName_type const & root_element);

  /**
   * @brief return the reference read in xml file
   * @return reference object build thanks to infos read in xml file
   */
  boost::shared_ptr<Reference> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const & attributes);

 private:
  boost::shared_ptr<Reference> referenceRead_;  ///< current reference object
};

/**
 * @class MacroParSetHandler
 * @brief Handler used to parse macroParSet element
 */
class MacroParSetHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroParSetHandler(elementName_type const& root_element);

  /**
   * @brief return the macroParSet read in xml file
   * @return reference object build thanks to infos read in xml file
   */
  boost::shared_ptr<MacroParSet> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<MacroParSet> macroParSet_;  ///< current macroParSet object
};

/**
 * @class SetHandler
 * @brief Handler used to parse a set of parameter element
 */
class SetHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit SetHandler(elementName_type const & root_element);

  /**
   * @brief return the set of parameters read in xml file
   * @return set of parameters object build thanks to infos read in xml file
   */
  boost::shared_ptr<ParametersSet> get() const;

  /**
   * @brief  add a reference object to the set of parameters
   */
  void addReference();

  /**
   * @brief  add a parameter object to the set of parameters
   */
  void addPar();

  /**
   * @brief  add a table of parameter object to the set of parameters
   */
  void addTable();

  /**
   * @brief  add a macroParSet object to the set of parameters
   */
  void addMacroParSet();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const & attributes);

 private:
  boost::shared_ptr<ParametersSet> setRead_;  ///< current set of parameters object
  ParHandler parHandler_;  ///< handler used to read par element
  ParTableHandler parTableHandler_;  ///< handler used to read parTable element
  RefHandler refHandler_;  ///< handler used to read reference element
  MacroParSetHandler macroParSetHandler_;  ///< handler used to read macroParSet element
};

/**
 * @class MacroParameterSetHandler
 * @brief Handler used to parse a set of macroParameterSet element
 */
class MacroParameterSetHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroParameterSetHandler(elementName_type const& root_element);

  /**
   * @brief return the macroParameterSet read in xml file
   * @return reference object build thanks to infos read in xml file
   */
  boost::shared_ptr<MacroParameterSet> get() const;

  /**
   * @brief  add a reference object to the set of macroParameter
   */
  void addReference();

  /**
   * @brief  add a parameter object to the set of macroParameter
   */
  void addParameter();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<MacroParameterSet> macroParameterSet_;  ///< current set of macroParameterSet object
  RefHandler refHandler_;  ///< handler used to read reference element
  ParHandler parHandler_;  ///< handler used to read par element
};


/**
 * @class XmlHandler
 * @brief Parameters file handler class
 *
 * XmlHandler is the implementation of XML handler for parsing
 * parameters files.
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
  boost::shared_ptr<ParametersSetCollection> getParametersSetCollection();

  /**
   * @brief add a set of parameter to the parameters set collection
   */
  void addSet();

  /**
   * @brief add a macroParameterSet object to the parameters set collection
   */
  void addMacroParameterSet();

 private:
  SetHandler setHandler_;  ///< handler used to read a set of parameter element
  boost::shared_ptr<ParametersSetCollection> parametersSetCollection_;  ///< Parameters sets collection parsed
  MacroParameterSetHandler macroParameterSetHandler_;  ///< handler used to read a macroParameterSet element
};

}  // namespace parameters

#endif  // API_PAR_PARXMLHANDLER_H_
