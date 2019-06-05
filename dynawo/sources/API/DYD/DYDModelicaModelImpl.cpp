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
 * @file DYDModelicaModelImpl.cpp
 * @brief Composite model description : implementation file
 *
 */

#include <algorithm>  // for std::find
#include <boost/lexical_cast.hpp>
#include <sstream>
#include <list>
#include <set>

#include <iomanip>
#include <fstream>
#include <memory>

#include "DYNMacrosMessage.h"

#include "DYDModelicaModelImpl.h"
#include "DYDConnectorFactory.h"
#include "DYDConnector.h"
#include "DYDMacroConnectImpl.h"
#include "DYDUnitDynamicModel.h"


using std::map;
using std::vector;
using std::list;
using std::pair;
using std::make_pair;
using std::set;
using std::string;
using std::stringstream;
using boost::shared_ptr;
using boost::dynamic_pointer_cast;


namespace dynamicdata {

ModelicaModel::Impl::Impl(const string& id) :
Model::Impl(id, Model::MODELICA_MODEL) {
}

ModelicaModel::Impl::~Impl() {
}

string
ModelicaModel::Impl::getStaticId() const {
  return staticId_;
}

ModelicaModel&
ModelicaModel::Impl::setStaticId(const string& staticId) {
  staticId_ = staticId;
  return *this;
}

const map<string, shared_ptr<UnitDynamicModel> >&
ModelicaModel::Impl::getUnitDynamicModels() const {
  return unitDynamicModelsMap_;
}

const map<string, shared_ptr<Connector> >&
ModelicaModel::Impl::getInitConnectors() const {
  return initConnectorsMap_;
}

const map<string, shared_ptr<Connector> >&
ModelicaModel::Impl::getConnectors() const {
  return connectorsMap_;
}

const map<string, shared_ptr<MacroConnect> >&
ModelicaModel::Impl::getMacroConnects() const {
  return macroConnectsMap_;
}

ModelicaModel&
ModelicaModel::Impl::addUnitDynamicModel(const shared_ptr<UnitDynamicModel>& model) {
  if (unitDynamicModelsMap_.find(model->getId()) != unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ModelIDNotUnique, model->getId());
  if (model->getId() == getId())
    throw DYNError(DYN::Error::API, UnitModelIDSameAsModelName, model->getId());
  if (model->getId() == model->getDynamicModelName())
    throw DYNError(DYN::Error::API, UnitModelIDSameAsUnitModelName, model->getId());
  unitDynamicModelsMap_[model->getId()] = model;
  return *this;
}

ModelicaModel&
ModelicaModel::Impl::addConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model2, model1, getId());

  string pc_first = model1 + '_' + var1;
  string pc_second = model2 + '_' + var2;
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  string pc_Id;
  if (pc_first < pc_second)
    pc_Id = pc_first + '_' + pc_second;
  else
    pc_Id = pc_second + '_' + pc_first;

  // Used instead of map_[pc_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  pair<map<string, shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = connectorsMap_.emplace(pc_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = connectorsMap_.insert(make_pair(pc_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, pc_first, pc_second);
  return *this;
}

ModelicaModel&
ModelicaModel::Impl::addInitConnect(const string& model1, const string& var1,
        const string& model2, const string& var2) {
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, ConnectorNotPartofModel, model2, model1, getId());

  string ic_first;
  string ic_second;
  string ic_Id;
  ic_first = model1 + '_' + var1;
  ic_second = model2 + '_' + var2;
  // To build the connector Id, sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  if (ic_first < ic_second)
    ic_Id = ic_first + '_' + ic_second;
  else
    ic_Id = ic_second + '_' + ic_first;
  // Used instead of initConnectorsMap_[ic_Id] = Connector::Impl(model1, var1, model2, var2)
  // to avoid necessity to create Connector::Impl default constructor
  pair<map<string, shared_ptr<Connector> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = initConnectorsMap_.emplace(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2)));
#else
  ret = initConnectorsMap_.insert(make_pair(ic_Id, shared_ptr<Connector>(ConnectorFactory::newConnector(model1, var1, model2, var2))));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, ConnectorIDNotUnique, id_, ic_first, ic_second);
  return *this;
}

ModelicaModel&
ModelicaModel::Impl::addMacroConnect(const shared_ptr<MacroConnect>& macroConnect) {
  string model1 = macroConnect->getFirstModelId();
  string model2 = macroConnect->getSecondModelId();
  if (unitDynamicModelsMap_.find(model1) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model1, model2, getId());
  if (unitDynamicModelsMap_.find(model2) == unitDynamicModelsMap_.end())
    throw DYNError(DYN::Error::API, MacroConnectNotPartofModel, model2, model1, getId());

  string id;
  if (model1 < model2)
    id = model1 + '_' + model2;
  else
    id = model2 + '_' + model1;
  pair<map<string, shared_ptr<MacroConnect> >::iterator, bool> ret;
#ifdef LANG_CXX11
  ret = macroConnectsMap_.emplace(id, macroConnect);
#else
  ret = macroConnectsMap_.insert(make_pair(id, macroConnect));
#endif
  if (!ret.second)
    throw DYNError(DYN::Error::API, MacroConnectIDNotUnique, id);
  return *this;
}

/**
 * @brief function for hasSameStructureAs.
 * create a map: model[ID] = Name
 */
map<string, string >
modelsByInitName(const map<string, shared_ptr<UnitDynamicModel> >& uDM) {
  map<string, string > modelsInitName;
  map<string, shared_ptr<UnitDynamicModel> >::const_iterator itUdm;
  for (itUdm = uDM.begin(); itUdm != uDM.end(); ++itUdm)
    modelsInitName[itUdm->first] = itUdm->second->getInitModelName();
  return modelsInitName;
}

/**
 * @brief function for hasSameStructureAs.
 * create a map: model[ID] = Name
 */
map<string, string >
modelsByName(const map<string, shared_ptr<UnitDynamicModel> >& uDM) {
  map<string, string > modelsName;
  map<string, shared_ptr<UnitDynamicModel> >::const_iterator itUdm;
  for (itUdm = uDM.begin(); itUdm != uDM.end(); ++itUdm)
    modelsName[itUdm->first] = itUdm->second->getDynamicModelName();
  return modelsName;
}

/**
 * @brief function for hasSameStructureAs.
 * return "modelName_VariableId" of connect's first Element
 */
string
connect1stElement2String(const shared_ptr<Connector>& connect, const map<string, string >& modelsName) {
  map<string, string>::const_iterator iter = modelsName.find(connect->getFirstModelId());
  if (iter == modelsName.end())
    throw DYNError(DYN::Error::API, ConnectedModelNotFound, connect->getFirstModelId());

  string modelName = iter->second;
  string ic_first = modelName + '_' + connect->getFirstVariableId();

  return ic_first;
}
/**
 * @brief function for hasSameStructureAs.
 * return "modelName_VariableId" of connect's second Element
 */
string
connect2ndElement2String(const shared_ptr<Connector>& connect, const map<string, string >& modelsName) {
  map<string, string>::const_iterator iter = modelsName.find(connect->getSecondModelId());
  if (iter == modelsName.end())
    throw DYNError(DYN::Error::API, ConnectedModelNotFound, connect->getSecondModelId());

  string modelName = iter->second;
  string ic_second = modelName + '_' + connect->getSecondVariableId();

  return ic_second;
}

/**
 * @brief function for hasSameStructureAs.
 * convert a connection to string
 */
string
connection2String(const shared_ptr<Connector>& connect, const map<string, string >& modelsName) {
  string ic_first = connect1stElement2String(connect, modelsName);
  string ic_second = connect2ndElement2String(connect, modelsName);

  string ic_string;
  // Sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  if (ic_first < ic_second)
    ic_string = ic_first + '_' + ic_second;
  else
    ic_string = ic_second + '_' + ic_first;
  return ic_string;
}

/**
 * @brief function for hasSameStructureAs.
 * convert a macro connection to string
 */
string
macroConnect2String(const shared_ptr<MacroConnect>& connect, const map<string, string >& modelsName) {
  map<string, string>::const_iterator iter = modelsName.find(connect->getFirstModelId());

  if (iter == modelsName.end())
    throw DYNError(DYN::Error::API, ConnectedModelNotFound, connect->getFirstModelId());
  string modelName1 = iter->second;

  iter = modelsName.find(connect->getSecondModelId());
  if (iter == modelsName.end())
    throw DYNError(DYN::Error::API, ConnectedModelNotFound, connect->getFirstModelId());
  string modelName2 = iter->second;

  string ic_string;
  // Sort the string so as 1st_Model_ID is smaller than 2nd_Model_ID. EX: ID_1 < ID_2
  if (modelName1 < modelName2)
    ic_string = modelName1 + '_' + modelName2;
  else
    ic_string = modelName2 + '_' + modelName1;
  return ic_string;
}

/**
 * @brief function for hasSameStructureAs.
 * convert all connections to a list
 */
list<string>
connections2StringList(const map<string, shared_ptr<Connector> >& connects, const map<string, string >& modelsName) {
  list<string> listIc_string;
  map<string, shared_ptr<Connector> >::const_iterator itIc;
  for (itIc = connects.begin(); itIc != connects.end(); ++itIc)
    listIc_string.push_back(connection2String(itIc->second, modelsName));
  listIc_string.sort();  // sort the list.
  return listIc_string;
}

/**
 * @brief function for hasSameStructureAs.
 * convert all model names to a list
 */
list<string>
modelsName2List(const map<string, string >& modelsName) {
  list<string> modelsNameList;
  map<string, string >::const_iterator it;
  for (it = modelsName.begin(); it != modelsName.end(); ++it)
    modelsNameList.push_back(it->second);
  modelsNameList.sort();  // sort the list.
  return modelsNameList;
}

/**
 * @brief function for hasSameStructureAs.
 * convert all macro connections to a list
 */
list<string>
macroConnect2StringList(const map<string, shared_ptr<MacroConnect> >& connects, const map<string, string >& modelsName) {
  list<string> listIc_string;
  map<string, shared_ptr<MacroConnect> >::const_iterator itIc;
  for (itIc = connects.begin(); itIc != connects.end(); ++itIc)
    listIc_string.push_back(macroConnect2String(itIc->second, modelsName));
  listIc_string.sort();  // sort the list.
  return listIc_string;
}

/**
 * @brief function for hasSameStructureAs. is same connection?
 */
bool
isSameConnection(const shared_ptr<Connector>& connect1, const shared_ptr<Connector>& connect2,
        const map<string, string >& modelsName1, const map<string, string >& modelsName2) {
  return ( connection2String(connect1, modelsName1) == connection2String(connect2, modelsName2));
}

/**
 * @brief function for hasSameStructureAs. is same macro connection?
 */
bool
isSameMacroConnect(const shared_ptr<MacroConnect>& connect1, const shared_ptr<MacroConnect>& connect2,
        const map<string, string >& modelsName1, const map<string, string >& modelsName2) {
  if (connect1->getConnector() != connect2->getConnector())
    return false;
  return ( macroConnect2String(connect1, modelsName1) == macroConnect2String(connect2, modelsName2));
}

/**
 * @brief for connections2MapSetofModelsInvolvedInOneTypeofConnectedVariable. return map[modelID_varID]=<ModelID1,   , ModelIDn>
 */
map<string, set<string> >
connections2ModelsInvolvedInOneConnectedVariableType(const map<string, shared_ptr<Connector> >& connects,
        const map<string, string>& modelsName) {
  map<string, set<string> > modelsInvolvedInOneConnectedVariableType;
  map<string, shared_ptr<Connector> >::const_iterator itIc;
  for (itIc = connects.begin(); itIc != connects.end(); itIc++) {
    (modelsInvolvedInOneConnectedVariableType[connect1stElement2String(itIc->second, modelsName)]).insert(itIc->second->getFirstModelId());
    (modelsInvolvedInOneConnectedVariableType[connect2ndElement2String(itIc->second, modelsName)]).insert(itIc->second->getSecondModelId());
  }
  return modelsInvolvedInOneConnectedVariableType;
}

bool
ModelicaModel::Impl::hasSameStructureAs(const shared_ptr<ModelicaModel>& modelicaModel,
        map< shared_ptr<UnitDynamicModel>, shared_ptr<UnitDynamicModel> >& unitDynModelsMap) {
  // Testing if the models have the same "size"
  if (unitDynamicModelsMap_.size() != modelicaModel->getUnitDynamicModels().size()
          || connectorsMap_.size() != modelicaModel->getConnectors().size()
          || initConnectorsMap_.size() != modelicaModel->getInitConnectors().size()
          || macroConnectsMap_.size() != modelicaModel->getMacroConnects().size()
          ) {
    return false;
  }

  map<string, string > modelsInitName1 = modelsByInitName(unitDynamicModelsMap_);
  map<string, string > modelsInitName2 = modelsByInitName(modelicaModel->getUnitDynamicModels());

  map<string, string > modelsName1 = modelsByName(unitDynamicModelsMap_);
  map<string, string > modelsName2 = modelsByName(modelicaModel->getUnitDynamicModels());

  // Case with no connections
  if (connectorsMap_.size() == 0 && initConnectorsMap_.size() == 0 && macroConnectsMap_.size() == 0) {
    list<string> listInitModelsName1 = modelsName2List(modelsInitName1);
    list<string> listInitModelsName2 = modelsName2List(modelsInitName2);
    if (listInitModelsName1 != listInitModelsName2)
      return false;  // Check whether the two sets of modelsInitNames Strings are globally identical
    list<string> listModelsName1 = modelsName2List(modelsName1);
    list<string> listModelsName2 = modelsName2List(modelsName2);
    if (listModelsName1 != listModelsName2)
      return false;  // Check whether the two sets of modelsNames Strings are globally identical

    // Mapping UDMs
    vector<string> UDMAlreadyMapped;  //  UDMs in the reference modelica model that have already been linked to
    //  an UDM in the considered modelica model. An already mapped UDM should not be mapped again
    map<string, shared_ptr<UnitDynamicModel> > interMapUDM = modelicaModel->getUnitDynamicModels();
    for (map<string, shared_ptr<UnitDynamicModel> >::iterator itUdm1 = unitDynamicModelsMap_.begin();
        itUdm1 != unitDynamicModelsMap_.end(); ++itUdm1)
      for (map<string, shared_ptr<UnitDynamicModel> >::iterator itUdm2 = interMapUDM.begin(); itUdm2 != interMapUDM.end(); ++itUdm2)
        if ((*(itUdm1->second)) == (*(itUdm2->second)) && find(UDMAlreadyMapped.begin(), UDMAlreadyMapped.end(), itUdm2->first) == UDMAlreadyMapped.end()) {
          unitDynModelsMap[itUdm1->second] = itUdm2->second;
          UDMAlreadyMapped.push_back(itUdm2->first);
          break;  // thanks to the two preliminary checks, every udm should find its match
        }

    return true;
  }
  // Note that for now, hasSameStructure does not handle the case where some UDMs are involved in connects and others not.
  // (we need to have all of them be involved in one connect at least, or all of them without any connect)

  map<string, shared_ptr<Connector> > interMapIC = modelicaModel->getInitConnectors();
  map<string, shared_ptr<Connector> > interMapPC = modelicaModel->getConnectors();
  map<string, shared_ptr<MacroConnect> > interMapMacroConnect = modelicaModel->getMacroConnects();

  list<string> listIc1_string = connections2StringList(initConnectorsMap_, modelsName1);
  list<string> listIc2_string = connections2StringList(interMapIC, modelsName2);
  if (listIc1_string != listIc2_string)
    return false;  // Check whether the two sets of Init Connections Strings are globally identical

  list<string> listPc1_string = connections2StringList(connectorsMap_, modelsName1);
  list<string> listPc2_string = connections2StringList(interMapPC, modelsName2);
  if (listPc1_string != listPc2_string)
    return false;  // Check whether the two sets of Pin Connections Strings are globally identical

  list<string> listMacroConnect1_string = macroConnect2StringList(macroConnectsMap_, modelsName1);
  list<string> listMacroConnect2_string = macroConnect2StringList(interMapMacroConnect, modelsName2);
  if (listMacroConnect1_string != listMacroConnect2_string)
    return false;  // Check whether the two sets of Macro Connections Strings are globally identical
  // Here, two macroConnects are considered equal if they connect the same two models.
  // It does not check whether the micro connections made within them are the same.

  // Check whether the different types of Init connected variables involve in the same amount of UDMs between two modelica models
  // For example to detect that these two pairs of dyd connects don't belong to the same structure :
  // <dyn:initConnect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID1" var2="sortie"/>
  // <dyn:initConnect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID2" var2="sortie"/>
  // VS
  // <dyn:initConnect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID1" var2="sortie"/>
  // <dyn:initConnect id1="ModelNameA_ID2" var1="sortie" id2="ModelNameB_ID2" var2="sortie"/>
  map<string, set<string> > modelsInvolvedInOneConnectedVariableType1 =
        connections2ModelsInvolvedInOneConnectedVariableType(initConnectorsMap_, modelsName1);
  map<string, set<string> > modelsInvolvedInOneConnectedVariableType2 =
      connections2ModelsInvolvedInOneConnectedVariableType(interMapIC, modelsName2);  // map[modelName_varId]=<ModelID1,   , ModelIDn>
  // Testing if the maps have same "size"
  if (modelsInvolvedInOneConnectedVariableType1.size() != modelsInvolvedInOneConnectedVariableType2.size())
    return false;
  // Testing if each type of Init connected variable have same number of UDM involved in
  for (map<string, set<string> >::iterator  itNb1 = modelsInvolvedInOneConnectedVariableType1.begin(),
      itNb2 = modelsInvolvedInOneConnectedVariableType2.begin();
      itNb1 != modelsInvolvedInOneConnectedVariableType1.end(); ++itNb1, ++itNb2) {
    if ((itNb1->second).size() != (itNb2->second).size())
      return false;
    }

  // Check whether the different types of Pin connected variables involve in the same amount of UDMs between two modelica models
  // For example to detect that these two pairs of dyd connects don't belong to the same structure :
  // <dyn:connect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID1" var2="sortie"/>
  // <dyn:connect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID2" var2="sortie"/>
  // VS
  // <dyn:connect id1="ModelNameA_ID1" var1="sortie" id2="ModelNameB_ID1" var2="sortie"/>
  // <dyn:connect id1="ModelNameA_ID2" var1="sortie" id2="ModelNameB_ID2" var2="sortie"/>
  map<string, set<string> > modelsInvolvedInOneTypeofConnectedVariable1 =
      connections2ModelsInvolvedInOneConnectedVariableType(connectorsMap_, modelsName1);
  map<string, set<string> > modelsInvolvedInOneTypeofConnectedVariable2 =
      connections2ModelsInvolvedInOneConnectedVariableType(interMapPC, modelsName2);  // map[modelName_varId]=<ModelID1,   , ModelIDn>
  // Testing if the maps have same "size"
  if (modelsInvolvedInOneConnectedVariableType1.size() != modelsInvolvedInOneConnectedVariableType2.size())
    return false;
  // Testing if each type of connected variable have same number of UDM involved in
  for (map<string, set<string> >::iterator  itNb1 = modelsInvolvedInOneConnectedVariableType1.begin(),
      itNb2 = modelsInvolvedInOneConnectedVariableType2.begin();
      itNb1 != modelsInvolvedInOneConnectedVariableType1.end(); ++itNb1, ++itNb2) {
    if ((itNb1->second).size() != (itNb2->second).size())
      return false;
  }


  // The check whether the different types of macro connected models involve the same amount of UDMs between two modelica models is not implemented


  // Mapping init connection
  vector<string> InitConnectionAlreadyMapped;  //  Init connects in the reference modelica model that have already been linked to
  //  an Init connect in the considered modelica model. An already mapped Init connect should not be mapped again
  map<shared_ptr<Connector>, shared_ptr<Connector> > initConnectionsMap;
  for ( map<string, shared_ptr<Connector> >::iterator itIc1 = initConnectorsMap_.begin(); itIc1 != initConnectorsMap_.end(); ++itIc1)
    for (map<string, shared_ptr<Connector> >::iterator itIc2 = interMapIC.begin(); itIc2 != interMapIC.end(); ++itIc2)
      if (isSameConnection(itIc1->second, itIc2->second, modelsInitName1, modelsInitName2) &&
          find(InitConnectionAlreadyMapped.begin(), InitConnectionAlreadyMapped.end(), itIc2->first) == InitConnectionAlreadyMapped.end()) {
        initConnectionsMap[itIc1->second] = itIc2->second;
        InitConnectionAlreadyMapped.push_back(itIc2->first);
        break;
      }

  // Mapping connection
  vector<string> PinConnectionAlreadyMapped;  //  Pin connects in the reference modelica model that have already been linked to
  //  a Pin connect in the considered modelica model. An already mapped Pin connect should not be mapped again
  //  Have in mind that some rare dyd cases can be built where checking that each reference Connect is mapped to only one Connect does not guarantee
  //  that the mapping is done properly since two connects may be the same (same udms and variables) and play different roles in the overall connects' graph
  map<shared_ptr<Connector>, shared_ptr<Connector> > pinConnectionsMap;
  for (map<string, shared_ptr<Connector> >::iterator itPc1 = connectorsMap_.begin(); itPc1 != connectorsMap_.end(); ++itPc1)
    for (map<string, shared_ptr<Connector> >::iterator itPc2 = interMapPC.begin(); itPc2 != interMapPC.end(); ++itPc2)
      if (isSameConnection(itPc1->second, itPc2->second, modelsName1, modelsName2) &&
          find(PinConnectionAlreadyMapped.begin(), PinConnectionAlreadyMapped.end(), itPc2->first) == PinConnectionAlreadyMapped.end()) {
        pinConnectionsMap[itPc1->second] = itPc2->second;
        PinConnectionAlreadyMapped.push_back(itPc2->first);
        break;
      }

  // Mapping macro connection
  vector<string> MacroConnectionAlreadyMapped;  //  Macro connects in the reference modelica model that have already been linked to
  //  a Macro connect in the considered modelica model. An already mapped Macro connect should not be mapped again
  map<shared_ptr<MacroConnect>, shared_ptr<MacroConnect> > macroConnectMap;
  for (map<string, shared_ptr<MacroConnect> >::iterator itMC1 = macroConnectsMap_.begin(); itMC1 != macroConnectsMap_.end(); ++itMC1)
    for (map<string, shared_ptr<MacroConnect> >::iterator itMC2 = interMapMacroConnect.begin(); itMC2 != interMapMacroConnect.end(); ++itMC2)
      if (isSameMacroConnect(itMC1->second, itMC2->second, modelsName1, modelsName2) &&
          find(MacroConnectionAlreadyMapped.begin(), MacroConnectionAlreadyMapped.end(), itMC2->first) == MacroConnectionAlreadyMapped.end()) {
        macroConnectMap[itMC1->second] = itMC2->second;
        MacroConnectionAlreadyMapped.push_back(itMC2->first);
        break;
      }

  // Mapping unit dynamic models thanks to the init connect declaration
  map<string, shared_ptr<UnitDynamicModel> > modelsID1 = unitDynamicModelsMap_;
  map<string, shared_ptr<UnitDynamicModel> > modelsID2 = modelicaModel->getUnitDynamicModels();
  map<shared_ptr<UnitDynamicModel>, shared_ptr<UnitDynamicModel> > localUnitDynamicModelsMap;
  for (map<string, shared_ptr<Connector> >::iterator itIc1 = initConnectorsMap_.begin(); itIc1 != initConnectorsMap_.end(); ++itIc1) {
    shared_ptr<UnitDynamicModel> udm1_side1 = modelsID1[itIc1->second->getFirstModelId()];
    shared_ptr<UnitDynamicModel> udm1_side2 = modelsID1[itIc1->second->getSecondModelId()];

    shared_ptr<UnitDynamicModel> udm2_side1 = modelsID2[ initConnectionsMap[itIc1->second]->getFirstModelId() ];
    shared_ptr<UnitDynamicModel> udm2_side2 = modelsID2[ initConnectionsMap[itIc1->second]->getSecondModelId() ];

    if (itIc1->second->getFirstVariableId() == initConnectionsMap[itIc1->second]->getFirstVariableId()) {
      if (((*udm1_side1) != (*udm2_side1)) || ((*udm1_side2) != (*udm2_side2)))
        return false;

      localUnitDynamicModelsMap[ udm1_side1 ] = udm2_side1;
      localUnitDynamicModelsMap[ udm1_side2 ] = udm2_side2;
    } else {
      if (((*udm1_side1) != (*udm2_side2)) || ((*udm1_side2) != (*udm2_side1)))
        return false;

      localUnitDynamicModelsMap[ udm1_side1 ] = udm2_side2;
      localUnitDynamicModelsMap[ udm1_side2 ] = udm2_side1;
    }
  }

  // Mapping unit dynamic models thanks to the connectors declaration
  for (map<string, shared_ptr<Connector> >::iterator itPc1 = connectorsMap_.begin(); itPc1 != connectorsMap_.end(); ++itPc1) {
    shared_ptr<UnitDynamicModel> udm1_side1 = modelsID1[itPc1->second->getFirstModelId()];
    shared_ptr<UnitDynamicModel> udm1_side2 = modelsID1[itPc1->second->getSecondModelId()];

    shared_ptr<UnitDynamicModel> udm2_side1 = modelsID2[ pinConnectionsMap[itPc1->second]->getFirstModelId() ];
    shared_ptr<UnitDynamicModel> udm2_side2 = modelsID2[ pinConnectionsMap[itPc1->second]->getSecondModelId() ];

    if (itPc1->second->getFirstVariableId() == pinConnectionsMap[itPc1->second]->getFirstVariableId()) {
      if (((*udm1_side1) != (*udm2_side1)) || ((*udm1_side2) != (*udm2_side2)))
        return false;

      localUnitDynamicModelsMap[ udm1_side1 ] = udm2_side1;
      localUnitDynamicModelsMap[ udm1_side2 ] = udm2_side2;
    } else {
      if (((*udm1_side1) != (*udm2_side2)) || ((*udm1_side2) != (*udm2_side1)))
        return false;

      localUnitDynamicModelsMap[ udm1_side1 ] = udm2_side2;
      localUnitDynamicModelsMap[ udm1_side2 ] = udm2_side1;
    }
  }

  // Mapping unit dynamic models thanks to the macro connect declaration
  for (map<string, shared_ptr<MacroConnect> >::iterator itMC1 = macroConnectsMap_.begin(); itMC1 != macroConnectsMap_.end(); ++itMC1) {
    shared_ptr<UnitDynamicModel> udm1_side1 = modelsID1[itMC1->second->getFirstModelId()];
    shared_ptr<UnitDynamicModel> udm1_side2 = modelsID1[itMC1->second->getSecondModelId()];

    shared_ptr<UnitDynamicModel> udm2_side1 = modelsID2[ macroConnectMap[itMC1->second]->getFirstModelId() ];
    shared_ptr<UnitDynamicModel> udm2_side2 = modelsID2[ macroConnectMap[itMC1->second]->getSecondModelId() ];

    if (((*udm1_side1) != (*udm2_side1)) || ((*udm1_side2) != (*udm2_side2)))
      return false;

    localUnitDynamicModelsMap[ udm1_side1 ] = udm2_side1;
    localUnitDynamicModelsMap[ udm1_side2 ] = udm2_side2;
  }

  // Modelica models have same structure : fill unitDynModelsMap and trace compilation mapping between unit dynamic models
  map<shared_ptr<UnitDynamicModel>, shared_ptr<UnitDynamicModel> >::iterator itUdmRef;
  for (itUdmRef = localUnitDynamicModelsMap.begin(); itUdmRef != localUnitDynamicModelsMap.end(); ++itUdmRef) {
    unitDynModelsMap[itUdmRef->first] = itUdmRef->second;
  }

  return true;
}

string
ModelicaModel::Impl::getId() const {
  return Model::Impl::getId();
}

Model::ModelType
ModelicaModel::Impl::getType() const {
  return Model::Impl::getType();
}

Model&
ModelicaModel::Impl::addStaticRef(const string& var, const string& staticVar) {
  return Model::Impl::addStaticRef(var, staticVar);
}

void
ModelicaModel::Impl::addMacroStaticRef(const shared_ptr<MacroStaticRef>& macroStaticRef) {
  Model::Impl::addMacroStaticRef(macroStaticRef);
}

staticRef_const_iterator
ModelicaModel::Impl::cbeginStaticRef() const {
  return Model::Impl::cbeginStaticRef();
}

staticRef_const_iterator
ModelicaModel::Impl::cendStaticRef() const {
  return Model::Impl::cendStaticRef();
}

macroStaticRef_const_iterator
ModelicaModel::Impl::cbeginMacroStaticRef() const {
  return Model::Impl::cbeginMacroStaticRef();
}

macroStaticRef_const_iterator
ModelicaModel::Impl::cendMacroStaticRef() const {
  return Model::Impl::cendMacroStaticRef();
}

staticRef_iterator
ModelicaModel::Impl::beginStaticRef() {
  return Model::Impl::beginStaticRef();
}

staticRef_iterator
ModelicaModel::Impl::endStaticRef() {
  return Model::Impl::endStaticRef();
}

macroStaticRef_iterator
ModelicaModel::Impl::beginMacroStaticRef() {
  return Model::Impl::beginMacroStaticRef();
}

macroStaticRef_iterator
ModelicaModel::Impl::endMacroStaticRef() {
  return Model::Impl::endMacroStaticRef();
}

const shared_ptr<StaticRef>&
ModelicaModel::Impl::findStaticRef(const string& key) {
  return Model::Impl::findStaticRef(key);
}

const shared_ptr<MacroStaticRef>&
ModelicaModel::Impl::findMacroStaticRef(const string& id) {
  return Model::Impl::findMacroStaticRef(id);
}


}  // namespace dynamicdata
