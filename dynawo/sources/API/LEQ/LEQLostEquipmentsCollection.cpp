//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file  LEQLostEquipmentsCollection.cpp
 *
 * @brief Dynawo lost equipments collection : implementation file
 *
 */
#include "LEQLostEquipmentsCollection.h"

#include "LEQLostEquipment.h"
#include "LEQLostEquipmentFactory.h"

using boost::shared_ptr;
using std::string;

namespace lostEquipments {

void
LostEquipmentsCollection::addLostEquipment(const string& id, const string& type) {
  shared_ptr<LostEquipment> lostEquipment = LostEquipmentFactory::newLostEquipment(id, type);
  lostEquipments_.insert(lostEquipment);
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator
LostEquipmentsCollection::cbegin() const {
  return LostEquipmentsCollection::LostEquipmentsCollectionConstIterator(this, true);
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator
LostEquipmentsCollection::cend() const {
  return LostEquipmentsCollection::LostEquipmentsCollectionConstIterator(this, false);
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::LostEquipmentsCollectionConstIterator(const LostEquipmentsCollection* iterated, bool begin) :
    current_((begin ? iterated->lostEquipments_.begin() : iterated->lostEquipments_.end())) {}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator&
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator++() {
  ++current_;
  return *this;
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator++(int) {
  const LostEquipmentsCollection::LostEquipmentsCollectionConstIterator previous = *this;
  current_++;
  return previous;
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator&
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator--() {
  --current_;
  return *this;
}

LostEquipmentsCollection::LostEquipmentsCollectionConstIterator
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator--(int) {
  const LostEquipmentsCollection::LostEquipmentsCollectionConstIterator previous = *this;
  current_--;
  return previous;
}

bool
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator==(
  const LostEquipmentsCollection::LostEquipmentsCollectionConstIterator& other) const {
  return current_ == other.current_;
}

bool
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator!=(
  const LostEquipmentsCollection::LostEquipmentsCollectionConstIterator& other) const {
  return current_ != other.current_;
}

const shared_ptr<LostEquipment>&
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator*() const {
  return *current_;
}

const shared_ptr<LostEquipment>*
LostEquipmentsCollection::LostEquipmentsCollectionConstIterator::operator->() const {
  return &(*current_);
}

}  // namespace lostEquipments
