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
 * @file DYDBlackBoxModelImpl.cpp
 * @brief Blackbox model description : implementation file
 *
 */

#include "DYDBlackBoxModelImpl.h"

using std::string;

using boost::shared_ptr;

namespace dynamicdata {

BlackBoxModel::Impl::Impl(const string& id) :
Model::Impl(id, Model::BLACK_BOX_MODEL) {
}

BlackBoxModel::Impl::~Impl() {
}

std::string
BlackBoxModel::Impl::getLib() const {
  return lib_;
}

BlackBoxModel&
BlackBoxModel::Impl::setLib(const string& lib) {
  lib_ = lib;
  return *this;
}

string
BlackBoxModel::Impl::getStaticId() const {
  return staticId_;
}

BlackBoxModel&
BlackBoxModel::Impl::setStaticId(const string& staticId) {
  staticId_ = staticId;
  return *this;
}

BlackBoxModel&
BlackBoxModel::Impl::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

BlackBoxModel&
BlackBoxModel::Impl::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

string
BlackBoxModel::Impl::getParFile() const {
  return parFile_;
}

string
BlackBoxModel::Impl::getParId() const {
  return parId_;
}

string
BlackBoxModel::Impl::getId() const {
  return Model::Impl::getId();
}

Model::ModelType
BlackBoxModel::Impl::getType() const {
  return Model::Impl::getType();
}

Model&
BlackBoxModel::Impl::addStaticRef(const std::string& var, const std::string& staticVar) {
  return Model::Impl::addStaticRef(var, staticVar);
}

void
BlackBoxModel::Impl::addMacroStaticRef(const boost::shared_ptr<MacroStaticRef>& macroStaticRef) {
  Model::Impl::addMacroStaticRef(macroStaticRef);
}

staticRef_const_iterator
BlackBoxModel::Impl::cbeginStaticRef() const {
  return Model::Impl::cbeginStaticRef();
}

staticRef_const_iterator
BlackBoxModel::Impl::cendStaticRef() const {
  return Model::Impl::cendStaticRef();
}

macroStaticRef_const_iterator
BlackBoxModel::Impl::cbeginMacroStaticRef() const {
  return Model::Impl::cbeginMacroStaticRef();
}

macroStaticRef_const_iterator
BlackBoxModel::Impl::cendMacroStaticRef() const {
  return Model::Impl::cendMacroStaticRef();
}

staticRef_iterator
BlackBoxModel::Impl::beginStaticRef() {
  return Model::Impl::beginStaticRef();
}

staticRef_iterator
BlackBoxModel::Impl::endStaticRef() {
  return Model::Impl::endStaticRef();
}

macroStaticRef_iterator
BlackBoxModel::Impl::beginMacroStaticRef() {
  return Model::Impl::beginMacroStaticRef();
}

macroStaticRef_iterator
BlackBoxModel::Impl::endMacroStaticRef() {
  return Model::Impl::endMacroStaticRef();
}

const boost::shared_ptr<StaticRef>&
BlackBoxModel::Impl::findStaticRef(const std::string& key) {
  return Model::Impl::findStaticRef(key);
}

const boost::shared_ptr<MacroStaticRef>&
BlackBoxModel::Impl::findMacroStaticRef(const std::string& id) {
  return Model::Impl::findMacroStaticRef(id);
}

}  // namespace dynamicdata

