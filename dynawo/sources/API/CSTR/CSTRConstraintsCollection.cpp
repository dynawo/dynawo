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
 * @file  CSTRConstraintsCollection.cpp
 *
 * @brief Dynawo constraints : implementation file
 *
 */
#include "CSTRConstraintsCollection.h"

#include "CSTRConstraint.h"
#include "CSTRConstraintFactory.h"

#include <iostream>
#include <sstream>

using std::map;
using std::string;
using std::stringstream;
using std::vector;

namespace constraints {

ConstraintsCollection::ConstraintsCollection(const string& id) : id_(id) {}

void
ConstraintsCollection::addConstraint(
  const string& modelName,
  const string& description,
  const double& time,
  Type_t type,
  const string& modelType,
  const boost::optional<constraints::ConstraintData>& data) {
  stringstream id;
  id << time << "_" << modelName << "_" << description;  // allow to sort constraint by time, then modelName

  // find if a constraint of same description already exists
  // if this is the case, if type are different (and the first is begin), erase constraints of this description
  bool addConstraint = true;
  const auto iter = constraintsByModel_.find(modelName);
  if (iter == constraintsByModel_.end()) {
    constraintsByModel_[modelName] = vector<std::shared_ptr<Constraint> >();
  } else {
    vector<std::shared_ptr<Constraint> > constraints = iter->second;
    stringstream oldId;
    for (unsigned int i = 0; i < constraints.size(); ++i) {
      const string& oldDescription = constraints[i]->getDescription();
      Type_t oldType = constraints[i]->getType();
      double oldTime = constraints[i]->getTime();
      oldId.str("");
      oldId.clear();
      oldId << oldTime << "_" << modelName << "_" << oldDescription;
      if (oldDescription == description && oldType == CONSTRAINT_BEGIN && type == CONSTRAINT_END) {
        addConstraint = false;
        // remove in map
        iter->second.erase(iter->second.begin() + i);
        constraintsById_.erase(oldId.str());
        break;
      }
    }
  }

  if (addConstraint) {
    std::shared_ptr<Constraint> constraint = ConstraintFactory::newConstraint();
    constraint->setModelName(modelName);
    constraint->setDescription(description);
    constraint->setTime(time);
    constraint->setType(type);
    constraint->setData(data);
    constraint->setModelType(modelType);
    constraintsByModel_[modelName].push_back(constraint);
    constraintsById_[id.str()] = constraint;
  }
}

}  // namespace constraints
