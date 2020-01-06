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
 * @brief Dynamic data iterators: implementation file
 *
 * Iterators can be on models or connectors
 * container. They can be const or not
 */
#include "DYDIterators.h"
#include "DYDIteratorsImpl.h"

using boost::shared_ptr;

namespace dynamicdata {

dynamicModel_const_iterator::dynamicModel_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin):
impl_(new ModelConstIteratorImpl(iterated, begin)) { }

dynamicModel_const_iterator::dynamicModel_const_iterator(const dynamicModel_const_iterator& original) :
impl_(new ModelConstIteratorImpl(*(original.impl_))) { }

dynamicModel_const_iterator::dynamicModel_const_iterator(const dynamicModel_iterator& original) :
impl_(new ModelConstIteratorImpl(*(original.impl()))) { }

dynamicModel_const_iterator::~dynamicModel_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

dynamicModel_const_iterator&
dynamicModel_const_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ModelConstIteratorImpl(*(other.impl_));
  return *this;
}

dynamicModel_const_iterator&
dynamicModel_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

dynamicModel_const_iterator
dynamicModel_const_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

dynamicModel_const_iterator&
dynamicModel_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

dynamicModel_const_iterator
dynamicModel_const_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
dynamicModel_const_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
dynamicModel_const_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Model>&
dynamicModel_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Model>*
dynamicModel_const_iterator::operator->() const {
  return impl_->operator->();
}

connector_const_iterator::connector_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new ConnectorConstIteratorImpl(iterated, begin)) { }

connector_const_iterator::connector_const_iterator(const connector_const_iterator& original) :
impl_(new ConnectorConstIteratorImpl(*(original.impl_))) { }

connector_const_iterator::connector_const_iterator(const connector_iterator& original) :
impl_(new ConnectorConstIteratorImpl(*(original.impl()))) { }

connector_const_iterator::~connector_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

connector_const_iterator&
connector_const_iterator::operator=(const connector_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ConnectorConstIteratorImpl(*(other.impl_));
  return *this;
}

connector_const_iterator&
connector_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

connector_const_iterator
connector_const_iterator::operator++(int) {
  connector_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

connector_const_iterator&
connector_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

connector_const_iterator
connector_const_iterator::operator--(int) {
  connector_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
connector_const_iterator::operator==(const connector_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
connector_const_iterator::operator!=(const connector_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Connector>&
connector_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Connector>*
connector_const_iterator::operator->() const {
  return impl_->operator->();
}

dynamicModel_iterator::dynamicModel_iterator(DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new ModelIteratorImpl(iterated, begin)) { }

dynamicModel_iterator::dynamicModel_iterator(const THIS& original) :
impl_(new ModelIteratorImpl(*(original.impl_))) { }

dynamicModel_iterator::~dynamicModel_iterator() {
  delete impl_;
  impl_ = NULL;
}

dynamicModel_iterator&
dynamicModel_iterator::operator=(const THIS& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ModelIteratorImpl(*(other.impl_));
  return *this;
}

dynamicModel_iterator&
dynamicModel_iterator::operator++() {
  ++(*impl_);
  return *this;
}

dynamicModel_iterator
dynamicModel_iterator::operator++(int) {
  THIS previous = *this;
  (*impl_)++;
  return previous;
}

dynamicModel_iterator&
dynamicModel_iterator::operator--() {
  --(*impl_);
  return *this;
}

dynamicModel_iterator
dynamicModel_iterator::operator--(int) {
  THIS previous = *this;
  (*impl_)--;
  return previous;
}

bool
dynamicModel_iterator::operator==(const THIS& other) const {
  return *impl_ == *(other.impl_);
}

bool
dynamicModel_iterator::operator!=(const THIS& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Model>&
dynamicModel_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Model>*
dynamicModel_iterator::operator->() const {
  return impl_->operator->();
}

ModelIteratorImpl*
dynamicModel_iterator::impl() const {
  return impl_;
}

connector_iterator::connector_iterator(DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new ConnectorIteratorImpl(iterated, begin)) { }

connector_iterator::connector_iterator(const connector_iterator& original) :
impl_(new ConnectorIteratorImpl(*(original.impl_))) { }

connector_iterator::~connector_iterator() {
  delete impl_;
  impl_ = NULL;
}

connector_iterator&
connector_iterator::operator=(const connector_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new ConnectorIteratorImpl(*(other.impl_));
  return *this;
}

connector_iterator&
connector_iterator::operator++() {
  ++(*impl_);
  return *this;
}

connector_iterator
connector_iterator::operator++(int) {
  connector_iterator previous = *this;
  (*impl_)++;
  return previous;
}

connector_iterator&
connector_iterator::operator--() {
  --(*impl_);
  return *this;
}

connector_iterator
connector_iterator::operator--(int) {
  connector_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
connector_iterator::operator==(const connector_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
connector_iterator::operator!=(const connector_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<Connector>&
connector_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<Connector>*
connector_iterator::operator->() const {
  return impl_->operator->();
}

ConnectorIteratorImpl*
connector_iterator::impl() const {
  return impl_;
}

macroConnector_iterator::macroConnector_iterator(DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroConnectorIteratorImpl(iterated, begin)) { }

macroConnector_iterator::macroConnector_iterator(const macroConnector_iterator& original) :
impl_(new MacroConnectorIteratorImpl(*(original.impl_))) { }

macroConnector_iterator::~macroConnector_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroConnector_iterator&
macroConnector_iterator::operator=(const macroConnector_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroConnectorIteratorImpl(*(other.impl_));
  return *this;
}

macroConnector_iterator&
macroConnector_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroConnector_iterator
macroConnector_iterator::operator++(int) {
  macroConnector_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroConnector_iterator&
macroConnector_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroConnector_iterator
macroConnector_iterator::operator--(int) {
  macroConnector_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroConnector_iterator::operator==(const macroConnector_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroConnector_iterator::operator!=(const macroConnector_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<MacroConnector>&
macroConnector_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<MacroConnector>*
macroConnector_iterator::operator->() const {
  return impl_->operator->();
}

MacroConnectorIteratorImpl*
macroConnector_iterator::impl() const {
  return impl_;
}

macroConnector_const_iterator::macroConnector_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroConnectorConstIteratorImpl(iterated, begin)) { }

macroConnector_const_iterator::macroConnector_const_iterator(const macroConnector_const_iterator& original) :
impl_(new MacroConnectorConstIteratorImpl(*(original.impl_))) { }

macroConnector_const_iterator::macroConnector_const_iterator(const macroConnector_iterator& original) :
impl_(new MacroConnectorConstIteratorImpl(*(original.impl()))) { }

macroConnector_const_iterator::~macroConnector_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroConnector_const_iterator&
macroConnector_const_iterator::operator=(const macroConnector_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroConnectorConstIteratorImpl(*(other.impl_));
  return *this;
}

macroConnector_const_iterator&
macroConnector_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroConnector_const_iterator
macroConnector_const_iterator::operator++(int) {
  macroConnector_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroConnector_const_iterator&
macroConnector_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroConnector_const_iterator
macroConnector_const_iterator::operator--(int) {
  macroConnector_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroConnector_const_iterator::operator==(const macroConnector_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroConnector_const_iterator::operator!=(const macroConnector_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<MacroConnector>&
macroConnector_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<MacroConnector>*
macroConnector_const_iterator::operator->() const {
  return impl_->operator->();
}

macroConnect_iterator::macroConnect_iterator(DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroConnectIteratorImpl(iterated, begin)) { }

macroConnect_iterator::macroConnect_iterator(const macroConnect_iterator& original) :
impl_(new MacroConnectIteratorImpl(*(original.impl_))) { }

macroConnect_iterator::~macroConnect_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroConnect_iterator&
macroConnect_iterator::operator=(const macroConnect_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroConnectIteratorImpl(*(other.impl_));
  return *this;
}

macroConnect_iterator&
macroConnect_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroConnect_iterator
macroConnect_iterator::operator++(int) {
  macroConnect_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroConnect_iterator&
macroConnect_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroConnect_iterator
macroConnect_iterator::operator--(int) {
  macroConnect_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroConnect_iterator::operator==(const macroConnect_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroConnect_iterator::operator!=(const macroConnect_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<MacroConnect>&
macroConnect_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<MacroConnect>*
macroConnect_iterator::operator->() const {
  return impl_->operator->();
}

MacroConnectIteratorImpl*
macroConnect_iterator::impl() const {
  return impl_;
}

macroConnect_const_iterator::macroConnect_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroConnectConstIteratorImpl(iterated, begin)) { }

macroConnect_const_iterator::macroConnect_const_iterator(const macroConnect_const_iterator& original) :
impl_(new MacroConnectConstIteratorImpl(*(original.impl_))) { }

macroConnect_const_iterator::macroConnect_const_iterator(const macroConnect_iterator& original) :
impl_(new MacroConnectConstIteratorImpl(*(original.impl()))) { }

macroConnect_const_iterator::~macroConnect_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroConnect_const_iterator&
macroConnect_const_iterator::operator=(const macroConnect_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroConnectConstIteratorImpl(*(other.impl_));
  return *this;
}

macroConnect_const_iterator&
macroConnect_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroConnect_const_iterator
macroConnect_const_iterator::operator++(int) {
  macroConnect_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroConnect_const_iterator&
macroConnect_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroConnect_const_iterator
macroConnect_const_iterator::operator--(int) {
  macroConnect_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroConnect_const_iterator::operator==(const macroConnect_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroConnect_const_iterator::operator!=(const macroConnect_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<MacroConnect>&
macroConnect_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<MacroConnect>*
macroConnect_const_iterator::operator->() const {
  return impl_->operator->();
}

staticRef_iterator::staticRef_iterator(Model::Impl* iterated, bool begin) :
impl_(new StaticRefIteratorImpl(iterated, begin)) { }

staticRef_iterator::staticRef_iterator(MacroStaticReference::Impl* iterated, bool begin) :
impl_(new StaticRefIteratorImpl(iterated, begin)) { }

staticRef_iterator::staticRef_iterator(const staticRef_iterator& original) :
impl_(new StaticRefIteratorImpl(*(original.impl_))) { }

staticRef_iterator::~staticRef_iterator() {
  delete impl_;
  impl_ = NULL;
}

staticRef_iterator&
staticRef_iterator::operator=(const staticRef_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new StaticRefIteratorImpl(*(other.impl_));
  return *this;
}

staticRef_iterator&
staticRef_iterator::operator++() {
  ++(*impl_);
  return *this;
}

staticRef_iterator
staticRef_iterator::operator++(int) {
  staticRef_iterator previous = *this;
  (*impl_)++;
  return previous;
}

staticRef_iterator&
staticRef_iterator::operator--() {
  --(*impl_);
  return *this;
}

staticRef_iterator
staticRef_iterator::operator--(int) {
  staticRef_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
staticRef_iterator::operator==(const staticRef_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
staticRef_iterator::operator!=(const staticRef_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<StaticRef>&
staticRef_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<StaticRef>*
staticRef_iterator::operator->() const {
  return impl_->operator->();
}

StaticRefIteratorImpl*
staticRef_iterator::impl() const {
  return impl_;
}

staticRef_const_iterator::staticRef_const_iterator(const Model::Impl* iterated, bool begin) :
impl_(new StaticRefConstIteratorImpl(iterated, begin)) { }

staticRef_const_iterator::staticRef_const_iterator(const MacroStaticReference::Impl* iterated, bool begin) :
impl_(new StaticRefConstIteratorImpl(iterated, begin)) { }

staticRef_const_iterator::staticRef_const_iterator(const staticRef_const_iterator& original) :
impl_(new StaticRefConstIteratorImpl(*(original.impl_))) { }

staticRef_const_iterator::staticRef_const_iterator(const staticRef_iterator& original) :
impl_(new StaticRefConstIteratorImpl(*(original.impl()))) { }

staticRef_const_iterator::~staticRef_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

staticRef_const_iterator&
staticRef_const_iterator::operator=(const staticRef_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new StaticRefConstIteratorImpl(*(other.impl_));
  return *this;
}

staticRef_const_iterator&
staticRef_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

staticRef_const_iterator
staticRef_const_iterator::operator++(int) {
  staticRef_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

staticRef_const_iterator&
staticRef_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

staticRef_const_iterator
staticRef_const_iterator::operator--(int) {
  staticRef_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
staticRef_const_iterator::operator==(const staticRef_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
staticRef_const_iterator::operator!=(const staticRef_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<StaticRef>&
staticRef_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<StaticRef>*
staticRef_const_iterator::operator->() const {
  return impl_->operator->();
}

macroStaticRef_iterator::macroStaticRef_iterator(Model::Impl* iterated, bool begin) :
impl_(new MacroStaticRefIteratorImpl(iterated, begin)) { }

macroStaticRef_iterator::macroStaticRef_iterator(const macroStaticRef_iterator& original) :
impl_(new MacroStaticRefIteratorImpl(*(original.impl_))) { }

macroStaticRef_iterator::~macroStaticRef_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroStaticRef_iterator&
macroStaticRef_iterator::operator=(const macroStaticRef_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroStaticRefIteratorImpl(*(other.impl_));
  return *this;
}

macroStaticRef_iterator&
macroStaticRef_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroStaticRef_iterator
macroStaticRef_iterator::operator++(int) {
  macroStaticRef_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroStaticRef_iterator&
macroStaticRef_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroStaticRef_iterator
macroStaticRef_iterator::operator--(int) {
  macroStaticRef_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroStaticRef_iterator::operator==(const macroStaticRef_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroStaticRef_iterator::operator!=(const macroStaticRef_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<MacroStaticRef>&
macroStaticRef_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<MacroStaticRef>*
macroStaticRef_iterator::operator->() const {
  return impl_->operator->();
}

MacroStaticRefIteratorImpl*
macroStaticRef_iterator::impl() const {
  return impl_;
}

macroStaticRef_const_iterator::macroStaticRef_const_iterator(const Model::Impl* iterated, bool begin) :
impl_(new MacroStaticRefConstIteratorImpl(iterated, begin)) { }

macroStaticRef_const_iterator::macroStaticRef_const_iterator(const macroStaticRef_const_iterator& original) :
impl_(new MacroStaticRefConstIteratorImpl(*(original.impl_))) { }

macroStaticRef_const_iterator::macroStaticRef_const_iterator(const macroStaticRef_iterator& original) :
impl_(new MacroStaticRefConstIteratorImpl(*(original.impl()))) { }

macroStaticRef_const_iterator::~macroStaticRef_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroStaticRef_const_iterator&
macroStaticRef_const_iterator::operator=(const macroStaticRef_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroStaticRefConstIteratorImpl(*(other.impl_));
  return *this;
}

macroStaticRef_const_iterator&
macroStaticRef_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroStaticRef_const_iterator
macroStaticRef_const_iterator::operator++(int) {
  macroStaticRef_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroStaticRef_const_iterator&
macroStaticRef_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroStaticRef_const_iterator
macroStaticRef_const_iterator::operator--(int) {
  macroStaticRef_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroStaticRef_const_iterator::operator==(const macroStaticRef_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroStaticRef_const_iterator::operator!=(const macroStaticRef_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<MacroStaticRef>&
macroStaticRef_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<MacroStaticRef>*
macroStaticRef_const_iterator::operator->() const {
  return impl_->operator->();
}

macroStaticReference_iterator::macroStaticReference_iterator(DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroStaticReferenceIteratorImpl(iterated, begin)) { }

macroStaticReference_iterator::macroStaticReference_iterator(const macroStaticReference_iterator& original) :
impl_(new MacroStaticReferenceIteratorImpl(*(original.impl_))) { }

macroStaticReference_iterator::~macroStaticReference_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroStaticReference_iterator&
macroStaticReference_iterator::operator=(const macroStaticReference_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroStaticReferenceIteratorImpl(*(other.impl_));
  return *this;
}

macroStaticReference_iterator&
macroStaticReference_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroStaticReference_iterator
macroStaticReference_iterator::operator++(int) {
  macroStaticReference_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroStaticReference_iterator&
macroStaticReference_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroStaticReference_iterator
macroStaticReference_iterator::operator--(int) {
  macroStaticReference_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroStaticReference_iterator::operator==(const macroStaticReference_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroStaticReference_iterator::operator!=(const macroStaticReference_iterator& other) const {
  return *impl_ != *(other.impl_);
}

shared_ptr<MacroStaticReference>&
macroStaticReference_iterator::operator*() const {
  return *(*impl_);
}

shared_ptr<MacroStaticReference>*
macroStaticReference_iterator::operator->() const {
  return impl_->operator->();
}

MacroStaticReferenceIteratorImpl*
macroStaticReference_iterator::impl() const {
  return impl_;
}

macroStaticReference_const_iterator::macroStaticReference_const_iterator(const DynamicModelsCollection::Impl* iterated, bool begin) :
impl_(new MacroStaticReferenceConstIteratorImpl(iterated, begin)) { }

macroStaticReference_const_iterator::macroStaticReference_const_iterator(const macroStaticReference_const_iterator& original) :
impl_(new MacroStaticReferenceConstIteratorImpl(*(original.impl_))) { }

macroStaticReference_const_iterator::macroStaticReference_const_iterator(const macroStaticReference_iterator& original) :
impl_(new MacroStaticReferenceConstIteratorImpl(*(original.impl()))) { }

macroStaticReference_const_iterator::~macroStaticReference_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

macroStaticReference_const_iterator&
macroStaticReference_const_iterator::operator=(const macroStaticReference_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new MacroStaticReferenceConstIteratorImpl(*(other.impl_));
  return *this;
}


macroStaticReference_const_iterator&
macroStaticReference_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

macroStaticReference_const_iterator
macroStaticReference_const_iterator::operator++(int) {
  macroStaticReference_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

macroStaticReference_const_iterator&
macroStaticReference_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

macroStaticReference_const_iterator
macroStaticReference_const_iterator::operator--(int) {
  macroStaticReference_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
macroStaticReference_const_iterator::operator==(const macroStaticReference_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
macroStaticReference_const_iterator::operator!=(const macroStaticReference_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<MacroStaticReference>&
macroStaticReference_const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<MacroStaticReference>*
macroStaticReference_const_iterator::operator->() const {
  return impl_->operator->();
}

}  // namespace dynamicdata
