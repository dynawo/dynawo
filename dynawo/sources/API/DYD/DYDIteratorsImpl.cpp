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
 * @file  DYDIteratorsImpl.cpp
 *
 * @brief Dynamic data iterators : implementation file
 *
 */
#include "DYDIteratorsImpl.h"

using boost::shared_ptr;
using std::map;
using std::vector;
using std::string;

namespace dynamicdata {

ModelConstIteratorImpl::ModelConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->models_.begin() : iterated->models_.end())) { }

ModelConstIteratorImpl::ModelConstIteratorImpl(const ModelIteratorImpl& iterator) :
current_(iterator.current()) { }

ModelConstIteratorImpl::~ModelConstIteratorImpl() {
}

ModelConstIteratorImpl&
ModelConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ModelConstIteratorImpl
ModelConstIteratorImpl::operator++(int) {
  ModelConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

ModelConstIteratorImpl&
ModelConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

ModelConstIteratorImpl
ModelConstIteratorImpl::operator--(int) {
  ModelConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ModelConstIteratorImpl::operator==(const ModelConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ModelConstIteratorImpl::operator!=(const ModelConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Model>&
ModelConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<Model>*
ModelConstIteratorImpl::operator->() const {
  return &(current_->second);
}

ConnectorConstIteratorImpl::ConnectorConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->connectors_.begin() : iterated->connectors_.end())) { }

ConnectorConstIteratorImpl::ConnectorConstIteratorImpl(const ConnectorIteratorImpl& iterator) :
current_(iterator.current()) { }

ConnectorConstIteratorImpl::~ConnectorConstIteratorImpl() {
}

ConnectorConstIteratorImpl&
ConnectorConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ConnectorConstIteratorImpl
ConnectorConstIteratorImpl::operator++(int) {
  ConnectorConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

ConnectorConstIteratorImpl&
ConnectorConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

ConnectorConstIteratorImpl
ConnectorConstIteratorImpl::operator--(int) {
  ConnectorConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ConnectorConstIteratorImpl::operator==(const ConnectorConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ConnectorConstIteratorImpl::operator!=(const ConnectorConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Connector>&
ConnectorConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Connector>*
ConnectorConstIteratorImpl::operator->() const {
  return &(*current_);
}

ModelIteratorImpl::ModelIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->models_.begin() : iterated->models_.end())) { }

ModelIteratorImpl::~ModelIteratorImpl() {
}

ModelIteratorImpl&
ModelIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ModelIteratorImpl
ModelIteratorImpl::operator++(int) {
  ModelIteratorImpl previous = *this;
  current_++;
  return previous;
}

ModelIteratorImpl&
ModelIteratorImpl::operator--() {
  --current_;
  return *this;
}

ModelIteratorImpl
ModelIteratorImpl::operator--(int) {
  ModelIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ModelIteratorImpl::operator==(const ModelIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ModelIteratorImpl::operator!=(const ModelIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<Model>&
ModelIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<Model>*
ModelIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<Model> >::iterator
ModelIteratorImpl::current() const {
  return current_;
}

ConnectorIteratorImpl::ConnectorIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->connectors_.begin() : iterated->connectors_.end())) { }

ConnectorIteratorImpl::~ConnectorIteratorImpl() {
}

ConnectorIteratorImpl&
ConnectorIteratorImpl::operator++() {
  ++current_;
  return *this;
}

ConnectorIteratorImpl
ConnectorIteratorImpl::operator++(int) {
  ConnectorIteratorImpl previous = *this;
  current_++;
  return previous;
}

ConnectorIteratorImpl&
ConnectorIteratorImpl::operator--() {
  --current_;
  return *this;
}

ConnectorIteratorImpl
ConnectorIteratorImpl::operator--(int) {
  ConnectorIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
ConnectorIteratorImpl::operator==(const ConnectorIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
ConnectorIteratorImpl::operator!=(const ConnectorIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<Connector>&
ConnectorIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<Connector>*
ConnectorIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<Connector> >::iterator
ConnectorIteratorImpl::current() const {
  return current_;
}

MacroConnectorIteratorImpl::MacroConnectorIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroConnectors_.begin() : iterated->macroConnectors_.end())) { }

MacroConnectorIteratorImpl::~MacroConnectorIteratorImpl() {
}

MacroConnectorIteratorImpl&
MacroConnectorIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroConnectorIteratorImpl
MacroConnectorIteratorImpl::operator++(int) {
  MacroConnectorIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroConnectorIteratorImpl&
MacroConnectorIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroConnectorIteratorImpl
MacroConnectorIteratorImpl::operator--(int) {
  MacroConnectorIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroConnectorIteratorImpl::operator==(const MacroConnectorIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroConnectorIteratorImpl::operator!=(const MacroConnectorIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroConnector>&
MacroConnectorIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<MacroConnector>*
MacroConnectorIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<MacroConnector> >::iterator
MacroConnectorIteratorImpl::current() const {
  return current_;
}

MacroConnectorConstIteratorImpl::MacroConnectorConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroConnectors_.begin() : iterated->macroConnectors_.end())) { }

MacroConnectorConstIteratorImpl::~MacroConnectorConstIteratorImpl() {
}

MacroConnectorConstIteratorImpl::MacroConnectorConstIteratorImpl(const MacroConnectorIteratorImpl& iterator) :
current_(iterator.current()) { }

MacroConnectorConstIteratorImpl&
MacroConnectorConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroConnectorConstIteratorImpl
MacroConnectorConstIteratorImpl::operator++(int) {
  MacroConnectorConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroConnectorConstIteratorImpl&
MacroConnectorConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroConnectorConstIteratorImpl
MacroConnectorConstIteratorImpl::operator--(int) {
  MacroConnectorConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroConnectorConstIteratorImpl::operator==(const MacroConnectorConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroConnectorConstIteratorImpl::operator!=(const MacroConnectorConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroConnector>&
MacroConnectorConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<MacroConnector>*
MacroConnectorConstIteratorImpl::operator->() const {
  return &(current_->second);
}

MacroConnectIteratorImpl::MacroConnectIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroConnects_.begin() : iterated->macroConnects_.end())) { }

MacroConnectIteratorImpl::~MacroConnectIteratorImpl() {
}

MacroConnectIteratorImpl&
MacroConnectIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroConnectIteratorImpl
MacroConnectIteratorImpl::operator++(int) {
  MacroConnectIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroConnectIteratorImpl&
MacroConnectIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroConnectIteratorImpl
MacroConnectIteratorImpl::operator--(int) {
  MacroConnectIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroConnectIteratorImpl::operator==(const MacroConnectIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroConnectIteratorImpl::operator!=(const MacroConnectIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroConnect>&
MacroConnectIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<MacroConnect>*
MacroConnectIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<MacroConnect> >::iterator
MacroConnectIteratorImpl::current() const {
  return current_;
}

MacroConnectConstIteratorImpl::MacroConnectConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroConnects_.begin() : iterated->macroConnects_.end())) { }

MacroConnectConstIteratorImpl::~MacroConnectConstIteratorImpl() {
}

MacroConnectConstIteratorImpl::MacroConnectConstIteratorImpl(const MacroConnectIteratorImpl& iterator) :
current_(iterator.current()) { }

MacroConnectConstIteratorImpl&
MacroConnectConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroConnectConstIteratorImpl
MacroConnectConstIteratorImpl::operator++(int) {
  MacroConnectConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroConnectConstIteratorImpl&
MacroConnectConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroConnectConstIteratorImpl
MacroConnectConstIteratorImpl::operator--(int) {
  MacroConnectConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroConnectConstIteratorImpl::operator==(const MacroConnectConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroConnectConstIteratorImpl::operator!=(const MacroConnectConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroConnect>&
MacroConnectConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<MacroConnect>*
MacroConnectConstIteratorImpl::operator->() const {
  return &(*current_);
}

StaticRefIteratorImpl::StaticRefIteratorImpl(Model::Impl* iterated, bool begin) :
current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) { }

StaticRefIteratorImpl::StaticRefIteratorImpl(MacroStaticReference::Impl* iterated, bool begin) :
current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) { }

StaticRefIteratorImpl::~StaticRefIteratorImpl() {
}

StaticRefIteratorImpl&
StaticRefIteratorImpl::operator++() {
  ++current_;
  return *this;
}

StaticRefIteratorImpl
StaticRefIteratorImpl::operator++(int) {
  StaticRefIteratorImpl previous = *this;
  current_++;
  return previous;
}

StaticRefIteratorImpl&
StaticRefIteratorImpl::operator--() {
  --current_;
  return *this;
}

StaticRefIteratorImpl
StaticRefIteratorImpl::operator--(int) {
  StaticRefIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
StaticRefIteratorImpl::operator==(const StaticRefIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
StaticRefIteratorImpl::operator!=(const StaticRefIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<StaticRef>&
StaticRefIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<StaticRef>*
StaticRefIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<StaticRef> >::iterator
StaticRefIteratorImpl::current() const {
  return current_;
}

StaticRefConstIteratorImpl::StaticRefConstIteratorImpl(const Model::Impl* iterated, bool begin) :
current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) { }

StaticRefConstIteratorImpl::StaticRefConstIteratorImpl(const MacroStaticReference::Impl* iterated, bool begin) :
current_((begin ? iterated->staticRefs_.begin() : iterated->staticRefs_.end())) { }

StaticRefConstIteratorImpl::~StaticRefConstIteratorImpl() {
}

StaticRefConstIteratorImpl::StaticRefConstIteratorImpl(const StaticRefIteratorImpl& iterator) :
current_(iterator.current()) { }

StaticRefConstIteratorImpl&
StaticRefConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

StaticRefConstIteratorImpl
StaticRefConstIteratorImpl::operator++(int) {
  StaticRefConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

StaticRefConstIteratorImpl&
StaticRefConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

StaticRefConstIteratorImpl
StaticRefConstIteratorImpl::operator--(int) {
  StaticRefConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
StaticRefConstIteratorImpl::operator==(const StaticRefConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
StaticRefConstIteratorImpl::operator!=(const StaticRefConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<StaticRef>&
StaticRefConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<StaticRef>*
StaticRefConstIteratorImpl::operator->() const {
  return &(current_->second);
}


MacroStaticRefIteratorImpl::MacroStaticRefIteratorImpl(Model::Impl* iterated, bool begin) :
current_((begin ? iterated->macroStaticRefs_.begin() : iterated->macroStaticRefs_.end())) { }

MacroStaticRefIteratorImpl::~MacroStaticRefIteratorImpl() {
}

MacroStaticRefIteratorImpl&
MacroStaticRefIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroStaticRefIteratorImpl
MacroStaticRefIteratorImpl::operator++(int) {
  MacroStaticRefIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroStaticRefIteratorImpl&
MacroStaticRefIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroStaticRefIteratorImpl
MacroStaticRefIteratorImpl::operator--(int) {
  MacroStaticRefIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroStaticRefIteratorImpl::operator==(const MacroStaticRefIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroStaticRefIteratorImpl::operator!=(const MacroStaticRefIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroStaticRef>&
MacroStaticRefIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<MacroStaticRef>*
MacroStaticRefIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<MacroStaticRef> >::iterator
MacroStaticRefIteratorImpl::current() const {
  return current_;
}

MacroStaticRefConstIteratorImpl::MacroStaticRefConstIteratorImpl(const Model::Impl* iterated, bool begin) :
current_((begin ? iterated->macroStaticRefs_.begin() : iterated->macroStaticRefs_.end())) { }

MacroStaticRefConstIteratorImpl::~MacroStaticRefConstIteratorImpl() {
}

MacroStaticRefConstIteratorImpl::MacroStaticRefConstIteratorImpl(const MacroStaticRefIteratorImpl& iterator) :
current_(iterator.current()) { }

MacroStaticRefConstIteratorImpl&
MacroStaticRefConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroStaticRefConstIteratorImpl
MacroStaticRefConstIteratorImpl::operator++(int) {
  MacroStaticRefConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroStaticRefConstIteratorImpl&
MacroStaticRefConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroStaticRefConstIteratorImpl
MacroStaticRefConstIteratorImpl::operator--(int) {
  MacroStaticRefConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroStaticRefConstIteratorImpl::operator==(const MacroStaticRefConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroStaticRefConstIteratorImpl::operator!=(const MacroStaticRefConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroStaticRef>&
MacroStaticRefConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<MacroStaticRef>*
MacroStaticRefConstIteratorImpl::operator->() const {
  return &(current_->second);
}


MacroStaticReferenceIteratorImpl::MacroStaticReferenceIteratorImpl(DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroStaticReferences_.begin() : iterated->macroStaticReferences_.end())) { }

MacroStaticReferenceIteratorImpl::~MacroStaticReferenceIteratorImpl() {
}

MacroStaticReferenceIteratorImpl&
MacroStaticReferenceIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroStaticReferenceIteratorImpl
MacroStaticReferenceIteratorImpl::operator++(int) {
  MacroStaticReferenceIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroStaticReferenceIteratorImpl&
MacroStaticReferenceIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroStaticReferenceIteratorImpl
MacroStaticReferenceIteratorImpl::operator--(int) {
  MacroStaticReferenceIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroStaticReferenceIteratorImpl::operator==(const MacroStaticReferenceIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroStaticReferenceIteratorImpl::operator!=(const MacroStaticReferenceIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<MacroStaticReference>&
MacroStaticReferenceIteratorImpl::operator*() const {
  return current_->second;
}

shared_ptr<MacroStaticReference>*
MacroStaticReferenceIteratorImpl::operator->() const {
  return &(current_->second);
}

map<string, shared_ptr<MacroStaticReference> >::iterator
MacroStaticReferenceIteratorImpl::current() const {
  return current_;
}

MacroStaticReferenceConstIteratorImpl::MacroStaticReferenceConstIteratorImpl(const DynamicModelsCollection::Impl* iterated, bool begin) :
current_((begin ? iterated->macroStaticReferences_.begin() : iterated->macroStaticReferences_.end())) { }

MacroStaticReferenceConstIteratorImpl::~MacroStaticReferenceConstIteratorImpl() {
}

MacroStaticReferenceConstIteratorImpl::MacroStaticReferenceConstIteratorImpl(const MacroStaticReferenceIteratorImpl& iterator) :
current_(iterator.current()) { }

MacroStaticReferenceConstIteratorImpl&
MacroStaticReferenceConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

MacroStaticReferenceConstIteratorImpl
MacroStaticReferenceConstIteratorImpl::operator++(int) {
  MacroStaticReferenceConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

MacroStaticReferenceConstIteratorImpl&
MacroStaticReferenceConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

MacroStaticReferenceConstIteratorImpl
MacroStaticReferenceConstIteratorImpl::operator--(int) {
  MacroStaticReferenceConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
MacroStaticReferenceConstIteratorImpl::operator==(const MacroStaticReferenceConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
MacroStaticReferenceConstIteratorImpl::operator!=(const MacroStaticReferenceConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<MacroStaticReference>&
MacroStaticReferenceConstIteratorImpl::operator*() const {
  return current_->second;
}

const shared_ptr<MacroStaticReference>*
MacroStaticReferenceConstIteratorImpl::operator->() const {
  return &(current_->second);
}

}  // namespace dynamicdata
