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
 * @file  FSXmlHandler.cpp
 *
 * @brief Handler for final state collection file : implementation file
 *
 * XmlHandler is the implmentation of Dynawo handler for parsing final
 * state input files
 */
#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "FSXmlHandler.h"
#include "FSFinalStateCollection.h"
#include "FSFinalStateCollectionFactory.h"
#include "FSModel.h"
#include "FSModelFactory.h"
#include "FSVariable.h"
#include "FSVariableFactory.h"

using std::map;
using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

xml::sax::parser::namespace_uri fs_ns("http://www.rte-france.com/dynawo");  ///< namespace used to read final state xml file


namespace finalState {

XmlHandler::XmlHandler() :
finalStateCollection_(FinalStateCollectionFactory::newInstance("")),
modelHandler_(parser::ElementName(fs_ns, "model")),
variableHandler_(parser::ElementName(fs_ns, "variable")),
level_(0) {
  onElement(fs_ns("finalStateInput/model"), modelHandler_);
  onElement(fs_ns("finalStateInput/variable"), variableHandler_);

  modelHandler_.onStart(lambda::bind(&XmlHandler::beginModel, lambda::ref(*this)));
  modelHandler_.onEnd(lambda::bind(&XmlHandler::endModel, lambda::ref(*this)));
  modelHandler_.onEnd(lambda::bind(&XmlHandler::addModel, lambda::ref(*this)));
  variableHandler_.onEnd(lambda::bind(&XmlHandler::addVariable, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {
}

shared_ptr<FinalStateCollection>
XmlHandler::getFinalStateCollection() {
  return finalStateCollection_;
}

void
XmlHandler::beginModel() {
  ++level_;
}

void
XmlHandler::endModel() {
  level_--;
  if (level_ == 0) {
    modelByLevel_.clear();
  } else {
    parsedModel_ = modelByLevel_[level_];
  }
}

void
XmlHandler::addModel() {
  if (level_ > 1) {
    parsedModel_->addSubModel(modelHandler_.get());
  } else {
    finalStateCollection_->addModel(modelHandler_.get());
  }

  modelByLevel_[level_] = modelHandler_.get();
  parsedModel_ = modelHandler_.get();
}

void
XmlHandler::addVariable() {
  if (level_ >= 1) {
    parsedModel_->addVariable(variableHandler_.get());
  } else {
    finalStateCollection_->addVariable(variableHandler_.get());
  }
}

ModelHandler::ModelHandler(elementName_type const & root_element) {
  onStartElement(root_element, lambda::bind(&ModelHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
ModelHandler::create(attributes_type const & attributes) {
  modelRead_ = ModelFactory::newModel(attributes["id"]);
}

shared_ptr<Model>
ModelHandler::get() const {
  return modelRead_;
}

VariableHandler::VariableHandler(elementName_type const & root_element) {
  onStartElement(root_element, lambda::bind(&VariableHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
VariableHandler::create(attributes_type const & attributes) {
  variableRead_ = VariableFactory::newVariable(attributes["name"]);
}

shared_ptr<Variable>
VariableHandler::get() const {
  return variableRead_;
}

}  // namespace finalState
