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
 * @file  FSFinalStateCollectionFactory.h
 *
 * @brief Dynawo final state collection factory : header file
 *
 */
#ifndef API_FS_FSFINALSTATECOLLECTIONFACTORY_H_
#define API_FS_FSFINALSTATECOLLECTIONFACTORY_H_

#include <boost/shared_ptr.hpp>

#include "FSExport.h"

namespace finalState {
class FinalStateCollection;

class __DYNAWO_FS_EXPORT FinalStateCollectionFactory {
 public:
  /**
   * @brief create a new instance of final stat collection
   *
   * @param id
   * @return Final state collection
   */
  static boost::shared_ptr<FinalStateCollection> newInstance(const std::string& id);
  /**
   * @brief copy the final state collection
   *
   * @param original to copy
   * @return final state collection
   */
  static boost::shared_ptr<FinalStateCollection> copyInstance(boost::shared_ptr<FinalStateCollection> original);
  /**
   * @brief copy the final state collection
   *
   * @param original to copy
   * @return final state collection
   */
  static boost::shared_ptr<FinalStateCollection> copyInstance(const FinalStateCollection& original);
};  ///< Class for creation of Final State Coolection
}  // namespace finalState

#endif  // API_FS_FSFINALSTATECOLLECTIONFACTORY_H_
