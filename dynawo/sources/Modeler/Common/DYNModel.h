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
 * @file  DYNModel.h
 *
 * @brief Model header (defines all methods which should be declared in each models)
 *
 */
#ifndef MODELER_COMMON_DYNMODEL_H_
#define MODELER_COMMON_DYNMODEL_H_

#include <vector>
#include <map>
#include <string>
#include <boost/shared_ptr.hpp>
#include "DYNEnumUtils.h"
#include "PARParametersSet.h"

namespace timeline {
class Timeline;
}  // namespace timeline

namespace constraints {
class ConstraintsCollection;
}  // namespace constraints

namespace curves {
class Curve;
class CurvesCollection;
}  // namespace curves

namespace DYN {
class SparseMatrix;

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @brief Generic model
 */
class Model {
 public:
  /**
   * @brief destructor
   */
  virtual ~Model() = default;

  /**
   * @brief evaluate the residual functions of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param f values of the residual functions
   */
  virtual void evalF(const double t, const double* y, const double* yp, double* f) = 0;

  /**
   * @brief evaluate the differential residual functions of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param f values of the residual functions
   */
  virtual void evalFDiff(const double t, const double* y, const double* yp, double* f) = 0;

  /**
   * @brief evaluate the differential residual functions of the models for which there was a mode change
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param f values of the residual functions
   */
  virtual void evalFMode(const double t, const double* y, const double* yp, double* f) = 0;

  /**
   * @brief get the current value of the continuous variables
   *
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   */
  virtual void copyContinuousVariables(const double* y, const double* yp) = 0;

  /**
   * @brief get the current value of the discrete variables
   *
   * @param z current values of discrete variables
   */
  virtual void copyDiscreteVariables(const double* z) = 0;

  /**
   * @brief evaluate the root functions of the model based on the variable values contained in the model
   *
   * @param t current time
   * @param g values of the root functions
   */
  virtual void evalG(double t, std::vector<state_g>& g) = 0;

  /**
   * @brief evaluate the discrete variables of the model based on the variable values contained in the model
   *
   * @param t current time
   */
  virtual void evalZ(double t) = 0;

  /**
   * @brief evaluate the mode of the model based on the variable values contained in the model
   *
   * @param t current time
   */
  virtual void evalMode(double t) = 0;

  /**
   * @brief compute the transpose jacobian of the sub model \f$ J = @F/@x + cj * @F/@x' \f$  based on the variable values contained in the model
   *
   * @param t time to use for the evaluation
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   */
  virtual void evalJt(const double t, const double cj, SparseMatrix& Jt) = 0;

  /**
   * @brief compute the transpose prim jacobian of the sub model \f$ J'= @F/@x' \f$  based on the variable values contained in the model
   *
   * @param t time to use for the evaluation
   * @param cj Jacobian prime coefficient
   * @param JtPrim jacobian matrix to fullfill
   */
  virtual void evalJtPrim(const double t, const double cj, SparseMatrix& JtPrim) = 0;

  /**
   * @brief ensure data coherence (asserts, min/max, sanity checks ....)
   *
   * @param t time to use for the evaluation
   */
  virtual void checkDataCoherence(const double t) = 0;

  /**
   * @brief Coherence check on parameters (min/max values, sanity checks)
   */
  virtual void checkParametersCoherence() const = 0;

  /**
   * @brief set equation's formula in Model
   *
   */
  virtual void setFequationsModel() = 0;
  /**
   * @brief set root equation's formula in Model
   *
   */
  virtual void setGequationsModel() = 0;


  /**
   * @brief retrieve the initial values of the model
   *
   * @param t0 initial time of the simulation
   * @param y0 initial values of the variables
   * @param yp0 initial values of the derivatives of the variables
   */
  virtual void getY0(const double t0, std::vector<double>& y0, std::vector<double>& yp0) = 0;

  /**
   * @brief retrieve mode change information
   *
   *
   * @return @b true if one mode of the model has change
   */
  virtual bool modeChange() const = 0;

  /**
   * @brief get the overall system mode change type
   *
   * @return mode change type for the overall system
   */
  virtual modeChangeType_t getModeChangeType() const = 0;

  /**
   * @brief set the overall system mode change type
   *
   * @param modeChangeType overall system mode change type
   */
  virtual void setModeChangeType(const modeChangeType_t& modeChangeType) = 0;

  /**
   * @brief reinitialize the mode change and mode change type values to default values (for ModelMulti and each SubModel)
   *
   */
  virtual void reinitMode() = 0;

  /**
   * @brief get the type of z that were modified
   * @return type of z that were modified
   */
  virtual zChangeType_t getSilentZChangeType() const = 0;

  /**
   * @brief initialize the type of discrete variables (notSilent, used only in discrete equations, used only in continuous equations)
   *
   *
   * @param enableSilentZ whether silent z is enabled or disabled
   */
  virtual void initSilentZ(bool enableSilentZ) = 0;

  /**
   * @brief get the properties of each residual function (algebraic or differential equation)
   *
   * @return properties of each equation
   */
  virtual const std::vector<propertyF_t>& getFType() const = 0;

  /**
   * @brief get the properties of the variables (algebraic, external or differential variable)
   *
   * @return properties of each variable
   */
  virtual const std::vector<propertyContinuousVar_t>& getYType() const = 0;

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
   * @brief Set the initialisation status of the simulation
   *
   * @param isInitProcess : true for initialisation, false for standard dynamic simulation
   */
  virtual void setIsInitProcess(bool isInitProcess) = 0;

  /**
   * @brief set the initial time to use for models
   * @param t0 initial time to use
   */
  virtual void setInitialTime(const double t0) = 0;

  /**
   * @brief get the number of root functions
   *
   *
   * @return number of root functions
   */
  virtual int sizeG() const = 0;

  /**
   * @brief get the number of residual functions of the model
   *
   *
   * @return number of residual functions
   */
  virtual int sizeF() const = 0;

  /**
   * @brief get the number of mode
   *
   *
   * @return  number of mode
   */
  virtual int sizeMode() const = 0;

  /**
   * @brief get the number of discrete variables
   *
   *
   * @return  number of discrete variables
   */
  virtual int sizeZ() const = 0;

  /**
   * @brief  get the number of continuous variable
   *
   *
   * @return  number of continuous variable
   */
  virtual int sizeY() const = 0;

  // infos

  /**
   * @brief get informations about residual functions
   *
   * @param globalFIndex global index of the residual functions to find
   * @param subModelName name of the subModel who contains the residual functions
   * @param localFIndex local index of the residual functions inside the subModel
   * @param fEquation equation formula related to local index
   */
  virtual void getFInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation) const = 0;

  /**
   * @brief get informations about root functions
   *
   * @param globalGIndex global index of the root functions to find
   * @param subModelName name of the subModel who contains the root functions
   * @param localGIndex local index of the root functions inside the subModel
   * @param gEquation equation formula related to local index
   */
  virtual void getGInfos(const int globalGIndex, std::string& subModelName, int& localGIndex, std::string& gEquation) const = 0;

  /**
   * @brief initialize the model
   *
   * @param t0 time to use to initialize the model
   */
  virtual void init(const double t0) = 0;

  /**
   * @brief initial all the buffers of the model
   *
   */
  virtual void initBuffers() = 0;

  /**
   * @brief print informations about the model
   *
   */
  virtual void printModel() const = 0;

  /**
   * @brief print initial values of the model
   *
   * @param directory directory where the file of initial values should be printed
   * @param dumpFileName name of the file where to dump the values
   */
  virtual void printModelValues(const std::string& directory, const std::string& dumpFileName) = 0;

  /**
   * @brief print values of the initialization model
   *
   * @param directory directory where the file of initial values should be printed
   * @param dumpFileName name of the file where to dump the values
   */
  virtual void printInitModelValues(const std::string& directory, const std::string& dumpFileName) = 0;

  /**
   * @brief evaluate the calculated variables of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param z values of the discrete variables
   */
  virtual void evalCalculatedVariables(const double t, const std::vector<double>& y, const std::vector<double>& yp, const std::vector<double>& z) = 0;

  /**
   * @brief update the subset of calculated variables needed for curves
   *
   * @param curvesCollection set of curves
   */
  virtual void updateCalculatedVarForCurves(std::shared_ptr<curves::CurvesCollection>& curvesCollection) const = 0;

  /**
   * @brief export the parameters of the model for dump
   *
   * @param mapParameters map associating the file where parameters should be dumped with the stream of parameters
   */
  virtual void dumpParameters(std::map< std::string, std::string>& mapParameters) = 0;

  /**
   * @brief  retrieve the value of a parameter
   *
   * @param curveModelName name of the model where the parameter should be
   * @param curveVariable name of the parameter
   * @param value value of the parameter
   * @param found @b true if the parameter exist, @b false else
   */
  virtual void getModelParameterValue(const std::string& curveModelName, const std::string& curveVariable, double& value, bool& found) = 0;

  /**
   * @brief  load the parameters values from a previous dump
   *
   * @param mapParameters map associating the file where parameters should be dumped with the stream of parameters
   */
  virtual void loadParameters(const std::map< std::string, std::string>& mapParameters) = 0;

  /**
   * @brief export the variables of the model for dump
   *
   * @param mapVariables map associating the file where variables should be dumped with the stream of variables
   */
  virtual void dumpVariables(std::map< std::string, std::string>& mapVariables) = 0;

  /**
   * @brief  load the variables values from a previous dump
   *
   * @param mapVariables map associating the file where variables should be dumped with the stream of variables
   */
  virtual void loadVariables(const std::map< std::string, std::string>& mapVariables) = 0;

  /**
   * @brief copy current values in "pre" buffers (need for modelica sub models)
   *
   */
  virtual void rotateBuffers() = 0;

  /**
   * @brief print all messages which appear during the simulation (debug stream)
   */
  virtual void printMessages() = 0;

  /**
   * @brief set the timeline to use during the simulation (where events should be added)
   *
   * @param timeline timeline to use
   */
  virtual void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline) = 0;

  /**
   * @brief set the constraints collection to use during the simulation (where constraints should be added)
   *
   * @param constraints constraints collections to use
   */
  virtual void setConstraints(const std::shared_ptr<constraints::ConstraintsCollection>& constraints) = 0;

  /**
   * @brief initialize curve (reference with the variable, variable exists ...)
   *
   * @param curve curve to find
   * @return true if the curve was added
   */
  virtual bool initCurves(std::shared_ptr<curves::Curve>& curve) = 0;

  /**
   * @brief set the simulation working directory to use
   * @param workingDirectory Simulation working directory to use
   */
  virtual void setWorkingDirectory(const std::string& workingDirectory) = 0;

   /**
   * @brief Print all variables names.
   * @param withVariableType add the type of the variables (algebraic or differential)
   */
  virtual void printVariableNames(bool withVariableType) = 0;

  /**
   * @brief Print all equations.
   */
  virtual void printEquations() = 0;

  /**
  * @brief Print all parameters values
  */
  virtual void printParameterValues() const = 0;

  /**
  * @brief Print values of parameters set by local initialization
  */
  virtual void printLocalInitParametersValues() const = 0;

  /**
   * @brief Get a variable name from its index.
   *
   * This function is intended to be used in debug mode as it allocates a lot of memory
   * but can be called in release mode.
   *
   * @param index Index of the variable.
   *
   * @return name of the variable
   */
  virtual std::string getVariableName(int index) = 0;

  /**
   * @brief Copy the discrete variable values from the model data structure to the solver data structure
   *
   * @param z vector of discrete values from the solver data structure
   */
  virtual void getCurrentZ(std::vector<double>& z) const = 0;

  /**
   * @brief Copy the discrete variable values from the solver data structure to the model data structure
   *
   * This function is necessary when a solver has to go back in time for non convergence reasons to begin the new resolution with
   * the correct discrete variable value (for example for simplified solver)
   *
   * @param z vector of discrete values from the solver data structure
   */
  virtual void setCurrentZ(const std::vector<double>& z) = 0;

  /**
   * @brief Notify that time step is performed in the simulation
   */
  virtual void notifyTimeStep() = 0;

  /**
   * @brief set the local initialization solver parameters of the model
   * @param localInitParameters local initialization solver parameters set
   */
  virtual void setLocalInitParameters(std::shared_ptr<parameters::ParametersSet> localInitParameters) = 0;
};  ///< Generic class for Model

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODEL_H_
