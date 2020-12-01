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
 * @file  DYDIterators.cpp
 *
 * @brief Dynamic data iterators : implementation file
 *
 */
#include "DYDIterators.h"

#include "DYDDynamicModelsCollection.h"
#include "DYDMacroStaticReference.h"
#include "DYDModel.h"

using boost::shared_ptr;
using std::map;
using std::string;
using std::vector;

namespace dynamicdata {

dynamicModel_const_iterator::dynamicModel_const_iterator(const DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->models_.begin() : iterated->models_.end())) {}

dynamicModel_const_iterator&
dynamicModel_const_iterator::operator++() {
  ++current_;
  return *this;
}

dynamicModel_const_iterator
dynamicModel_const_iterator::operator++(int) {
  dynamicModel_const_iterator previous = *this;
  current_++;
  return previous;
}

dynamicModel_const_iterator&
dynamicModel_const_iterator::operator--() {
  --current_;
  return *this;
}

dynamicModel_const_iterator
dynamicModel_const_iterator::operator--(int) {
  dynamicModel_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
dynamicModel_const_iterator::operator==(const dynamicModel_const_iterator& other) const {
  return current_ == other.current_;
}

bool
dynamicModel_const_iterator::operator!=(const dynamicModel_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Model>& dynamicModel_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Model>* dynamicModel_const_iterator::operator->() const {
  return &(current_->second);
}

connector_const_iterator::connector_const_iterator(const DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->connectors_.begin() : iterated->connectors_.end())) {}

connector_const_iterator&
connector_const_iterator::operator++() {
  ++current_;
  return *this;
}

connector_const_iterator
connector_const_iterator::operator++(int) {
  connector_const_iterator previous = *this;
  current_++;
  return previous;
}

connector_const_iterator&
connector_const_iterator::operator--() {
  --current_;
  return *this;
}

connector_const_iterator
connector_const_iterator::operator--(int) {
  connector_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
connector_const_iterator::operator==(const connector_const_iterator& other) const {
  return current_ == other.current_;
}

bool
connector_const_iterator::operator!=(const connector_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Connector>& connector_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<Connector>* connector_const_iterator::operator->() const {
  return &(*current_);
}

dynamicModel_iterator::dynamicModel_iterator(DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->models_.begin() : iterated->models_.end())) {}

dynamicModel_iterator&
dynamicModel_iterator::operator++() {
  ++current_;
  return *this;
}

dynamicModel_iterator
dynamicModel_iterator::operator++(int) {
  dynamicModel_iterator previous = *this;
  current_++;
  return previous;
}

dynamicModel_iterator&
dynamicModel_iterator::operator--() {
  --current_;
  return *this;
}

dynamicModel_iterator
dynamicModel_iterator::operator--(int) {
  dynamicModel_iterator previous = *this;
  current_--;
  return previous;
}

bool
dynamicModel_iterator::operator==(const dynamicModel_iterator& other) const {
  return current_ == other.current_;
}

bool
dynamicModel_iterator::operator!=(const dynamicModel_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<Model>& dynamicModel_iterator::operator*() const {
  return current_->second;
}

shared_ptr<Model>* dynamicModel_iterator::operator->() const {
  return &(current_->second);
}

connector_iterator::connector_iterator(DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->connectors_.begin() : iterated->connectors_.end())) {}

connector_iterator&
connector_iterator::operator++() {
  ++current_;
  return *this;
}

connector_iterator
connector_iterator::operator++(int) {
  connector_iterator previous = *this;
  current_++;
  return previous;
}

connector_iterator&
connector_iterator::operator--() {
  --current_;
  return *this;
}

connector_iterator
connector_iterator::operator--(int) {
  connector_iterator previous = *this;
  current_--;
  return previous;
}

bool
connector_iterator::operator==(const connector_iterator& other) const {
  return current_ == other.current_;
}

bool
connector_iterator::operator!=(const connector_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<Connector>& connector_iterator::operator*() const {
  return *current_;
}

shared_ptr<Connector>* connector_iterator::operator->() const {
  return &(*current_);
}

macroConnector_iterator::macroConnector_iterator(DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroConnectors_.begin() : iterated->macroConnectors_.end())) {}

macroConnector_iterator&
macroConnector_iterator::operator++() {
  ++current_;
  return *this;
}

macroConnector_iterator
macroConnector_iterator::operator++(int) {
  macroConnector_iterator previous = *this;
  current_++;
  return previous;
}

macroConnector_iterator&
macroConnector_iterator::operator--() {
  --current_;
  return *this;
}

macroConnector_iterator
macroConnector_iterator::operator--(int) {
  macroConnector_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroConnector_iterator::operator==(const macroConnector_iterator& other) const {
  return current_ == other.current_;
}

bool
macroConnector_iterator::operator!=(const macroConnector_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroConnector>& macroConnector_iterator::operator*() const {
  return current_->second;
}

shared_ptr<MacroConnector>* macroConnector_iterator::operator->() const {
  return &(current_->second);
}

macroConnector_const_iterator::macroConnector_const_iterator(const DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroConnectors_.begin() : iterated->macroConnectors_.end())) {}

macroConnector_const_iterator&
macroConnector_const_iterator::operator++() {
  ++current_;
  return *this;
}

macroConnector_const_iterator
macroConnector_const_iterator::operator++(int) {
  macroConnector_const_iterator previous = *this;
  current_++;
  return previous;
}

macroConnector_const_iterator&
macroConnector_const_iterator::operator--() {
  --current_;
  return *this;
}

macroConnector_const_iterator
macroConnector_const_iterator::operator--(int) {
  macroConnector_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroConnector_const_iterator::operator==(const macroConnector_const_iterator& other) const {
  return current_ == other.current_;
}

bool
macroConnector_const_iterator::operator!=(const macroConnector_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroConnector>& macroConnector_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<MacroConnector>* macroConnector_const_iterator::operator->() const {
  return &(current_->second);
}

macroConnect_iterator::macroConnect_iterator(DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroConnects_.begin() : iterated->macroConnects_.end())) {}

macroConnect_iterator&
macroConnect_iterator::operator++() {
  ++current_;
  return *this;
}

macroConnect_iterator
macroConnect_iterator::operator++(int) {
  macroConnect_iterator previous = *this;
  current_++;
  return previous;
}

macroConnect_iterator&
macroConnect_iterator::operator--() {
  --current_;
  return *this;
}

macroConnect_iterator
macroConnect_iterator::operator--(int) {
  macroConnect_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroConnect_iterator::operator==(const macroConnect_iterator& other) const {
  return current_ == other.current_;
}

bool
macroConnect_iterator::operator!=(const macroConnect_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroConnect>& macroConnect_iterator::operator*() const {
  return *current_;
}

shared_ptr<MacroConnect>* macroConnect_iterator::operator->() const {
  return &(*current_);
}

macroConnect_const_iterator::macroConnect_const_iterator(const DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroConnects_.begin() : iterated->macroConnects_.end())) {}

macroConnect_const_iterator&
macroConnect_const_iterator::operator++() {
  ++current_;
  return *this;
}

macroConnect_const_iterator
macroConnect_const_iterator::operator++(int) {
  macroConnect_const_iterator previous = *this;
  current_++;
  return previous;
}

macroConnect_const_iterator&
macroConnect_const_iterator::operator--() {
  --current_;
  return *this;
}

macroConnect_const_iterator
macroConnect_const_iterator::operator--(int) {
  macroConnect_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroConnect_const_iterator::operator==(const macroConnect_const_iterator& other) const {
  return current_ == other.current_;
}

bool
macroConnect_const_iterator::operator!=(const macroConnect_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroConnect>& macroConnect_const_iterator::operator*() const {
  return *current_;
}

const shared_ptr<MacroConnect>* macroConnect_const_iterator::operator->() const {
  return &(*current_);
}

staticRef_iterator::staticRef_iterator(Model* iterated, bool begin) : current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) {}

staticRef_iterator::staticRef_iterator(MacroStaticReference* iterated, bool begin) :
    current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) {}

staticRef_iterator&
staticRef_iterator::operator++() {
  ++current_;
  return *this;
}

staticRef_iterator
staticRef_iterator::operator++(int) {
  staticRef_iterator previous = *this;
  current_++;
  return previous;
}

staticRef_iterator&
staticRef_iterator::operator--() {
  --current_;
  return *this;
}

staticRef_iterator
staticRef_iterator::operator--(int) {
  staticRef_iterator previous = *this;
  current_--;
  return previous;
}

bool
staticRef_iterator::operator==(const staticRef_iterator& other) const {
  return current_ == other.current_;
}

bool
staticRef_iterator::operator!=(const staticRef_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<StaticRef>& staticRef_iterator::operator*() const {
  return current_->second;
}

shared_ptr<StaticRef>* staticRef_iterator::operator->() const {
  return &(current_->second);
}

staticRef_const_iterator::staticRef_const_iterator(const Model* iterated, bool begin) :
    current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) {}

staticRef_const_iterator::staticRef_const_iterator(const MacroStaticReference* iterated, bool begin) :
    current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) {}

staticRef_const_iterator&
staticRef_const_iterator::operator++() {
  ++current_;
  return *this;
}

staticRef_const_iterator
staticRef_const_iterator::operator++(int) {
  staticRef_const_iterator previous = *this;
  current_++;
  return previous;
}

staticRef_const_iterator&
staticRef_const_iterator::operator--() {
  --current_;
  return *this;
}

staticRef_const_iterator
staticRef_const_iterator::operator--(int) {
  staticRef_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
staticRef_const_iterator::operator==(const staticRef_const_iterator& other) const {
  return current_ == other.current_;
}

bool
staticRef_const_iterator::operator!=(const staticRef_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<StaticRef>& staticRef_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<StaticRef>* staticRef_const_iterator::operator->() const {
  return &(current_->second);
}

macroStaticRef_iterator::macroStaticRef_iterator(Model* iterated, bool begin) :
    current_((begin ? iterated->macroStaticRefs_.begin() : iterated->macroStaticRefs_.end())) {}

macroStaticRef_iterator&
macroStaticRef_iterator::operator++() {
  ++current_;
  return *this;
}

macroStaticRef_iterator
macroStaticRef_iterator::operator++(int) {
  macroStaticRef_iterator previous = *this;
  current_++;
  return previous;
}

macroStaticRef_iterator&
macroStaticRef_iterator::operator--() {
  --current_;
  return *this;
}

macroStaticRef_iterator
macroStaticRef_iterator::operator--(int) {
  macroStaticRef_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroStaticRef_iterator::operator==(const macroStaticRef_iterator& other) const {
  return current_ == other.current_;
}

bool
macroStaticRef_iterator::operator!=(const macroStaticRef_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroStaticRef>& macroStaticRef_iterator::operator*() const {
  return current_->second;
}

shared_ptr<MacroStaticRef>* macroStaticRef_iterator::operator->() const {
  return &(current_->second);
}

macroStaticRef_const_iterator::macroStaticRef_const_iterator(const Model* iterated, bool begin) :
    current_((begin ? iterated->macroStaticRefs_.begin() : iterated->macroStaticRefs_.end())) {}

macroStaticRef_const_iterator&
macroStaticRef_const_iterator::operator++() {
  ++current_;
  return *this;
}

macroStaticRef_const_iterator
macroStaticRef_const_iterator::operator++(int) {
  macroStaticRef_const_iterator previous = *this;
  current_++;
  return previous;
}

macroStaticRef_const_iterator&
macroStaticRef_const_iterator::operator--() {
  --current_;
  return *this;
}

macroStaticRef_const_iterator
macroStaticRef_const_iterator::operator--(int) {
  macroStaticRef_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroStaticRef_const_iterator::operator==(const macroStaticRef_const_iterator& other) const {
  return current_ == other.current_;
}

bool
macroStaticRef_const_iterator::operator!=(const macroStaticRef_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroStaticRef>& macroStaticRef_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<MacroStaticRef>* macroStaticRef_const_iterator::operator->() const {
  return &(current_->second);
}

macroStaticReference_iterator::macroStaticReference_iterator(DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroStaticReferences_.begin() : iterated->macroStaticReferences_.end())) {}

macroStaticReference_iterator&
macroStaticReference_iterator::operator++() {
  ++current_;
  return *this;
}

macroStaticReference_iterator
macroStaticReference_iterator::operator++(int) {
  macroStaticReference_iterator previous = *this;
  current_++;
  return previous;
}

macroStaticReference_iterator&
macroStaticReference_iterator::operator--() {
  --current_;
  return *this;
}

macroStaticReference_iterator
macroStaticReference_iterator::operator--(int) {
  macroStaticReference_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroStaticReference_iterator::operator==(const macroStaticReference_iterator& other) const {
  return current_ == other.current_;
}

bool
macroStaticReference_iterator::operator!=(const macroStaticReference_iterator& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroStaticReference>& macroStaticReference_iterator::operator*() const {
  return current_->second;
}

shared_ptr<MacroStaticReference>* macroStaticReference_iterator::operator->() const {
  return &(current_->second);
}

macroStaticReference_const_iterator::macroStaticReference_const_iterator(const DynamicModelsCollection* iterated, bool begin) :
    current_((begin ? iterated->macroStaticReferences_.begin() : iterated->macroStaticReferences_.end())) {}

macroStaticReference_const_iterator&
macroStaticReference_const_iterator::operator++() {
  ++current_;
  return *this;
}

macroStaticReference_const_iterator
macroStaticReference_const_iterator::operator++(int) {
  macroStaticReference_const_iterator previous = *this;
  current_++;
  return previous;
}

macroStaticReference_const_iterator&
macroStaticReference_const_iterator::operator--() {
  --current_;
  return *this;
}

macroStaticReference_const_iterator
macroStaticReference_const_iterator::operator--(int) {
  macroStaticReference_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
macroStaticReference_const_iterator::operator==(const macroStaticReference_const_iterator& other) const {
  return current_ == other.current_;
}

bool
macroStaticReference_const_iterator::operator!=(const macroStaticReference_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroStaticReference>& macroStaticReference_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<MacroStaticReference>* macroStaticReference_const_iterator::operator->() const {
  return &(current_->second);
}

}  // namespace dynamicdata
