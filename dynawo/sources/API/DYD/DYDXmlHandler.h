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
 * @file DYDXmlHandler.h
 * @brief Handler for dynamic models collection
 * file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * dynamic models collection files.
 */

#ifndef API_DYD_DYDXMLHANDLER_H_
#define API_DYD_DYDXMLHANDLER_H_

#include "DYDBlackBoxModel.h"
#include "DYDDynamicModelsCollection.h"
#include "DYDModelTemplate.h"
#include "DYDModelTemplateExpansion.h"
#include "DYDModelicaModel.h"
#include "DYDUnitDynamicModel.h"

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

namespace parameters {
class ParametersSetCollection;
}

namespace dynamicdata {

/**
 * @struct ConnectorRead
 * @brief structure defining a connector element
 */
struct ConnectorRead {
  std::string id1;   ///< id of the first model to connect
  std::string var1;  ///< variable of the first model to connect
  std::string id2;   ///< id of the second model to connect
  std::string var2;  ///< variable of the second model to connect
};

/**
 * @struct StaticRefRead
 * @brief structure defining a staticRef element
 */
struct StaticRefRead {
  std::string var;        ///< variable fo the model
  std::string staticVar;  ///< static variable
};

/**
 * @struct MacroConnectionRead
 * @brief structure defining a macroConnection element
 */
struct MacroConnectionRead {
  std::string var1;  ///< id of the first variable to connect
  std::string var2;  ///< id of the second variable to connect
};

/**
 * @class UnitDynamicModelHandler
 * @brief Handler used to parse UnitDynamicModel element
 */
class UnitDynamicModelHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit UnitDynamicModelHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~UnitDynamicModelHandler();

  /**
   * @brief return the unit dynamic model read in xml file
   * @return unit dynamic model object build thanks to infos read in xml file
   */
  std::shared_ptr<UnitDynamicModel> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<UnitDynamicModel> unitDynamicModel_;  ///< current unit dynamic model object
};

/**
 * @class StaticRefHandler
 * @brief Handler used to parse StaticRef element
 */
class StaticRefHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit StaticRefHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~StaticRefHandler();

  /**
   * @brief return the static ref read in xml file
   * @return static ref object build thanks to infos read in xml file
   */
  StaticRefRead get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  StaticRefRead staticRef_;  ///< current static ref object
};

/**
 * @class MacroStaticRefHandler
 * @brief Handler used to parse MacroStaticRef element
 */
class MacroStaticRefHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroStaticRefHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~MacroStaticRefHandler();

  /**
   * return the macroStaticRef read in xml file
   * @return the MacroStaticRef object build thanks to infos read in xml file
   */
  std::shared_ptr<MacroStaticRef> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<MacroStaticRef> macroStaticRef_;  ///< current MacroStaticRef object
};

/**
 * @class MacroStaticReferenceHandler
 * @brief Handler used to parse macroStaticReference elements
 */
class MacroStaticReferenceHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroStaticReferenceHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~MacroStaticReferenceHandler();

  /**
   * return the macroStaticReference read in xml file
   * @return MacroStaticReference object build thanks to infos read in xml file
   */
  std::shared_ptr<MacroStaticReference> get() const;

  /**
   * @brief add a staticRef to the macroStaticReference
   */
  void addStaticRef();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  StaticRefHandler staticRefHandler_;                             ///< handler used to read staticRef element
  std::shared_ptr<MacroStaticReference> macroStaticReference_;    ///< current MacroStaticReference object
};

/**
 * @class ConnectHandler
 * @brief Handler used to parse connect element
 */
class ConnectHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ConnectHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ConnectHandler();

  /**
   * @brief return the connector read in xml file
   * @return connector object build thanks to infos read in xml file
   */
  ConnectorRead get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  ConnectorRead connector_;  ///< current connector object
};

/**
 *
 * @class MacroConnectHandler
 * @brief Handler used to parse MacroConnect element
 */
class MacroConnectHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroConnectHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~MacroConnectHandler();

  /**
   * return the macro connect read in xml file
   * @return macro connect object build thanks to infos read in xml file
   */
  std::shared_ptr<MacroConnect> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<MacroConnect> macroConnect_;  ///< current macro connect object
};

/**
 * @class MacroConnectionHandler
 * @brief Handler used to parse macroConnection element
 */
class MacroConnectionHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroConnectionHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~MacroConnectionHandler();

  /**
   * return the macro connection read in xml file
   * @return macro connection object build thanks to infos read in xml file
   */
  MacroConnectionRead get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  MacroConnectionRead macroConnection_;  ///< current macro connection object
};

/**
 * @class MacroConnectorHandler
 * @brief Handler used to parse MacroConnector element
 */
class MacroConnectorHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit MacroConnectorHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~MacroConnectorHandler();

  /**
   * return the macro connector read in xml file
   * @return macro connector object build thanks to infos read in xml file
   */
  std::shared_ptr<MacroConnector> get() const;

  /**
   * @brief add a connector to the macro connector
   */
  void addConnect();

  /**
   * @brief add an init connector to the macro connector
   */
  void addInitConnect();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  MacroConnectionHandler macroConnectionHandler_;      ///< handler used to read macroConnection element
  MacroConnectionHandler macroInitConnectionHandler_;  ///< handler used to read macroInitConnection element
  std::shared_ptr<MacroConnector> macroConnector_;     ///< current macro connector object
};

/**
 * @class ModelicaModelHandler
 * @brief Handler used to parse modelica model element
 */
class ModelicaModelHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelicaModelHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ModelicaModelHandler();

  /**
   * @brief return the modelica model read in xml file
   * @return modelica model object build thanks to infos read in xml file
   */
  std::shared_ptr<ModelicaModel> get() const;

  /**
   * @brief add a connector to the modelica model
   */
  void addConnect();

  /**
   * @brief add an init connector to the modelica model
   */
  void addInitConnect();

  /**
   * @brief add a static reference to the modelica model
   */
  void addStaticRef();

  /**
   * @brief add a unit dynamic model to the modelica model
   */
  void addUnitDynamicModel();

  /**
   * @brief add a macro connect to the modelica model
   */
  void addMacroConnect();

  /**
   * @brief add a macroStaticRef to the modelica model
   */
  void addMacroStaticRef();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  ConnectHandler connectHandler_;                    ///< handler used to read connect element
  ConnectHandler initConnectHandler_;                ///< handler used to read init connect element
  MacroConnectHandler macroConnectHandler_;          ///< handler used to read macro connect element
  StaticRefHandler staticRefHandler_;                ///< handler used to read static ref element
  MacroStaticRefHandler macroStaticRefHandler_;      ///< handler used to read macroStaticRef element
  UnitDynamicModelHandler unitDynamicModelHandler_;  ///< handler used to read unit dynamic model element
  std::shared_ptr<ModelicaModel> modelicaModel_;     ///< current modelica model
};

/**
 * @class ModelTemplateHandler
 * @brief Handler used to parse model template element
 */
class ModelTemplateHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelTemplateHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ModelTemplateHandler();

  /**
   * @brief return the model template read in xml file
   * @return model template object build thanks to infos read in xml file
   */
  std::shared_ptr<ModelTemplate> get() const;

  /**
   * @brief add a connector to the model template
   */
  void addConnect();

  /**
   * @brief add an init connector to the model template
   */
  void addInitConnect();

  /**
   * @brief add a macro connect to the model template
   */
  void addMacroConnect();

  /**
   * @brief add a static reference to the model template
   */
  void addStaticRef();

  /**
   * @brief add a macroStaticRef to the model template
   */
  void addMacroStaticRef();

  /**
   * @brief add a unit dynamic model to the model template
   */
  void addUnitDynamicModel();

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  ConnectHandler connectHandler_;                    ///< handler used to read connect element
  ConnectHandler initConnectHandler_;                ///< handler used to read init connect element
  MacroConnectHandler macroConnectHandler_;          ///< handler used to read macro connect element
  StaticRefHandler staticRefHandler_;                ///< handler used to read static ref element
  MacroStaticRefHandler macroStaticRefHandler_;      ///< handler used to read macroStaticRef element
  UnitDynamicModelHandler unitDynamicModelHandler_;  ///< handler used to read unit dynamic model element
  std::shared_ptr<ModelTemplate> modelTemplate_;     ///< current model template
};

/**
 * @class BlackBoxModelHandler
 * @brief Handler used to parse black box model element
 */
class BlackBoxModelHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit BlackBoxModelHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~BlackBoxModelHandler();

  /**
   * @brief add a static reference to the black box model
   */
  void addStaticRef();

  /**
   * @brief add a macroStaticRef to the black box model
   */
  void addMacroStaticRef();

  /**
   * @brief return the black box model read in xml file
   * @return black box model object build thanks to infos read in xml file
   */
  std::shared_ptr<BlackBoxModel> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  StaticRefHandler staticRefHandler_;               ///< handler used to read static ref element
  MacroStaticRefHandler macroStaticRefHandler_;     ///< handler used to read macroStaticRef element
  std::shared_ptr<BlackBoxModel> blackBoxModel_;    ///< current black box model
};

/**
 * @class ModelTemplateExpansionHandler
 * @brief Handler used to parse model template expansion element
 */
class ModelTemplateExpansionHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit ModelTemplateExpansionHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~ModelTemplateExpansionHandler();

  /**
   * @brief add a static reference to the model template expansion
   */
  void addStaticRef();

  /**
   * @brief add a macroStaticRef to the model template expansion
   */
  void addMacroStaticRef();

  /**
   * @brief return the model template  expansion read in xml file
   * @return model template expansion object build thanks to infos read in xml file
   */
  std::shared_ptr<ModelTemplateExpansion> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  StaticRefHandler staticRefHandler_;                                 ///< handler used to read static ref element
  MacroStaticRefHandler macroStaticRefHandler_;                       ///< handler used to read macroStaticRef element
  std::shared_ptr<ModelTemplateExpansion> modelTemplateExpansion_;    ///< current model template expansion
};

/**
 * @class XmlHandler
 * @brief dynamic models file handler class
 *
 * XmlHandler is the implementation of XML handler for parsing
 * dynamic models files.
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
   * @brief Parsed parameters set collection getter
   *
   * @return Parameters set collection parsed.
   */
  std::shared_ptr<DynamicModelsCollection> getDynamicModelsCollection();

  /**
   * @brief Set root directory
   *
   * @param root Root directory for files name completion.
   */
  void setRootDirectory(const std::string& root);

 private:
  /**
   * @brief add a modelica model to the dynamic models collection
   */
  void addModelicaModel();

  /**
   * @brief add a model template to the dynamic models collection
   */
  void addModelTemplate();

  /**
   * @brief add a black box model to the dynamic models collection
   */
  void addBlackBoxModel();

  /**
   * @brief add a model template expansion to the dynamic models collection
   */
  void addModelTemplateExpansion();

  /**
   * @brief add a (system) connect to the dynamic models collection
   */
  void addConnect();

  /**
   * @brief add a (system) macroConnect to the dynamic models collection
   */
  void addMacroConnect();

  /**
   * @brief add a macro connector element to the dynamic models collection
   */
  void addMacroConnector();

  /**
   * @brief add a macroStaticReference to the dynamic models collection
   */
  void addMacroStaticReference();

  std::shared_ptr<DynamicModelsCollection> dynamicModelsCollection_;    ///< Dynamic models collection parsed
  ModelicaModelHandler modelicaModelHandler_;                           ///< handler used to read modelia model element
  ModelTemplateHandler modelTemplateHandler_;                           ///< handler used to read model template element
  BlackBoxModelHandler blackBoxModelHandler_;                           ///< handler used to read black box model element
  ModelTemplateExpansionHandler modelTemplateExpansionHandler_;         ///< handler used to read model template expansion element
  ConnectHandler connectHandler_;                                       ///< handler used to read connect element
  MacroConnectHandler macroConnectHandler_;                             ///< handler used to read macroConnect element
  MacroConnectorHandler macroConnectorHandler_;                         ///< handler used to read macroConnector element
  MacroStaticReferenceHandler macroStaticReferenceHandler_;             ///< handler used to read macroStaticReference element
};

}  // namespace dynamicdata

#endif  // API_DYD_DYDXMLHANDLER_H_
