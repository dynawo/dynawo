//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTXMLHANDLER_H_
#define API_CRT_CRTXMLHANDLER_H_

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>


namespace criteria {
class CriteriaCollection;
class Criteria;
class CriteriaParams;
class CriteriaParamsVoltageLevel;

/**
 * @class ElementWithIdHandler
 * @brief Handler used to parse an element with an id
 */
class ElementWithIdHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ElementWithIdHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ElementWithIdHandler();

  /**
   * @brief return the id read in xml file
   * @return id build thanks to infos read in xml file
   */
  const std::string& getId() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::string idRead_;  ///< current element id
};

/**
 * @class ComponentHandler
 * @brief Handler used to parse a component element
 */
class ComponentHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ComponentHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ComponentHandler();

  /**
   * @brief return the id read in xml file
   * @return id build thanks to infos read in xml file
   */
  const std::string& getId() const;

  /**
   * @brief return the voltageLevel id read in xml file
   * @return voltageLevel id build thanks to infos read in xml file
   */
  const std::string& getVoltageLevelId() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::string idRead_;              ///< current component id
  std::string voltageLevelIdRead_;  ///< current voltageLevel id
};

/**
 * @class CriteriaParamsVoltageLevelHandler
 * @brief Handler used to parse criteria params voltage level element
 */
class CriteriaParamsVoltageLevelHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CriteriaParamsVoltageLevelHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~CriteriaParamsVoltageLevelHandler();

  /**
   * @brief return the criteria params voltage level read in xml file
   * @return criteria params voltage level object build thanks to infos read in xml file
   */
  boost::shared_ptr<CriteriaParamsVoltageLevel> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<CriteriaParamsVoltageLevel> criteriaParamsVoltageLevelRead_;  ///< current parameters voltage level
};

/**
 * @class CriteriaParamsHandler
 * @brief Handler used to parse criteria params element
 */
class CriteriaParamsHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CriteriaParamsHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~CriteriaParamsHandler();

  /**
   * @brief return the criteria params read in xml file
   * @return criteria params  object build thanks to infos read in xml file
   */
  std::shared_ptr<CriteriaParams> get() const;

 protected:
  /**
   * @brief add a criteria parameter voltage level to the criteria parameter
   */
  void addCriteriaParamsVoltageLevel();

  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<CriteriaParams> criteriaParamsRead_;  ///< current parameters
  CriteriaParamsVoltageLevelHandler criteriaParamsVoltageLevelHandler_;  ///< handler used to read voltage level elements
};

/**
 * @class CriteriaHandler
 * @brief Handler used to parse criteria element
 */
class CriteriaHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CriteriaHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~CriteriaHandler();

  /**
   * @brief return the criteria read in xml file
   * @return criteria object build thanks to infos read in xml file
   */
  std::shared_ptr<Criteria> get() const;

 protected:
  /**
   * @brief add a criteria parameter to the criteria
   */
  void addCriteriaParams();
  /**
   * @brief add a component to the criteria
   */
  void addComponent();
  /**
   * @brief add a country to the criteria
   */
  void addCountry();
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<Criteria> criteriaRead_;  ///< current criteria
  CriteriaParamsHandler criteriaParamsHandler_;  ///< handler used to read criteria parameters element
  ComponentHandler cmpHandler_;  ///< handler used to read component elements
  ElementWithIdHandler countryHandler_;  ///< handler used to read country elements
};

/**
 * @class XmlHandler
 * @brief Criteria file handler class
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * criteria' input files.
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
  virtual ~XmlHandler();

  /**
   * @brief Parsed criteria collection getter
   *
   * @return criteria collection parsed.
   */
  std::shared_ptr<CriteriaCollection> getCriteriaCollection();

 private:
  /**
   * @brief add a bus criteria to the criteria collection
   */
  void addBusCriteria();

  /**
   * @brief add a load criteria to the criteria collection
   */
  void addLoadCriteria();

  /**
   * @brief add a generator criteria to the criteria collection
   */
  void addGenCriteria();

  std::shared_ptr<CriteriaCollection> criteriaCollection_;  ///< Criteria collection parsed
  CriteriaHandler busCriteriaHandler_;  ///< handler used to read bus criteria element
  CriteriaHandler loadCriteriaHandler_;  ///< handler used to read load criteria element
  CriteriaHandler genCriteriaHandler_;  ///< handler used to read generator criteria element
};


}  // namespace criteria

#endif  // API_CRT_CRTXMLHANDLER_H_
