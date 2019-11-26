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
 * @file  FSIterators.cpp
 *
 * @brief Final state iterators : implementation file
 *
 */
#include "FSIteratorsImpl.h"

using boost::shared_ptr;
using std::vector;

namespace finalState {

ModelConstIteratorImpl::ModelConstIteratorImpl(const FinalStateCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->models_.begin() : iterated->models_.end());
}

ModelConstIteratorImpl::ModelConstIteratorImpl(const FinalStateModel::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->subModels_.begin() : iterated->subModels_.end());
}

ModelConstIteratorImpl::ModelConstIteratorImpl(const ModelIteratorImpl& iterator) {
  current_ = iterator.current();
}

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

const shared_ptr<FinalStateModel>&
ModelConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<FinalStateModel>*
ModelConstIteratorImpl::operator->() const {
  return &(*current_);
}

VariableConstIteratorImpl::VariableConstIteratorImpl(const FinalStateCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariableConstIteratorImpl::VariableConstIteratorImpl(const FinalStateModel::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariableConstIteratorImpl::VariableConstIteratorImpl(const VariableIteratorImpl& iterator) {
  current_ = iterator.current();
}

VariableConstIteratorImpl::~VariableConstIteratorImpl() {
}

VariableConstIteratorImpl&
VariableConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

VariableConstIteratorImpl
VariableConstIteratorImpl::operator++(int) {
  VariableConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

VariableConstIteratorImpl&
VariableConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

VariableConstIteratorImpl
VariableConstIteratorImpl::operator--(int) {
  VariableConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
VariableConstIteratorImpl::operator==(const VariableConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
VariableConstIteratorImpl::operator!=(const VariableConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const shared_ptr<Variable>&
VariableConstIteratorImpl::operator*() const {
  return *current_;
}

const shared_ptr<Variable>*
VariableConstIteratorImpl::operator->() const {
  return &(*current_);
}

ModelIteratorImpl::ModelIteratorImpl(FinalStateCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->models_.begin() : iterated->models_.end());
}

ModelIteratorImpl::ModelIteratorImpl(FinalStateModel::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->subModels_.begin() : iterated->subModels_.end());
}

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

shared_ptr<FinalStateModel>&
ModelIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<FinalStateModel>*
ModelIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<FinalStateModel> >::iterator
ModelIteratorImpl::current() const {
  return current_;
}

VariableIteratorImpl::VariableIteratorImpl(FinalStateCollection::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariableIteratorImpl::VariableIteratorImpl(FinalStateModel::Impl* iterated, bool begin) {
  current_ = (begin ? iterated->variables_.begin() : iterated->variables_.end());
}

VariableIteratorImpl::~VariableIteratorImpl() {
}

VariableIteratorImpl&
VariableIteratorImpl::operator++() {
  ++current_;
  return *this;
}

VariableIteratorImpl
VariableIteratorImpl::operator++(int) {
  VariableIteratorImpl previous = *this;
  current_++;
  return previous;
}

VariableIteratorImpl&
VariableIteratorImpl::operator--() {
  --current_;
  return *this;
}

VariableIteratorImpl
VariableIteratorImpl::operator--(int) {
  VariableIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
VariableIteratorImpl::operator==(const VariableIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
VariableIteratorImpl::operator!=(const VariableIteratorImpl& other) const {
  return current_ != other.current_;
}

shared_ptr<Variable>&
VariableIteratorImpl::operator*() const {
  return *current_;
}

shared_ptr<Variable>*
VariableIteratorImpl::operator->() const {
  return &(*current_);
}

vector<shared_ptr<Variable> >::iterator
VariableIteratorImpl::current() const {
  return current_;
}

}  // namespace finalState
