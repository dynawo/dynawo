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
 * @file  DYNComponentInterface.h
 *
 * @brief Component data interface : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_H_

#include <string>
#include <vector>
#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>

#ifdef LANG_CXX11
#include <mutex>
#include <unordered_map>
#include <thread>
#endif

namespace DYN {

class SubModel;
class StateVariable;
class StaticParameter;

/**
 * class ComponentInterface
 */

/**
 * @class ComponentInterface
 * @brief Class describing a component of the network
 */
class ComponentInterface {
 public:
  /**
   * @brief Definition of the type of the component
   */
  typedef enum {
    UNKNOWN,  ///< Unknown type
    BUS,  ///< the component is a bus
    CALCULATED_BUS,  ///< the component is a calculated bus
    SWITCH,  ///< the component is a switch
    LOAD,  ///< the component is a load
    LINE,  ///< the component is a line
    GENERATOR,  ///< the component is a generator
    SHUNT,  ///< the component is a shunt
    DANGLING_LINE,  ///< the component is a dangling line
    TWO_WTFO,  ///< the component is a two windings transformer
    THREE_WTFO,  ///< the component is a three windings transformer
    SVC,  ///< the component is a static var compensator
    VSC_CONVERTER,  ///< the component is a voltage source converter
    LCC_CONVERTER,  ///< the component is a line-commutated converter
    HVDC_LINE  ///< the component is a dc line (without converter)
  } ComponentType_t;

 public:
  /**
   * @brief Constructor
   */
  ComponentInterface();

  /**
   * @brief Constructor
   */
  virtual ~ComponentInterface();

  /**
   * @brief Setter for the component's hasDynamicModel_ attribute
   * @param hasDynamicModel @b true is component has a dynamic model (other than c++ one), @b false else
   */
  void hasDynamicModel(bool hasDynamicModel);

  /**
   * @brief Setter for the component's model attribute
   * @param model : dynamic model of the component
   */
  void setModelDyn(const boost::shared_ptr<SubModel>& model);

  /**
   * @brief associate a component variable with a model variable
   * @param componentVar component variable name
   * @param modelId model id
   * @param modelVar model variable name
   */
  void setReference(const std::string& componentVar, const std::string& modelId, const std::string& modelVar);

  /**
   * @brief Getter for the component's hasDynamicModel_ attribute
   * @return  @b true is component has a dynamic model (other than c++ one), @b false else
   */
  bool hasDynamicModel() const;

  /**
   * @brief update state variables with data from model (c++ or dynamic model)
   * @param filterForCriteriaCheck true if we only want to update the parameters used in criteria check
   */
  void updateFromModel(bool filterForCriteriaCheck);

  /**
   * @brief get state variable reference in dynamic model
   */
  void getStateVariableReference();

  /**
   * @brief Set the type of the interface
   *
   * @param type type of the interface
   */
  void setType(const ComponentType_t& type);

  /**
   * @brief Getter fot the interface's type
   * @return interface's type
   */
  const ComponentType_t& getType() const;

  /**
   * @brief import static parameters
   */
  virtual void importStaticParameters() = 0;

  /**
   * @brief update iidm structure from state variables
   */
  void exportStateVariables();

  /**
   * @brief update iidm structure from state variables for each unit component
   */
  virtual void exportStateVariablesUnitComponent() = 0;

  /**
   * @brief Getter for the component' id
   * @return The id of the component
   */
  virtual std::string getID() const = 0;

  /**
   * @brief get the index of a state variable thanks to its name
   * @param varName name of the state variable
   * @return index of the state variable, @b -1 if the variable does not exist
   */
  virtual int getComponentVarIndex(const std::string& varName) const = 0;

#ifdef _DEBUG_
  /**
   * @brief enable check criteria sanity check
   */
  void enableCheckStateVariable();

  /**
   * @brief disable check criteria sanity check
   */
  void disableCheckStateVariable();

  /**
   * @brief set a state variable value thanks to its name
   *
   * @param index index of the state variable
   * @param value value to assign
   */
  void setValue(const int index, const double value);
#endif

 public:
  /**
   * @brief retrieve a state variable value thanks to its name
   *
   * @param name name of the state variable
   *
   * @return the value of the state variable
   */
  template<typename T> T getStaticParameterValue(const std::string& name) const;

 protected:
  /**
   * @brief retrieve a state variable value thanks to its name
   *
   * @param index index of the state variable
   *
   * @return the value of the state variable
   */
  template<typename T> T getValue(const int index) const;

 protected:
  std::vector<StateVariable> stateVariables_;  ///< state variable
  boost::unordered_map<std::string, StaticParameter> staticParameters_;  ///< static parameter by name, from iidm data
  ComponentType_t type_;  ///< type of the interface

 private:
#ifdef LANG_CXX11
  struct DynamicModelDef {
    DynamicModelDef() = default;
    explicit DynamicModelDef(bool hasDynamicModel, const boost::shared_ptr<SubModel>& modelDyn): hasDynamicModel_(hasDynamicModel), modelDyn_(modelDyn) {}
    bool hasDynamicModel_ = false;  ///< @b true is component has a dynamic model (other than c++ one), @b false else
    boost::shared_ptr<SubModel> modelDyn_;  ///< dynamic model of the component
  };
#endif

  boost::shared_ptr<SubModel> getModelDyn() const;

 private:
#ifdef LANG_CXX11
  std::unordered_map<std::thread::id, DynamicModelDef> dynamicDef_;
  mutable std::mutex dynamicDefMutex_;
#else
  bool hasDynamicModel_;  ///< @b true is component has a dynamic model (other than c++ one), @b false else
  boost::shared_ptr<SubModel> modelDyn_;  ///< dynamic model of the component
#endif

#ifdef _DEBUG_
  bool checkStateVariableAreUpdatedBeforeCriteriaCheck_;  ///< true if we want to check that all state variable used in check criteria are properly updated
#endif
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCOMPONENTINTERFACE_H_
