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
 * @file  DYNDataInterfaceIIDM.h
 *
 * @brief Data interface : header file of IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNDATAINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNDATAINTERFACEIIDM_H_

#include <map>
#include <boost/unordered_set.hpp>

#include "DYNDataInterface.h"
#include "DYNCriteria.h"

namespace IIDM {
class Network;
class Bus;
class Switch;
class Line;
class Transformer2Windings;
class Transformer3Windings;
class Load;
class ShuntCompensator;
class Generator;
class DanglingLine;
class TieLine;
class StaticVarCompensator;
class VoltageLevel;
class VscConverterStation;
class LccConverterStation;
class HvdcLine;
}  // namespace IIDM

namespace DYN {
class ComponentInterface;
class BusInterface;
class SubModel;
class NetworkInterfaceIIDM;
class CalculatedBusInterfaceIIDM;
class VoltageLevelInterface;
class SwitchInterface;
class LccConverterInterface;
class GeneratorInterface;
class LoadInterface;
class ShuntCompensatorInterface;
class StaticVarCompensatorInterface;
class VscConverterInterface;
class DanglingLineInterface;
class TwoWTransformerInterface;
class ThreeWTransformerInterface;
class LineInterface;
class HvdcLineInterface;

class DataInterfaceIIDM : public DataInterface {
 public:
  /**
   * @brief Constructor
   * @param networkIIDM instance of iidm network
   */
  explicit DataInterfaceIIDM(IIDM::Network networkIIDM);

  /**
   * @brief Destructor
   */
  ~DataInterfaceIIDM();

  /**
   * @brief init dataInterface from iidm network
   */
  void initFromIIDM();

  /**
   * @brief getter for the instance of IIDM network
   * @return the instance of IIDM network
   */
  IIDM::Network& getNetworkIIDM();

  /**
   * @copydoc DataInterface::getNetwork() const
   */
  boost::shared_ptr<NetworkInterface> getNetwork() const;

  /**
   * @copydoc DataInterface::hasDynamicModel(const std::string& id)
   */
  void hasDynamicModel(const std::string& id);

  /**
   * @copydoc DataInterface::setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model)
   */
  void setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model);

  /**
   * @copydoc DataInterface::setModelNetwork(const boost::shared_ptr<SubModel>& model)
   */
  void setModelNetwork(const boost::shared_ptr<SubModel>& model);

  /**
   * @copydoc DataInterface::setReference(const std::string& componentVar, const std::string& staticId ,const std::string& modelId, const std::string& modelVar)
   */
  void setReference(const std::string& componentVar, const std::string& staticId, const std::string& modelId, const std::string& modelVar);

  /**
   * @copydoc DataInterface::mapConnections()
   */
  void mapConnections();

  /**
   * @copydoc DataInterface::updateFromModel(bool filterForCriteriaCheck)
   */
  void updateFromModel(bool filterForCriteriaCheck);

  /**
   * @copydoc DataInterface::getStateVariableReference()
   */
  void getStateVariableReference();

  /**
   * @copydoc DataInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc DataInterface::exportStateVariables()
   */
  void exportStateVariables();

  /**
   * @copydoc DataInterface::configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria)
   */
  void configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @copydoc DataInterface::checkCriteria(double t, bool finalStep)
   */
  bool checkCriteria(double t, bool finalStep);

  /**
   * @brief fill a vector with the ids of the failing criteria
   * @param failingCriteria vector to fill
   */
  void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const;

  /**
   * @copydoc DataInterface::getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName)
   */
  double getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName)
   */
  int getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName)
   */
  bool getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getBusName(const std::string& staticID, const std::string& labelNode)
   */
  std::string getBusName(const std::string& staticID, const std::string& labelNode);

 private:
  /**
   * @brief find a bus interface thanks to its id
   * @param id: id of the bus interface to find
   *
   * @return instance of bus interface found
   */
  boost::shared_ptr<BusInterface> findBusInterface(const std::string& id);

  /**
   * @brief find a voltage level interface thanks to its id
   * @param id: id of the voltage level interface to find
   *
   * @return instance of voltage level interface found
   */
  boost::shared_ptr<VoltageLevelInterface> findVoltageLevelInterface(const std::string& id);

  /**
   * @brief find a calculated bus interface thanks to its voltageLevel id and the original node
   * @param voltageLevelId id of the voltageLevel where the bus should be found
   * @param node index of the original node
   *
   * @return instance of the calculated bus interface
   */
  boost::shared_ptr<BusInterface> findCalculatedBusInterface(const std::string& voltageLevelId, const int& node);

  /**
   * @brief find a component thanks to its id
   * @param id : id of the component to find
   *
   * @return instance of component interface found
   */
  boost::shared_ptr<ComponentInterface>& findComponent(const std::string& id);

  /**
   * @brief import and create a voltage level interface thanls to the IIDM instance
   *
   * @param voltageLevelIIDM IIDM instance to use to create voltageLevelInterface
   * @return the instance VoltageLevelInterface created
   */
  boost::shared_ptr<VoltageLevelInterface> importVoltageLevel(IIDM::VoltageLevel& voltageLevelIIDM);

  /**
   * @brief import and create a switch interface thanks to the IIDM instance
   *
   * @param switchIIDM IIDM instance to use to create switchInterface
   * @return the instance of switchInterface created
   */
  boost::shared_ptr<SwitchInterface> importSwitch(IIDM::Switch& switchIIDM);

  /**
   * @brief import and create a generator interface thanks to the IIDM instance
   *
   * @param generatorIIDM IIDM instance to use to create generatorInterface
   * @return the instance of GeneratorInterface created
   */
  boost::shared_ptr<GeneratorInterface> importGenerator(IIDM::Generator & generatorIIDM);

  /**
   * @brief import and create a load interface thanks to the IIDM instance
   *
   * @param loadIIDM IIDM instance to use to create loadInterface
   * @return the instance of loadInterface created
   */
  boost::shared_ptr<LoadInterface> importLoad(IIDM::Load& loadIIDM);

  /**
   * @brief import and create a shunt interface thanks to the IIDM instance
   *
   * @param shuntIIDM IIDM instance to use to create shuntInterface
   * @return the instance of shuntCompensatorInterface created
   */
  boost::shared_ptr<ShuntCompensatorInterface> importShuntCompensator(IIDM::ShuntCompensator& shuntIIDM);

  /**
   * @brief import and create a danglingLine interface thanks to the IIDM instance
   *
   * @param danglingLineIIDM IIDM instance to use to create danglingLineInterface
   * @return the instance of danglingLineInterface created
   */
  boost::shared_ptr<DanglingLineInterface> importDanglingLine(IIDM::DanglingLine& danglingLineIIDM);

  /**
   * @brief import and create a svc interface thanks to the IIDM instance
   *
   * @param svcIIDM IIDM instance to use to create svcInterface
   * @return the instance of staticVarCompensatorInterface created
   */
  boost::shared_ptr<StaticVarCompensatorInterface> importStaticVarCompensator(IIDM::StaticVarCompensator& svcIIDM);

  /**
   * @brief import and create a two windings transformer interface thanks to the IIDM instance
   *
   * @param twoWTfo IIDM instance to use to create twoWindingsTransformer Interface
   * @return the instance of TwoWTransformerInterface created
   */
  boost::shared_ptr<TwoWTransformerInterface> importTwoWindingsTransformer(IIDM::Transformer2Windings & twoWTfo);

  /**
   * @brief import and create a three windings transformer interface thanks to the IIDM instance
   *
   * @param threeWTfo IIDM instance to use to create threeWindingsTransformer Interface
   * @return the instance of ThreeWTransformerInterface created
   */
  boost::shared_ptr<ThreeWTransformerInterface> importThreeWindingsTransformer(IIDM::Transformer3Windings & threeWTfo);

   /**
   * @brief import and create a line interface thanks to the IIDM instance
   *
   * @param lineIIDM IIDM instance to use to create line Interface
   * @return the instance of LineInterface created
   */
  boost::shared_ptr<LineInterface>  importLine(IIDM::Line& lineIIDM);

  /**
   * @brief import and create a tieline interface thanks to the IIDM instance
   *
   * @param lineIIDM IIDM instance to use to create tieline Interface
   */
  void importTieLine(IIDM::TieLine& lineIIDM);

  /**
   * @brief import and create a vsc converter interface thanks to the IIDM instance
   *
   * @param vscIIDM: IIDM instance to use to create vsc converter interface
   * @return the instance of vscConverterInterface created
   */
  boost::shared_ptr<VscConverterInterface> importVscConverter(IIDM::VscConverterStation& vscIIDM);

  /**
   * @brief import and create a lcc converter interface thanks to the IIDM instance
   *
   * @param lccIIDM: IIDM instance to use to create lcc converter interface
   * @return the instance of lccConverterInterface created
   */
  boost::shared_ptr<LccConverterInterface> importLccConverter(IIDM::LccConverterStation& lccIIDM);

   /**
   * @brief import and create a hvdc line interface thanks to the IIDM instance
   *
   * @param hvdcLineIIDM IIDM instance to use to create hvdc line Interface
   * @return the instance of HvdcLineInterface created
   */
  boost::shared_ptr<HvdcLineInterface> importHvdcLine(IIDM::HvdcLine& hvdcLineIIDM);

  /**
   * @brief configure the bus criteria
   *
   * @param criteria criteria to be used
   */
  void configureBusCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the load criteria
   *
   * @param criteria criteria to be used
   */
  void configureLoadCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the generator criteria
   *
   * @param criteria criteria to be used
   */
  void configureGeneratorCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

 private:
  IIDM::Network networkIIDM_;  ///< instance of the IIDM network
  boost::shared_ptr<NetworkInterfaceIIDM> network_;  ///< instance of the network interface
  std::map<std::string, boost::shared_ptr<VoltageLevelInterface> > voltageLevels_;  ///< map of voltageLevel by name
  std::map<std::string, boost::shared_ptr<ComponentInterface> > components_;  ///< map of components by name
  std::map<std::string, boost::shared_ptr<BusInterface> > busComponents_;  ///< map of bus by name
  std::map<std::string, boost::shared_ptr<LoadInterface> > loadComponents_;  ///< map of loads by name
  std::map<std::string, boost::shared_ptr<GeneratorInterface> > generatorComponents_;  ///< map of generators by name
  std::map<std::string, std::vector<boost::shared_ptr<CalculatedBusInterfaceIIDM> > > calculatedBusComponents_;  ///< calculatedBus per voltageLevel
  std::vector<boost::shared_ptr<Criteria> > criteria_;  ///< table of criteria to check
};  ///< Generic data interface for IIDM format files
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDATAINTERFACEIIDM_H_
