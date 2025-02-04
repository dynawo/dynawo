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
 * @file PARXmlHandler.cpp
 * @brief Handler for parameters collection file : implementation file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * parameters collection files.
 *
 */

#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>
#include <boost/lexical_cast.hpp>

#include "PARXmlHandler.h"
#include "PARParameter.h"
#include "PARParameterFactory.h"
#include "PARReference.h"
#include "PARReferenceFactory.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParametersSetCollection.h"
#include "PARParametersSetCollectionFactory.h"
#include "PARMacroParameterSet.h"
#include "PARMacroParameterSet.h"
#include "DYNMacrosMessage.h"


using std::string;
using std::vector;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace parameters {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
setHandler_(parser::ElementName(namespace_uri(), "set")),
parametersSetCollection_(ParametersSetCollectionFactory::newCollection()),
macroParameterSetHandler_(parser::ElementName(namespace_uri(), "macroParameterSet")) {
  onElement(namespace_uri()("parametersSet/set"), setHandler_);
  onElement(namespace_uri()("parametersSet/macroParameterSet"), macroParameterSetHandler_);
  setHandler_.onEnd(lambda::bind(&XmlHandler::addSet, lambda::ref(*this)));
  macroParameterSetHandler_.onEnd(lambda::bind(&XmlHandler::addMacroParameterSet, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

std::shared_ptr<ParametersSetCollection>
XmlHandler::getParametersSetCollection() {
  return parametersSetCollection_;
}

void
XmlHandler::addSet() {
  parametersSetCollection_->addParametersSet(setHandler_.get());
}

void
XmlHandler::addMacroParameterSet() {
  parametersSetCollection_->addMacroParameterSet(macroParameterSetHandler_.get());
}

SetHandler::SetHandler(elementName_type const & root_element) :
parHandler_(parser::ElementName(namespace_uri(), "par")),
parTableHandler_(parser::ElementName(namespace_uri(), "parTable")),
refHandler_(parser::ElementName(namespace_uri(), "reference")),
macroParSetHandler_(parser::ElementName(namespace_uri(), "macroParSet")) {
  onElement(root_element + namespace_uri()("par"), parHandler_);
  onElement(root_element + namespace_uri()("parTable"), parTableHandler_);
  onElement(root_element + namespace_uri()("reference"), refHandler_);
  onElement(root_element + namespace_uri()("macroParSet"), macroParSetHandler_);

  onStartElement(root_element, lambda::bind(&SetHandler::create, lambda::ref(*this), lambda_args::arg2));

  parHandler_.onEnd(lambda::bind(&SetHandler::addPar, lambda::ref(*this)));
  refHandler_.onEnd(lambda::bind(&SetHandler::addReference, lambda::ref(*this)));
  parTableHandler_.onEnd(lambda::bind(&SetHandler::addTable, lambda::ref(*this)));
  macroParSetHandler_.onEnd(lambda::bind(&SetHandler::addMacroParSet, lambda::ref(*this)));
}

SetHandler::~SetHandler() {}

void
SetHandler::create(attributes_type const & attributes) {
  setRead_ = ParametersSetFactory::newParametersSet(attributes["id"].as_string());
}

std::shared_ptr<ParametersSet>
SetHandler::get() const {
  return setRead_;
}

void
SetHandler::addReference() {
  setRead_->addReference(refHandler_.get());
}

void
SetHandler::addPar() {
  setRead_->addParameter(parHandler_.get());
}

void
SetHandler::addMacroParSet() {
  setRead_->addMacroParSet(macroParSetHandler_.get());
}

void
SetHandler::addTable() {
  string name = parTableHandler_.getName();
  string type = parTableHandler_.getType();
  vector<TableParameter> pars = parTableHandler_.getPars();
  for (unsigned int i = 0; i < pars.size(); ++i) {
    string row = pars[i].row;
    string column = pars[i].column;
    if (type == string("BOOL")) {
      bool value = (pars[i].value == "true");
      setRead_->createParameter(name, value, row, column);
    } else if (type == string("INT")) {
      int value = boost::lexical_cast<int>(pars[i].value);
      setRead_->createParameter(name, value, row, column);
    } else if (type == string("DOUBLE")) {
      double value = boost::lexical_cast<double>(pars[i].value);
      setRead_->createParameter(name, value, row, column);
    } else if (type == string("STRING")) {
      string value = pars[i].value;
      setRead_->createParameter(name, value, row, column);
    }
  }
}

ParTableHandler::ParTableHandler(elementName_type const & root_element) :
parInTableHandler_(parser::ElementName(namespace_uri(), "par")) {
  onElement(root_element + namespace_uri()("par"), parInTableHandler_);
  onStartElement(root_element, lambda::bind(&ParTableHandler::create, lambda::ref(*this), lambda_args::arg2));
  parInTableHandler_.onEnd(lambda::bind(&ParTableHandler::addPar, lambda::ref(*this)));
}

ParTableHandler::~ParTableHandler() {}

void
ParTableHandler::create(attributes_type const & attributes) {
  pars_.clear();
  setType(attributes["type"]);
  setName(attributes["name"]);
}

void
ParTableHandler::addPar() {
  pars_.push_back(parInTableHandler_.get());
}

vector<TableParameter>
ParTableHandler::getPars() const {
  return pars_;
}

ParInTableHandler::ParInTableHandler(elementName_type const & root_element) {
  onStartElement(root_element, lambda::bind(&ParInTableHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ParInTableHandler::~ParInTableHandler() {}

void
ParInTableHandler::create(attributes_type const & attributes) {
  par_.value = attributes["value"].as_string();
  par_.row = attributes["row"].as_string();
  par_.column = attributes["column"].as_string();
}

TableParameter
ParInTableHandler::get() const {
  return par_;
}

ParHandler::ParHandler(elementName_type const & root_element) {
  onStartElement(root_element, lambda::bind(&ParHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ParHandler::~ParHandler() {}

void
ParHandler::create(attributes_type const & attributes) {
  string type = attributes["type"];
  string value = attributes["value"];
  string name = attributes["name"];
  if (type == string("BOOL")) {
    bool bValue = (value == "true");
    parameter_ = ParameterFactory::newParameter(name, bValue);
  } else if (type == string("INT")) {
    int iValue = boost::lexical_cast<int>(value);
    parameter_ = ParameterFactory::newParameter(name, iValue);
  } else if (type == string("DOUBLE")) {
    double dValue = boost::lexical_cast<double>(value);
    parameter_ = ParameterFactory::newParameter(name, dValue);
  } else if (type == string("STRING")) {
    parameter_ = ParameterFactory::newParameter(name, value);
  }
}

std::shared_ptr<Parameter>
ParHandler::get() const {
  return parameter_;
}

RefHandler::RefHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&RefHandler::create, lambda::ref(*this), lambda_args::arg2));
}

RefHandler::~RefHandler() {}

void RefHandler::create(attributes_type const & attributes) {
  Reference::OriginData origData;
  if (attributes["origData"].as_string() == ReferenceOriginNames[Reference::IIDM]) {
    origData = Reference::OriginData::IIDM;
  } else if (attributes["origData"].as_string() == ReferenceOriginNames[Reference::PAR]) {
    origData = Reference::OriginData::PAR;
  } else {
    throw DYNError(DYN::Error::API, ReferenceUnknownOriginData, origData);
  }

  referenceRead_ = ReferenceFactory::newReference(attributes["name"], origData);
  referenceRead_->setType(attributes["type"]);
  referenceRead_->setOrigName(attributes["origName"].as_string());
  if (attributes.has("componentId"))
    referenceRead_->setComponentId(attributes["componentId"]);
  if (attributes.has("parId"))
    referenceRead_->setParId(attributes["parId"]);
  if (attributes.has("parFile"))
    referenceRead_->setParFile(attributes["parFile"]);
}

std::shared_ptr<Reference>
RefHandler::get() const {
  return referenceRead_;
}

MacroParameterSetHandler::MacroParameterSetHandler(elementName_type const& root_element) :
refHandler_(parser::ElementName(namespace_uri(), "reference")),
parHandler_(parser::ElementName(namespace_uri(), "par")) {
  onStartElement(root_element, lambda::bind(&MacroParameterSetHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + namespace_uri()("reference"), refHandler_);
  onElement(root_element + namespace_uri()("par"), parHandler_);
  refHandler_.onEnd(lambda::bind(&MacroParameterSetHandler::addReference, lambda::ref(*this)));
  parHandler_.onEnd(lambda::bind(&MacroParameterSetHandler::addParameter, lambda::ref(*this)));
}

MacroParameterSetHandler::~MacroParameterSetHandler() {}

void
MacroParameterSetHandler::create(attributes_type const & attributes) {
  macroParameterSet_ = std::make_shared<MacroParameterSet>(attributes["id"].as_string());
}

void
MacroParameterSetHandler::addReference() {
  macroParameterSet_->addReference(refHandler_.get());
}

void
MacroParameterSetHandler::addParameter() {
  macroParameterSet_->addParameter(parHandler_.get());
}

std::shared_ptr<MacroParameterSet>
MacroParameterSetHandler::get() const {
  return macroParameterSet_;
}

MacroParSetHandler::MacroParSetHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&MacroParSetHandler::create, lambda::ref(*this), lambda_args::arg2));
}

MacroParSetHandler::~MacroParSetHandler() {}

void
MacroParSetHandler::create(attributes_type const & attributes) {
  macroParSet_ = std::make_shared<MacroParSet>(attributes["id"].as_string());
}

std::shared_ptr<MacroParSet>
MacroParSetHandler::get() const {
  return macroParSet_;
}

}  // namespace parameters
