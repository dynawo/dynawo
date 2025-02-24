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

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/vector.hpp>

#include "DYNModelNetwork.h"
#include "DYNModelNetwork.hpp"

#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "DYNModelConstants.h"
#include "DYNModelBus.h"
#include "DYNModelSwitchFactory.h"
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

#include "DYNFileSystemUtils.h"


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
ModelCPP("NETWORK"),
calculatedVarBuffer_(NULL),
isInit_(false) ,
isInitModel_(false),
withNodeBreakerTopology_(false),
deactivateRootFunctions_(false) {
  busContainer_.reset(new ModelBusContainer());
}

ModelNetwork::~ModelNetwork() {
  delete[] calculatedVarBuffer_;
  calculatedVarBuffer_ = NULL;
}

void
ModelNetwork::initializeFromData(const shared_ptr<DataInterface>& data) {
#if defined(_DEBUG_)
  Timer timer("ModelNetwork::initializeFromData");
#endif
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << "Network initialization" << Trace::endline;
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  shared_ptr<NetworkInterface> network = data->getNetwork();
  map<string, std::shared_ptr<ComponentInterface> > componentsById;
  map<string, std::shared_ptr<ModelBus> > modelBusById;
  map<string, std::shared_ptr<VscConverterInterface> > vscs;
  map<string, std::shared_ptr<LccConverterInterface> > lccs;

  for (const auto& voltageLevel : network->getVoltageLevels()) {
    const string& voltageLevelId = voltageLevel->getID();
    Trace::debug(Trace::network()) << DYNLog(AddingVoltageLevelToNetwork, voltageLevelId) << Trace::endline;
    std::shared_ptr<ModelVoltageLevel> modelVoltageLevel(new ModelVoltageLevel(voltageLevel));
    std::shared_ptr<ModelVoltageLevel> modelVoltageLevelInit(new ModelVoltageLevel(voltageLevel));
    // Add to containers
    components_.push_back(modelVoltageLevel);
    initComponents_.push_back(modelVoltageLevelInit);
    vLevelComponents_.push_back(modelVoltageLevel);
    vLevelInitComponents_.push_back(modelVoltageLevelInit);
    modelVoltageLevel->setNetwork(this);
    if (voltageLevel->isNodeBreakerTopology())
      withNodeBreakerTopology_ = true;

    // ==============================
    //    CREATE BUS MODEL
    // ==============================
    for (const auto& bus : voltageLevel->getBuses()) {
      string id = bus->getID();
      std::shared_ptr<ModelBus> modelBus(new ModelBus(bus, voltageLevel->isNodeBreakerTopology()));
      componentsById[id] = bus;
      modelBusById[id] = modelBus;
      // Add to containers
      modelVoltageLevelInit->addBus(modelBus);
      initEvalGComponents_.push_back(modelBus);
      modelBus->setNetwork(this);
      modelBus->setVoltageLevel(modelVoltageLevel);
      if (bus->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(BusExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingBusToNetwork, id) << Trace::endline;
      modelVoltageLevel->addBus(modelBus);
      busContainer_->add(modelBus);
      evalGComponents_.push_back(modelBus);
      // declare reference between subModel and static data
      data->setReference("v", id, id, "U_value");
      data->setReference("angle", id, id, "phi_value");
    }

    // =============================
    //    CREATE SWITCH MODEL
    // =============================
    for (const auto& aSwitch : voltageLevel->getSwitches()) {
      string id = aSwitch->getID();
      componentsById[id] = aSwitch;
      std::shared_ptr<ModelSwitch> modelSwitch(new ModelSwitch(aSwitch));

      modelSwitch->setNetwork(this);
      if (aSwitch->getBusInterface1()) {
        std::shared_ptr<ModelBus> modelBus1 = modelBusById[aSwitch->getBusInterface1()->getID()];
        modelSwitch->setModelBus1(modelBus1);
      }
      if (aSwitch->getBusInterface2()) {
        std::shared_ptr<ModelBus> modelBus2 = modelBusById[aSwitch->getBusInterface2()->getID()];
        modelSwitch->setModelBus2(modelBus2);
      }

      modelVoltageLevelInit->addSwitch(modelSwitch);

      if (aSwitch->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(SwitchExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingSwitchToNetwork, id) << Trace::endline;
      // Add to containers
      modelVoltageLevel->addSwitch(modelSwitch);
      // declare reference between subModel and static data
      data->setReference("state", id, id, "state_value");
    }

    // =============================
    //    CREATE LOAD MODEL
    // =============================
    for (const auto& load : voltageLevel->getLoads()) {
      const string& id = load->getID();
      componentsById[id] = load;
      std::shared_ptr<ModelBus> modelBus = modelBusById[load->getBusInterface()->getID()];
      std::shared_ptr<ModelLoad> modelLoad(new ModelLoad(*load, *modelBus));
      modelLoad->setNetwork(this);
      modelVoltageLevelInit->addComponent(modelLoad);

      if (load->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(LoadExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingLoadToNetwork, id) << Trace::endline;
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
    for (const auto& generator : voltageLevel->getGenerators()) {
      string id = generator->getID();
      componentsById[id] = generator;
      std::shared_ptr<ModelGenerator> modelGenerator(new ModelGenerator(generator));
      modelGenerator->setNetwork(this);
      std::shared_ptr<ModelBus> modelBus = modelBusById[generator->getBusInterface()->getID()];
      modelGenerator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelGenerator);

      if (generator->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(GeneratorExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingGeneratorToNetwork, id) << Trace::endline;
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
    for (const auto& shunt : voltageLevel->getShuntCompensators()) {
      string id = shunt->getID();
      componentsById[id] = shunt;
      std::shared_ptr<ModelShuntCompensator> modelShuntCompensator(new ModelShuntCompensator(shunt));
      modelShuntCompensator->setNetwork(this);
      std::shared_ptr<ModelBus> modelBus = modelBusById[shunt->getBusInterface()->getID()];
      modelShuntCompensator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelShuntCompensator);
      modelVoltageLevelInit->addComponentEvalG(modelShuntCompensator);
      initEvalGComponents_.push_back(modelShuntCompensator);

      if (shunt->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(ShuntExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingShuntToNetwork, id) << Trace::endline;
      // add to containers
      modelVoltageLevel->addComponent(modelShuntCompensator);
      modelVoltageLevel->addComponentEvalG(modelShuntCompensator);
      evalGComponents_.push_back(modelShuntCompensator);
      // declare reference between subModel and static data
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
      data->setReference("currentSection", id, id, "currentSection_value");
    }

    // =======================================
    //    CREATE STATIC VAR COMPENSATOR MODEL
    // =======================================
    for (const auto& sVarC : voltageLevel->getStaticVarCompensators()) {
      string id = sVarC->getID();
      componentsById[id] = sVarC;
      std::shared_ptr<ModelStaticVarCompensator> modelStaticVarCompensator(new ModelStaticVarCompensator(sVarC));
      modelStaticVarCompensator->setNetwork(this);
      std::shared_ptr<ModelBus> modelBus = modelBusById[sVarC->getBusInterface()->getID()];
      modelStaticVarCompensator->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelStaticVarCompensator);

      if (sVarC->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(SVCExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingSVCToNetwork, id) << Trace::endline;
      // Add to containers
      modelVoltageLevel->addComponent(modelStaticVarCompensator);
      // declare reference between subModel and static data
      data->setReference("p", id, id, "P_value");
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
      if (sVarC->hasStandbyAutomaton()) {
        data->setReference("regulatingMode", id, id, "mode_value");
      }
    }

    // =================================
    //    CREATE DANGLING LINES  MODEL
    // =================================
    for (const auto& danglingLine : voltageLevel->getDanglingLines()) {
      string id = danglingLine->getID();
      componentsById[id] = danglingLine;
      std::shared_ptr<ModelDanglingLine> modelDanglingLine(new ModelDanglingLine(danglingLine));
      modelDanglingLine->setNetwork(this);
      std::shared_ptr<ModelBus> modelBus = modelBusById[danglingLine->getBusInterface()->getID()];
      modelDanglingLine->setModelBus(modelBus);

      modelVoltageLevelInit->addComponent(modelDanglingLine);
      modelVoltageLevelInit->addComponentEvalG(modelDanglingLine);
      initEvalGComponents_.push_back(modelDanglingLine);

      if (danglingLine->hasDynamicModel()) {
        Trace::debug(Trace::network()) << DYNLog(DanglingLineExtDynModel, id) << Trace::endline;
        continue;
      }
      Trace::debug(Trace::network()) << DYNLog(AddingDanglingLineToNetwork, id) << Trace::endline;
      // add to containers
      modelVoltageLevel->addComponent(modelDanglingLine);
      modelVoltageLevel->addComponentEvalG(modelDanglingLine);
      evalGComponents_.push_back(modelDanglingLine);
      // declare reference between subModel and static data
      data->setReference("p", id, id, "P_value");
      data->setReference("q", id, id, "Q_value");
      data->setReference("state", id, id, "state_value");
    }
  }

  // =============================
  //    CREATE LINES MODEL
  // =============================
  for (const auto& line : network->getLines()) {
    string id = line->getID();
    componentsById[id] = line;
    std::shared_ptr<ModelLine> modelLine(new ModelLine(line));
    modelLine->setNetwork(this);
    if (line->getBusInterface1()) {
      std::shared_ptr<ModelBus> modelBus1 = modelBusById[line->getBusInterface1()->getID()];
      modelLine->setModelBus1(modelBus1);
    }
    if (line->getBusInterface2()) {
      std::shared_ptr<ModelBus> modelBus2 = modelBusById[line->getBusInterface2()->getID()];
      modelLine->setModelBus2(modelBus2);
    }

    initComponents_.push_back(modelLine);
    initEvalGComponents_.push_back(modelLine);

    if (line->hasDynamicModel()) {
      Trace::debug(Trace::network()) << DYNLog(LineExtDynModel, id) << Trace::endline;
      continue;
    }

    Trace::debug(Trace::network()) << DYNLog(AddingLineToNetwork, id) << Trace::endline;
    // add to containers
    components_.push_back(modelLine);
    evalGComponents_.push_back(modelLine);
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
  vector<std::shared_ptr<ModelTwoWindingsTransformer> > modelsTfo;
  for (const auto& twoWTfo : network->getTwoWTransformers()) {
    string id = twoWTfo->getID();
    componentsById[id] = twoWTfo;
    std::shared_ptr<ModelTwoWindingsTransformer> modelTwoWindingsTransformer(new ModelTwoWindingsTransformer(twoWTfo));
    modelsTfo.push_back(modelTwoWindingsTransformer);
    modelTwoWindingsTransformer->setNetwork(this);
    if (twoWTfo->getBusInterface1()) {
      std::shared_ptr<ModelBus> modelBus1 = modelBusById[twoWTfo->getBusInterface1()->getID()];
      modelTwoWindingsTransformer->setModelBus1(modelBus1);
    }
    if (twoWTfo->getBusInterface2()) {
      std::shared_ptr<ModelBus> modelBus2 = modelBusById[twoWTfo->getBusInterface2()->getID()];
      modelTwoWindingsTransformer->setModelBus2(modelBus2);
    }

    initComponents_.push_back(modelTwoWindingsTransformer);
    initEvalGComponents_.push_back(modelTwoWindingsTransformer);

    if (twoWTfo->hasDynamicModel()) {
      Trace::debug(Trace::network()) << DYNLog(TwoWTfoExtDynModel, id) << Trace::endline;
      continue;
    }
    Trace::debug(Trace::network()) << DYNLog(AddingTwoWTfoToNetwork, id) << Trace::endline;

    // add to containers
    components_.push_back(modelTwoWindingsTransformer);
    evalGComponents_.push_back(modelTwoWindingsTransformer);

    // declare reference between subModel and static data
    data->setReference("p1", id, id, "P1_value");
    data->setReference("q1", id, id, "Q1_value");
    data->setReference("p2", id, id, "P2_value");
    data->setReference("q2", id, id, "Q2_value");
    data->setReference("state", id, id, "state_value");
    if (modelTwoWindingsTransformer->getModelRatioTapChanger() ||
        modelTwoWindingsTransformer->getModelPhaseTapChanger() ||
        (modelTwoWindingsTransformer->getModelTapChanger() && !modelTwoWindingsTransformer->getModelTapChanger()->isFictitious())) {
      data->setReference("tapIndex", id, id, "step_value");
    }
  }

  // =================================
  //    CREATE 3WTfo  MODEL
  // =================================
  for (const auto& threeWTfo : network->getThreeWTransformers()) {
    string id = threeWTfo->getID();
    componentsById[id] = threeWTfo;
    std::shared_ptr<ModelThreeWindingsTransformer> modelThreeWindingsTransformer(new ModelThreeWindingsTransformer(threeWTfo));
    modelThreeWindingsTransformer->setNetwork(this);
    if (threeWTfo->getBusInterface1()) {
      std::shared_ptr<ModelBus> modelBus1 = modelBusById[threeWTfo->getBusInterface1()->getID()];
      modelThreeWindingsTransformer->setModelBus1(modelBus1);
    }
    if (threeWTfo->getBusInterface2()) {
      std::shared_ptr<ModelBus> modelBus2 = modelBusById[threeWTfo->getBusInterface2()->getID()];
      modelThreeWindingsTransformer->setModelBus2(modelBus2);
    }
    if (threeWTfo->getBusInterface3()) {
      std::shared_ptr<ModelBus> modelBus3 = modelBusById[threeWTfo->getBusInterface3()->getID()];
      modelThreeWindingsTransformer->setModelBus3(modelBus3);
    }

    initComponents_.push_back(modelThreeWindingsTransformer);
    initEvalGComponents_.push_back(modelThreeWindingsTransformer);

    if (threeWTfo->hasDynamicModel()) {
      Trace::debug(Trace::network()) << DYNLog(ThreeWTfoExtDynModel, id) << Trace::endline;
      continue;
    }

    Trace::debug(Trace::network()) << DYNLog(AddingThreeWTfoToNetwork, id) << Trace::endline;

    // add to containers
    components_.push_back(modelThreeWindingsTransformer);
    evalGComponents_.push_back(modelThreeWindingsTransformer);
  }

  for (const auto& voltageLevel : network->getVoltageLevels()) {
    // ==============================================
    // STORE VSC/LCC interface, needed for HVDC lines
    // ==============================================
    for (const auto& vscConverter : voltageLevel->getVscConverters()) {
      string id = vscConverter->getID();
      vscs[id] = vscConverter;
    }

    for (const auto& lccConverter : voltageLevel->getLccConverters()) {
      string id = lccConverter->getID();
      lccs[id] = lccConverter;
    }
  }


  // =======================================
  //    CREATE TapChanger connection for tfo
  // =======================================
  for (const auto& modelTfo : modelsTfo) {
    if (modelTfo->getModelRatioTapChanger()) {
      string terminalRefId = modelTfo->getTerminalRefId();
      if (terminalRefId == "")
        continue;
      string side = modelTfo->getSide();
      map<string, std::shared_ptr<ComponentInterface> >::const_iterator iComponent = componentsById.find(terminalRefId);
      if (iComponent == componentsById.end())
        throw DYNError(Error::MODELER, UnknownComponent, terminalRefId);

      std::shared_ptr<BusInterface> busInterface;
      switch (iComponent->second->getType()) {
        case ComponentInterface::BUS:
          busInterface = std::dynamic_pointer_cast<BusInterface>(iComponent->second);
          break;
        case ComponentInterface::SWITCH:
          if (side == "ONE") {
            busInterface = std::dynamic_pointer_cast<SwitchInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = std::dynamic_pointer_cast<SwitchInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::LOAD:
          busInterface = std::dynamic_pointer_cast<LoadInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::LINE:
          if (side == "ONE") {
            busInterface = std::dynamic_pointer_cast<LineInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = std::dynamic_pointer_cast<LineInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::GENERATOR:
          busInterface = std::dynamic_pointer_cast<GeneratorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::SHUNT:
          busInterface = std::dynamic_pointer_cast<ShuntCompensatorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::SVC:
          busInterface = std::dynamic_pointer_cast<StaticVarCompensatorInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::DANGLING_LINE:
          busInterface = std::dynamic_pointer_cast<DanglingLineInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::TWO_WTFO:
          if (side == "ONE") {
            busInterface = std::dynamic_pointer_cast<TwoWTransformerInterface>(iComponent->second)->getBusInterface1();
          } else {
            busInterface = std::dynamic_pointer_cast<TwoWTransformerInterface>(iComponent->second)->getBusInterface2();
          }
          break;
        case ComponentInterface::THREE_WTFO:
          if (side == "ONE") {
            busInterface = std::dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface1();
          } else if (side == "TWO") {
            busInterface = std::dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface2();
          } else {
            busInterface = std::dynamic_pointer_cast<ThreeWTransformerInterface>(iComponent->second)->getBusInterface3();
          }
          break;
        case ComponentInterface::VSC_CONVERTER:
          busInterface = std::dynamic_pointer_cast<VscConverterInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::LCC_CONVERTER:
          busInterface = std::dynamic_pointer_cast<LccConverterInterface>(iComponent->second)->getBusInterface();
          break;
        case ComponentInterface::UNKNOWN:
        case ComponentInterface::CALCULATED_BUS:
        case ComponentInterface::HVDC_LINE:
        case ComponentInterface::COMPONENT_TYPE_COUNT:
          break;
      }
      if (busInterface) {
        std::shared_ptr<ModelBus> modelBus = modelBusById[busInterface->getID()];
        modelTfo->setBusMonitored(modelBus);
      }
    }
  }

  // =============================
  //    CREATE HVDC MODEL
  // =============================
  for (const auto&  hvdcLine : network->getHvdcLines()) {
    string id = hvdcLine->getID();
    string idVsc1 = hvdcLine->getIdConverter1();
    string idVsc2 = hvdcLine->getIdConverter2();

    // retrieve the two converters associated with the current hvdc line
    const std::shared_ptr<ConverterInterface>& conv1 = hvdcLine->getConverter1();
    const std::shared_ptr<ConverterInterface>& conv2 = hvdcLine->getConverter2();

    // add the hvdc line and convertesr in the component list
    componentsById[ id ] = hvdcLine;
    componentsById[ idVsc1 ] = conv1;
    componentsById[ idVsc2 ] = conv2;

    std::shared_ptr<ModelHvdcLink> modelHvdcLink = std::make_shared<ModelHvdcLink>(hvdcLine);
    modelHvdcLink->setNetwork(this);
    if (conv1->getBusInterface()) {
      std::shared_ptr<ModelBus> modelBus = modelBusById[conv1->getBusInterface()->getID()];
      modelHvdcLink->setModelBus1(modelBus);
    }
    if (conv2->getBusInterface()) {
      std::shared_ptr<ModelBus> modelBus = modelBusById[conv2->getBusInterface()->getID()];
      modelHvdcLink->setModelBus2(modelBus);
    }

    initComponents_.push_back(modelHvdcLink);

    // is there a dynamic model?
    if (hvdcLine->hasDynamicModel()) {
      Trace::debug(Trace::network()) << DYNLog(HvdcExtDynModel, id) << Trace::endline;
      continue;
    }
    Trace::debug(Trace::network()) << DYNLog(AddingHvdcToNetwork, id) << Trace::endline;

    // add to containers
    components_.push_back(modelHvdcLink);

    // declare reference between subModel and static data
    data->setReference("p1", id, id, "P1_value");
    data->setReference("q1", id, id, "Q1_value");
    data->setReference("state1", id, id, "state1_value");
    data->setReference("p2", id, id, "P2_value");
    data->setReference("q2", id, id, "Q2_value");
    data->setReference("state2", id, id, "state2_value");
  }

  if (Trace::logExists(Trace::network(), DEBUG))
    printStats(data);
}

void
ModelNetwork::printStats(const shared_ptr<DataInterface>& data) const {
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  Trace::debug(Trace::network()) << DYNLog(NetworkStats) << Trace::endline;
  Trace::debug(Trace::network()) << "------------------------------" << Trace::endline;
  const shared_ptr<NetworkInterface> network = data->getNetwork();
  unsigned nbVoltageLevels = 0;
  unsigned nbStaticBuses = 0;
  unsigned nbDynamicBuses = 0;
  unsigned nbStaticSwitches = 0;
  unsigned nbDynamicSwitches = 0;
  unsigned nbStaticLoads = 0;
  unsigned nbDynamicLoads = 0;
  unsigned nbStaticGens = 0;
  unsigned nbDynamicGens = 0;
  unsigned nbStaticShuntCompensators = 0;
  unsigned nbDynamicShuntCompensators = 0;
  unsigned nbStaticSVCs = 0;
  unsigned nbDynamicSVCs = 0;
  unsigned nbStaticDanglingLines = 0;
  unsigned nbDynamicDanglingLines = 0;
  unsigned nbStaticLines = 0;
  unsigned nbDynamicLines = 0;
  unsigned nbStatic2WTs = 0;
  unsigned nbDynamic2WTs = 0;
  unsigned nbStatic3WTs = 0;
  unsigned nbDynamic3WTs = 0;
  unsigned nbStaticHVDCs = 0;
  unsigned nbDynamicHVDCs = 0;


  const vector<std::shared_ptr<VoltageLevelInterface> >& voltageLevels = network->getVoltageLevels();
  nbVoltageLevels = static_cast<unsigned>(voltageLevels.size());
  for (const auto& voltageLevel : voltageLevels) {
    for (const auto& bus : voltageLevel->getBuses()) {
      if (bus->hasDynamicModel()) {
        ++nbDynamicBuses;
        continue;
      }
      ++nbStaticBuses;
    }

    for (const auto& aSwitch : voltageLevel->getSwitches()) {
      if (aSwitch->hasDynamicModel()) {
        ++nbDynamicSwitches;
        continue;
      }
      ++nbStaticSwitches;
    }

    for (const auto& load : voltageLevel->getLoads()) {
      if (load->hasDynamicModel()) {
        ++nbDynamicLoads;
        continue;
      }
      ++nbStaticLoads;
    }

    for (const auto& generator : voltageLevel->getGenerators()) {
      if (generator->hasDynamicModel()) {
        ++nbDynamicGens;
        continue;
      }
      ++nbStaticGens;
    }

    for (const auto& shunt : voltageLevel->getShuntCompensators()) {
      if (shunt->hasDynamicModel()) {
        ++nbDynamicShuntCompensators;
        continue;
      }
      ++nbStaticShuntCompensators;
    }

    for (const auto& sVarC : voltageLevel->getStaticVarCompensators()) {
      if (sVarC->hasDynamicModel()) {
        ++nbDynamicSVCs;
        continue;
      }
      ++nbStaticSVCs;
    }

    for (const auto& danglingLine : voltageLevel->getDanglingLines()) {
      if (danglingLine->hasDynamicModel()) {
        ++nbDynamicDanglingLines;
        continue;
      }
      ++nbStaticDanglingLines;
    }
  }

  for (const auto& line : network->getLines()) {
    if (line->hasDynamicModel()) {
      ++nbDynamicLines;
      continue;
    }
    ++nbStaticLines;
  }

  for (const auto& twoWTfo : network->getTwoWTransformers()) {
    if (twoWTfo->hasDynamicModel()) {
      ++nbDynamic2WTs;
      continue;
    }
    ++nbStatic2WTs;
  }

  for (const auto& threeWTfo : network->getThreeWTransformers()) {
    if (threeWTfo->hasDynamicModel()) {
      ++nbDynamic3WTs;
      continue;
    }
    ++nbStatic3WTs;
  }

  for (const auto& hvdcLine : network->getHvdcLines()) {
    if (hvdcLine->hasDynamicModel()) {
      ++nbDynamicHVDCs;
      continue;
    }
    ++nbStaticHVDCs;
  }

  stringstream ss;
  ss << nbVoltageLevels;
  Trace::debug(Trace::network()) << DYNLog(NetworkNbVoltagelevel, ss.str()) << Trace::endline;
  printComponentStats(KeyLog_t::NetworkNbBus, nbStaticBuses, nbDynamicBuses);
  printComponentStats(KeyLog_t::NetworkNbSwitches, nbStaticSwitches, nbDynamicSwitches);
  printComponentStats(KeyLog_t::NetworkNbLoads, nbStaticLoads, nbDynamicLoads);
  printComponentStats(KeyLog_t::NetworkNbGenerators, nbStaticGens, nbDynamicGens);
  printComponentStats(KeyLog_t::NetworkNbShunt, nbStaticShuntCompensators, nbDynamicShuntCompensators);
  printComponentStats(KeyLog_t::NetworkNbSVC, nbStaticSVCs, nbDynamicSVCs);
  printComponentStats(KeyLog_t::NetworkNbDanglingLine, nbStaticDanglingLines, nbDynamicDanglingLines);
  printComponentStats(KeyLog_t::NetworkNbLine, nbStaticLines, nbDynamicLines);
  printComponentStats(KeyLog_t::NetworkNbTwoWTfo, nbStatic2WTs, nbDynamic2WTs);
  printComponentStats(KeyLog_t::NetworkNbThreeWTfo, nbStatic3WTs, nbDynamic3WTs);
  printComponentStats(KeyLog_t::NetworkNbHVDC, nbStaticHVDCs, nbDynamicHVDCs);
}

void
ModelNetwork::printComponentStats(KeyLog_t::value message, unsigned nbStatic, unsigned nbDynamic) const {
  stringstream ss;
  stringstream ss2;
  stringstream ss3;
  ss << nbStatic;
  ss2 << nbDynamic;
  ss3 << nbStatic + nbDynamic;
  Trace::debug(Trace::network()) << (DYN::Message(Message::LOG_KEY, KeyLog_t::names(message)), ss3.str(), ss.str(), ss2.str()) << Trace::endline;
}

void
ModelNetwork::initializeStaticData() {
  int yNum = 0;
  for (const auto& component : getComponents()) {
    component->init(yNum);
  }
}

void
ModelNetwork::analyseComponents() const {
  // keep the biggest component
  const vector<shared_ptr<SubNetwork> >& subNetworks = busContainer_->getSubNetworks();
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
ModelNetwork::computeComponents(const double t) {
  // Timer timer1("ModelNetwork::computeComponents");
  busContainer_->resetSubNetwork();

  for (const auto& component : getComponents())
    component->addBusNeighbors();

  // connectivity calculation
  busContainer_->exploreNeighbors(t);
}

void
ModelNetwork::getSize() {
  sizeY_ = 0;
  sizeZ_ = 0;
  sizeMode_ = 0;
  sizeF_ = 0;
  sizeG_ = 0;
  sizeCalculatedVar_ = 0;
  componentIndexByCalculatedVar_.clear();
  unsigned int index = 0;
  for (const auto& component : getComponents()) {
    component->initSize();
    sizeY_ += component->sizeY();
    sizeZ_ += component->sizeZ();
    sizeMode_ += component->sizeMode();
    sizeF_ += component->sizeF();
    component->setOffsetCalculatedVar(sizeCalculatedVar_);
    sizeCalculatedVar_ += component->sizeCalculatedVar();
    componentIndexByCalculatedVar_.resize(sizeCalculatedVar_, index);
    ++index;
  }
  if (!deactivateRootFunctions_) {
    for (const auto& component : getComponents()) {
      sizeG_ += component->sizeG();
    }
  }
}

void
ModelNetwork::dumpUserReadableElementList(const std::string& nameElement) const {
  map<string, int> mapElement;
  vector<Element> elements;
  std::string modelName;
  for (const auto& component : components_) {
    if (nameElement.rfind(component->id(), 0) == 0) {
      component->defineElements(elements, mapElement);
      modelName = component->id();
    }
  }
  for (const auto& vlComponent : vLevelComponents_) {
    for (const auto& component : vlComponent->getComponents()) {
      if (nameElement.rfind(component->id(), 0) == 0) {
        component->defineElements(elements, mapElement);
        modelName = component->id();
      }
    }
  }
  if (!elements.empty()) {
    Trace::info() << DYNLog(NetworkElementNames, modelName) << Trace::endline;
    vector< std::pair<size_t, string> > vec;
    for (unsigned int i = 0; i < elements.size(); ++i) {
      const Element& element = elements[i];
      if (element.getTypeElement() == Element::TERMINAL) {
        vec.push_back(std::make_pair(LevensteinDistance(element.id(), nameElement, 10, 1, 10), element.id()));
      }
    }
    std::sort(vec.begin(), vec.end() , compStringDist());
    for (const auto& vecValue : vec) {
      Trace::info() << "  ->" << vecValue.second << Trace::endline;
    }
  } else {
    Trace::info() << DYNLog(NetworkElementCompNotFound, modelName) << Trace::endline;
  }
}

void
ModelNetwork::printModel() const {
  Trace::debug(Trace::modeler()) << DYNLog(ModelName) << std::setw(25) << std::left << modelType() << "=>" << name() << Trace::endline;
  Trace::debug(Trace::modeler()) << "         Y : [" << std::setw(6) << yDeb_ << " ; " << std::setw(6) << yDeb_ + sizeY() << "[" << Trace::endline;
  unsigned offset = yDeb_;
  for (const auto& component : components_) {
    if (component->sizeY() != 0) {
      Trace::debug(Trace::modeler()) << "           " << component->id() << "    Y[" << std::setw(6) << offset << " ; " << std::setw(6)
                              << offset + component->sizeY() << "[" << Trace::endline;
      offset += component->sizeY();
    }
  }
  Trace::debug(Trace::modeler()) << "         F : [" << std::setw(6) << fDeb_ << " ; " << std::setw(6) << fDeb_ + sizeF() << "[" << Trace::endline;
  offset = fDeb_;
  for (const auto& component : components_) {
    if (component->sizeF() != 0) {
      Trace::debug(Trace::modeler()) << "           " << component->id() << "    F[" << std::setw(6) << offset << " ; " << std::setw(6)
                              << offset + component->sizeF() << "[" << Trace::endline;
      offset += component->sizeF();
    }
  }

  if (sizeZ() != 0) {
    Trace::debug(Trace::modeler()) << "         Z : [" << std::setw(6) << zDeb_ << " ; " << std::setw(6) << zDeb_ + sizeZ() << "[" << Trace::endline;
  }
  if (sizeMode() != 0) {
    Trace::debug(Trace::modeler()) << "      mode : [" << std::setw(6) << modeDeb_ << " ; " << std::setw(6) << modeDeb_ + sizeMode() << "[" << Trace::endline;
  }


  if (sizeG() != 0) {
    Trace::debug(Trace::modeler()) << "         G : [" << std::setw(6) << gDeb_ << " ; " << std::setw(6) << gDeb_ + sizeG() << "[" << Trace::endline;
  }

  Trace::debug(Trace::modeler()) << Trace::endline;
}

void
ModelNetwork::initSubBuffers() {
  if (isInitModel_) {
    int offsetY = 0;
    int offsetF = 0;
    yLocalInit_.resize(sizeY_);
    ypLocalInit_.resize(sizeY_);
    fLocalInit_.resize(sizeF_);
    for (const auto& initComponent : initComponents_) {
      if (initComponent->sizeY() != 0) {
        initComponent->setReferenceY(&yLocalInit_[0], &ypLocalInit_[0], &fLocalInit_[0], offsetY, offsetF);
        offsetY += initComponent->sizeY();
        offsetF += initComponent->sizeF();
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

    for (const auto& component : components_) {
      if (component->sizeY() != 0) {
        component->setReferenceY(yLocal_, ypLocal_, fLocal_, offsetY, offsetF);
        offsetY += component->sizeY();
        offsetF += component->sizeF();
      }
      if (component->sizeZ() != 0) {
        component->setReferenceZ(zLocal_, zLocalConnected_, offsetZ);
        offsetZ += component->sizeZ();
      }
      if (component->sizeCalculatedVar() != 0) {
        component->setReferenceCalculatedVar(calculatedVarBuffer_, offsetCalculatedVars);
        offsetCalculatedVars += component->sizeCalculatedVar();
      }
      if (component->sizeG() != 0) {
        component->setReferenceG(gLocal_, offsetG);
        offsetG += component->sizeG();
      }
    }
  }
}

void
ModelNetwork::evalF(double /*t*/, const propertyF_t type) {
  Timer timer("ModelNetwork::evalF");

  if (type != DIFFERENTIAL_EQ) {
    // compute nodal current injections (convention: > 0 if the current goes out of the node)
    busContainer_->resetInjections();
    // busContainer_->resetCurrentUStatus();

    Timer* timer2 = new Timer("ModelNetwork::evalF_evalNodeInjection");
    for (const auto& component : getComponents())
      component->evalNodeInjection();

    delete timer2;
  }

  // evaluate F
  Timer* timer3 = new Timer("ModelNetwork::evalF_evalF");
  for (const auto& component : getComponents())
    component->evalF(type);
  delete timer3;
}

void
ModelNetwork::evalG(const double t) {
  if (deactivateRootFunctions_)
    return;
  // Timer timer3("ModelNetwork::evalG");
  for (const auto& component : getComponents())
    component->evalG(t);
}

void
ModelNetwork::evalZ(const double t) {
  Timer timer3("ModelNetwork::evalZ");
  bool topoChange = false;
  bool stateChange = false;
  for (const auto& component : getComponents()) {
    switch (component->evalZ(t, deactivateRootFunctions_)) {
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
    computeComponents(t);
    analyseComponents();
  } else if (stateChange) {
    evalYMat();
  }
}

modeChangeType_t
ModelNetwork::evalMode(const double t) {
  /* Two kinds of events are controlled:
   *     1. State or topological change on the network (given by the evalState method)
   *     2. Short-circuit on a bus (given by the evalNodeFault method)
   */
  bool topoChange = false;
  bool stateChange = false;
  modeChangeType_t modeChangeType = NO_MODE;

  for (const auto& component : getComponents()) {
    switch (component->evalState(t)) {
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
#if defined(_DEBUG_)
  Timer timer3("ModelNetwork::calculatedVars");
#endif
  for (const auto& component : getComponents())
    component->evalCalculatedVars();

  std::copy(calculatedVarBuffer_, calculatedVarBuffer_ + sizeCalculatedVar_, calculatedVars_.begin());
}

void
ModelNetwork::evalJt(const double /*t*/, const double cj, const int rowOffset, SparseMatrix& jt) {
  Timer timer("ModelNetwork::evalJt");

  // init bus derivatives
  Timer* timer2 = new Timer("ModelNetwork::evalJt_initDerivatives");
  busContainer_->initDerivatives();
  delete timer2;

  // fill bus derivatives
  Timer* timer3 = new Timer("ModelNetwork::evalJt_evalDerivatives");
  for (const auto& component : getComponents())
    component->evalDerivatives(cj);
  delete timer3;

  // fill sparse matrix Jt
  Timer* timer1 = new Timer("ModelNetwork::evalJt_evalJt");
  for (const auto& component : getComponents())
    component->evalJt(cj, rowOffset, jt);
  delete timer1;
}

void
ModelNetwork::evalJtPrim(const double /*t*/, const double /*cj*/, const int rowOffset, SparseMatrix& jtPrim) {
  for (const auto& component : getComponents())
    component->evalDerivativesPrim();

  for (const auto& component : getComponents())
    component->evalJtPrim(rowOffset, jtPrim);
}

void
ModelNetwork::getIndexesOfVariablesUsedForCalculatedVarI(const unsigned iCalculatedVar, std::vector<int>& indexes) const {
  const int index = componentIndexByCalculatedVar_[iCalculatedVar];
  const std::shared_ptr<NetworkComponent>& comp = isInitModel_ ?  initComponents_[index] : components_[index];
  const unsigned varIndex = iCalculatedVar - comp->getOffsetCalculatedVar();
  comp->getIndexesOfVariablesUsedForCalculatedVarI(varIndex, indexes);
}

void
ModelNetwork::evalJCalculatedVarI(unsigned iCalculatedVar, vector<double>& res) const {
  const int index = componentIndexByCalculatedVar_[iCalculatedVar];
  const std::shared_ptr<NetworkComponent>& comp = isInitModel_ ?  initComponents_[index] : components_[index];
  const unsigned varIndex = iCalculatedVar - comp->getOffsetCalculatedVar();
  comp->evalJCalculatedVarI(varIndex, res);
}

double
ModelNetwork::evalCalculatedVarI(const unsigned iCalculatedVar) const {
  const int index = componentIndexByCalculatedVar_[iCalculatedVar];
  const std::shared_ptr<NetworkComponent>& comp = isInitModel_ ?  initComponents_[index] : components_[index];
  const unsigned varIndex = iCalculatedVar - comp->getOffsetCalculatedVar();
  return comp->evalCalculatedVarI(varIndex);
}

void
ModelNetwork::getY0() {
  isInit_ = true;

  busContainer_->resetNodeInjections();

  for (const auto& component : getComponents())
    component->evalNodeInjection();

  for (const auto& component : getComponents()) {
    component->getY0();
  }

  busContainer_->resetCurrentUStatus();
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

  const std::shared_ptr<parameters::ParametersSet> networkModelLocalInitParameters =
                                  parameters::ParametersSetFactory::newParametersSet("networkModelLocalInitParameters");
  networkModelLocalInitParameters->createParameter("mxiter", 5);

  Trace::debug() << DYNLog(SolveParameters, name()) << Trace::endline;

  solver.init(this, 0, &yLocalInit_[0], &fLocalInit_[0], networkModelLocalInitParameters);

  /*static std::string baseY = "tmpSolY/solY-";
  static std::string baseYp = "tmpSolYp/solYp-";
  stringstream nomFichierY;
  nomFichierY << baseY << "Init" << ".txt";
  stringstream nomFichierYp;
  nomFichierYp << baseYp << "Init" << ".txt";

  if (!exists("tmpSolY")) {
    create_directory("tmpSolY");
  }

  if (!exists("tmpSolYp")) {
    create_directory("tmpSolYp");
  }

  const auto& xNames = xNamesInit();

  std::ofstream fileY;
  fileY.open(nomFichierY.str().c_str(), std::ofstream::out);

  for (unsigned int i = 0; i < yLocalInit_.size(); ++i) {
    fileY << i << " " << xNames[i] << " " << yLocalInit_[i] << "\n";
  }

  std::ofstream fileYp;
  fileYp.open(nomFichierYp.str().c_str(), std::ofstream::out);

  for (unsigned int i = 0; i < ypLocalInit_.size(); ++i) {
    fileYp << i << " " << xNames[i] << " " << ypLocalInit_[i] << "\n";
  }

  fileY.close();
  fileYp.close();*/

  try {
    solver.solve();
    for (const auto& vLevelInitComponent : vLevelInitComponents_)
      vLevelInitComponent->setInitialSwitchCurrents();
  } catch (const Error&) {
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
    for (const auto& component : components_) {
      component->instantiateVariables(variables);
    }
  }
}

void
ModelNetwork::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) {
  defineVariables(variables);
}

void
ModelNetwork::defineParameters(vector<ParameterModeler>& parameters) {
  ModelVoltageLevel::defineParameters(parameters);
  ModelLine::defineParameters(parameters);
  ModelThreeWindingsTransformer::defineParameters(parameters);
  ModelTwoWindingsTransformer::defineParameters(parameters);
  ModelHvdcLink::defineParameters(parameters);
  parameters.push_back(ParameterModeler("startingPointMode", VAR_TYPE_STRING, EXTERNAL_PARAMETER));
  parameters.push_back(ParameterModeler("deactivateRootFunctions", VAR_TYPE_BOOL, EXTERNAL_PARAMETER));

  for (const auto& component : getComponents()) {
    component->defineNonGenericParameters(parameters);
  }
}

void
ModelNetwork::evalStaticYType() {
  unsigned int offset = 0;
  for (const auto& component : getComponents()) {
    if (component->sizeY() != 0) {
      component->setBufferYType(yType_, offset);
      offset += component->sizeY();
      component->evalStaticYType();
    }
  }
}

void
ModelNetwork::evalDynamicYType() {
  for (const auto& component : getComponents()) {
    if (component->sizeY() != 0) {
      component->evalDynamicYType();
    }
  }
}

void
ModelNetwork::evalStaticFType() {
  unsigned int offsetComponent = 0;
  for (const auto& component : getComponents()) {
    if (component->sizeF() != 0) {
      component->setBufferFType(fType_, offsetComponent);
      offsetComponent += component->sizeF();
      component->evalStaticFType();
    }
  }
}

void
ModelNetwork::collectSilentZ(BitMask* silentZTable) {
  unsigned int offsetComponent = 0;
  for (const auto& component : getComponents()) {
    if (component->sizeZ() > 0) {
      component->collectSilentZ(&silentZTable[offsetComponent]);
      offsetComponent += component->sizeZ();
    }
  }
}

void
ModelNetwork::evalDynamicFType() {
  for (const auto& component : getComponents()) {
    if (component->sizeF() != 0)
      component->evalDynamicFType();
  }
}

void
ModelNetwork::defineElements(vector<Element>& elements, map<string, int>& mapElement) {
  for (const auto& component : getComponents())
    component->defineElements(elements, mapElement);
}

void
ModelNetwork::setSubModelParameters() {
  const auto& deactivateRootFunctions = findParameter("deactivateRootFunctions", false);
  deactivateRootFunctions_ = false;
  if (deactivateRootFunctions.hasValue())
    deactivateRootFunctions_ = deactivateRootFunctions.getValue<bool>();
  for (const auto& component : getComponents())
    component->setSubModelParameters(parametersDynamic_);
}

void
ModelNetwork::evalYMat() {
  for (const auto& component : getComponents())
    component->evalYMat();
}

void
ModelNetwork::init(const double t0) {
  initializeStaticData();

  getSize();
  initSubBuffers();

  computeComponents(t0);
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

  for (const auto& voltageLevel : getVoltageLevels())
    voltageLevel->computeLoops();
}

void
ModelNetwork::setFequationsInit() {
  unsigned int offset = 0;
  const bool isInitModelSave = isInitModel_;
  // Initialization models equations
  fEquationInitIndex_.clear();
  isInitModel_ = true;
  for (const auto& initComponent : initComponents_) {
    map<int, string> FpropComponent;
    initComponent->setFequations(FpropComponent);

    for (const auto& mapFprop : FpropComponent) {
      int index = offset + mapFprop.first;
      const string formula = mapFprop.second;
      fEquationInitIndex_[index] = formula;
    }
    offset += FpropComponent.size();
  }
  isInitModel_ = isInitModelSave;
}

void
ModelNetwork::setFequations() {
  unsigned int offset = 0;
  const bool isInitModelSave = isInitModel_;

  isInitModel_ = false;
  fEquationIndex_.clear();
  for (const auto& component : components_) {
    map<int, string> FpropComponent;
    component->setFequations(FpropComponent);

    for (const auto& mapFprop : FpropComponent) {
      int index = offset + mapFprop.first;
      const string formula = mapFprop.second;
      fEquationIndex_[index] = formula;
    }
    offset += FpropComponent.size();
  }
  isInitModel_ = isInitModelSave;
}

void
ModelNetwork::setGequations() {
  unsigned int offset = 0;
  for (const auto& component : getComponents()) {
    if (component->sizeG() != 0) {
      map<int, string> GpropComponent;
      component->setGequations(GpropComponent);

      map<int, string>::const_iterator itMapGprop;
      for (const auto& mapGprop : GpropComponent) {
        int index = offset + mapGprop.first;
        const string formula = mapGprop.second;
        gEquationIndex_[index] = formula;
      }
      offset += GpropComponent.size();
    }
  }
}

void
ModelNetwork::printInternalParameters(std::ofstream& fstream) const {
  for (const auto& component : getComponents()) {
    component->printInternalParameters(fstream);
  }
}

void
ModelNetwork::dumpInternalVariables(boost::archive::binary_oarchive&) const {
  // not needed
}

void
ModelNetwork::dumpVariables(map< string, string >& mapVariables) {
  stringstream values;
  boost::archive::binary_oarchive os(values);
  string cSum = getCheckSum();

  os << cSum;
  os << getComponents().size();
  // Dump variables of components
  for (const auto& component : getComponents()) {
    os << component->getId();
    component->dumpVariables(os);
  }

  mapVariables[ variablesFileName() ] = values.str();
}

void
ModelNetwork::loadVariables(const string& variables) {
  bool couldBeLoaded = true;
  stringstream values(variables);
  boost::archive::binary_iarchive is(values);

  string cSum = getCheckSum();
  string cSumRead;
  is >> cSumRead;

  if (cSumRead != cSum) {
    Trace::warn() << DYNLog(WrongCheckSum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  size_t nbComponent;
  is >> nbComponent;
  const std::vector<std::shared_ptr<NetworkComponent> >& components = getComponents();

  std::unordered_map<std::string, size_t> ids2Indexes;
  for (size_t i = 0, itEnd = components.size(); i < itEnd; ++i) {
    ids2Indexes[components[i]->getId()] = i;
  }

  // load variables of components
  for (size_t i = 0; i < nbComponent; ++i) {
    std::string idRead;
    is >> idRead;
    auto it = ids2Indexes.find(idRead);
    if (it != ids2Indexes.end()) {
      couldBeLoaded &= components[it->second]->loadVariables(is, variablesFileName());
    } else {
      // Not found, skip the component
      Trace::debug() << DYNLog(NetworkComponentNotFoundInDump, idRead, variablesFileName().c_str()) << Trace::endline;
      vector<double> yValues;
      vector<double> ypValues;
      vector<double> zValues;
      vector<double> gValues;
      is >> yValues;
      is >> ypValues;
      is >> zValues;
      is >> gValues;
      double dummyValueD;
      bool dummyValueB;
      int dummyValueI;
      char type;
      unsigned nbInternalVar;
      is >> nbInternalVar;
      for (unsigned j = 0; j < nbInternalVar; ++j) {
        is >> type;
        if (type == 'B')
          is >> dummyValueB;
        else if (type == 'D')
          is >> dummyValueD;
        else if (type == 'I')
          is >> dummyValueI;
      }
      couldBeLoaded = false;
    }
  }
  if (!couldBeLoaded)
    Trace::warn() << DYNLog(WrongParameterNum, name()) << Trace::endline;

  // notify we used dumped values
  isStartingFromDump_ = true;
}

void
ModelNetwork::loadInternalVariables(boost::archive::binary_iarchive&) {
  // not needed
}

/*void
ModelNetwork::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) {
  for (const auto& component : initComponents_) {
    component->instantiateVariables(variables);
  }
}*/

}  // namespace DYN
