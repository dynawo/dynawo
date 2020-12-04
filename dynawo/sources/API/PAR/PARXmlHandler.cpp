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
#include "PARParametersSetCollection.h"
#include "PARParametersSetCollectionFactory.h"


using std::map;
using std::string;
using std::vector;

using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

xml::sax::parser::namespace_uri par_ns("http://www.rte-france.com/dynawo");  ///< namespace used to read parameters xml file

namespace parameters {

XmlHandler::XmlHandler() :
setHandler_(parser::ElementName(par_ns, "set")),
parametersSetCollection_(ParametersSetCollectionFactory::newCollection()) {
  onElement(par_ns("parametersSet/set"), setHandler_);
  setHandler_.onEnd(lambda::bind(&XmlHandler::addSet, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {
}

shared_ptr<ParametersSetCollection>
XmlHandler::getParametersSetCollection() {
  return parametersSetCollection_;
}

void
XmlHandler::addSet() {
  parametersSetCollection_->addParametersSet(setHandler_.get());
}

SetHandler::SetHandler(elementName_type const & root_element) :
parHandler_(parser::ElementName(par_ns, "par")),
parTableHandler_(parser::ElementName(par_ns, "parTable")),
refHandler_(parser::ElementName(par_ns, "reference")) {
  onElement(root_element + par_ns("par"), parHandler_);
  onElement(root_element + par_ns("parTable"), parTableHandler_);
  onElement(root_element + par_ns("reference"), refHandler_);

  onStartElement(root_element, lambda::bind(&SetHandler::create, lambda::ref(*this), lambda_args::arg2));

  parHandler_.onEnd(lambda::bind(&SetHandler::addPar, lambda::ref(*this)));
  refHandler_.onEnd(lambda::bind(&SetHandler::addReference, lambda::ref(*this)));
  parTableHandler_.onEnd(lambda::bind(&SetHandler::addTable, lambda::ref(*this)));
}

void
SetHandler::create(attributes_type const & attributes) {
  setRead_ = shared_ptr<ParametersSet>(new ParametersSet(attributes["id"].as_string()));
}

shared_ptr<ParametersSet>
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
parInTableHandler_(parser::ElementName(par_ns, "par")) {
  onElement(root_element + par_ns("par"), parInTableHandler_);
  onStartElement(root_element, lambda::bind(&ParTableHandler::create, lambda::ref(*this), lambda_args::arg2));
  parInTableHandler_.onEnd(lambda::bind(&ParTableHandler::addPar, lambda::ref(*this)));
}

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

shared_ptr<Parameter>
ParHandler::get() const {
  return parameter_;
}

RefHandler::RefHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&RefHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void RefHandler::create(attributes_type const & attributes) {
  referenceRead_ = ReferenceFactory::newReference(attributes["name"]);
  referenceRead_->setType(attributes["type"]);
  referenceRead_->setOrigData(attributes["origData"].as_string());
  referenceRead_->setOrigName(attributes["origName"].as_string());
  if (attributes.has("componentId"))
    referenceRead_->setComponentId(attributes["componentId"]);
}

shared_ptr<Reference>
RefHandler::get() const {
  return referenceRead_;
}

}  // namespace parameters
