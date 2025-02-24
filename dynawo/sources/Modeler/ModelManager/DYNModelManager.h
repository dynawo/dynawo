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
#include "DYNModelModelica.h"
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
  ~ModelManager() override;

  // instantiate the virtual methods of the Model class
  /**
   * @brief initialization of the model
   * @param t0 : initial time of the simulation
   */
  void init(double t0) override;

  /**
   * @copydoc SubModel::getSize() override
   */
  void getSize() override;

  /**
   * @copydoc SubModel::evalF(double t, propertyF_t type) override
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @copydoc SubModel::evalG(const double t) override
   */
  void evalG(double t) override;

  /**
   * @copydoc SubModel::evalZ(const double t) override
   */
  void evalZ(double t) override;

  /**
   * @copydoc SubModel::evalMode(const double t) override;
   */
  modeChangeType_t evalMode(double t) override;

  /**
   * @copydoc SubModel::evalJt(double t, double cj, int rowOffset, SparseMatrix& jt)
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc SubModel::evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim)
   */
  void evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @brief copy Z to local data
   *
   * @param z discrete values to copy
   */
  void evalZ(std::vector<double>& z);

  /**
   * @copydoc SubModel::checkDataCoherence(double t) override
   */
  void checkDataCoherence(double t) override;

  /**
   * @copydoc SubModel::checkParametersCoherence() const override
   */
  void checkParametersCoherence() const override;

  /**
   * @copydoc SubModel::setFequations() override
   */
  void setFequations() override;

  /**
   * @copydoc SubModel::setGequations() override
   */
  void setGequations() override;

  /**
   * @copydoc SubModel::setFequationsInit() override
   */
  void setFequationsInit() override;

  /**
   * @copydoc SubModel::setGequationsInit() override
   */
  void setGequationsInit() override;

  /**
   * @copydoc SubModel::evalCalculatedVars() override
   */
  void evalCalculatedVars() override;

  /**
   * @copydoc SubModel::evalStaticFType() override
   */
  void evalStaticFType() override;

  /**
   * @copydoc SubModel::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc SubModel::evalDynamicFType() override
   */
  void evalDynamicFType() override;

  /**
   * @copydoc SubModel::getY0() override
   */
  void getY0() override;

  /**
   * @copydoc SubModel::evalStaticYType() override
   */
  void evalStaticYType() override;

  /**
   * @copydoc SubModel::evalDynamicYType() override
   */
  void evalDynamicYType() override;

  /**
   * @copydoc SubModel::dumpParameters(std::map< std::string, std::string > & mapParameters) override
   */
  void dumpParameters(std::map< std::string, std::string >& mapParameters) override;

  /**
   * @copydoc SubModel::dumpVariables(std::map< std::string, std::string > & mapVariables) override
   */
  void dumpVariables(std::map< std::string, std::string >& mapVariables) override;

  /**
   * @brief write the final parameters values (relying on low level Modelica data structures)
   * @throw when the parameter value type in Modelica data structures is incompatible with the value type in Dynawo Parameter
   */
  void writeParametersFinalValues();

  /**
  * @brief retrieve the value of a parameter
  *
  * @param nameParameter name of a parameter to found
  * @param value value of the parameter
  * @param found @b true if the parameter exist, @b false else
  */
  void getSubModelParameterValue(const std::string& nameParameter, std::string& value, bool& found) override;

  /**
   * @copydoc SubModel::loadParameters(const std::string & parameters) override
   */
  void loadParameters(const std::string& parameters) override;

  /**
   * @copydoc SubModel::loadVariables(const std::string & variables) override
   */
  void loadVariables(const std::string& variables) override;

  /**
   * @copydoc SubModel::initParams() override;
   */
  void initParams() override;

  /**
  * @brief write initial values parameters of a model in a file
  *
  * @param fstream the file to stream parameters to
  */
  void printValuesParameters(std::ofstream& fstream) override;

  /**
  * @brief write parameters of the initialization model in a file
  *
  * @param fstream the file to stream parameters to
  */
  void printInitValuesParameters(std::ofstream& fstream) const override;

  /**
   * @copydoc SubModel::modelType() const override
   */
  const std::string& modelType() const override;

  /**
   * @copydoc SubModel::rotateBuffers() override
   */
  void rotateBuffers() override;

  /**
   * @copydoc SubModel::notifyTimeStep() override
   */
  void notifyTimeStep() override;

  /**
   * @copydoc SubModel::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) override
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;

 /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarIAdept(unsigned iCalculatedVar, std::vector<double>& res) const;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override;

  /**
   * @copydoc SubModel::initializeStaticData() override
   */
  void initializeStaticData() override;

  /**
   * @copydoc SubModel::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineParameters(std::vector<ParameterModeler>& parameters) override
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;

  /**
   * @copydoc SubModel::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) override
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables) override;

  /**
   * @copydoc SubModel::defineParametersInit(std::vector<ParameterModeler>& parameters) override
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters) override;

  /**
   * @copydoc SubModel::initializeFromData(const boost::shared_ptr<DataInterface> &data) override
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;

  /**
   * @copydoc SubModel::setSubModelParameters() override
   */
  void setSubModelParameters() override;

  /**
   * @brief set the submodel shared parameters value
   * @param isInit whether to set the values for the init or dynamic model
   * @param origin the origin from which the default value comes (MO)
   */
  void setSharedParametersDefaultValues(bool isInit, const parameterOrigin_t& origin);

  /**
   * @copydoc SubModel::setSharedParametersDefaultValues() override
   */
  inline void setSharedParametersDefaultValues() override {
    setSharedParametersDefaultValues(false, MO);
  }

  /**
   * @copydoc SubModel::setSharedParametersDefaultValuesInit() override
   */
  inline void setSharedParametersDefaultValuesInit() override {
    if (hasInit()) setSharedParametersDefaultValues(true, MO);
  }

  /**
   * @copydoc SubModel::initSubBuffers() override
   */
  void initSubBuffers() override;

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

#ifdef _ADEPT_
  adept::adouble computeDelayDerivative(int exprNumber, adept::adouble exprValue, double time, adept::adouble delayTime, double delayMax);
#endif

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
   * @copydoc SubModel::hasDataCheckCoherence() const override
   */
  bool hasDataCheckCoherence() const override;

 /**
* @brief fill a parameters' value set
*
* @return p
*/
 const DelayManager& getDelayManager() const {
  return delayManager_;
 }

 /**
 * @brief fill a parameters' value set
 *
 * @return parametersSet the parameters' set to fill
 */
 DelayManager& getNonCstDelayManager() {
  return const_cast<DelayManager&>(getDelayManager());
 }

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
  void evalF(double t, const std::vector<adept::adouble>& y, const std::vector<adept::adouble>& yp, std::vector<adept::adouble>& f);

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
  void evalJtAdept(double t, double *y, double* yp, double cj, SparseMatrix& Jt, int rowOffset, bool complete = true);
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
  void setManagerTime(double st);

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
  inline void setLoadedParameter(const std::string& name, const std::string& value) {
    setParameterValue(name, LOADED_DUMP, value, false);
  }

  /**
  * @brief turns on symbolic evalJ
  *
  */
  void setEvalJIsSymbolic() override {
    modelModelica()->setEvalJIsSymbolic();
  }

 /**
  * @brief turns on symbolic evalJ
  *
  */
 void setEvalFIsSymbolic() override {
   modelModelica()->setEvalFIsSymbolic();
  }

 private:
  /**
   * @brief fill a parameters' value set
   *
   * @param parameters the parameters from which to extract the values
   * @param parametersSet the parameters' set to fill
   */
  void createParametersValueSet(const std::unordered_map<std::string, ParameterModeler>& parameters,
      const std::shared_ptr<parameters::ParametersSet>& parametersSet) const;

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
      const std::map<std::string, std::vector<boost::shared_ptr<VariableAlias> > >& reversedAlias);

  /**
   * @brief set the values of z calculated parameters
   * @param z discrete values to use
   * @param reversedAlias reference variable name to alias variables map
   */
  void setZCalculatedParameters(std::vector<double>& z,
      const std::map<std::string, std::vector<boost::shared_ptr<VariableAlias> > >& reversedAlias);

  /**
   * @brief read calculated variables and create calculated parameters from them
   * @param calculatedVars calculated variables values to use
   * @param reversedAlias reference variable name to alias variables map
   */
  void createCalculatedParametersFromInitialCalculatedVariables(const std::vector<double>& calculatedVars,
      const std::map<std::string, std::vector<boost::shared_ptr<VariableAlias> > >& reversedAlias);

  /**
   * @brief set the values of initial parameters
   */
  void setInitialCalculatedParameters();

 private:
  bool modelInitUsed_;  ///< whether init model is used
};

}  // namespace DYN

#endif  // MODELER_MODELMANAGER_DYNMODELMANAGER_H_
