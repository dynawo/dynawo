//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file PARMacroParameterSet.cpp
 * @brief PARMacroParameterSet description : implementation file
 *
 */

#include "PARMacroParameterSet.h"
#include "PARReference.h"
#include "DYNMacrosMessage.h"

using boost::shared_ptr;
using std::map;
using std::string;
using std::vector;

namespace parameters {

MacroParameterSet::MacroParameterSet(const string& id) : id_(id) { }

const std::string&
MacroParameterSet::getId() const {
  return id_;
}

void
MacroParameterSet::addReference(boost::shared_ptr<Reference> reference) {
  std::string name = reference->getName();
  std::pair<std::map<std::string, boost::shared_ptr<Reference> >::iterator, bool> ret;
  ret = references_.emplace(name, reference);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ReferenceAlreadySetInMacroParameterSet, reference->getName(), getId());
}

void
MacroParameterSet::addParameter(boost::shared_ptr<Parameter> parameter) {
  std::string name = parameter->getName();
  std::pair<std::map<std::string, boost::shared_ptr<Parameter> >::iterator, bool> ret;
  ret = parameters_.emplace(name, parameter);
  if (!ret.second)
    throw DYNError(DYN::Error::API, ParameterAlreadySetInMacroParameterSet, parameter->getName(), getId());
}

MacroParameterSet::parameter_const_iterator::parameter_const_iterator(const MacroParameterSet* iterated, bool begin) :
current_((begin ? iterated->parameters_.begin() : iterated->parameters_.end())) { }

MacroParameterSet::parameter_const_iterator&
MacroParameterSet::parameter_const_iterator::operator++() {
  ++current_;
  return *this;
}

MacroParameterSet::parameter_const_iterator
MacroParameterSet::parameter_const_iterator::operator++(int) {
  MacroParameterSet::parameter_const_iterator previous = *this;
  current_++;
  return previous;
}

MacroParameterSet::parameter_const_iterator&
MacroParameterSet::parameter_const_iterator::operator--() {
  --current_;
  return *this;
}

MacroParameterSet::parameter_const_iterator
MacroParameterSet::parameter_const_iterator::operator--(int) {
  MacroParameterSet::parameter_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
MacroParameterSet::parameter_const_iterator::operator==(const MacroParameterSet::parameter_const_iterator& other) const {
  return current_ == other.current_;
}

bool
MacroParameterSet::parameter_const_iterator::operator!=(const MacroParameterSet::parameter_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Parameter>&
MacroParameterSet::parameter_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Parameter>*
MacroParameterSet::parameter_const_iterator::operator->() const {
  return &(current_->second);
}

MacroParameterSet::parameter_const_iterator
MacroParameterSet::cbeginParameter() const {
  return MacroParameterSet::parameter_const_iterator(this, true);
}

MacroParameterSet::parameter_const_iterator
MacroParameterSet::cendParameter() const {
  return MacroParameterSet::parameter_const_iterator(this, false);
}

// for Reference

MacroParameterSet::reference_const_iterator::reference_const_iterator(const MacroParameterSet* iterated, bool begin) :
current_((begin ? iterated->references_.begin() : iterated->references_.end())) { }

MacroParameterSet::reference_const_iterator&
MacroParameterSet::reference_const_iterator::operator++() {
  ++current_;
  return *this;
}

MacroParameterSet::reference_const_iterator
MacroParameterSet::reference_const_iterator::operator++(int) {
  MacroParameterSet::reference_const_iterator previous = *this;
  current_++;
  return previous;
}

bool
MacroParameterSet::reference_const_iterator::operator==(const MacroParameterSet::reference_const_iterator& other) const {
  return current_ == other.current_;
}

bool
MacroParameterSet::reference_const_iterator::operator!=(const MacroParameterSet::reference_const_iterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<Reference>&
MacroParameterSet::reference_const_iterator::operator*() const {
  return current_->second;
}

const shared_ptr<Reference>*
MacroParameterSet::reference_const_iterator::operator->() const {
  return &(current_->second);
}

MacroParameterSet::reference_const_iterator
MacroParameterSet::cbeginReference() const {
  return MacroParameterSet::reference_const_iterator(this, true);
}

MacroParameterSet::reference_const_iterator
MacroParameterSet::cendReference() const {
  return MacroParameterSet::reference_const_iterator(this, false);
}

}  // namespace parameters
