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
#include <set>
#include <unordered_map>

using std::map;
using std::string;
using std::stringstream;
using std::vector;
using std::set;

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
  id << time << "_" << modelName << "_" << type << "_" << description;  // allow to sort constraint by time, then modelName and type

  if (constraintsById_.find(id.str()) == constraintsById_.end()) {
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

void
ConstraintsCollection::filter(DYN::ConstraintValueType_t filterType) {
  if (filterType == DYN::NO_CONSTRAINTS_FILTER)
    return;

  for (auto & modelIt : constraintsByModel_) {
    std::vector<std::shared_ptr<Constraint> > & constraints = modelIt.second;
    std::unordered_map<std::string, std::vector<std::shared_ptr<Constraint> > > constraintsByDescr;
    std::set<std::string> activeConstraints;

    for (std::shared_ptr<Constraint> & constraint : constraints) {
      const string & descr = constraint->getDescription();
      Type_t type = constraint->getType();

      if ((constraintsByDescr.find(descr) == constraintsByDescr.end()) || (activeConstraints.find(descr) == activeConstraints.end())) {  // open constraint
        if (type == CONSTRAINT_BEGIN) {
          constraintsByDescr[descr].push_back(constraint);
          activeConstraints.insert(descr);
        }
      } else if (filterType == DYN::CONSTRAINTS_DYNAFLOW) {
        std::shared_ptr<Constraint> & lastConstraint = constraintsByDescr[descr].back();
        if (lastConstraint->getData() && constraint->getData()) {  // update constraint by merging datas
          ConstraintData mergedData = lastConstraint->getData().get();
          if (!mergedData.valueMax)
            mergedData.valueMax = mergedData.value;
          mergedData.value = constraint->getData()->value;
          mergedData.valueMax = std::max(mergedData.valueMax.value(), mergedData.value);
          lastConstraint->setData(mergedData);
          lastConstraint->setTime(constraint->getTime());
        }
        if (type == CONSTRAINT_END)  // close constraint
          activeConstraints.erase(activeConstraints.find(descr));
      } else {
        if (type == CONSTRAINT_END) {  // classic mode, forget closed constraints
          constraintsByDescr.erase(constraintsByDescr.find(descr));
        } else if (filterType == DYN::CONSTRAINTS_KEEP_LAST) {  // replace constraint
          constraintsByDescr[descr].front() = constraint;
        }
      }
    }

    constraints.clear();
    for (auto & descrIt : constraintsByDescr)
      for (std::shared_ptr<Constraint> & constraint : descrIt.second)
        constraints.push_back(constraint);
  }

  // regenerate filtered constraintsById_
  constraintsById_.clear();
  stringstream idSs;
  for (auto & modelIt : constraintsByModel_)
    for (std::shared_ptr<Constraint> & constraint : modelIt.second) {
      idSs.str(std::string());
      idSs.clear();
      idSs << constraint->getTime() << "_" << modelIt.first << "_" << constraint->getType() << "_" << constraint->getDescription();
      constraintsById_[idSs.str()] = constraint;
    }
}

void
ConstraintsCollection::clear() {
  constraintsByModel_.clear();
  constraintsById_.clear();
}

}  // namespace constraints
