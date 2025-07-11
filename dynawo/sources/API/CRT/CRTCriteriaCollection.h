//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#ifndef API_CRT_CRTCRITERIACOLLECTION_H_
#define API_CRT_CRTCRITERIACOLLECTION_H_

#include "CRTCriteria.h"

#include <string>


namespace criteria {
/**
 * @class CriteriaCollection
 * @brief Criteria collection interface class
 *
 * Interface class for criteria collection object. This a container for criteria
 */
class CriteriaCollection {
 public:
  /**
  * define type of components
  */
  typedef enum { BUS, LOAD, GENERATOR } CriteriaCollectionType_t;  ///< components type

 public:
  /**
   * @brief add a criteria to the collection
   *
   * @param type type of component this criteria applies to
   * @param criteria criteria to add to the collection
   */
  void add(CriteriaCollectionType_t type, const std::shared_ptr<Criteria>& criteria);

  /**
   * @brief merge this collection with the other one
   *
   * @param other another criteria collection
   */
  void merge(const std::shared_ptr<CriteriaCollection>& other);

  /**
  * @brief get bus criteria
  *
  * @return bus criteria
  */
  const std::vector<std::shared_ptr<Criteria> >& getBusCriteria() const {
    return busCriteria_;
  }

  /**
  * @brief get load criteria
  *
  * @return load criteria
  */
  const std::vector<std::shared_ptr<Criteria> >& getLoadCriteria() const {
    return loadCriteria_;
  }

  /**
  * @brief get generator criteria
  *
  * @return generator criteria
  */
  const std::vector<std::shared_ptr<Criteria> >& getGeneratorCriteria() const {
    return generatorCriteria_;
  }

 private:
  std::vector<std::shared_ptr<Criteria> > busCriteria_;        ///< Vector of the bus criteria object
  std::vector<std::shared_ptr<Criteria> > loadCriteria_;       ///< Vector of the load criteria object
  std::vector<std::shared_ptr<Criteria> > generatorCriteria_;  ///< Vector of the generator criteria object
};

}  // namespace criteria

#endif  // API_CRT_CRTCRITERIACOLLECTION_H_
