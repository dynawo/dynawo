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
 * @file  DYNSubModel.h
 *
 * @brief Class Interface to describe a subModel : header file
 *
 */
#ifndef MODELER_COMMON_DYNSUBMODEL_H_
#define MODELER_COMMON_DYNSUBMODEL_H_

#include <vector>
#include <map>
#include <string>
#include <list>
#include <fstream>
#include <iostream>
#include <unordered_map>
#include <unordered_set>

#include <boost/shared_ptr.hpp>

#include "DYNEnumUtils.h"
#include "DYNParameterModeler.h"
#include "PARParametersSet.h"
#include "CSTRConstraintsCollection.h"
#include "DYNBitMask.h"
#include "DYNElement.h"


namespace parameters {
class ParametersSet;
}  // namespace parameters

namespace timeline {
class Timeline;
}  // namespace timeline

namespace curves {
class Curve;
}  // namespace curves

namespace DYN {
class Message;
class MessageTimeline;
class SparseMatrix;
class Variable;
class DataInterface;
class Element;

/**
 * @brief SubModel Class
 *
 * Class interface to each sub model that is used to generate the whole model
 */
class SubModel {
 public:
  /**
   * @brief default constructor
   */
  SubModel();

  /**
   * @brief destructor
   */
  virtual ~SubModel() = default;

  /// @brief Default copy constructor
  SubModel(SubModel&&) = default;
  /**
   * @brief Default copy assignement operator
   * @returns this
   */
  SubModel& operator=(SubModel&&) = default;

  // methods to implement for each submodels
 public:
  /**
   * @brief initialize all the data for a sub model
   * @param t0 : initial time of the simulation
   */
  virtual void init(const double t0) = 0;

  /**
   * @brief get the type of the sub model
   * @return the type of the sub model
   */
  virtual std::string modelType() const = 0;

  /**
   * @brief export the parameters of the sub model for dump
   *
   * @param mapParameters : map associating the file where parameters should be dumped with the stream of parameters
   */
  virtual void dumpParameters(std::map< std::string, std::string >& mapParameters) = 0;

  /**
   * @brief export the variables values of the sub model for dump
   *
   * @param mapVariables : map associating the file where values should be dumped with the stream of values
   */
  virtual void dumpVariables(std::map< std::string, std::string >& mapVariables) = 0;

  /**
   * @brief load the parameters values from a previous dump
   *
   * @param parameters : stream of values where the parameters were dumped
   */
  virtual void loadParameters(const std::string& parameters) = 0;

  /**
   * @brief load the variables values from a previous dump
   *
   * @param variables : stream of values where the variables were dumped
   */
  virtual void loadVariables(const std::string& variables) = 0;

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  virtual void collectSilentZ(BitMask* silentZTable) = 0;

  /**
   * @brief update parameters of modelica model
   * @param parameterSet ParametersSet filled with external values
   */
  virtual void updateParameters(std::shared_ptr<parameters::ParametersSet>& parametersSet) {}

 public:
  /**
   * @brief Model F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param[in] t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or both)
   */
  virtual void evalF(double t, propertyF_t type) = 0;

  /**
   * @brief Model G(t,y,y') function evaluation
   *
   * Get the roots' value
   * @param[in] t Simulation instant
   */
  virtual void evalG(const double t) = 0;

  /**
   * @brief Model discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @throws Error::MODELER typed @p Error.
   */
  virtual void evalZ(const double t) = 0;

  /**
   * @brief compute the value of calculated variables
   */
  virtual void evalCalculatedVars() = 0;

  /**
   * @brief compute the transpose jacobian of the sub model \f$ J = @F/@x + cj * @F/@x' \f$
   *
   * @param t time to use for the evaluation
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  virtual void evalJt(const double t, const double cj, SparseMatrix& Jt, const int rowOffset) = 0;

  /**
   * @brief compute the transpose prim jacobian of the sub model \f$ J'= @F/@x' \f$
   *
   * @param t time to use for the evaluation
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  virtual void evalJtPrim(const double t, const double cj, SparseMatrix& Jt, const int rowOffset) = 0;

  /**
   * @brief Model mode change type evaluation
   *
   * Set the mode change type value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @return mode change type value
   */
  virtual modeChangeType_t evalMode(const double t) = 0;

  /**
   * @brief Coherence check on parameters (min/max values, sanity checks)
   */
  virtual void checkParametersCoherence() const = 0;

  /**
   * @brief Coherence check on data (asserts, min/max values, sanity checks)
   *
   * @param t time for which to conduct the data coherence check
   */
  virtual void checkDataCoherence(const double t);

  /**
   * @brief set formula for modelica models' equation
   */
  virtual void setFequations() = 0;

  /**
   * @brief set formula for modelica models' root equation
   */
  virtual void setGequations() = 0;

  /**
   * @brief set formula for modelica models' equation for init model
   */
  virtual void setFequationsInit() = 0;

  /**
   * @brief set formula for modelica models' root equation for init model
   */
  virtual void setGequationsInit() = 0;

  /**
   * @brief Model initial state variables' evaluation
   *
   * Set the initial value of model's state variables, state variables derivatives
   * and discrete variables.
   */
  virtual void getY0() = 0;

  /**
   * @brief evaluate the properties of the variables that won't change during simulation
   * (algebraic, differential, external or external optional variables)
   *
   */
  virtual void evalStaticYType() = 0;

  /**
   * @brief update during the simulation the properties of the variables that depends on others variables values
   *
   */
  virtual void evalDynamicYType() = 0;

  /**
   * @brief evaluate the properties of the residual function  that won't change during simulation (algebraic or differential equation)
   *
   */
  virtual void evalStaticFType() = 0;

  /**
   * @brief update during the simulation the properties of the residual functions that depends on others variables values
   *
   */
  virtual void evalDynamicFType() = 0;

  /**
   * @brief Model model's sizes getter
   *
   * Get the sizes of the vectors and matrixes used by the solver to simulate
   * ModelModel instance. Used by @p ModelMulti to generate right size matrixes
   * and vector for the solver.
   */
  virtual void getSize() = 0;

  /**
   * @brief Model elements initializer
   *
   * Define Model elements (connection variables for output and other models).
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  virtual void defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement) = 0;

  /**
   * @brief initialize static data of the model
   */
  virtual void initializeStaticData() = 0;

  /**
   * @brief initialize the model from data interface
   *
   * @param data data interface to use to initialize the model
   */
  virtual void initializeFromData(const boost::shared_ptr<DataInterface>& data) = 0;

  /**
   * @brief write initial values of a model in a file
   *
   * @param directory directory where the file should be printed
   * @param dumpFileName name of the file where to dump the values
   */
  void printModelValues(const std::string& directory, const std::string& dumpFileName);

  /**
   * @brief write values of the initialization model in a file
   *
   * @param directory directory where the file should be printed
   * @param dumpFileName name of the file where to dump the values
   */
  void printInitModelValues(const std::string& directory, const std::string& dumpFileName);

  /**
   * @brief define each variables of the model
   *
   * @param variables vector of variables to fullfill
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @brief define each parameters of the model
   *
   * @param parameters vector of parameters to fullfill
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @brief define each variables of the init model
   *
   * @param variables vector of variables to fullfill
   */
  virtual void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @brief define each parameters of the init model
   *
   * @param parameters vector of parameters to fullfill
   */
  virtual void defineParametersInit(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @brief  rotate the buffers : after one iteration, copy the values buffers in pre buffers
   *
   */
  virtual void rotateBuffers() = 0;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  virtual void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  virtual double evalCalculatedVarI(unsigned iCalculatedVar) const = 0;

  /**
   * @brief set the submodel parameters value
   */
  virtual void setSubModelParameters() = 0;

  /**
   * @brief set the submodel shared dynamic parameters value
   */
  virtual void setSharedParametersDefaultValues() = 0;

  /**
   * @brief set the submodel shared init parameters value
   */
  virtual void setSharedParametersDefaultValuesInit() = 0;

   /**
   * @brief  init sub buffers
   */
  virtual void initSubBuffers() = 0;

  /**
   * @brief Notify that time step has been performed in the simulation
   */
  virtual void notifyTimeStep() = 0;

  /// common to each subModels
 public:
  /**
   * @brief initialize data that are unchanged during all the simulation (size of vector for examples)
   */
  void initStaticData();

  /**
   * @brief initialize the model thanks to data stored in dataInterface (IIDM,...)
   * @param data data to use to initialize the model
   */
  void initFromData(const boost::shared_ptr<DataInterface>& data);

  /**
   * @brief initialize the subModel
   *
   * @param t0 time to use when calling initialization
   * @param localInitParameters local initialization solver parameters
   */
  void initSub(const double t0, std::shared_ptr<parameters::ParametersSet> localInitParameters);

  /**
   * @brief initialize size and offset to use during the simulation
   *
   * @param sizeYGlob offset to use for the subModel in the Y global vector
   * @param sizeZGlob offset to use for the subModel in the Z global vector
   * @param sizeModeGlob offset to use for the subModel in the Mode global vector
   * @param sizeFGlob offset to use for the subModel in the F global vector
   * @param sizeGGlob offset to use for the subModel in the G global vector
   */
  void initSize(int& sizeYGlob, int& sizeZGlob, int& sizeModeGlob, int& sizeFGlob, int& sizeGGlob);

  /**
   * @brief Model F(t,y,y') function evaluation
   * Get the residues' values at a certain instant time with given state variables,
   * state variables derivatives
   * @param t Simulation instant
   */
  void evalFSub(const double t);

  /**
   * Get the differential residues' values at a certain instant time
   * @param t Simulation instant
   */
  virtual void evalFDiffSub(const double t);

  /**
   * @brief Model G(t,y,y') function evaluation
   * Get the roots' value
   * @param t Simulation instant
   */
  void evalGSub(const double t);

  /**
   * @brief Model discrete variables evaluation
   * Get the discrete variables' value depending on current simulation instant and
   * current state variables values.
   * @param t Simulation instant
   */
  void evalZSub(const double t);

  /**
   * @brief  calculate calculated variables
   *
   * @param t Simulation instant
   */
  void evalCalculatedVariablesSub(const double t);

  /**
   * @brief Model transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtSub(const double t, const double cj, SparseMatrix& Jt, int& rowOffset);

  /**
   * @brief Model transposed jacobian prime matrix evaluation \f$( J = @F/@x' )\f$
   *
   * Get the sparse transposed jacobian
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be added
   */
  void evalJtPrimSub(const double t, const double cj, SparseMatrix& jt, int& rowOffset);

  /**
   * @brief Model mode change type evaluation
   *
   * Set the mode change type value depending on current simulation instant and
   * current state variables values.
   * @param t Simulation instant
   * @return mode change type
   */
  //--------------------------------------------------------------------
  modeChangeType_t evalModeSub(const double t);

  /**
  * @brief Get the mode change value
  *
  * @return mode change value
  */
  inline bool modeChange() const {
    return modeChange_;
  }

  /**
  * @brief Set the mode change value
  *
  * @param modeChange mode change value
  */
  inline void modeChange(const bool modeChange) {
    modeChange_ = modeChange;
  }

 /**
  * @brief Set the mode change type value
  *
  * @param modeChangeType mode change type
  */
  inline void setModeChangeType(const modeChangeType_t& modeChangeType) {
    modeChangeType_ = modeChangeType;
  }

  /**
   * @brief Coherence check on data (asserts, min/max values, sanity checks)
   *
   * @param t : time for which to conduct the data coherence check
   */
  void checkDataCoherenceSub(const double t);

  /**
   * @brief For calling setFequations() in SubModel
   * add equations formula
   */
  void setFequationsSub();
  /**
   * @brief For calling setGequations() in SubModel
   * add root equations formula
   */
  void setGequationsSub();

  /**
   * @brief retrieve the value of a given calculated variable
   *
   * @param indexCalculatedVar index of the calculated variable to retrieve
   *
   * @return value of the calculated variable
   */
  double getCalculatedVar(int indexCalculatedVar);

  /**
   * @brief get the values of all variables at the initial time
   */
  void getY0Sub();

  /**
   * @brief get the values of all variables at the initial time
   *
   * @param y0 global vector of continuous variables
   * @param yp0 global vector of the derivative of the variables
   * @param z0 global vector of the discrecte variables
   *
   * @todo : merge getY0Sub and getY0Values
   */
  void getY0Values(std::vector<double>& y0, std::vector<double>& yp0, std::vector<double>& z0);

  /**
   * @brief get the properties of all variables
   *
   * @return the properties of all variables
   */
    inline propertyContinuousVar_t* getYType() const {
      return yType_;
    }

  /**
   * @brief defines the name of all variables for the dynamic sub model
   *
   */
  inline void defineNames() {
    defineNamesImpl(variables_, zNames_, xNames_, calculatedVarNames_);
  }

  /**
   * @brief defines the name of all variables for the init sub model
   *
   */
  inline void defineNamesInit() {
    defineNamesImpl(variablesInit_, zNamesInit_, xNamesInit_, calculatedVarNamesInit_);
  }

  /**
   * @brief define the indexes and names of all parameters and variables of a dynamic sub-model
   *
   * @param variables variables vector
   * @param zNames vector linking discrete variables with names
   * @param xNames vector linking continuous (possibly flow) variables with names
   * @param calculatedVarNames vector linking calculated variables with names
   */
  virtual void defineNamesImpl(std::vector<boost::shared_ptr<Variable> >& variables, std::vector<std::string>& zNames,
                       std::vector<std::string>& xNames, std::vector<std::string>& calculatedVarNames);

  /**
   * @brief print some data for the subModel (size,index, etc...)
   */
  virtual void printModel() const;

  /**
   * @brief Print all parameters values
   */
  void printParameterValues() const;

  /**
   * @brief Print values of parameters set by local initialization
   */
  void printLocalInitParametersValues() const;

  /**
   * @brief load parameters from a previous save
   *
   * @param mapParameters map associating name of the model and data saved
   */
  void loadParameters(const std::map< std::string, std::string >& mapParameters);

  /**
   * @brief load variables from a previous save
   *
   * @param mapVariables map associating name of the model and data saved
   */
  void loadVariables(const std::map< std::string, std::string >& mapVariables);

  /**
   * @brief get the current values of discrete variables
   *
   * @param z global vector to fill
   */
  void getZ(std::vector<double>& z);

  /**
   * @brief define the elements of the subModel (terminal, structure)
   */
  void defineElements();

  /**
   * @brief release the elements of subModel (only needed for connection)
   */
  void releaseElements();

  /**
   * @brief get the elements associating to a name of variable/structure
   *
   * @param name name of the variable/structure
   *
   * @return elements associating to the variable/structure
   */
  std::vector<Element> getElements(const std::string& name) const;

  /**
   * @brief dump into the log the list of elements of the submodel
   * @param nameElement name of the variable/structure
   */
  virtual void dumpUserReadableElementList(const std::string& nameElement) const;

  /**
   * @brief check whether the variable is available within the sub-model
   *
   * @param nameVariable name of the variable
   *
   * @return @b true if the variable exists inside the model
   */
  bool hasVariable(const std::string& nameVariable) const;

  /**
   * @brief check whether the variable is available within the init sub-model
   *
   * @param nameVariable name of the variable
   *
   * @return @b true if the variable exists inside the init model
   */
  bool hasVariableInit(const std::string& nameVariable) const;

  /**
   * @brief retrieve a given sub-model variable
   *
   * @param variableName name of the variable
   *
   * @return @p towards the variable
   * @throw an assert if the variable does not exist
   */
  boost::shared_ptr <Variable> getVariable(const std::string& variableName) const;

  /**
   * @brief retrieve the current value of a given variable
   *
   * @param nameVariable name of the variable
   *
   * @return value of the variable
   */
  double getVariableValue(const std::string& nameVariable) const;

  /**
   * @brief retrieve the current value of a given variable
   *
   * @param variable the variable
   *
   * @return value of the variable
   */
  double getVariableValue(const boost::shared_ptr<Variable>& variable) const;

  /**
   * @brief retrieve the global index of a given variable
   *
   * @param variable the variable
   *
   * @return the variable index in the relevant matrix
   * @throw an error when the variable type is not relevant
   */
  int getVariableIndexGlobal(const boost::shared_ptr<Variable>& variable) const;

  /**
   * @brief check whether the parameter is available within the sub-model
   *
   * @param nameParameter name of the parameter
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   * @return @b true if the parameter exists inside the model
   */
  bool hasParameter(const std::string& nameParameter, const bool isInitParam) const;

  /**
   * @brief check whether the initial parameter is available within the sub-model
   *
   * @param nameParameter name of the parameter
   * @return @b true if the initial parameter exists inside the model
   */
  inline bool hasParameterInit(const std::string& nameParameter) const {
    return hasParameter(nameParameter, true);
  }

  /**
   * @brief check whether the dynamic parameter is available within the sub-model
   *
   * @param nameParameter name of the parameter
   * @return @b true if the dynamic parameter exists inside the model
   */
  inline bool hasParameterDynamic(const std::string& nameParameter) const {
    return hasParameter(nameParameter, false);
  }

  /**
   * @brief print all messages that appears during the simulation (debug stream)
   *
   */
  void printMessages();

  /**
   * @brief add a new message (execution log)
   *
   * @param message message to add
   */
  void addMessage(const std::string& message);

  /**
   * @brief add a new event log
   *
   * @param modelName name of the model where the event appears
   * @param messageTimeline event description with a message and priority
   */
  void addEvent(const std::string& modelName, const MessageTimeline& messageTimeline);

  /**
   * @brief begin/end a constraint
   *
   * @param modelName name of the model where the constraint (dis)appears
   * @param begin @b true if the constrain begin
   * @param description description of the constraint
   * @param modelType type of the model
   * @param constraintData detailed information about the constraint
   */
  void addConstraint(
    const std::string& modelName,
    bool begin,
    const Message& description,
    const std::string& modelType = "",
    const boost::optional<constraints::ConstraintData>& constraintData = boost::none);

  /**
   * @brief Determines if the model has a constraint collection
   *
   * @returns whether the model has a constraint collection
   */
  bool hasConstraints() const;

  /**
   * @brief set the timeline to use during the simulation (where events should be added)
   *
   * @param timeline timeline to use
   */
  void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline);

  /**
   * @brief determines if contains a timeline
   *
   * @returns whether the model has a timeline
   */
  bool hasTimeline() const;

  /**
   * @brief set the constraints collection to use during the simulation (where constraints should be added)
   *
   * @param constraints constraints collections to use
   */
  void setConstraints(const std::shared_ptr<constraints::ConstraintsCollection>& constraints);

  /**
   * @brief set the simulation working directory to use
   * @param workingDirectory Simulation working directory to use
   */
  void setWorkingDirectory(const std::string& workingDirectory);

  /**
   * @brief get the current simulation context to use
   * @return current simulation context to use
   */
  inline const std::string& getWorkingDirectory() { return workingDirectory_; }

  /**
   * @brief get the associations between one variable and its name
   *
   * @return a map associating one variable and its name
   */
  const std::unordered_map<std::string, boost::shared_ptr<Variable> >& getVariableByName() const {
    return variablesByName_;
  }

  /**
   * @brief add a curve of a variable to store for the model
   *
   * @param curve curve to store
   */
  void addCurve(std::shared_ptr<curves::Curve>& curve);

  /**
   * @brief update the subset of calculated variables needed for curves
   *
   * @param curve curve whose value needs to be updated
   */
  void updateCalculatedVarForCurve(std::shared_ptr<curves::Curve>& curve);

  /**
   * @brief add a curve of a parameter to store for the model
   *
   * @param curve curve to store
   */
  void addParameterCurve(std::shared_ptr<curves::Curve>& curve);

  /**
   * @brief defines all variables for the dynamic model
   */
  void defineVariables();

  /**
   * @brief defines all parameters for the dynamic model
   *
   */
  void defineParameters() {
    defineParameters(false);
  }

  /**
   * @brief instantiate all non-unitary parameters
   *
   * @param isInitParam whether to do it for initial (or dynamic) parameters
   * @param nonUnitaryParameters non unitary parameter of this model
   * @param addedParameter parameter added after processing non unitary parameters
   */
  void instantiateNonUnitaryParameters(const bool isInitParam,
      const std::map<std::string, ParameterModeler>& nonUnitaryParameters,
      std::unordered_set<std::string>& addedParameter);

  /**
   * @brief set a parameter value from a parameters set (API PAR) (only for unitary cardinality)
   *
   * @param parameterName name of the parameter to be set
   * @param isInitParam whether to do it for initial (or dynamic) parameters
   */
  inline void setParameterFromPARFile(const std::string& parameterName, const bool isInitParam) {
    if (readPARParameters_->hasReference(parameterName))
      setParameterFromSet(findParameterReference(parameterName, isInitParam), readPARParameters_, IIDM);
    else
      setParameterFromSet(findParameterReference(parameterName, isInitParam), readPARParameters_, PAR);
  }

  /**
   * @brief set a parameter value from a parameters set(only for unitary cardinality)
   *
   * @param parameter parameter to be set
   * @param parametersSet the set to scan for a value
   * @param origin the origin of the set data (MO, PAR, INIT, ...)
   */
  void setParameterFromSet(ParameterModeler& parameter, const std::shared_ptr<parameters::ParametersSet>& parametersSet, const parameterOrigin_t& origin);

  /**
   * @brief set all parameters values from a parameters set (API PAR)
   */
  void setParametersFromPARFile();

  /**
   * @brief set all parameters values from a parameters set (API PAR)
   * @param isInitParam whether the parameter is an initParam or a dynamic parameter
   */
  void setParametersFromPARFile(const bool isInitParam);

  /**
   * @brief search for a parameter with a given name
   *
   * @param name name of the desired parameter
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   * @return desired parameter
   */
  const ParameterModeler& findParameter(const std::string& name, const bool isInitParam) const;

  /**
   * @brief search for an initial parameter with a given name
   *
   * @param name name of the desired parameter
   * @return desired initial parameter
   */
  inline const ParameterModeler& findParameterInit(const std::string& name) const {
    return findParameter(name, true);
  }

  /**
   * @brief search for a dynamic parameter with a given name
   *
   * @param name name of the desired parameter
   * @return desired dynamic parameter
   */
  inline const ParameterModeler& findParameterDynamic(const std::string& name) const {
    return findParameter(name, false);
  }

  /**
   * @brief set a given parameter value
   *
   * @param name name of the desired parameter
   * @param origin the origin from which the value comes from
   * @param value the value to set
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   */
  template <typename T> void setParameterValue(const std::string& name, const parameterOrigin_t& origin, const T& value, const bool isInitParam);


  /**
   * @brief Getter for parameters
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   * @return submodel parameters
   */
  inline const std::unordered_map<std::string, ParameterModeler>& getParameters(const bool isInitParam) const {
    return (isInitParam ? getParametersInit() : getParametersDynamic());
  }

  /**
   * @brief Getter for attribute parametersDynamic_
   *
   * @return submodel attribute parametersDynamic_
   */
  const std::unordered_map<std::string, ParameterModeler>& getParametersDynamic() const;

  /**
   * @brief Getter for attribute parametersInit_
   *
   * @return submodel attribute parametersInit_
   */
  const std::unordered_map<std::string, ParameterModeler>& getParametersInit() const;

  /**
   * @brief Add parameters
   *
   * @param parameters vector of parameters to add
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   */
  void addParameters(const std::vector<ParameterModeler>& parameters, const bool isInitParam);

  /**
   * @brief Add a parameter
   *
   * @param parameter Parameter to add
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   */
  void addParameter(const ParameterModeler& parameter, const bool isInitParam);

  /**
   * @brief Reset the parameters
   *
   * @param isInitParam whether to reset the initial (or dynamic) parameters
   */
  void resetParameters(const bool isInitParam);

  /**
   * @brief defines all variables for the init model
   */
  void defineVariablesInit();

  /**
   * @brief defines all parameters for the init model
   *
   */
  void defineParametersInit() {
    defineParameters(true);
  }

  /**
   * @brief Define all parameters for the init or dynamic model
   *
   * @param isInitParam whether to define the initial (or dynamic) parameters
   */
  void defineParameters(const bool isInitParam);

  /**
   * @brief defines the local buffer to use for the evaluation of residual function
   *
   * @param f global buffer for the evaluation of residual function
   * @param offsetF offset to use to find the beginning of the local buffer
   */
  void setBufferF(double* f, const int offsetF);

  /**
   * @brief defines the local buffer to use for the evaluation of root function
   *
   * @param g global buffer for the evaluation of root function
   * @param offsetG offset to use to find the beginning of the local buffer
   */
  void setBufferG(state_g* g, const int offsetG);

  /**
   * @brief defines the local buffer to define the continuous variables
   *
   * @param y global buffer to define the continuous variable
   * @param yp global buffer to define the derivative of the continuous variable
   * @param offsetY offset to use to find the beginning of the local buffer
   */
  void setBufferY(double* y, double* yp, const int offsetY);

  /**
   * @brief   defines the local buffer to define the discrete variables
   *
   * @param z global buffer to define the discrete variable
   * @param zConnected global buffer to define the connection status of the discrete variable
   * @param offsetZ offset to use to find the beginning of the local buffer
   */
  void setBufferZ(double* z, bool* zConnected, int offsetZ);

  /**
   * @brief   defines the local buffer to define the variables properties
   *
   * @param yType global buffer to define the variable properties
   * @param offsetYType offset to use to find the beginning of the local buffer
   */
  void setBufferYType(propertyContinuousVar_t* yType, const int offsetYType);

  /**
   * @brief   defines the local buffer to define the residual functions properties
   *
   * @param fType global buffer to define the residual functions properties
   * @param offsetFType offset to use to find the beginning of the local buffer
   */
  void setBufferFType(propertyF_t* fType, const int offsetFType);

  /**
   * @brief get the index to use to find the discrete values of the model inside the global vector
   *
   * @return index in the global vector
   */
  inline int zDeb() const {
    return zDeb_;
  }

  /**
   * @brief get the index to use to find the residual values of the model inside the global vector
   *
   * @return index in the global vector
   */
  inline int fDeb() const {
    return fDeb_;
  }

  /**
   * @brief get the index to use to find the root values of the model inside the global vector
   *
   * @return index in the global vector
   */

  inline int gDeb() const {
    return gDeb_;
  }

  /**
   * @brief get the index to use to find the continuous values of the model inside the global vector
   *
   * @return index in the global vector
   */
  inline int yDeb() const {
    return yDeb_;
  }

  /**
   * @brief get the name of the subModel
   *
   * @return name of the subModel
   */
  inline std::string name() const {
    return name_;
  }

  /**
   * @brief defines the name of the subModel
   *
   * @param name name of the subModel
   */
  inline void name(const std::string& name) {
    name_ = name;
  }

  /**
   * @brief get the staticId of the subModel (i.e. the name of the model in the IIDM structure)
   *
   * @return staticId of the subModel
   */
  inline const std::string& staticId() const {
    return staticId_;
  }

  /**
   * @brief defines the staticId of the subModel
   *
   * @param id staticId of the subModel
   */
  inline void staticId(const std::string& id) {
    staticId_ = id;
  }

  /**
   * @brief get the names of all discrete variables of the dynamic model
   *
   * @return names of all discrete variables
   */
  inline const std::vector<std::string>& zNames() {
    return zNames_;
  }

  /**
   * @brief get the names of all continuous variables of the dynamic model
   *
   * @return names of all continuous variables
   */
  inline const std::vector<std::string>& xNames() {
    return xNames_;
  }

  /**
   * @brief get the names of all continuous aliases variables of the dynamic model
   *
   * @return names of all continuous aliases variables
   */
  inline const std::vector<std::pair<std::string, std::pair<std::string, bool> > >& xAliasesNames() {
    return xAliasesNames_;
  }

  /**
   * @brief get the names of all discrete aliases variables of the dynamic model
   *
   * @return names of all discrete aliases variables
   */
  inline const std::vector<std::pair<std::string, std::pair<std::string, bool> > >& zAliasesNames() {
    return zAliasesNames_;
  }

  /**
   * @brief get the initial model variables (indexed by name)
   *
   * @return map (name, variable)
   */
  inline const std::unordered_map<std::string, boost::shared_ptr<Variable> >& variablesByNameInit() {
    return variablesByNameInit_;
  }

  /**
   * @brief get the names of all discrete variables of the init model
   *
   * @return names of all discrete variables
   */
  inline const std::vector<std::string>& zNamesInit() {
    return zNamesInit_;
  }

  /**
   * @brief get the names of all continuous variables of the init model
   *
   * @return names of all continuous variables
   */
  inline const std::vector<std::string>& xNamesInit() {
    return xNamesInit_;
  }

  /**
   * @brief get the names of all calculated variables (values calculated thanks to other variables
   * for the init model
   *
   * @return names of all calculated variables
   */
  inline const std::vector<std::string>& getCalculatedVarNamesInit() {
    return calculatedVarNamesInit_;
  }

  /**
   * @brief get the names of all calculated variables (values calculated thanks to other variables
   * for the dynamic model
   *
   * @return names of all calculated variables
   */
  inline const std::vector<std::string>& getCalculatedVarNames() {
    return calculatedVarNames_;
  }

  /**
   * @brief get the name of a calculated variable using the index in the vector
   *
   * @param index index of the calculated variable in the vector
   * @return the name of the calculated variable
   */

  inline const std::string& getCalculatedVarName(const unsigned int index) {
    return calculatedVarNames_[index];
  }

  /**
   * @brief get the number of residual functions of the model
   *
   * @return number of residual functions
   */
  inline unsigned int sizeF() const {
    return sizeF_;
  }

  /**
   * @brief get the number of discrete variables
   *
   * @return number of discrete variables
   */
  inline unsigned int sizeZ() const {
    return sizeZ_;
  }

  /**
   * @brief get the number of root functions
   *
   * @return number of root functions
   */
  inline unsigned int sizeG() const {
    return sizeG_;
  }

  /**
   * @brief get the number of mode
   *
   * @return number of mode
   */
  inline unsigned int sizeMode() const {
    return sizeMode_;
  }

  /**
   * @brief get the number of continuous variable
   *
   * @return number of continuous variable
   */
  inline unsigned int sizeY() const {
    return sizeY_;
  }

  /**
   * @brief get the number of calculated variables
   *
   * @return number of calculated variables
   */
  inline unsigned int sizeCalculatedVar() const {
    return static_cast<unsigned int>(calculatedVars_.size());
  }

  /**
   * @brief get the number of residual functions of the init model
   *
   * @return number of residual functions of init
   */
  inline unsigned int sizeFInit() const {
    return static_cast<unsigned int>(fEquationInitIndex_.size());
  }

  /**
   * @brief get the number of root functions of the init model
   *
   * @return number of root functions of init
   */
  inline unsigned int sizeGInit() const {
    return static_cast<unsigned int>(gEquationInitIndex_.size());
  }

  /**
   * @brief set the time to use for the equation's evaluation
   *
   * @param time time to use
   */
  inline void setCurrentTime(const double time) {
    currentTime_ = time;
  }

  /**
   * @brief get the current time used for the equation's evaluation
   *
   * @return current time used
   */
  inline double getCurrentTime() const {
    return currentTime_;
  }

  /**
   * @brief set whether we used the initial model or the dynamic model
   *
   * @param isInitProcess @b true if the initial model is used
   */
  inline void setIsInitProcess(bool isInitProcess) {
    isInitProcess_ = isInitProcess;
  }

  /**
   * @brief get the indicator if the initial model is used or the dynamic model
   *
   * @return @b true if the initial model is used
   */
  inline bool getIsInitProcess() const {
    return isInitProcess_;
  }

  /**
   * @brief get equation string for debug log
   *
   * @param index WARNING index is local index in this submodel, not global index
   * @return string of equation
   */
  std::string getFequationByLocalIndex(const int index);

  /**
   * @brief get root equation string for debug log
   *
   * @param index WARNING index is local index in this submodel, not global index
   * @return string of root equation
   */
  std::string getGequationByLocalIndex(const int index);

  /**
   * @brief setter for the parameters set read from PAR file
   *
   * @param params parameters set read from PAR file
   */
  void setPARParameters(const std::shared_ptr<parameters::ParametersSet>& params);

  /**
   * @brief retrieve the value of a parameter
   *
   * @param nameParameter name of a parameter to found
   * @param value value of the parameter
   * @param found @b true if the parameter exist, @b false else
   */
  virtual void getSubModelParameterValue(const std::string& nameParameter, std::string& value, bool& found);

  /**
   * @brief retrieve the value of a parameter of the initialization model
   *
   * @param nameParameter name of a parameter to found
   * @param value value of the parameter
   * @param found @b true if the parameter exist, @b false else
   */
  virtual void getInitSubModelParameterValue(const std::string & nameParameter, std::string& value, bool& found) const;

  /**
   * @brief get index of this submodel in the global continuous variable table
   * @return index of this submodel in the global continuous variable table
   */
  int getOffsetY() const {return offsetY_;}

 protected:
  /**
   * @brief get the name of the file where parameters should be dumped
   *
   * @return name of the file where parameters should be dumped
   */
  inline std::string parametersFileName() const {
    return modelType() + "-" + name() + "-parameters.bin";
  }

  /**
   * @brief get the name of the file where variables should be dumped
   *
   * @return name of the file where variables should be dumped
   */
  inline std::string variablesFileName() const {
    return modelType() + "-" + name() + "-variables.bin";
  }

  /**
   * @brief structure use for sorting pairs in a vector
   */
  struct compStringDist {
  /**
   * @brief compare two pairs
   * @param p1 first pair to compare
   * @param p2 second pair to compare
   * @return @b true is the first pair double argument's absolute value is greater that the second one's
   */
  bool operator()(const std::pair<size_t, std::string>& p1, const std::pair<size_t, std::string>& p2) const {
    return p1.first < p2.first;
  }
  };

  /**
   * @brief initialize the parameters thanks to external values and internal equations
   */
  virtual void initParams() = 0;

  /**
   * @brief write initial variables values of a model in a file
   *
   * @param fstream the file to stream variables to
   */
  void printValuesVariables(std::ofstream& fstream);

  /**
   * @brief write initial values parameters of a model in a file
   *
   * @param fstream the file to stream parameters to
   */
  virtual void printValuesParameters(std::ofstream& fstream);

  /**
   * @brief write variables values of the initialization model in a file
   *
   * @param fstream the file to stream variables to
   */
  void printInitValuesVariables(std::ofstream& fstream);

  /**
   * @brief write parameters of the initialization model in a file
   *
   * @param fstream the file to stream parameters to
   */
  virtual void printInitValuesParameters(std::ofstream& fstream) const;

  /**
  * @brief write internal parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  virtual void printInternalParameters(std::ofstream& fstream) const;

  /**
   * @brief Determines if the sub model has a data check coherence operation (non-empty function)
   * @returns true if the sub model has a data check coherence operation, false if not
   */
  virtual bool hasDataCheckCoherence() const {
    return false;
  }

 private:
  /**
   * @brief search for a parameter with a given name
   *
   * @param name name of the desired parameter
   * @param isInitParam whether to retrieve the initial (or dynamic) parameters
   * @return desired parameter as a reference
   */
  ParameterModeler& findParameterReference(const std::string& name, const bool isInitParam);

  /**
   * @brief save informations about the model (size, current values of buffers, etc..)
   */
  void saveData();

  /**
   * @brief restore informations about the model (size, current values of buffers, etc..)
   */
  void restoreData();

  /**
   * @brief get the subElements contains in one element
   *
   * @param element element where we should analyze and find the subElements
   *
   * @return list of subElements contains in element
   */
  std::vector<Element> getSubElements(const Element& element) const;

  /**
   * @brief get the map of index of equation and equation in string format (init or dynamic ones)
   * @return the map of index of equation and equation in string format
   */
  const std::map<int, std::string>& fEquationIndex() const;

  /**
   * @brief get the map of index of root equation and root equation in string format (init or dynamic ones)
   * @return the map of index of root equation and root equation in string format
   */
  std::map<int, std::string>& gEquationIndex();

  /**
   * @brief set a parameter value from a parameters set (API PAR) (only for unitary cardinality)
   *
   * @param parameter parameter to be set
   */
  inline void setParameterFromPARFile(ParameterModeler& parameter) {
    if (!readPARParameters_)
      return;
    if (readPARParameters_->hasReference(parameter.getName()))
      setParameterFromSet(parameter, readPARParameters_, IIDM);
    else
      setParameterFromSet(parameter, readPARParameters_, PAR);
  }

 protected:
  std::shared_ptr<parameters::ParametersSet> readPARParameters_;  ///< parameters set read from PAR file

  // size of subModel
  unsigned int sizeF_;  ///< size of the local F function
  unsigned int sizeZ_;  ///< size of the local Z function
  unsigned int sizeG_;  ///< size of the local G function
  unsigned int sizeMode_;  ///< size of the local mode function
  unsigned int sizeY_;  ///< size of the local Y function
  unsigned int sizeCalculatedVar_;  ///< number of calculated variables

  // Data associated to a subModel
  // -----------------------------
  double* fLocal_;  ///< local buffer to fill when calculating residual functions
  state_g* gLocal_;  ///< local buffer to fill when calculating root functions
  double* yLocal_;  ///< local buffer to use when accessing continuous variables
  int offsetY_;  ///< index in the global variable table
  double* ypLocal_;  ///< local buffer to use when accessing derivatives of continuous variables
  double* zLocal_;  ///< local buffer to use when accessing discrete variables
  bool* zLocalConnected_;  ///< table to know whether a discrete var is connected or not

  std::vector<double> yLocalInit_;  ///< local buffer used for the init model
  std::vector<double> ypLocalInit_;  ///< local buffer used for the init model
  std::vector<double> zLocalInit_;  ///< local buffer used for the init model
  std::vector<double> fLocalInit_;  ///< local buffer used for the init model

  std::vector<double> calculatedVars_;  ///< local buffer to fill when calculating calculated variables
  std::vector<double> calculatedVarsInit_;  ///< local buffer to fill when calculating calculated variables for init model
  std::unordered_map<std::string, boost::shared_ptr<Variable> > variablesByName_;  ///< association between variables and its name for dynamic model
  std::unordered_map<std::string, boost::shared_ptr<Variable> > variablesByNameInit_;  ///< association between variables and its name for init model

  propertyContinuousVar_t* yType_;  ///< local buffer to use when accessing each variable property (Algebraic / Differential / External)
  propertyF_t* fType_;  ///< local buffer to use when accessing each residual function property(Algebraic / Differential)

  std::unordered_map<std::string, ParameterModeler> parametersDynamic_;  ///< hashmap of sub-model parameters
  std::unordered_map<std::string, ParameterModeler> parametersInit_;  ///< hashmap of sub-model parameters

  // Index to access data inside global buffers
  // -------------------------------------------
  int yDeb_;  ///< offset to use to find y values inside the global buffer
  int zDeb_;  ///< offset to use to find z values inside the global buffer
  int modeDeb_;  ///< offset to use to find mode values inside the global buffer
  int fDeb_;  ///< offset to use to find residual functions values inside the global buffer
  int gDeb_;  ///< offset to use to find root functions values inside the global buffer

  bool withLoadedParameters_;  ///< whether to load parameters values (from a dump)
  bool withLoadedVariables_;  ///< whether to load variable values (from a dump)

  std::map<int, std::string> fEquationIndex_;  ///< for DEBUG log, map of index of equation and equation in string
  std::map<int, std::string> gEquationIndex_;  ///< for DEBUG log, map of index of root equation and root equation in string

  std::map<int, std::string> fEquationInitIndex_;  ///< for DEBUG log, map of index of equation and equation in string for init model
  std::map<int, std::string> gEquationInitIndex_;  ///< for DEBUG log, map of index of root equation and root equation in string  for init model

  std::shared_ptr<parameters::ParametersSet> localInitParameters_;  ///< local initialization solver parameters set

 private:
  int sizeFSave_;  ///< save of the size of F
  int sizeZSave_;  ///< save of the size of Z
  int sizeGSave_;  ///< save of the size of G
  int sizeModeSave_;  ///< save of the size of the Mode
  int sizeYSave_;  ///< save of the size of Y
  int sizeCalculatedVarSave_;  ///< size of the size of calculated variables
  double* fLocalSave_;  ///< save of the local buffer of residual functions
  state_g* gLocalSave_;  ///< save of the local buffer of root functions
  double* yLocalSave_;  ///< save of the local buffer for continuous variables
  double* ypLocalSave_;  ///< save of the local buffer for the derivative of continuous variables
  double* zLocalSave_;  ///< save of the local buffer for discrete variables
  int offsetYSave_;  ///< save of index in the global variable table

  bool modeChange_;  ///< @b true if one mode has changed
  modeChangeType_t modeChangeType_;  ///< type of mode change

  bool initialized_;  ///< whether is the model initialized
  std::string name_;  ///< name of the model
  std::string staticId_;  ///< name of the model inside the IIDM data

  std::vector<boost::shared_ptr<Variable> > variables_;  ///< vector of sub-model variables

  std::vector<std::string> zNames_;  ///< vector of the discrete variables name
  std::vector<std::string> xNames_;  ///< vector of the continuous variables names
  std::vector<std::string> calculatedVarNames_;  ///< vector of sub-model calculated variables names
  std::vector<std::pair<std::string, std::pair<std::string, bool> > > xAliasesNames_;  ///< vector of the continuous aliases variables names
  std::vector<std::pair<std::string, std::pair<std::string, bool> > > zAliasesNames_;  ///< vector of the discrete aliases variables names

  std::vector<std::string> zNamesInit_;  ///< name of the discrete variables of the init model
  std::vector<std::string> xNamesInit_;  ///< name of the continuous variables of the init model
  std::vector<std::string> calculatedVarNamesInit_;  ///< name of the calculated variables of the init model
  std::vector<boost::shared_ptr<Variable> > variablesInit_;  ///< vector of sub-model variables

  std::map<std::string, int > mapElement_;  ///< map between elements names and indexes
  std::vector<Element > elements_;  ///< elements of the models

  std::vector<boost::shared_ptr<curves::Curve> > curves_;  ///< curves to store

  std::list<std::string> messages_;  ///< messages that appears during the simulation

  double currentTime_;  ///< current simulation time
  boost::shared_ptr<timeline::Timeline> timeline_;  ///< timeline where event messages should be added
  std::shared_ptr<constraints::ConstraintsCollection> constraints_;  ///< constraints collection where constraints should be added

  std::string workingDirectory_;  ///< Working directory of the simulation (configuration of the simulation)

  bool isInitProcess_;  ///< whether the init process (or the standard dynamic simulation) is running
};

}  // namespace DYN

#include "DYNSubModel.hpp"

#endif  // MODELER_COMMON_DYNSUBMODEL_H_
