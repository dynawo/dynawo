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
 * @file  DYNModelManager.h
 *
 * @brief Class of Model Manager : interface between a modelica model and a subModel
 *
 */
#ifndef MODELER_MODELMANAGER_DYNMODELMANAGER_H_
#define MODELER_MODELMANAGER_DYNMODELMANAGER_H_

#include <vector>
#include <set>
#include <map>
#include <boost/core/noncopyable.hpp>

#include "DYNDelayManager.h"
#include "DYNSubModel.h"
#include "DYNModelManagerCommon.h"
#include "DYNVariableAlias.h"

#ifdef _ADEPT_
#pragma GCC diagnostic ignored "-Wunused-parameter"
#include "adept.h"
#pragma GCC diagnostic error "-Wunused-parameter"
#endif

namespace parameters {
class ParametersSet;
}  // namespace parameters

namespace DYN {
class SparseMatrix;
class DataInterface;
class ModelModelica;

/**
 * class ModelManager
 */
class ModelManager : public SubModel, private boost::noncopyable {
 public:
  /**
   * @brief default constructor
   */
  ModelManager();
  /**
   * @brief default destructor
   */
  ~ModelManager();

  // instantiate the virtual methods of the Model class
  /**
   * @brief initialization of the model
   * @param t0 : initial time of the simulation
   */
  void init(const double t0);

  /**
   * @copydoc SubModel::getSize()
   */
  void getSize();

  /**
   * @copydoc SubModel::evalF(double t, propertyF_t type)
   */
  void evalF(double t, propertyF_t type);

  /**
   * @copydoc SubModel::evalG(const double t)
   */
  void evalG(const double t);

  /**
   * @copydoc SubModel::evalZ(const double t)
   */
  void evalZ(const double t);

  /**
   * @copydoc SubModel::evalMode(const double t);
   */
  modeChangeType_t evalMode(const double t);

  /**
   * @copydoc SubModel::evalJt(const double t,const double cj, SparseMatrix& Jt, const int rowOffset)
   */
  void evalJt(const double t, const double cj, SparseMatrix& Jt, const int rowOffset);

  /**
   * @copydoc SubModel::evalJtPrim(const double t,const double cj, SparseMatrix& Jt, const int rowOffset)
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& Jt, const int rowOffset);
  /**
   * @brief copy Z to local data
   *
   * @param z discrete values to copy
   */
  void evalZ(std::vector<double>& z);

  /**
   * @copydoc SubModel::checkDataCoherence (const double t)
   */
  void checkDataCoherence(const double t);

  /**
   * @copydoc SubModel::checkParametersCoherence() const
   */
  void checkParametersCoherence() const;

  /**
   * @copydoc SubModel::setFequations()
   */
  void setFequations();

  /**
   * @copydoc SubModel::setGequations()
   */
  void setGequations();

  /**
   * @copydoc SubModel::setFequationsInit()
   */
  void setFequationsInit();

  /**
   * @copydoc SubModel::setGequationsInit()
   */
  void setGequationsInit();

  /**
   * @copydoc SubModel::evalCalculatedVars()
   */
  void evalCalculatedVars();

  /**
   * @copydoc SubModel::evalStaticFType()
   */
  void evalStaticFType();

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable);

  /**
   * @copydoc SubModel::evalDynamicFType()
   */
  void evalDynamicFType();

  /**
   * @copydoc SubModel::getY0()
   */
  void getY0();

  /**
   * @copydoc SubModel::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc SubModel::evalDynamicYType()
   */
  void evalDynamicYType();

  /**
   * @copydoc SubModel::dumpParameters(std::map< std::string, std::string > & mapParameters)
   */
  void dumpParameters(std::map< std::string, std::string >& mapParameters);

  /**
   * @copydoc SubModel::dumpVariables(std::map< std::string, std::string > & mapVariables)
   */
  void dumpVariables(std::map< std::string, std::string >& mapVariables);

  /**
   * @brief write the final parameters values (relying on low level Modelica data structures)
   * @throw when the parameter value type in Modelica data structures is incompatible with the value type in Dynawo Parameter
   */
  void writeParametersFinalValues();

  /**
   * @copydoc SubModel::getSubModelParameterValue(const std::string & nameParameter, std::string& value, bool & found)
   */
  void getSubModelParameterValue(const std::string& nameParameter, std::string& value, bool& found);

  /**
   * @copydoc SubModel::loadParameters(const std::string & parameters)
   */
  void loadParameters(const std::string& parameters);

  /**
   * @copydoc SubModel::loadVariables(const std::string & variables)
   */
  void loadVariables(const std::string& variables);

  /**
   * @copydoc SubModel::initParams();
   */
  void initParams();

  /**
   * @copydoc SubModel::printValuesParameters(std::ofstream& fstream)
   */
  void printValuesParameters(std::ofstream& fstream);

  /**
   * @copydoc SubModel::printInitValuesParameters(std::ofstream& fstream)
   */
  void printInitValuesParameters(std::ofstream& fstream);

  /**
   * @copydoc SubModel::modelType() const
   */
  std::string modelType() const;

  /**
   * @copydoc SubModel::rotateBuffers()
   */
  void rotateBuffers();

  /**
   * @copydoc SubModel::notifyTimeStep()
   */
  void notifyTimeStep();

  /**
   * @copydoc SubModel::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement)
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement);

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;

  /**
   * @copydoc SubModel::initializeStaticData()
   */
  void initializeStaticData();

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc SubModel::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  void defineParameters(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters);

  /**
   * @copydoc SubModel::initializeFromData(const boost::shared_ptr<DataInterface> &data)
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data);

  /**
   * @copydoc SubModel::setSubModelParameters()
   */
  void setSubModelParameters();

  /**
   * @brief set the submodel shared parameters value
   * @param isInit whether to set the values for the init or dynamic model
   * @param origin the origin from which the default value comes (MO)
   */
  void setSharedParametersDefaultValues(const bool isInit, const parameterOrigin_t& origin);

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues()
   */
  inline void setSharedParametersDefaultValues() {
    setSharedParametersDefaultValues(false, MO);
  }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit()
   */
  inline void setSharedParametersDefaultValuesInit() {
    if (hasInit()) setSharedParametersDefaultValues(true, MO);
  }

  /**
   * @copydoc SubModel::initSubBuffers()
   */
  void initSubBuffers();

  /**
   * @brief Computes the delayed value
   *
   * Retrieves the value corresponding to timepoint @p time - @p delayTime if allowed by @p delayMax
   *
   * @throw IncorrectDelay error if @p delayTime is not compatible (negative or less than @p delayMax)
   *
   * @param exprValue the value corresponding to @p time
   * @param exprNumber the id of the delay, in practice the index in the arrays of delayed variables
   * @param time the current time point
   * @param delayTime the delay to apply to the value
   * @param delayMax the maximum delay allowed
   *
   * @returns the computed delayed value
   */
  double computeDelay(int exprNumber, double exprValue, double time, double delayTime, double delayMax);

  /**
   * @brief Add new delay struture
   *
   * @param exprNumber the id of the delay to create
   * @param time pointer to the time that will be externally updated at runtime
   * @param exprValue pointer to the value that will be externally updated at runtime
   * @param delayMax maximum allowed delay
   */
  void addDelay(int exprNumber, const double* time, const double* exprValue, double delayMax);

  /**
   * @copydoc SubModel::hasDataCheckCoherence() const
   */
  bool hasDataCheckCoherence() const;

 private:
#ifdef _ADEPT_

  /**
   * @brief evaluate the residual functions with adept values
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param f values of the residual functions
   */
  void evalF(const double t, const std::vector<adept::adouble>& y, const std::vector<adept::adouble>& yp, std::vector<adept::adouble>& f);

  /**
   * @brief evaluate the jacobian with adept values
   *
   * @param t time to use for the evaluation
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   * @param rowOffset offset to use when filling the jacobian structure
   * @param complete @b true if \f$( J=@F/@x + cj * @F/@x')\f$ else \f$( J = @F/@x')\f$
   */
  void evalJtAdept(const double t, double *y, double* yp, const double cj, SparseMatrix& Jt, const int rowOffset, bool complete = true);
#endif

  /**
   * @brief initialization
   *
   */
  void initialize();

  /**
   * @brief set the current time
   * @param st time to set
   */
  void setManagerTime(const double st);

  /**
   * @brief calculate the values of the parameters
   *
   */
  void solveParameters();

  /**
   * @brief set the values of the calculated parameters
   *
   * @param y continuous values to use
   * @param z discrete values to use
   * @param calculatedVars calculated variables values to use
   */
  void setCalculatedParameters(std::vector<double>& y, std::vector<double>& z, const std::vector<double>& calculatedVars);

  /**
   * @brief set the value of a given calculated parameter
   *
   * @param name the name of the parameter to update
   * @param value the new value
   */
  inline void setCalculatedParameter(const std::string& name, const double value) {
    setParameterValue(name, LOCAL_INIT, value, false);
  }

  /**
   * @copydoc ModelManager::setCalculatedParameter (const std::string& name, const double& value)
   */
  inline void setCalculatedParameter(const std::string& name, const int value) {
    setParameterValue(name, LOCAL_INIT, value, false);
  }

  /**
   * @copydoc ModelManager::setCalculatedParameter (const std::string& name, const double& value)
   */
  inline void setCalculatedParameter(const std::string& name, const bool value) {
    setParameterValue(name, LOCAL_INIT, value, false);
  }

  /**
   * @copydoc ModelManager::setCalculatedParameter (const std::string& name, const double& value)
   */
  inline void setCalculatedParameter(const std::string& name, const std::string& value) {
    setParameterValue(name, LOCAL_INIT, value, false);
  }

  /**
   * @brief set the value of a given dynamic parameter
   *
   * @param name the name of the parameter to update
   * @param value the new value
   */
  inline void setFinalParameter(const std::string& name, const double value) {
    setParameterValue(name, FINAL, value, false);
  }

  /**
   * @copydoc ModelManager::setFinalParameter (const std::string& name, const double& value)
   */
  inline void setFinalParameter(const std::string& name, const int value) {
    setParameterValue(name, FINAL, value, false);
  }

  /**
   * @copydoc ModelManager::setFinalParameter (const std::string& name, const double& value)
   */
  inline void setFinalParameter(const std::string& name, const bool value) {
    setParameterValue(name, FINAL, value, false);
  }

  /**
   * @copydoc ModelManager::setFinalParameter (const std::string& name, const double& value)
   */
  inline void setFinalParameter(const std::string& name, const std::string& value) {
    setParameterValue(name, FINAL, value, false);
  }

  /**
   * @brief set the values of a given loaded parameters
   *
   * @param name the name of the parameter to update
   * @param value the new value
   */
  inline void setLoadedParameter(const std::string& name, const double value) {
    setParameterValue(name, LOADED_DUMP, value, false);
  }

  /**
   * @copydoc ModelManager::setLoadedParameter (const std::string& name, const double& value)
   */
  inline void setLoadedParameter(const std::string& name, const int value) {
    setParameterValue(name, LOADED_DUMP, value, false);
  }

  /**
   * @copydoc ModelManager::setLoadedParameter (const std::string& name, const double& value)
   */
  inline void setLoadedParameter(const std::string& name, const bool value) {
    setParameterValue(name, LOADED_DUMP, value, false);
  }

  /**
   * @copydoc ModelManager::setLoadedParameter (const std::string& name, const double& value)
   */
  inline void setLoadedParameter(const std::string& name, const std::string value) {
    setParameterValue(name, LOADED_DUMP, value, false);
  }

 private:
  /**
   * @brief fill a parameters' value set
   *
   * @param parameters the parameters from which to extract the values
   * @param parametersSet the parameters' set to fill
   */
  void createParametersValueSet(const std::unordered_map<std::string, ParameterModeler>& parameters,
      boost::shared_ptr<parameters::ParametersSet>& parametersSet);

 protected:
  /**
   * @brief whether has init model
   * @return whether has init model
   */
  virtual bool hasInit() const = 0;

 protected:
  ModelModelica* modelInit_;  ///< dynamic init model
  ModelModelica* modelDyn_;  ///< dynamic model
  DYNDATA* dataInit_;  ///< dynamic data for init model
  DYNDATA* dataDyn_;  ///< dynamic data
  std::string modelType_;  ///< model type
  DelayManager delayManager_;  ///< manager of delayed values

 private:
  /**
   * @brief returns the relevant instance of DYNDATA
   *
   * if the current model used is the init model, return the dynamic data for the init model
   * otherwise return the dynamic data for the standard model
   * @return an instance of DYNDATA
   */
  DYNDATA* data() const;

  /**
   * @brief returns the relevant instance of MODEL_DATA
   *
   * if the current model used is the init model, return the model data for the init model
   * otherwise return the model data for the standard model
   * @return an instance of MODEL_DATA
   */
  MODEL_DATA* modelData() const;

  /**
   * @brief returns the relevant instance of SIMULATION_INFO
   *
   * if the current model used is the init model, return the simulation infos for the init model
   * otherwise return the simulation info for the standard model
   * @return an instance of SIMULATION_INFO
   */
  SIMULATION_INFO* simulationInfo() const;

  /**
   * @brief returns the initialisation Modelica model
   *
   *
   * @return the initialisation Modelica model
   */
  ModelModelica* modelModelicaInit() const;
  /**
   * @brief returns the standard (not the initialisation) Modelica model
   *
   *
   * @return the standard Modelica model
   */
  ModelModelica* modelModelicaDynamic() const;
  /**
   * @brief returns the relevant Modelica model
   *
   * if the current model used is the init model, return the init model
   * otherwise return the standard model
   * @return a Modelica model
   */
  ModelModelica* modelModelica() const;

  /**
   * @brief associate modelica buffers to subModel buffers
   */
  void associateBuffers();

  /**
   * @brief set the values of y calculated parameters
   * @param y continuous values to use
   * @param reversedAlias reference variable name to alias variables map
   */
  void setYCalculatedParameters(std::vector<double>& y,
      const std::map<std::string, std::vector< boost::shared_ptr <VariableAlias> > >& reversedAlias);

  /**
   * @brief set the values of z calculated parameters
   * @param z discrete values to use
   * @param reversedAlias reference variable name to alias variables map
   */
  void setZCalculatedParameters(std::vector<double>& z,
      const std::map<std::string, std::vector< boost::shared_ptr <VariableAlias> > >& reversedAlias);

  /**
   * @brief read calculated variables and create calculated parameters from them
   * @param calculatedVars calculated variables values to use
   * @param reversedAlias reference variable name to alias variables map
   */
  void createCalculatedParametersFromInitialCalculatedVariables(const std::vector<double>& calculatedVars,
      const std::map<std::string, std::vector< boost::shared_ptr <VariableAlias> > >& reversedAlias);

  /**
   * @brief set the values of initial parameters
   */
  void setInitialCalculatedParameters();

 private:
  /**
   * @brief Used to iterate over parameters
   */
  typedef std::unordered_map<std::string, ParameterModeler>::const_iterator ParamIterator;
  bool modelInitUsed_;  ///< whether init model is used
};

}  // namespace DYN

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGER_H_
