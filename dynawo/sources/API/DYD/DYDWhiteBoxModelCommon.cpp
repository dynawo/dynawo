//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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

#include "DYDWhiteBoxModelCommon.h"
#include "DYNMacrosMessage.h"

using std::string;
using std::map;

namespace dynamicdata {
string
getConnectionId(const string& model1, const string& var1,
    const string& model2, const string& var2,  const string& id,
    const map<string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap) {
  if (unitDynamicModelsMap.find(model1) == unitDynamicModelsMap.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model1, model2, id);
  if (unitDynamicModelsMap.find(model2) == unitDynamicModelsMap.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model2, model1, id);

  string connectionFirst = model1 + '_' + var1;
  string connectionSecond = model2 + '_' + var2;
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  if (connectionFirst < connectionSecond)
    return connectionFirst + '_' + connectionSecond;
  return connectionSecond + '_' + connectionFirst;
}



string
getMacroConnectionId(const string& model1, const string& model2, const string& id,
    const map<string, std::shared_ptr<UnitDynamicModel> >& unitDynamicModelsMap) {
  if (unitDynamicModelsMap.find(model1) == unitDynamicModelsMap.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model1, model2, id);
  if (unitDynamicModelsMap.find(model2) == unitDynamicModelsMap.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model2, model1, id);

  if (model1 < model2)
    return model1 + '_' + model2;
  else
    return model2 + '_' + model1;
}
}  // namespace dynamicdata
