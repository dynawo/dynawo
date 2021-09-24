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
 * @file EXTVARXmlHandler.cpp
 * @brief Handler for external variables collection
 * file : implementation file
 */

#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "DYNFileSystemUtils.h"
#include "DYNMacrosMessage.h"
#include "DYNExecUtils.h"

#include "EXTVARVariableFactory.h"
#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARXmlHandler.h"
#include "EXTVARVariablesCollection.h"

using std::string;
using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace externalVariables {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
variablesCollection_(VariablesCollectionFactory::newCollection()),
variablesHandler_(parser::ElementName(namespace_uri(), "variable")) {
  onElement(namespace_uri()("external_variables/variable"), variablesHandler_);

  variablesHandler_.onEnd(lambda::bind(&XmlHandler::addVariable, lambda::ref(*this)));
}

boost::shared_ptr<VariablesCollection>
XmlHandler::getVariablesCollection() {
  return variablesCollection_;
}

void
XmlHandler::addVariable() {
  shared_ptr<Variable> variable = variablesHandler_.get();
  variablesCollection_->addVariable(variable);
}

shared_ptr<Variable>
VariableHandler::get() const {
  return variable_;
}

VariableHandler::VariableHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&VariableHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
VariableHandler::create(attributes_type const& attributes) {
  Variable::Type variableType;
  if (attributes["type"].as_string() == "continuous") {
#ifdef LANG_CXX11
    variableType = Variable::Type::CONTINUOUS;
#else
    variableType = Variable::CONTINUOUS;
#endif
  } else if (attributes["type"].as_string() == "discrete") {
#ifdef LANG_CXX11
    variableType = Variable::Type::DISCRETE;
#else
    variableType = Variable::DISCRETE;
#endif
  } else if (attributes["type"].as_string() == "boolean") {
#ifdef LANG_CXX11
    variableType = Variable::Type::BOOLEAN;
#else
    variableType = Variable::BOOLEAN;
#endif
  } else if (attributes["type"].as_string() == "discreteArray") {
#ifdef LANG_CXX11
    variableType = Variable::Type::DISCRETE_ARRAY;
#else
    variableType = Variable::DISCRETE_ARRAY;
#endif
  } else if (attributes["type"].as_string() == "continuousArray") {
#ifdef LANG_CXX11
    variableType = Variable::Type::CONTINUOUS_ARRAY;
#else
    variableType = Variable::CONTINUOUS_ARRAY;
#endif
  } else {
    throw DYNError(DYN::Error::API, XmlParsingError, "variable type should be one of continuous|discrete|discreteArray|continuousArray");
  }
  variable_ = VariableFactory::newVariable(attributes["id"], variableType);
  if (attributes.has("defaultValue")) {
    variable_->setDefaultValue(attributes["defaultValue"].as_string());
  }
  if (attributes.has("size")) {
    variable_->setSize(attributes["size"]);
  }
  if (attributes.has("optional")) {
    variable_->setOptional(attributes["optional"]);
  }
}

}  // namespace externalVariables
