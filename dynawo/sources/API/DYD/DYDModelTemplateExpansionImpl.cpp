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
 * @file DYDModelTemplateExpansionImpl.cpp
 * @brief Model template expansion description : implementation file
 *
 */

#include "DYDModelTemplateExpansionImpl.h"

#include "DYNMacrosMessage.h"

using std::string;

using boost::shared_ptr;

namespace dynamicdata {

ModelTemplateExpansion::Impl::Impl(const string& id) :
Model::Impl(id, Model::MODEL_TEMPLATE_EXPANSION) {
}

ModelTemplateExpansion::Impl::~Impl() {
}

std::string
ModelTemplateExpansion::Impl::getTemplateId() const {
  return templateId_;
}

ModelTemplateExpansion&
ModelTemplateExpansion::Impl::setTemplateId(const string& templateId) {
  templateId_ = templateId;
  return *this;
}

string
ModelTemplateExpansion::Impl::getStaticId() const {
  return staticId_;
}

ModelTemplateExpansion&
ModelTemplateExpansion::Impl::setStaticId(const string& staticId) {
  staticId_ = staticId;
  return *this;
}

ModelTemplateExpansion&
ModelTemplateExpansion::Impl::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

ModelTemplateExpansion&
ModelTemplateExpansion::Impl::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

string
ModelTemplateExpansion::Impl::getParFile() const {
  return parFile_;
}

string
ModelTemplateExpansion::Impl::getParId() const {
  return parId_;
}

string
ModelTemplateExpansion::Impl::getId() const {
  return Model::Impl::getId();
}

Model::ModelType
ModelTemplateExpansion::Impl::getType() const {
  return Model::Impl::getType();
}

Model&
ModelTemplateExpansion::Impl::addStaticRef(const std::string& var, const std::string& staticVar) {
  return Model::Impl::addStaticRef(var, staticVar);
}

void
ModelTemplateExpansion::Impl::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) {
  Model::Impl::addMacroStaticRef(macroStaticRef);
}

staticRef_const_iterator
ModelTemplateExpansion::Impl::cbeginStaticRef() const {
  return Model::Impl::cbeginStaticRef();
}

staticRef_const_iterator
ModelTemplateExpansion::Impl::cendStaticRef() const {
  return Model::Impl::cendStaticRef();
}

macroStaticRef_const_iterator
ModelTemplateExpansion::Impl::cbeginMacroStaticRef() const {
  return Model::Impl::cbeginMacroStaticRef();
}

macroStaticRef_const_iterator
ModelTemplateExpansion::Impl::cendMacroStaticRef() const {
  return Model::Impl::cendMacroStaticRef();
}

staticRef_iterator
ModelTemplateExpansion::Impl::beginStaticRef() {
  return Model::Impl::beginStaticRef();
}

staticRef_iterator
ModelTemplateExpansion::Impl::endStaticRef() {
  return Model::Impl::endStaticRef();
}

macroStaticRef_iterator
ModelTemplateExpansion::Impl::beginMacroStaticRef() {
  return Model::Impl::beginMacroStaticRef();
}

macroStaticRef_iterator
ModelTemplateExpansion::Impl::endMacroStaticRef() {
  return Model::Impl::endMacroStaticRef();
}

const boost::shared_ptr<StaticRef>&
ModelTemplateExpansion::Impl::findStaticRef(const std::string& key) {
  return Model::Impl::findStaticRef(key);
}

const boost::shared_ptr<MacroStaticRef>&
ModelTemplateExpansion::Impl::findMacroStaticRef(const std::string& id) {
  return Model::Impl::findMacroStaticRef(id);
}

}  // namespace dynamicdata
