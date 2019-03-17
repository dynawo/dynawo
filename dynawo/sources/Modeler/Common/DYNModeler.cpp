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
 * @file  DYNModeler.cpp
 *
 * @brief Assembly all models declared in inputs files
 *
 */

#include <string>
#include <vector>
#include <cmath>
#include <map>

#include <boost/algorithm/string.hpp>

#include "PARParametersSet.h"
#include "PARReference.h"
#include "DYDConnector.h"
#include "DYDModel.h"

#include "DYNModeler.h"
#include "DYNCommun.h"
#include "DYNMacrosMessage.h"
#include "DYNSubModel.h"
#include "DYNConnectInterface.h"
#include "DYNStaticRefInterface.h"
#include "DYNModelDescription.h"
#include "DYNDynamicData.h"
#include "DYNModelMulti.h"
#include "DYNSubModelFactory.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNElement.h"
#include "DYNDataInterface.h"
#include "DYNExecUtils.h"

using std::string;
using std::stringstream;
using std::map;
using std::vector;

using boost::shared_ptr;

using parameters::ParametersSet;
using parameters::Reference;

namespace DYN {

void
Modeler::initSystem() {
  model_ = shared_ptr<ModelMulti>(new ModelMulti());
  if (data_)
    initNetwork();

  initModelDescription();
  initConnects();
}

void
Modeler::initNetwork() {
  // network model from an IIDM situation
  // --------------------------------------------
  shared_ptr<SubModel> modelNetwork;
  string DDBDir = "";
  if (!hasEnvVar("DYNAWO_DDB_DIR")) {
    throw DYNError(Error::MODELER, MissingDDBDir);
  }
  DDBDir = getEnvVar("DYNAWO_DDB_DIR");

  try {
    modelNetwork.reset(SubModelFactory::createSubModelFromLib(DDBDir + "/DYNModelNetwork.dylib"));
    modelNetwork->initFromData(data_);
    data_->setModelNetwork(modelNetwork);
    modelNetwork->name("NETWORK");
    shared_ptr<ParametersSet> networkParams = dyd_->getNetworkParameters();
    modelNetwork->setPARParameters(networkParams);

    model_->addSubModel(modelNetwork, "DYNModelNetwork.dylib");
    subModels_["NETWORK"] = modelNetwork;
  } catch (const string & msg) {
    Trace::error() << msg << Trace::endline;
  }
}

void
Modeler::initModelDescription() {
  map<string, shared_ptr<ModelDescription> > modelDescriptions = dyd_->getModelDescriptions();
  map<string, shared_ptr<ModelDescription> >::const_iterator itModelDescription;
  for (itModelDescription = modelDescriptions.begin(); itModelDescription != modelDescriptions.end(); ++itModelDescription) {
    if (itModelDescription->second->getModel()->getType() == dynamicdata::Model::MODEL_TEMPLATE) {
      continue;
    }

    if ((itModelDescription->second)->hasCompiledModel()) {
      shared_ptr<SubModel> model;
      try {
        model.reset(SubModelFactory::createSubModelFromLib(itModelDescription->second->getLib()));
        model->name((itModelDescription->second)->getID());
        model->staticId((itModelDescription->second)->getStaticId());
        shared_ptr<ParametersSet> params = (itModelDescription->second)->getParametersSet();

        // params can be a nullptr if no parFile was given for the model
        if (params) {
          // if there are references in external parameters, retrieve the parameters' value from IIDM or INIT
          vector<string> referencesNames = params->getReferencesNames();

          for (vector<string>::const_iterator itRef = referencesNames.begin(); itRef != referencesNames.end(); ++itRef) {
            string refType = params->getReference(*itRef)->getType();
            Reference::OriginData refOrigData_ = params->getReference(*itRef)->getOrigData();  // IIDM or INIT
            string refOrigName = params->getReference(*itRef)->getOrigName();
            string staticID = (itModelDescription->second)->getStaticId();
            string componentID = params->getReference(*itRef)->getComponentId();
            // if data_ origin is IIDM file, retrieve the value and add a parameter in the parameter set.
            if (componentID != "")
              staticID = componentID;  // when componentID exist, this id should be used to find the parameter value
            if (refOrigData_ == Reference::IIDM) {
              if (refType == "DOUBLE") {
                double value = data_->getStaticParameterDoubleValue(staticID, refOrigName);
                params->createParameter(*itRef, value);
                Trace::info("MODELER") << DYNLog(AddedRefParToSet, itModelDescription->first, *itRef, value) << Trace::endline;
              } else if (refType == "INT") {
                int value = data_->getStaticParameterIntValue(staticID, refOrigName);
                params->createParameter(*itRef, value);
                Trace::info("MODELER") << DYNLog(AddedRefParToSet, itModelDescription->first, *itRef, value) << Trace::endline;
              } else if (refType == "BOOL") {
                bool value = data_->getStaticParameterBoolValue(staticID, refOrigName);
                params->createParameter(*itRef, value);
                Trace::info("MODELER") << DYNLog(AddedRefParToSet, itModelDescription->first, *itRef, value) << Trace::endline;
              } else {
                throw DYNError(Error::MODELER, ParameterWrongTypeReference, *itRef);
              }
            } else {
              throw DYNError(Error::MODELER, FunctionNotAvailable);
            }
          }
        }
        model->setPARParameters(params);
        model->initFromData(data_);
        // add the submodel
        model_->addSubModel(model, itModelDescription->second->getLib());
        subModels_[(itModelDescription->second)->getID()] = model;
        (itModelDescription->second)->setSubModel(model);
        // reference static
        if ((itModelDescription->second)->getStaticId() != "") {
          data_->setDynamicModel((itModelDescription->second)->getStaticId(), model);
          initStaticRefs(model, (itModelDescription->second));
        }
      } catch (const string & msg) {
        Trace::error() << msg << Trace::endline;
        throw DYNError(Error::MODELER, CompileModel, (itModelDescription->second)->getID());
      }
    } else {
      throw DYNError(Error::MODELER, CompileModel, (itModelDescription->second)->getID());
    }
  }
}

void
Modeler::initStaticRefs(const shared_ptr<SubModel>& model, const shared_ptr<ModelDescription>& modelDescription) {
  vector<shared_ptr<StaticRefInterface> > references = modelDescription->getStaticRefInterfaces();

  vector<shared_ptr<StaticRefInterface> >::const_iterator itReference;
  for (itReference = references.begin(); itReference != references.end(); ++itReference) {
    string modelID = ((*itReference)->getModelID().empty()) ? modelDescription->getID() : (*itReference)->getModelID();
    string modelVar = (*itReference)->getModelVar();
    string staticVar = (*itReference)->getStaticVar();

    data_->setReference(staticVar, model->staticId(), modelID, modelVar);
  }
}

void
Modeler::initConnects() {
  Trace::info("MODELER") << DYNLog(EnteringInitConnects) << Trace::endline;
  map<string, shared_ptr<ConnectInterface> > connects = dyd_->getConnectInterfaces();
  for (map<string, shared_ptr<ConnectInterface> >::const_iterator itConnector = connects.begin();
          itConnector != connects.end(); ++itConnector) {
    string id1 = (itConnector->second)->getConnectedModel1();
    string id2 = (itConnector->second)->getConnectedModel2();
    string var1 = (itConnector->second)->getModel1Var();
    string var2 = (itConnector->second)->getModel2Var();

    map<string, shared_ptr<SubModel> >::iterator iter1;
    map<string, shared_ptr<SubModel> >::iterator iter2;
    iter1 = subModels_.find(id1);
    iter2 = subModels_.find(id2);
    if (iter1 == subModels_.end() || iter2 == subModels_.end()) {
      Trace::error() << DYNLog(CreateDynamicConnectFailed, id1, var1, id2, var2) << Trace::endline;
      Trace::error() << DYNLog(NotInstancedModel) << Trace::endline;
      continue;
    }
    //  @todo add same mechanism for @NODE1@, @NODE2@, @NODE3@

    // convention : if node inside a connector, the staticId of the component is before @NODE@
    const string labelNode = "@NODE@";
    const string labelStaticId = "@STATIC_ID@";

    // so the name of the var is as follow : @STATIC_ID@@@NODE@_var
    bool foundStaticIdInVar1 = (var1.find(labelStaticId) != string::npos);
    bool foundStaticIdInVar2 = (var2.find(labelStaticId) != string::npos);
    // in connector, use static id of the model where the connection should be connected
    // replace @STATIC_ID@ by @id@
    if (foundStaticIdInVar1)
      var1.replace(var1.find(labelStaticId), labelStaticId.size(), "@" + iter2->second->staticId() + "@");
    if (foundStaticIdInVar2)
      var2.replace(var2.find(labelStaticId), labelStaticId.size(), "@" + iter1->second->staticId() + "@");

    bool foundNodeInVar1 = (var1.find(labelNode) != string::npos);
    bool foundNodeInVar2 = (var2.find(labelNode) != string::npos);

    if (foundNodeInVar1 && foundNodeInVar2) {
      throw DYNError(Error::MODELER, WrongConnectTwoUnknownNodes, id1, var1, id2, var2);
    } else if (foundNodeInVar1) {
      var1 = findNodeConnectorName(var1);
    } else if (foundNodeInVar2) {
      var2 = findNodeConnectorName(var2);
    }

    Trace::debug("MODELER") << DYNLog(DynamicConnect, id1, var1, id2, var2) << Trace::endline;

    model_->connectElements(iter1->second, var1, iter2->second, var2);
  }

  Trace::info("MODELER") << DYNLog(LeavingInitConnects) << Trace::endline;
}

string
Modeler::findNodeConnectorName(const string& id) {
  // remove @NODE@
  string tmpId = id;
  const string labelNode = "@NODE@";
  tmpId.replace(tmpId.find(labelNode), labelNode.size(), "");
  // retrieve the staticId of the component
  vector<string> strs;
  boost::split(strs, tmpId, boost::is_any_of("@"));

  if (strs.size() == 3) {
    string busName = data_->getBusName(strs[1]);
    string staticIdLabel = "@" + strs[1] + "@";
    // replace @staticId@ by the node name
    tmpId.replace(tmpId.find(staticIdLabel), staticIdLabel.size(), busName);
  }
  return tmpId;
}

}  // namespace DYN

