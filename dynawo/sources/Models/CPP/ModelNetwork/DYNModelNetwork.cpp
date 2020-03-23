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
 * @file  DYNModelNetwork.cpp
 *
 * @brief Model Network implementation.
 *
 * Model Network is the container of all subModels who constitute a network
 * such as voltage levels, lines (AC or DC), transformers, etc..
 *
 */
#include <sstream>
#include <iostream>
#include <cmath>
#include <iomanip>

#include "DYNModelNetwork.h"
#include "DYNModelNetwork.hpp"

#include "PARParametersSet.h"
#include "DYNModelConstants.h"
#include "DYNModelBus.h"
#include "DYNModelSwitch.h"
#include "DYNModelLine.h"
#include "DYNModelTwoWindingsTransformer.h"
#include "DYNModelThreeWindingsTransformer.h"
#include "DYNModelLoad.h"
#include "DYNModelShuntCompensator.h"
#include "DYNModelStaticVarCompensator.h"
#include "DYNModelGenerator.h"
#include "DYNModelDanglingLine.h"
#include "DYNModelRatioTapChanger.h"
#include "DYNModelPhaseTapChanger.h"
#include "DYNModelHvdcLink.h"
#include "DYNModelVoltageLevel.h"

#include "DYNNetworkInterface.h"
#include "DYNDataInterface.h"
#include "DYNBusInterface.h"
#include "DYNSwitchInterface.h"
#include "DYNLoadInterface.h"
#include "DYNLineInterface.h"
#include "DYNGeneratorInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNDanglingLineInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNThreeWTransformerInterface.h"
#include "DYNHvdcLineInterface.h"
#include "DYNVscConverterInterface.h"
#include "DYNLccConverterInterface.h"
#include "DYNVoltageLevelInterface.h"

#include "DYNParameter.h"

#include "DYNSparseMatrix.h"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNTimer.h"
#include "DYNElement.h"
#include "DYNSolverKINSubModel.h"


using boost::shared_ptr;
using boost::dynamic_pointer_cast;
using std::vector;
using std::map;
using std::string;
using std::stringstream;
using std::pair;
using std::make_pair;

using parameters::ParametersSet;

/**
 * @brief ModelNewtorkFactory getter
 *
 * @return A pointer to a new instance of ModelNetworkFactory
 */
extern "C" DYN::SubModelFactory* getFactory() {
  return (new DYN::ModelNetworkFactory());
}

/**
 * @brief ModelNewtorkFactory destroy method
 */
extern "C" void deleteFactory(DYN::SubModelFactory* factory) {
  delete factory;
}

/**
 * @brief ModelNetwork getter
 *
 * @return A pointer to a new instance of Model Network
 */
extern "C" DYN::SubModel* DYN::ModelNetworkFactory::create() const {
  DYN::SubModel* model(new DYN::ModelNetwork());
  return model;
}

/**
 * @brief ModelNetwork destroy method
 */
extern "C" void DYN::ModelNetworkFactory::destroy(DYN::SubModel* model) const {
  delete model;
}

namespace DYN {

ModelNetwork::ModelNetwork() :
Impl("NETWORK"),
calculatedVarBuffer_(NULL),
isInit_(false) ,
isInitModel_(false),
withNodeBreakerTopology_(false) {
  busContainer_.reset(new ModelBusContainer());
}

ModelNetwork::~ModelNetwork() {
  delete[] calculatedVarBuffer_;
  calculatedVarBuffer_ = NULL;
}

void
ModelNetwork::initializeFromData(const shared_ptr<DataInterface>& data) {
  Timer timer("ModelNetwork::initFromData");
  shared_ptr<NetworkInterface> network = data->getNetwork();
  map<string, shared_ptr<ComponentInterface> > componentsById;
  map<string, shared_ptr<ModelBus> > modelBusById;
  map<string, shared_ptr<VscConverterInterface> > vscs;
  map<string, shared_ptr<LccConverterInterface> > lccs;


  const vector<shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  vector<shared_ptr<VoltageLevelInterface> >::const_iterator iVL;
  for (iVL = voltageLevels.begin(); iVL != voltageLevels.end(); ++iVL) {
    string voltageLevelsId = (*iVL)->getID();
    Trace::debug("NETWORK") << DYNLog(AddingVoltageLevelToNetwork, voltageLevelsId) << Trace::endline;
    shared_ptr<ModelVoltageLevel> modelVoltageLevel(new ModelVoltageLevel(*iVL));
    shared_ptr<ModelVoltageLevel> modelVoltageLevelInit(new ModelVoltageLevel(*iVL));
    // Add to containers
    components_.push_back(modelVoltageLevel);
    initComponents_.push_back(modelVoltageLevelInit);
    vLevelComponents_.push_back(modelVoltageLevel);
    vLevelInitComponents_.push_back(modelVoltageLevelInit);
    modelVoltageLevel->setNetwork(this);
    if ((*iVL)->isNodeBreakerTopology())
      withNodeBreakerTopology_ = true;

    // ==============================
    //    CREATE BUS MODEL
    // ==============================
    const vector<shared_ptr<BusInterface> >& buses = (*iVL)->getBuses();
    vector<shared_ptr<BusInterface> >::const_iterator iBus;
    for (iBus = buses.begin(); iBus != buses.end(); ++iBus) {
      string id = (*iBus)->getID();
      Trace::debug("NETWORK") << DYNLog(AddingBusToNetwork, id) << Trace::endline;
      shared_ptr<ModelBus> modelBus(new ModelBus(*iBus));
      componentsById[id] = (*iBus);
      modelBusById[id] = modelBus;
      // Add to containers
      modelVoltageLevel->addBus(modelBus);
      modelVoltageLevelInit->addBus(modelBus);
      busContainer_->add(modelBus);
      modelBus->setNetwork(this);
      modelBus->setVoltageLevel(modelVoltageLevel);
      // declare reference between subModel and static data
      data->setReference("v", id, id, "U_value");
      data->setReference("angle", id, id, "phi_value");
    }

    // =============================
    //    CREATE SWITCH MODEL
    // =============================
    const vector<shared_ptr<SwitchInterface> >& switches = (*iVL)->getSwitches();
    vector<shared_ptr<SwitchInterface> >::const_iterator iSwitch;
    for (iSwitch = switches.begin(); iSwitch != switches.end(); ++iSwitch) {
      string id = (*iSwitch)->getID();
      componentsById[id] = (*iSwitch);
      shared_ptr<ModelSwitch> modelSwitch(new ModelSwitch(*iSwitch));

      modelSwitch->setNetwork(this);
      if ((*iSwitch)->getBusInterface1()) {
        shared_ptr<ModelBus> modelBus1 = modelBusById[(*iSwitch)->getBusInterface1()->getID()];
        modelSwitch->setModelBus1(modelBus1);
      }
      if ((*iSwitch)->getBusInterface2()) {
        shared_ptr<ModelBus> modelBus2 = modelBusById[(*iSwitch)->getBusInterface2()->getID()];
        modelSwitch->setModelBus2(modelBus2);
      }

      modelVoltageLevelInit->addSwitch(modelSwitch);

      if ((*iSwitch)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(SwitchExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingSwitchToNetwork, id) << Trace::endline;
      // Add to containers
      modelVoltageLevel->addSwitch(modelSwitch);
      // declare reference between subModel and static data
      data->setReference("state", id, id, "state_value");
    }

    // =============================
    //    CREATE LOAD MODEL
    // =============================
    const vector<shared_ptr<LoadInterface> >& loads = (*iVL)->getLoads();
    vector<shared_ptr<LoadInterface> >::const_iterator iLoad;
    for (iLoad = loads.begin(); iLoad != loads.end(); ++iLoad) {
      string id = (*iLoad)->getID();
      componentsById[id] = (*iLoad);
      shared_ptr<ModelLoad> modelLoad(new ModelLoad(*iLoad));
      modelLoad->setNetwork(this);
      shared_ptr<ModelBus> modelBus = modelBusById[(*iLoad)->getBusInterface()->getID()];
      modelLoad->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelLoad);

      if ((*iLoad)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(LoadExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingLoadToNetwork, id) << Trace::endline;
      // Add to containers
      modelVoltageLevel->addComponent(modelLoad);
      // declare reference between subModel and static data
      data->setReference("p", id, id, "P_value");
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
    }

    // =============================
    //    CREATE GENERATORS  MODEL
    // =============================
    const vector<shared_ptr<GeneratorInterface> >& generators = (*iVL)->getGenerators();
    vector<shared_ptr<GeneratorInterface> >::const_iterator iGen;
    for (iGen = generators.begin(); iGen != generators.end(); ++iGen) {
      string id = (*iGen)->getID();
      componentsById[id] = (*iGen);
      shared_ptr<ModelGenerator> modelGenerator(new ModelGenerator(*iGen));
      modelGenerator->setNetwork(this);
      shared_ptr<ModelBus> modelBus = modelBusById[(*iGen)->getBusInterface()->getID()];
      modelGenerator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelGenerator);

      if ((*iGen)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(GeneratorExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingGeneratorToNetwork, id) << Trace::endline;
      // add to containers
      modelVoltageLevel->addComponent(modelGenerator);
      // declare reference between subModel and static data
      data->setReference("p", id, id, "P_value");
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
    }

    // =================================
    //    CREATE SHUNT COMPENSATOR MODEL
    // =================================
    const vector<shared_ptr<ShuntCompensatorInterface> >& shunts = (*iVL)->getShuntCompensators();
    vector<shared_ptr<ShuntCompensatorInterface> >::const_iterator iShunt;
    for (iShunt = shunts.begin(); iShunt != shunts.end(); ++iShunt) {
      string id = (*iShunt)->getID();
      componentsById[id] = (*iShunt);
      shared_ptr<ModelShuntCompensator> modelShuntCompensator(new ModelShuntCompensator(*iShunt));
      modelShuntCompensator->setNetwork(this);
      shared_ptr<ModelBus> modelBus = modelBusById[(*iShunt)->getBusInterface()->getID()];
      modelShuntCompensator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelShuntCompensator);

      if ((*iShunt)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(ShuntExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingShuntToNetwork, id) << Trace::endline;
      // add to containers
      modelVoltageLevel->addComponent(modelShuntCompensator);
      // declare reference between subModel and static data
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
      data->setReference("currentSection", id, id, "currentSection_value");
    }

    // =======================================
    //    CREATE STATIC VAR COMPENSATOR MODEL
    // =======================================
    const vector<shared_ptr<StaticVarCompensatorInterface> >& svcs = (*iVL)->getStaticVarCompensators();
    vector<shared_ptr<StaticVarCompensatorInterface> >::const_iterator iSvc;
    for (iSvc = svcs.begin(); iSvc != svcs.end(); ++iSvc) {
      string id = (*iSvc)->getID();
      componentsById[id] = (*iSvc);
      shared_ptr<ModelStaticVarCompensator> modelStaticVarCompensator(new ModelStaticVarCompensator(*iSvc));
      modelStaticVarCompensator->setNetwork(this);
      shared_ptr<ModelBus> modelBus = modelBusById[(*iSvc)->getBusInterface()->getID()];
      modelStaticVarCompensator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelStaticVarCompensator);

      if ((*iSvc)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(SVCExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingSVCToNetwork, id) << Trace::endline;
      // Add to containers
      modelVoltageLevel->addComponent(modelStaticVarCompensator);
      // declare reference between subModel and static data
      data->setReference("q", id, id, "QProduced_value");
      data->setReference("regulatingMode", id, id, "mode_value");
      data->setReference("state", id, id, "state_value");
      data->setReference("uSetPoint", id, id, "uSetPoint_value");
    }

    // =================================
    //    CREATE DANGLING LINES  MODEL
    // =================================
    const vector<shared_ptr<DanglingLineInterface> >& danglingLines = (*iVL)->getDanglingLines();
    vector<shared_ptr<DanglingLineInterface> >::const_iterator iDangling;
    for (iDangling = danglingLines.begin(); iDangling != danglingLines.end(); ++iDangling) {
      string id = (*iDangling)->getID();
      componentsById[id] = (*iDangling);
      shared_ptr<ModelDanglingLine> modelDanglingLine(new ModelDanglingLine(*iDangling));
      modelDanglingLine->setNetwork(this);
      shared_ptr<ModelBus> modelBus = modelBusById[(*iDangling)->getBusInterface()->getID()];
      modelDanglingLine->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelDanglingLine);


      if ((*iDangling)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(DanglingLineExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug("NETWORK") << DYNLog(AddingDanglingLineToNetwork, id) << Trace::endline;
      // add to containers
      modelVoltageLevel->addComponent(modelDanglingLine);
      // declare reference between subModel and static data
      data->setReference("p", id, id, "P_value");
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
    }
  }

  // =============================
  //    CREATE LINES MODEL
  // =============================
  const vector<shared_ptr<LineInterface> >& lines = network->getLines();
  vector<shared_ptr<LineInterface> >::const_iterator iLine;
  for (iLine = lines.begin(); iLine != lines.end(); ++iLine) {
    string id = (*iLine)->getID();
    componentsById[id] = (*iLine);
    shared_ptr<ModelLine> modelLine(new ModelLine(*iLine));
    modelLine->setNetwork(this);
    if ((*iLine)->getBusInterface1()) {
      shared_ptr<ModelBus> modelBus1 = modelBusById[(*iLine)->getBusInterface1()->getID()];
      modelLine->setModelBus1(modelBus1);
    }
    if ((*iLine)->getBusInterface2()) {
      shared_ptr<ModelBus> modelBus2 = modelBusById[(*iLine)->getBusInterface2()->getID()];
      modelLine->setModelBus2(modelBus2);
    }

    initComponents_.push_back(modelLine);

    if ((*iLine)->hasDynamicModel()) {
      Trace::info("NETWORK") << DYNLog(LineExtDynModel, id) << Trace::endline;
      continue;
    }

    Trace::debug("NETWORK") << DYNLog(AddingLineToNetwork, id) << Trace::endline;
    // add to containers
    components_.push_back(modelLine);
    // declare reference between subModel and static data
    data->setReference("p1", id, id, "P1_value");
    data->setReference("q1", id, id, "Q1_value");
    data->setReference("p2", id, id, "P2_value");
    data->setReference("q2", id, id, "Q2_value");
    data->setReference("state", id, id, "state_value");
  }

  // =================================
  //    CREATE 2WTfo  MODEL
  // =================================
  const vector<shared_ptr<TwoWTransformerInterface> >& twoWTfos = network->getTwoWTransformers();
  vector<shared_ptr<TwoWTransformerInterface> >::const_iterator i2WTfo;
  vector<shared_ptr<ModelTwoWindingsTransformer> > modelsTfo;
  for (i2WTfo = twoWTfos.begin(); i2WTfo != twoWTfos.end(); ++i2WTfo) {
    string id = (*i2WTfo)->getID();
    componentsById[id] = (*i2WTfo);
    shared_ptr<ModelTwoWindingsTransformer> modelTwoWindingsTransformer(new ModelTwoWindingsTransformer(*i2WTfo));
    modelsTfo.push_back(modelTwoWindingsTransformer);
    modelTwoWindingsTransformer->setNetwork(this);
    if ((*i2WTfo)->getBusInterface1()) {
      shared_ptr<ModelBus> modelBus1 = modelBusById[(*i2WTfo)->getBusInterface1()->getID()];
      modelTwoWindingsTransformer->setModelBus1(modelBus1);
    }
    if ((*i2WTfo)->getBusInterface2()) {
      shared_ptr<ModelBus> modelBus2 = modelBusById[(*i2WTfo)->getBusInterface2()->getID()];
      modelTwoWindingsTransformer->setModelBus2(modelBus2);
    }

    initComponents_.push_back(modelTwoWindingsTransformer);


    if ((*i2WTfo)->hasDynamicModel()) {
      Trace::info("NETWORK") << DYNLog(TwoWTfoExtDynModel, id) << Trace::endline;
      continue;
    }
    Trace::debug("NETWORK") << DYNLog(AddingTwoWTfoToNetwork, id) << Trace::endline;

    // add to containers
    components_.push_back(modelTwoWindingsTransformer);

    // declare reference between subModel and static data
    data->setReference("p1", id, id, "P1_value");
    data->setReference("q1", id, id, "Q1_value");
    data->setReference("p2", id, id, "P2_value");
    data->setReference("q2", id, id, "Q2_value");
    data->setReference("state", id, id, "state_value");
    data->setReference("tapIndex", id, id, "step_value");
  }

  // =================================
  //    CREATE 3WTfo  MODEL
  // =================================
  const vector<shared_ptr<ThreeWTransformerInterface> >&threeWTfos = network->getThreeWTransformers();
  vector<shared_ptr<ThreeWTransformerInterface> >::const_iterator i3WTfo;
  for (i3WTfo = threeWTfos.begin(); i3WTfo != threeWTfos.end(); ++i3WTfo) {
    string id = (*i3WTfo)->getID();
    componentsById[id] = (*i3WTfo);
    shared_ptr<ModelThreeWindingsTransformer> modelThreeWindingsTransformer(new ModelThreeWindingsTransformer(*i3WTfo));
    modelThreeWindingsTransformer->setNetwork(this);
    if ((*i3WTfo)->getBusInterface1()) {
      shared_ptr<ModelBus> modelBus1 = modelBusById[(*i3WTfo)->getBusInterface1()->getID()];
      modelThreeWindingsTransformer->setModelBus1(modelBus1);
    }
    if ((*i3WTfo)->getBusInterface2()) {
      shared_ptr<ModelBus> modelBus2 = modelBusById[(*i3WTfo)->getBusInterface2()->getID()];
      modelThreeWindingsTransformer->setModelBus2(modelBus2);
    }
    if ((*i3WTfo)->getBusInterface3()) {
      shared_ptr<ModelBus> modelBus3 = modelBusById[(*i3WTfo)->getBusInterface3()->getID()];
      modelThreeWindingsTransformer->setModelBus3(modelBus3);
    }

    initComponents_.push_back(modelThreeWindingsTransformer);


    if ((*i3WTfo)->hasDynamicModel()) {
      Trace::info("NETWORK") << DYNLog(ThreeWTfoExtDynModel, id) << Trace::endline;
      continue;
    }

    Trace::debug("NETWORK") << DYNLog(AddingThreeWTfoToNetwork, id) << Trace::endline;

    // add to containers
    components_.push_back(modelThreeWindingsTransformer);
  }

  for (iVL = voltageLevels.begin(); iVL != voltageLevels.end(); ++iVL) {
    // ==============================================
    // STORE VSC/LCC interface, needed for HVDC lines
    // ==============================================
    const vector<shared_ptr<VscConverterInterface> >& vscConverters = (*iVL)->getVscConverters();
    vector<shared_ptr<VscConverterInterface> >::const_iterator iVsc;
    for (iVsc = vscConverters.begin(); iVsc != vscConverters.end(); ++iVsc) {
      string id = (*iVsc)->getID();
      vscs[id] = (*iVsc);
    }

    const vector<shared_ptr<LccConverterInterface> >& lccConverters = (*iVL)->getLccConverters();
    vector<shared_ptr<LccConverterInterface> >::const_iterator iLcc;
    for (iLcc = lccConverters.begin(); iLcc != lccConverters.end(); ++iLcc) {
      string id = (*iLcc)->getID();
      lccs[id] = (*iLcc);
    }
  }


  // =======================================
  //    CREATE TapChanger connection for tfo
  // =======================================
  vector<shared_ptr<ModelTwoWindingsTransformer> >::const_iterator iTfo;
  for (iTfo = modelsTfo.begin(); iTfo != modelsTfo.end(); ++iTfo) {
    if ((*iTfo)->getModelRatioTapChanger()) {
      string terminalRefId = (*iTfo)->getTerminalRefId();
      if (terminalRefId == "")
        continue;
      string side = (*iTfo)->getSide();
      map<string, shared_ptr<ComponentInterface> >::const_iterator iComponent = componentsById.find(terminalRefId);
      if (iComponent == componentsById.end())
        throw DYNError(Error::MODELER, UnknownComponent, terminalRefId);

      shared_ptr<BusInterface> busInterface;
      switch (iComponent->second->getType()) {
        case ComponentInterface::BUS:
          busInterface = dynamic_pointer_cast<BusInterface>(iComponent->second);
          break;
        case ComponentInterface::SWITCH:
          if (side == "ONE") {
            busInterface = dynamic_pointer_cast<SwitchInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = dynamic_pointer_cast<SwitchInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::LOAD:
          busInterface = dynamic_pointer_cast<LoadInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::LINE:
          if (side == "ONE") {
            busInterface = dynamic_pointer_cast<LineInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = dynamic_pointer_cast<LineInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::GENERATOR:
          busInterface = dynamic_pointer_cast<GeneratorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::SHUNT:
          busInterface = dynamic_pointer_cast<ShuntCompensatorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::SVC:
          busInterface = dynamic_pointer_cast<StaticVarCompensatorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::DANGLING_LINE:
          busInterface = dynamic_pointer_cast<DanglingLineInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::TWO_WTFO:
          if (side == "ONE") {
            busInterface = dynamic_pointer_cast<TwoWTransformerInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = dynamic_pointer_cast<TwoWTransformerInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::THREE_WTFO:
          if (side == "ONE") {
            busInterface = dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface1();
          } else if (side == "TWO") {
            busInterface = dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface2();
          } else {
            busInterface = dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface3();
          }
          break;
        case ComponentInterface::VSC_CONVERTER:
          busInterface = dynamic_pointer_cast<VscConverterInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::LCC_CONVERTER:
          busInterface = dynamic_pointer_cast<LccConverterInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::UNKNOWN:
        case ComponentInterface::CALCULATED_BUS:
        case ComponentInterface::HVDC_LINE:
          break;
      }
      if (busInterface) {
        shared_ptr<ModelBus> modelBus = modelBusById[busInterface->getID()];
        (*iTfo)->setBusMonitored(modelBus);
      }
    }
  }

  // =============================
  //    CREATE HVDC MODEL
  // =============================
  const vector<shared_ptr<HvdcLineInterface> >& hvdcs = network->getHvdcLines();

  // go through all hvdc lines
  vector<shared_ptr<HvdcLineInterface> >::const_iterator iHvdc;
  for (iHvdc = hvdcs.begin(); iHvdc != hvdcs.end(); ++iHvdc) {
    // search for the two converters associated with the current hvdc line
    string idVsc1 = (*iHvdc)->getIdConverter1();
    string idVsc2 = (*iHvdc)->getIdConverter2();

    map<string, shared_ptr<VscConverterInterface> >::const_iterator iVsc1;
    map<string, shared_ptr<VscConverterInterface> >::const_iterator iVsc2;
    map<string, shared_ptr<LccConverterInterface> >::const_iterator iLcc1;
    map<string, shared_ptr<LccConverterInterface> >::const_iterator iLcc2;

    iVsc1 = vscs.find(idVsc1);
    iVsc2 = vscs.find(idVsc2);
    iLcc1 = lccs.find(idVsc1);
    iLcc2 = lccs.find(idVsc2);
    string id = (*iHvdc)->getID();
    // if the link is a HVDC-VSC link
    //----------------------------------
    if (iVsc1 != vscs.end() && iVsc2 != vscs.end()) {
      // add the hvdc line in the component list
      componentsById[ id ] = (*iHvdc);
      // add the two converters in the component list
      componentsById[ idVsc1 ] = iVsc1->second;
      componentsById[ idVsc2 ] = iVsc2->second;

      shared_ptr<ModelHvdcLink> modelHvdcLinkVsc(new ModelHvdcLink(iVsc1->second, iVsc2->second, (*iHvdc)));
      modelHvdcLinkVsc->setNetwork(this);

      if (iVsc1->second->getBusInterface()) {
        shared_ptr<ModelBus> modelBus = modelBusById[iVsc1->second->getBusInterface()->getID()];
        modelHvdcLinkVsc->setModelBus1(modelBus);
      }
      if (iVsc2->second->getBusInterface()) {
        shared_ptr<ModelBus> modelBus = modelBusById[iVsc2->second->getBusInterface()->getID()];
        modelHvdcLinkVsc->setModelBus2(modelBus);
      }

      initComponents_.push_back(modelHvdcLinkVsc);

      // is there a dynamic model?
      if ((*iHvdc)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(HvdcExtDynModel, id) << Trace::endline;
        continue;
      }

      Trace::debug("NETWORK") << DYNLog(AddingHvdcToNetwork, id) << Trace::endline;
      components_.push_back(modelHvdcLinkVsc);
      // declare reference between subModel and static data
      data->setReference("p", idVsc1, id, "P1_value");
      data->setReference("q", idVsc1, id, "Q1_value");
      data->setReference("state", idVsc1, id, "state1_value");
      data->setReference("p", idVsc2, id, "P2_value");
      data->setReference("q", idVsc2, id, "Q2_value");
      data->setReference("state", idVsc2, id, "state2_value");

    } else if (iLcc1 != lccs.end() && iLcc2 != lccs.end()) {  // if the link is a HVDC-LCC link
      // add the hvdc line in the component list
      componentsById[ id ] = (*iHvdc);
      // add the two converters in the component list
      componentsById[ idVsc1 ] = iLcc1->second;
      componentsById[ idVsc2 ] = iLcc2->second;

      shared_ptr<ModelHvdcLink> modelHvdcLinkLcc(new ModelHvdcLink(iLcc1->second, iLcc2->second, (*iHvdc)));
      modelHvdcLinkLcc->setNetwork(this);
      if (iLcc1->second->getBusInterface()) {
        shared_ptr<ModelBus> modelBus = modelBusById[iLcc1->second->getBusInterface()->getID()];
        modelHvdcLinkLcc->setModelBus1(modelBus);
      }
      if (iLcc2->second->getBusInterface()) {
        shared_ptr<ModelBus> modelBus = modelBusById[iLcc2->second->getBusInterface()->getID()];
        modelHvdcLinkLcc->setModelBus2(modelBus);
      }

      initComponents_.push_back(modelHvdcLinkLcc);

      // is there a dynamic model?
      if ((*iHvdc)->hasDynamicModel()) {
        Trace::info("NETWORK") << DYNLog(HvdcExtDynModel, id) << Trace::endline;
        continue;
      }

      Trace::debug("NETWORK") << DYNLog(AddingHvdcToNetwork, id) << Trace::endline;
      components_.push_back(modelHvdcLinkLcc);
      // declare reference between subModel and static data
      data->setReference("p", idVsc1, id, "P1_value");
      data->setReference("q", idVsc1, id, "Q1_value");
      data->setReference("state", idVsc1, id, "state1_value");
      data->setReference("p", idVsc2, id, "P2_value");
      data->setReference("q", idVsc2, id, "Q2_value");
      data->setReference("state", idVsc2, id, "state2_value");

    } else {
      throw DYNError(Error::MODELER, WrongIIDMDataForHVDC, id);
    }
  }
}

void
ModelNetwork::initializeStaticData() {
  int yNum = 0;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    (*itComponent)->init(yNum);
    (*itComponent)->initSize();
  }
}

void
ModelNetwork::analyseComponents() {
  // keep the biggest component
  vector< shared_ptr<SubNetwork> > subNetworks = busContainer_->getSubNetworks();
  unsigned int nbMaxNode = 0;
  unsigned int maxIndex = 0;
  for (unsigned int i = 0; i < subNetworks.size(); ++i) {
    if (subNetworks[i]->nbBus() > nbMaxNode) {
      nbMaxNode = subNetworks[i]->nbBus();
      maxIndex = i;
    }
  }
  Trace::debug() << DYNLog(KeepSubNetwork, maxIndex) << Trace::endline;
  for (unsigned int i = 0; i < subNetworks.size(); ++i) {
    if (i == maxIndex)
      subNetworks[i]->turnOnNodes();
    else
      subNetworks[i]->shutDownNodes();
  }
}

void
ModelNetwork::computeComponents() {
  Timer * timer1 = new Timer("ModelNetwork::computeComponents");
  busContainer_->resetSubNetwork();

  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->addBusNeighbors();

  // connectivity calculation
  busContainer_->exploreNeighbors();

  delete timer1;
}

void
ModelNetwork::getSize() {
  sizeY_ = 0;
  sizeZ_ = 0;
  sizeMode_ = 0;
  sizeF_ = 0;
  sizeG_ = 0;
  sizeCalculatedVar_ = 0;
  if (!isInitModel_)
    Trace::debug("MODELER") << "=== MODEL NETWORK ===" << Trace::endline;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    sizeY_ += (*itComponent)->sizeY();
    sizeZ_ += (*itComponent)->sizeZ();
    sizeMode_ += (*itComponent)->sizeMode();
    if ((*itComponent)->sizeF() != 0 && !isInitModel_)
      Trace::debug("MODELER") << (*itComponent)->id() << "    F[" << std::setw(6) << sizeF_ << " ; " << std::setw(6)
                              << sizeF_ + (*itComponent)->sizeF() << "[" << Trace::endline;
    sizeF_ += (*itComponent)->sizeF();
    sizeG_ += (*itComponent)->sizeG();
    sizeCalculatedVar_ += (*itComponent)->sizeCalculatedVar();
  }
  if (!isInitModel_)
    Trace::debug("MODELER") << "=====================" << Trace::endline;
}

void
ModelNetwork::initSubBuffers() {
  if (isInitModel_) {
    int offsetY = 0;
    int offsetF = 0;
    yLocalInit_.resize(sizeY_);
    ypLocalInit_.resize(sizeY_);
    fLocalInit_.resize(sizeF_);
    vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
    for (itComponent = initComponents_.begin(); itComponent != initComponents_.end(); ++itComponent) {
      if ((*itComponent)->sizeY() != 0) {
        (*itComponent)->setReferenceY(&yLocalInit_[0], &ypLocalInit_[0], &fLocalInit_[0], offsetY, offsetF);
        offsetY += (*itComponent)->sizeY();
        offsetF += (*itComponent)->sizeF();
      }
    }
  } else {
    if (calculatedVarBuffer_ != NULL)
      delete[] calculatedVarBuffer_;

    calculatedVarBuffer_ = new double[sizeCalculatedVar_];
    calculatedVars_.assign(sizeCalculatedVar_, 0);

    int offsetY = 0;
    int offsetF = 0;
    int offsetZ = 0;
    int offsetCalculatedVars = 0;
    int offsetG = 0;

    vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
    for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
      if ((*itComponent)->sizeY() != 0) {
        (*itComponent)->setReferenceY(yLocal_, ypLocal_, fLocal_, offsetY, offsetF);
        offsetY += (*itComponent)->sizeY();
        offsetF += (*itComponent)->sizeF();
      }
      if ((*itComponent)->sizeZ() != 0) {
        (*itComponent)->setReferenceZ(zLocal_, offsetZ);
        offsetZ += (*itComponent)->sizeZ();
      }
      if ((*itComponent)->sizeCalculatedVar() != 0) {
        (*itComponent)->setReferenceCalculatedVar(calculatedVarBuffer_, offsetCalculatedVars);
        offsetCalculatedVars += (*itComponent)->sizeCalculatedVar();
      }
      if ((*itComponent)->sizeG() != 0) {
        (*itComponent)->setReferenceG(gLocal_, offsetG);
        offsetG += (*itComponent)->sizeG();
      }
    }
  }
}

void
ModelNetwork::evalF(const double& /*t*/) {
#ifdef _DEBUG_
  Timer timer("ModelNetwork::evalF");
#endif

  // compute nodal current injections (convention: > 0 if the current goes out of the node)

  busContainer_->resetNodeInjections();

  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
#ifdef _DEBUG_
  Timer * timer2 = new Timer("ModelNetwork::evalF_evalNodeInjection");
#endif
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalNodeInjection();
#ifdef _DEBUG_
  delete timer2;
#endif

  // evaluate F
#ifdef _DEBUG_
  Timer timer3("ModelNetwork::evalF_evalF");
#endif
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalF();
}

void
ModelNetwork::evalG(const double& t) {
  Timer timer3("ModelNetwork::evalG");
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalG(t);
}

void
ModelNetwork::evalZ(const double& t) {
  Timer timer3("ModelNetwork::evalZ");
  bool topoChange = false;
  bool stateChange = false;
  for (vector<shared_ptr<NetworkComponent> >::const_iterator  itComponent = getComponents().begin(), itEnd = getComponents().end();
      itComponent != itEnd; ++itComponent) {
    switch ((*itComponent)->evalZ(t)) {
    case NetworkComponent::TOPO_CHANGE:
      topoChange = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      stateChange = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }
  if (topoChange) {
    breakModelSwitchLoops();
    evalYMat();
    computeComponents();
    analyseComponents();
  } else if (stateChange) {
    evalYMat();
  }
}

modeChangeType_t
ModelNetwork::evalMode(const double& t) {
  /* Two kinds of events are controlled:
   *     1. State or topological change on the network (given by the evalState method)
   *     2. Short-circuit on a bus (given by the evalNodeFault method)
   */
  bool topoChange = false;
  bool stateChange = false;
  modeChangeType_t modeChangeType = NO_MODE;

  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    switch ((*itComponent)->evalState(t)) {
    case NetworkComponent::TOPO_CHANGE:
      topoChange = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      stateChange = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }

  // recalculate admittance matrix and reevaluate connectivity
  if (topoChange) {
    modeChangeType = ALGEBRAIC_J_UPDATE_MODE;
  } else if (stateChange) {
    modeChangeType = ALGEBRAIC_MODE;
  }

  return modeChangeType;
}

void
ModelNetwork::evalCalculatedVars() {
  Timer timer3("ModelNetwork::calculatedVars");
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalCalculatedVars();

  std::copy(calculatedVarBuffer_, calculatedVarBuffer_ + sizeCalculatedVar_, calculatedVars_.begin());
}

void
ModelNetwork::evalJt(const double& /*t*/, const double& cj, SparseMatrix& jt, const int& rowOffset) {
  Timer timer("ModelNetwork::evalJ");

  // init bus derivatives
  Timer * timer2 = new Timer("evalJt_initBusDerivatives");
  busContainer_->initDerivatives();
  delete timer2;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;

  // fill bus derivatives
  Timer * timer3 = new Timer("evalJt_evalDerivatives");

  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalDerivatives(cj);
  delete timer3;

  // fill sparse matrix Jt
  Timer * timer1 = new Timer("EvalJt_evalJt");
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalJt(jt, cj, rowOffset);
  delete timer1;
}

void
ModelNetwork::evalJtPrim(const double& /*t*/, const double& /*cj*/, SparseMatrix& jt, const int& rowOffset) {
  for (vector<shared_ptr<NetworkComponent> >::const_iterator itComponent = getComponents().begin();
       itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalDerivativesPrim();

  for (vector<shared_ptr<NetworkComponent> >::const_iterator itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalJtPrim(jt, rowOffset);
}

vector<int>
ModelNetwork::getDefJCalculatedVarI(int iCalculatedVar) {
  int index = componentIndexByCalculatedVar_[iCalculatedVar];
  int varIndex = iCalculatedVar - getComponents()[index]->getOffsetCalculatedVar();
  vector<int> numVars;
  getComponents()[index]->getDefJCalculatedVarI(varIndex, numVars);
  return numVars;
}

void
ModelNetwork::evalJCalculatedVarI(int iCalculatedVar, double* y, double* yp, vector<double> &res) {
  int index = componentIndexByCalculatedVar_[iCalculatedVar];
  int varIndex = iCalculatedVar - getComponents()[index]->getOffsetCalculatedVar();
  getComponents()[index]->evalJCalculatedVarI(varIndex, y, yp, res);
}

double
ModelNetwork::evalCalculatedVarI(int iCalculatedVar, double* y, double* yp) {
  int index = componentIndexByCalculatedVar_[iCalculatedVar];
  int varIndex = iCalculatedVar - getComponents()[index]->getOffsetCalculatedVar();
  return getComponents()[index]->evalCalculatedVarI(varIndex, y, yp);
}

void
ModelNetwork::getY0() {
  isInit_ = true;

  busContainer_->resetNodeInjections();

  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalNodeInjection();

  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    (*itComponent)->getY0();
  }

  isInit_ = false;
}

void
ModelNetwork::initParams() {
  if (!withNodeBreakerTopology_) {
    isInitModel_ = false;
    vLevelInitComponents_.clear();
    initComponents_.clear();
    return;
  }

  isInitModel_ = true;

  init(getCurrentTime());
  getY0();

  // solve initial problem
  // generally, if the input is a network after a load flow, 5 iterations are enough to converge
  // otherwise, the network is not balanced, and the global init of the model would be necessary to compute switches currents
  SolverKINSubModel solver;
  const int nbMaxIter = 5;
  solver.init(this, 0, &yLocalInit_[0], &fLocalInit_[0], nbMaxIter);

  try {
  solver.solve();
  vector<shared_ptr<ModelVoltageLevel> >::const_iterator itComponentVL;
  for (itComponentVL = vLevelInitComponents_.begin(); itComponentVL != vLevelInitComponents_.end(); ++itComponentVL)
    (*itComponentVL)->setInitialSwitchCurrents();
  } catch (const DYN::Error &) {
    Trace::warn() << DYNLog(NetworkInitSwitchCurrentsFailed) << Trace::endline;
  }

  vLevelInitComponents_.clear();
  initComponents_.clear();
  solver.clean();
  isInitModel_ = false;
}

void
ModelNetwork::defineVariables(vector<boost::shared_ptr<Variable> >& variables) {
  if (components_.size() == 0) {
    ModelVoltageLevel::defineVariables(variables);
    ModelLine::defineVariables(variables);
    ModelThreeWindingsTransformer::defineVariables(variables);
    ModelTwoWindingsTransformer::defineVariables(variables);
    ModelHvdcLink::defineVariables(variables);
  } else {
    componentIndexByCalculatedVar_.clear();
    unsigned int index = 0;
    unsigned int sizeCalculatedVars = 0;
    vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
    for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
      (*itComponent)->instantiateVariables(variables);
      (*itComponent)->setOffsetCalculatedVar(sizeCalculatedVars);
      sizeCalculatedVars += (*itComponent)->sizeCalculatedVar();
      componentIndexByCalculatedVar_.resize(sizeCalculatedVars, index);
      ++index;
    }
  }
}

void
ModelNetwork::defineParameters(vector<ParameterModeler>& parameters) {
  ModelVoltageLevel::defineParameters(parameters);
  ModelLine::defineParameters(parameters);
  ModelThreeWindingsTransformer::defineParameters(parameters);
  ModelTwoWindingsTransformer::defineParameters(parameters);
  ModelHvdcLink::defineParameters(parameters);

  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    (*itComponent)->defineNonGenericParameters(parameters);
  }
}

void
ModelNetwork::evalYType() {
  unsigned int offset = 0;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    if ((*itComponent)->sizeY() != 0) {
      (*itComponent)->setBufferYType(yType_, offset);
      offset += (*itComponent)->sizeY();
      (*itComponent)->evalYType();
    }
  }
}

void
ModelNetwork::updateYType() {
  for (vector<shared_ptr<NetworkComponent> >::const_iterator itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    if ((*itComponent)->sizeY() != 0) {
      (*itComponent)->updateYType();
    }
  }
}

void
ModelNetwork::evalFType() {
  unsigned int offsetComponent = 0;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    if ((*itComponent)->sizeF() != 0) {
      (*itComponent)->setBufferFType(fType_, offsetComponent);
      offsetComponent += (*itComponent)->sizeF();
      (*itComponent)->evalFType();
    }
  }
}

void
ModelNetwork::updateFType() {
  for (vector<shared_ptr<NetworkComponent> >::const_iterator itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    if ((*itComponent)->sizeF() != 0)
      (*itComponent)->evalFType();
  }
}

void
ModelNetwork::defineElements(vector<Element>& elements, map<string, int>& mapElement) {
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    (*itComponent)->defineElements(elements, mapElement);
  }
}

void
ModelNetwork::setSubModelParameters() {
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    (*itComponent)->setSubModelParameters(parametersDynamic_);
  }
}

void
ModelNetwork::evalYMat() {
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent)
    (*itComponent)->evalYMat();
}

void
ModelNetwork::init(const double& /*t0*/) {
  initializeStaticData();

  getSize();
  initSubBuffers();

  computeComponents();
  analyseComponents();

  evalYMat();
  /*
   * Determine which switch can break a loop in a voltage level or a node
   * Used to break the current loops by using current variables in switch models
   */
  breakModelSwitchLoops();
}

void
ModelNetwork::breakModelSwitchLoops() {
  busContainer_->initRefIslands();

  vector<shared_ptr<ModelVoltageLevel> >::const_iterator itComponentVL;
  for (itComponentVL = getVoltageLevels().begin(); itComponentVL != getVoltageLevels().end(); ++itComponentVL)
    (*itComponentVL)->computeLoops();
}

void
ModelNetwork::setFequationsInit() {
  unsigned int offset = 0;
  bool isInitModelSave = isInitModel_;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  // Initialization models equations
  fEquationInitIndex_.clear();
  isInitModel_ = true;
  for (itComponent = initComponents_.begin(); itComponent != initComponents_.end(); ++itComponent) {
    map<int, string> FpropComponent;
    (*itComponent)->setFequations(FpropComponent);

    map<int, string>::const_iterator itMapFprop;
    for (itMapFprop = FpropComponent.begin(); itMapFprop != FpropComponent.end(); ++itMapFprop) {
      int index = offset + itMapFprop->first;
      string formula = itMapFprop->second;
      fEquationInitIndex_[index] = formula;
    }
    offset += FpropComponent.size();
  }
  isInitModel_ = isInitModelSave;
}

void
ModelNetwork::setFequations() {
  unsigned int offset = 0;
  bool isInitModelSave = isInitModel_;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;

  isInitModel_ = false;
  fEquationIndex_.clear();
  for (itComponent = components_.begin(); itComponent != components_.end(); ++itComponent) {
    map<int, string> FpropComponent;
    (*itComponent)->setFequations(FpropComponent);

    map<int, string>::const_iterator itMapFprop;
    for (itMapFprop = FpropComponent.begin(); itMapFprop != FpropComponent.end(); ++itMapFprop) {
      int index = offset + itMapFprop->first;
      string formula = itMapFprop->second;
      fEquationIndex_[index] = formula;
    }
    offset += FpropComponent.size();
  }
  isInitModel_ = isInitModelSave;
}

void
ModelNetwork::setGequations() {
  unsigned int offset = 0;
  vector<shared_ptr<NetworkComponent> >::const_iterator itComponent;
  for (itComponent = getComponents().begin(); itComponent != getComponents().end(); ++itComponent) {
    if ((*itComponent)->sizeG() != 0) {
      map<int, string> GpropComponent;
      (*itComponent)->setGequations(GpropComponent);

      map<int, string>::const_iterator itMapGprop;
      for (itMapGprop = GpropComponent.begin(); itMapGprop != GpropComponent.end(); ++itMapGprop) {
        int index = offset + itMapGprop->first;
        string formula = itMapGprop->second;
        gEquationIndex_[index] = formula;
      }
      offset += GpropComponent.size();
    }
  }
}

}  // namespace DYN
