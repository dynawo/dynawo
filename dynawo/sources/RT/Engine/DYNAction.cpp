//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
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
 * @file  DYNAction.cpp
 *
 * @brief Event interractor
 *
 */

#include "DYNTrace.h"

#include "DYNAction.h"

namespace DYN {

Action::Action(boost::shared_ptr<SubModel>& subModel, std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>>& parameterValueSet) :
subModel_(subModel),
parameterValueSet_(parameterValueSet) { }

void
Action::apply() {
  for (auto& parameterTuple : parameterValueSet_) {
    switch (std::get<2>(parameterTuple)) {
      case VAR_TYPE_DOUBLE: {
        subModel_->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<double>(std::get<1>(parameterTuple)), false);
        break;
      }
      case VAR_TYPE_INT: {
        subModel_->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<int>(std::get<1>(parameterTuple)), false);
        break;
      }
      case VAR_TYPE_BOOL: {
        subModel_->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<bool>(std::get<1>(parameterTuple)), false);
        break;
      }
      case VAR_TYPE_STRING: {
        subModel_->setParameterValue(std::get<0>(parameterTuple), DYN::FINAL, boost::any_cast<std::string>(std::get<1>(parameterTuple)), false);
        break;
      }
      default:
      {
        throw DYNError(Error::MODELER, ParameterBadType, std::get<0>(parameterTuple));
      }
    }
  }
  subModel_->setSubModelParameters();
  Trace::info() << "Action: SubModel " << subModel_->name() << " parameters updated" << Trace::endline;
}

void
Action::updateParameterValueSet(std::vector<std::tuple<std::string, boost::any, DYN::typeVarC_t>>& newParameterValueSet) {
  parameterValueSet_.insert(parameterValueSet_.end(), newParameterValueSet.begin(), newParameterValueSet.end());
}

}  // end of namespace DYN
