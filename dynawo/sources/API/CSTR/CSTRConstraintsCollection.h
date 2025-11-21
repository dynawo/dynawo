// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
//
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  CSTRConstraintsCollection.h
 *
 * @brief Dynawo constraints : interface file
 *
 */

#ifndef API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
#define API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_

#include "CSTRConstraint.h"
#include "DYNEnumUtils.h"

#include <map>
#include <string>
#include <vector>
#include <memory>

namespace constraints {

/**
 * @class ConstraintsCollection
 * @brief contraints interface class
 *
 * Interface class for ContraintsCollection object. This a container for constraints
 */
class ConstraintsCollection {
 public:
  /**
   * @brief constructor
   *
   * @param id ConstraintsCollection's id
   */
  explicit ConstraintsCollection(const std::string& id);

  /**
   * @brief Add a constraint to the collection
   *
   * @param modelName model where the constraint occurs
   * @param description description of the constraint
   * @param time time when the constraint occurs
   * @param type begin/end
   * @param modelType type of the model
   * @param data the constraint data to add
   */
  void addConstraint(const std::string& modelName, const std::string& description,
    const double& time, Type_t type,
    const std::string& modelType = "",
    const boost::optional<ConstraintData>& data = boost::none);

  /**
   * @brief filter the constraint collection by removing constraints cancelled during the simulation
   *
   * @param type filter type
   */
  void filter(DYN::ConstraintValueType_t type);

 public:
  /**
  * @brief get constraints by model
  *
  * @return constraints by model
  */
  const std::map<std::string, std::vector<std::shared_ptr<Constraint> > >& getConstraintsByModel() const {
    return constraintsByModel_;
  }

  /**
  * @brief get constraints by id
  *
  * @return constraints by id
  */
  const std::map<std::string, std::shared_ptr<Constraint> >& getConstraintsById() const {
    return constraintsById_;
  }

  /**
  * @brief empty constraint collection
  */
  void clear();

  /**
   * @brief Build a string id from constraint details
   *
   * @param modelName model where the constraint occurs
   * @param description description of the constraint
   * @param time time when the constraint occurs
   * @param type begin/end
   * @return the sortable id string
   */
  std::string idFromDetails(const std::string & modelName, const std::string & description, const double & time, Type_t type) const;


 private:
  std::string id_;                                                                        ///< ConstraintCollection's id
  std::map<std::string, std::vector<std::shared_ptr<Constraint> > > constraintsByModel_;  ///< constraint sorted by model
  std::map<std::string, std::shared_ptr<Constraint> > constraintsById_;                   ///< constraint sorted by id
};

}  // end of namespace constraints

#endif  // API_CSTR_CSTRCONSTRAINTSCOLLECTION_H_
