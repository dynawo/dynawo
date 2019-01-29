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

namespace timeline {
class Timeline;
}  // namespace timeline

namespace constraints {
class ConstraintsCollection;
}  // namespace constraints

namespace finalState {
class Model;
class Variable;
}  // namespace finalState

namespace curves {
class Curve;
class CurvesCollection;
}  // namespace curves

namespace DYN {
class SparseMatrix;

class Model {
 public:
  /**
   * @brief default destructor
   */
  virtual ~Model() { }

  /**
   * @brief evaluate the residual functions of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param f values of the residual functions
   */
  virtual void evalF(const double t, double* y, double* yp, double* f) = 0;

  /**
   * @brief evaluate the root functions of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param z current values of discrete variables
   * @param g values of the root functions
   */
  virtual void evalG(const double &t, const std::vector<double> &y, const std::vector<double> &yp,
          const std::vector<double> &z, std::vector<state_g> &g) = 0;

  /**
   * @brief evaluate the discrete variables of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param z values of the discrete variables
   */
  virtual void evalZ(const double & t, const std::vector<double> &y, const std::vector<double> &yp,
          std::vector<double> &z) = 0;

  /**
   * @brief evaluate the mode of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param z current values of discrete variables
   */
  virtual void evalMode(const double & t, const std::vector<double> &y, const std::vector<double> &yp, const std::vector<double> &z) = 0;

  /**
   * @brief compute the transpose jacobian of the sub model \f$ J = @F/@x + cj * @F/@x' \f$
   *
   * @param t time to use for the evaluation
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param cj Jacobian prime coefficient
   * @param Jt jacobian matrix to fullfill
   */
  virtual void evalJt(const double t, double* y, double* yp, const double cj, SparseMatrix& Jt) = 0;

  /**
   * @brief compute the transpose prim jacobian of the sub model \f$ J'= @F/@x' \f$
   *
   * @param t time to use for the evaluation
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param cj Jacobian prime coefficient
   * @param JtPrim jacobian matrix to fullfill
   */
  virtual void evalJtPrim(const double t, double* y, double* yp, const double cj, SparseMatrix& JtPrim) = 0;

  /**
   * @brief ensure data coherence (asserts, min/max, sanity checks ....)
   *
   * @param t time to use for the evaluation
   */
  virtual void checkDataCoherence(const double & t) = 0;

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
   * @param z0 initial values of discretes variables
   */
  virtual void getY0(const double& t0, std::vector<double> &y0, std::vector<double> &yp0, std::vector<double> &z0) = 0;

  /**
   * @brief set mode change information
   *
   * @param modeChange @b true if one mode of the model has change
   */
  virtual void modeChange(bool modeChange) = 0;

  /**
   * @brief  retrieve mode change information
   *
   *
   * @return @b true if one mode of the model has change
   */
  virtual bool modeChange() const = 0;

  /**
   * @brief retrieve mode change information for algebraic equation
   *
   *
   * @return  @b true if one mode of the model has change
   */
  virtual bool modeChangeAlg() const = 0;

  /**
   * @brief set mode change information for algebraic equation
   *
   * @param modeChange @b true if one mode of the sub model has change
   */
  virtual void modeChangeAlg(bool modeChange) = 0;

  /**
   * @brief set information that one discrete variables has changed
   *
   * @param zChange @b true if one mode of the sub model has change
   */
  virtual void zChange(bool zChange) = 0;

  /**
   * @brief retrieve if one discrete variables has changed
   *
   *
   * @return @b true if one discrete variables has changed
   */
  virtual bool zChange() const = 0;

  /**
   * @brief get the properties of each residual function (algebraic or differential equation)
   *
   * @return properties of each equation
   */
  virtual propertyF_t* getFType() const = 0;

  /**
   * @brief evaluate the properties of the residual functions (algebraic or differential)
   */
  virtual void evalFType() = 0;

  /**
   * @brief get the properties of the variables (algebraic, external or differential variable)
   *
   * @return properties of each variable
   */
  virtual propertyContinuousVar_t* getYType() const = 0;

  /**
   * @brief evaluate the properties of the variables (algebraic, external or differential variable)
   */
  virtual void evalYType() = 0;

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
  virtual void setInitialTime(const double& t0) = 0;

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
   * @brief get the number of discretes variables
   *
   *
   * @return  number of discretes variables
   */
  virtual int sizeZ() const = 0;

  /**
   * @brief  get the number of continuous variable
   *
   *
   * @return  number of continuous variable
   */
  virtual int sizeY() const = 0;

  /**
   * @brief get the number of calculated variables
   *
   *
   * @return number of calculated variables
   */
  virtual int sizeCalculatedVar() const = 0;

  // infos

  /**
   * @brief get informations about residual functions
   *
   * @param globalFIndex global index of the residual functions to find
   * @param subModelName name of the subModel who contains the residual functions
   * @param localFIndex local index of the residual functions inside the subModel
   * @param fEquation equation formula related to local index
   */
  virtual void getFInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation) = 0;
  /**
   * @brief get informations about root functions
   *
   * @param globalGIndex global index of the root functions to find
   * @param subModelName name of the subModel who contains the root functions
   * @param localGIndex local index of the root functions inside the subModel
   * @param gEquation equation formula related to local index
   */
  virtual void getGInfos(const int globalGIndex, std::string& subModelName, int& localGIndex, std::string& gEquation) = 0;

  /**
   * @brief initialize the model
   *
   * @param t0 time to use to initialize the model
   */
  virtual void init(const double& t0) = 0;

  /**
   * @brief initial all the buffers of the model
   *
   */
  virtual void initBuffers() = 0;

  /**
   * @brief print informations about the model
   *
   */
  virtual void printModele() = 0;

  /**
   * @brief print initial values of the model
   *
   * @param directory directory where the file of initial values should be printed
   */
  virtual void printInitValues(const std::string & directory) = 0;

  /**
   * @brief evaluate the calculated variables of the model
   *
   * @param t current time
   * @param y current values of continuous variables
   * @param yp current values of the derivative of the continuous variables
   * @param z values of the discrete variables
   */
  virtual void evalCalculatedVariables(const double & t, const std::vector<double> &y, const std::vector<double> &yp, const std::vector<double> &z) = 0;

  /**
   * @brief update the subset of calculated variables needed for curves
   *
   * @param curvesCollection set of curves
   * @param y values of the variables used to calculate the variable
   * @param yp value of the derivatives used to calculate the variable
   */
  virtual void updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection,
      std::vector<double>& y, std::vector<double>& yp) = 0;

  /**
   * @brief export the parameters of the model for dump
   *
   * @param mapParameters map associating the file where parameters should be dumped with the stream of parameters
   */
  virtual void dumpParameters(std::map< std::string, std::string> & mapParameters) = 0;

  /**
   * @brief  retrieve the value of a parameter
   *
   * @param curveModelName name of the model where the parameter should be
   * @param curveVariable name of the parameter
   * @param value value of the parameter
   * @param found @b true if the parameter exist, @b false else
   */
  virtual void getModelParameterValue(const std::string & curveModelName, const std::string & curveVariable, double & value, bool & found) = 0;

  /**
   * @brief  load the parameters values from a previous dump
   *
   * @param mapParameters map associating the file where parameters should be dumped with the stream of parameters
   */
  virtual void loadParameters(const std::map< std::string, std::string> & mapParameters) = 0;

  /**
   * @brief export the variables of the model for dump
   *
   * @param mapVariables map associating the file where variables should be dumped with the stream of variables
   */
  virtual void dumpVariables(std::map< std::string, std::string> & mapVariables) = 0;

  /**
   * @brief  load the variables values from a previous dump
   *
   * @param mapVariables map associating the file where variables should be dumped with the stream of variables
   */
  virtual void loadVariables(const std::map< std::string, std::string> & mapVariables) = 0;

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
  virtual void setConstraints(const boost::shared_ptr<constraints::ConstraintsCollection>& constraints) = 0;

  /**
   * @brief initialize curve (reference with the variable, variable exists ...)
   *
   * @param curve curve to find
   */
  virtual void initCurves(boost::shared_ptr<curves::Curve>& curve) = 0;

  /**
   * @brief fill variables with the current value
   *
   * @param model final state model where variables are stored
   */
  virtual void fillVariables(boost::shared_ptr<finalState::Model>& model) = 0;

  /**
   * @brief fill variable with the current value
   *
   * @param variable variable to fill
   */
  virtual void fillVariable(boost::shared_ptr<finalState::Variable>& variable) = 0;

  /**
   * @brief set the simulation working directory to use
   * @param workingDirectory Simulation working directory to use
   */
  virtual void setWorkingDirectory(const std::string& workingDirectory) = 0;

   /**
   * @brief Print all variables names.
   */
  virtual void printVariableNames() = 0;

  /**
   * @brief Print all equations.
   */
  virtual void printEquations() = 0;

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
   * @brief Copy the discrete variable values from the solver data structure to the model data structure
   *
   * This fonction is necessary when a solver has to go back in time for non convergence reasons to begin the new resolution with
   * the correct discrete variable value (for example for simplified solver)
   *
   * @param z vector of discrete values from the solver data structure
   */
  virtual void copyZ(const std::vector<double> &z) = 0;
};  ///< Generic class for Model
}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODEL_H_
