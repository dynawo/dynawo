//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools
// for power systems.
//

/**
 * @file  DYNDataInterfaceIIDM.hpp
 *
 * @brief Implementation of methods of template class
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_HPP_

#include <boost/pointer_cast.hpp>

namespace DYN {

template<typename T> void
DataInterfaceIIDM::configureQuadripoleCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria) {
  for (const auto& quadripoleCriteria : criteria->getQuadripoleCriteria()) {
    if (!QuadripoleCriteria<T>::criteriaEligibleForQuadripole(quadripoleCriteria->getParams())) continue;
    std::unique_ptr<QuadripoleCriteria<T>> dynCriteria = std::unique_ptr<QuadripoleCriteria<T>>(new QuadripoleCriteria<T>(quadripoleCriteria->getParams()));
    if (quadripoleCriteria->begin() != quadripoleCriteria->end()) {
      for (criteria::Criteria::component_id_const_iterator cmpIt = quadripoleCriteria->begin(),
          cmpItEnd = quadripoleCriteria->end();
          cmpIt != cmpItEnd; ++cmpIt) {
        std::shared_ptr<T> quadripole;
        std::unordered_map<std::string, std::shared_ptr<ComponentInterface> >::const_iterator quadripoleItfIter = components_.find(cmpIt->getId());
        if (quadripoleItfIter != components_.end()) {
          const std::shared_ptr<ComponentInterface>& cmp = quadripoleItfIter->second;
          if (cmp->getType() != ComponentInterface::LINE && cmp->getType() != ComponentInterface::TWO_WTFO) {
            Trace::warn() << DYNLog(WrongComponentType, cmpIt->getId(), "quadripole (line or transformer)") << Trace::endline;
            continue;
          }
          if (cmp->getType() != T::derivedType()) {
            continue;
          }
          quadripole = boost::dynamic_pointer_cast<T>(cmp);
          assert(quadripole);
        } else {
          Trace::warn() << DYNLog(ComponentNotFound, cmpIt->getId()) << Trace::endline;
          continue;
        }
        dynCriteria->addQuadripole(quadripole);
      }
    } else {
      continue;
    }
    if (!dynCriteria->empty()) {
      criteria_.push_back(std::move(dynCriteria));
    }
  }
}

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_HPP_
