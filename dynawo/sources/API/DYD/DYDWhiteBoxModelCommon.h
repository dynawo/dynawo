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

#ifndef API_DYD_DYDWHITEBOXMODELCOMMON_H_
#define API_DYD_DYDWHITEBOXMODELCOMMON_H_

#include "DYDUnitDynamicModel.h"

#include <map>
#include <string>
#include <memory>

namespace dynamicdata {

/**
 * @brief build the connection id from the model and variable names
 *
 * @param[in] model1 First model to connect
 * @param[in] var1 First model var to connect
 * @param[in] model2 Second model to connect
 * @param[in] var2 Second model var to connect
 * @param[in] id name of the parent model
 * @param[in] unitDynamicModelsMap Modelica models contained in the parent model
 *
 * @returns connection id
 */
std::string getConnectionId(const std::string& model1, const std::string& var1, const std::string& model2, const std::string& var2, const std::string& id,
                            const std::map<std::string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap);

/**
 * @brief build the macro connection id from the model names
 *
 * @param[in] model1 First model to connect
 * @param[in] model2 Second model to connect
 * @param[in] id name of the parent model
 * @param[in] unitDynamicModelsMap Modelica models contained in the parent model
 *
 * @returns connection id
 */
std::string getMacroConnectionId(const std::string& model1, const std::string& model2, const std::string& id,
                                 const std::map<std::string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap);

}  // namespace dynamicdata

#endif  // API_DYD_DYDWHITEBOXMODELCOMMON_H_
