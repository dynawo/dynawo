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
 * @file  DYNModelMulti.h
 *
 * @brief class of model multi (contains all subModels and connectors between them)
 *
 */
#ifndef MODELER_COMMON_DYNMODELMULTI_H_
#define MODELER_COMMON_DYNMODELMULTI_H_
#include <set>
#include <string>
#include <vector>
#include <boost/core/noncopyable.hpp>
#include <boost/unordered_map.hpp>

#include "DYNModel.h"

namespace DYN {
class SubModel;
class ConnectorContainer;

class ModelMulti : public Model, private boost::noncopyable {
 public:
  /**
   * @brief default constructor
   */
  ModelMulti();

  /**
   * @brief default destructor
   */
  ~ModelMulti();

  /**
   * @copydoc Model::evalF(const double t, double* y, double* yp, double* f)
   */
  void evalF(const double t, double* y, double* yp, double* f);

  /**
   * @copydoc Model::copyContinuousVariables(double* y, double* yp)
   */
  void copyContinuousVariables(double* y, double* yp);

  /**
   * @copydoc Model::copyDiscreteVariables(double* z)
   */
  void copyDiscreteVariables(double* z);

  /**
   * @copydoc Model::evalG(double t, std::vector<state_g> &g)
   */
  void evalG(double t, std::vector<state_g> &g);

  /**
   * @copydoc Model::evalZ(double t)
   */
  void evalZ(double t);

  /**
   * @copydoc Model::evalMode(double t)
   */
  void evalMode(double t);

  /**
   * @copydoc Model::evalJt(const double t, const double cj, SparseMatrix& Jt)
   */
  void evalJt(const double t, const double cj, SparseMatrix& Jt);

  /**
   * @copydoc Model::evalJtPrim(const double t, const double cj, SparseMatrix& JtPrim)
   */
  void evalJtPrim(const double t, const double cj, SparseMatrix& JtPrim);

  /**
   * @copydoc Model::checkDataCoherence(const double & t)
   */
  void checkDataCoherence(const double & t);

  /**
   * @copydoc Model::setFequationsModel()
   */
  void setFequationsModel();

  /**
   * @copydoc Model::setGequationsModel()
   */
  void setGequationsModel();

  /**
   * @copydoc Model::getY0(const double& t0, std::vector<double> &y0, std::vector<double> &yp0)
   */
  void getY0(const double& t0, std::vector<double> &y0, std::vector<double> &yp0);

  /**
   * @copydoc Model::modeChange()
   */
  inline bool modeChange() const {
    return modeChange_;
  }

  /**
   * @copydoc Model::getModeChangeType()
   */
  inline modeChangeType_t getModeChangeType() const {
    return modeChangeType_;
  }

  /**
   * @copydoc Model::setModeChangeType(const modeChangeType_t& modeChangeType)
   */
  inline void setModeChangeType(const modeChangeType_t& modeChangeType) {
    modeChangeType_ = modeChangeType;
  }

  /**
   * @copydoc Model::reinitMode()
   */
  void reinitMode();

  /**
   * @brief retrieve if one discrete variables has changed
   *
   *
   * @return @b true if one discrete variables has changed
   */
  bool zChange() const;

  /**
   * @copydoc Model::getFType()
   */
  inline propertyF_t* getFType() const {
    return fType_;
  }

  /**
   * @copydoc Model::evalFType()
   */
  void evalFType();

  /**
   * @copydoc Model::updateFType()
   */
  void updateFType();

  /**
   * @copydoc Model::getYType()
   */
  inline propertyContinuousVar_t* getYType() const {
    return yType_;
  }

  /**
   * @copydoc Model::evalYType()
   */
  void evalYType();

  /**
   * @copydoc Model::updateYType()
   */
  void updateYType();

  /**
   * @copydoc Model::setIsInitProcess(bool isInitProcess)
   */
  void setIsInitProcess(bool isInitProcess);

  /**
   * @copydoc Model::setInitialTime(const double& t0)
   */
  void setInitialTime(const double& t0);

  /**
   * @copydoc Model::sizeG() const
   */
  inline int sizeG() const {
    return sizeG_;
  }

  /**
   * @copydoc Model::sizeF() const
   */
  inline int sizeF() const {
    return sizeF_;
  }

  /**
   * @copydoc Model::sizeMode() const
   */
  inline int sizeMode() const {
    return sizeMode_;
  }

  /**
   * @copydoc Model::sizeZ() const
   */
  inline int sizeZ() const {
    return sizeZ_;
  }

  /**
   * @copydoc Model::sizeY() const
   */
  inline int sizeY() const {
    return sizeY_;
  }

  /**
   * @copydoc Model::getFInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation)
   */
  void getFInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation);
  /**
   * @copydoc Model::getGInfos(const int globalGIndex, std::string& subModelName, int& localGIndex, std::string& gEquation)
   */
  void getGInfos(const int globalGIndex, std::string& subModelName, int& localGIndex, std::string& gEquation);

  // ==============================
  // interface SIMULATION <-> MODEL
  // ==============================

  /**
   * @brief initialize the model
   *
   * @param t0 time to use to initialize the model
   */
  void init(const double& t0);

  /**
   * @copydoc Model::initBuffers()
   */
  void initBuffers();

  /**
   * @copydoc Model::printModel()
   */
  void printModel();

  /**
   * @copydoc Model::printInitValues(const std::string & directory)
   */
  void printInitValues(const std::string & directory);

  /**
   * @copydoc Model::evalCalculatedVariables(const double & t, const std::vector<double> &y, const std::vector<double> &yp,const std::vector<double> &z)
   */
  void evalCalculatedVariables(const double & t, const std::vector<double> &y, const std::vector<double> &yp, const std::vector<double> &z);

  /**
   * @copydoc Model::updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection, const std::vector<double>& y, const std::vector<double>& yp)
   */
  void updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection, const std::vector<double>& y, const std::vector<double>& yp);

  /**
   * @copydoc Model::dumpParameters(std::map< std::string, std::string> & mapParameters)
   */
  void dumpParameters(std::map< std::string, std::string> & mapParameters);

  /**
   * @copydoc Model::getModelParameterValue(const std::string & curveModelName, const std::string & curveVariable, double & value, bool & found)
   */
  void getModelParameterValue(const std::string & curveModelName, const std::string & curveVariable, double & value, bool & found);

  /**
   * @copydoc Model::loadParameters(const std::map< std::string, std::string> & mapParameters)
   */
  void loadParameters(const std::map< std::string, std::string> & mapParameters);

  /**
   * @copydoc Model::dumpVariables(std::map< std::string, std::string> & mapVariables)
   */
  void dumpVariables(std::map< std::string, std::string> & mapVariables);

  /**
   * @copydoc Model::loadVariables(const std::map< std::string, std::string> & mapVariables)
   */
  void loadVariables(const std::map< std::string, std::string> & mapVariables);

  /**
   * @copydoc Model::rotateBuffers()
   */
  void rotateBuffers();

  /**
   * @copydoc Model::printMessages()
   */
  void printMessages();

  /**
   * @copydoc Model::setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline)
   */
  void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline);

  /**
   * @copydoc Model::setConstraints(const boost::shared_ptr<constraints::ConstraintsCollection>& constraints)
   */
  void setConstraints(const boost::shared_ptr<constraints::ConstraintsCollection>& constraints);

  /**
   * @copydoc Model::initCurves(boost::shared_ptr<curves::Curve>& curve)
   */
  void initCurves(boost::shared_ptr<curves::Curve>& curve);

  /**
   * @copydoc Model::fillVariables(boost::shared_ptr<finalState::FinalStateModel>& model)
   */
  void fillVariables(boost::shared_ptr<finalState::FinalStateModel>& model);

  /**
   * @copydoc Model::fillVariable(boost::shared_ptr<finalState::Variable>& variable)
   */
  void fillVariable(boost::shared_ptr<finalState::Variable>& variable);

 public:
  /**
   * @brief add a sub model to the model multi container
   *
   * @param sub sub model to add
   * @param libName name of the library used to create the subModel
   */
  void addSubModel(boost::shared_ptr<SubModel>& sub, const std::string& libName);

  /**
   * @brief connect a variable of subModel1 to a variable of subModel2
   *
   * @param subModel1 first subModel where the variable is located
   * @param name1 name of the variable to connect inside the subModel 1
   * @param subModel2 second subModel where the variable is located
   * @param name2 name of the variable to connect inside the subModel 2
   */
  void connectElements(boost::shared_ptr<SubModel> &subModel1, const std::string &name1, boost::shared_ptr<SubModel> &subModel2, const std::string &name2);
  /**

   * @brief seek all variables that are connected by a connection
   *
   * @param subModel1 first subModel where the variable is located
   * @param name1 name of the variable to connect inside the subModel 1
   * @param subModel2 second subModel where the variable is located
   * @param name2 name of the variable to connect inside the subModel 2
   * @param variables outputs: after the call contains all couples variable1->variable2 connected by this connection
   */
  void findVariablesConnectedBy(const boost::shared_ptr<SubModel> &subModel1, const std::string &name1,
      const boost::shared_ptr<SubModel> &subModel2, const std::string &name2, std::vector<std::pair<std::string, std::string> >& variables) const;

  /**
   * @brief find a sub model inside the model multi thanks to its name
   *
   * @param name name of the subModel to find
   *
   * @return the subModel if it exists
   */
  boost::shared_ptr<SubModel> findSubModelByName(const std::string& name);

  /**
   * @brief find all subModels created from a library thanks to its name
   *
   * @param libName name of the library used to create subModels
   *
   * @return vector of subModels created from the library (if there is some subModels), empty vector otherwise
   */
  std::vector<boost::shared_ptr<SubModel> > findSubModelByLib(const std::string& libName);

  /**
   * @brief check for each submodels, if each external variables is connected
   * to another variable
   *
   * @return @b true is everything is ok, @b false otherwise
   */
  bool checkConnects();

  /**
   * @copydoc Model::setWorkingDirectory()
   */
  void setWorkingDirectory(const std::string& workingDirectory);

  /**
   * @copydoc Model::printVariableNames()
   */
  void printVariableNames();

  /**
   * @copydoc Model::printEquations()
   */
  void printEquations();

  /**
   * @copydoc Model::printParameterValues() const
   */
  void printParameterValues() const;

  /**
   * @copydoc Model::printLocalInitParametersValues() const;
   */
  void printLocalInitParametersValues() const;

  /**
   * @copydoc Model::getVariableName()
   */
  std::string getVariableName(int index);

  /**
   * @copydoc Model::getCurrentZ(std::vector<double> &z)
   */
  void getCurrentZ(std::vector<double> &z);

  /**
   * @copydoc Model::setCurrentZ(const std::vector<double> &zLocal)
   */
  void setCurrentZ(const std::vector<double> &z);

 private:
  /**
   * @brief copy the new values of discretes variables to the variables connected to it
   *
   * @return true if there was at least one change in the discrete variable values
   */
  bool propagateZModif();

  /**
   * @brief connect a variable of subModel1 to a variable of subModel2
   *
   * @param subModel1 first subModel where the variable is located
   * @param name1  name of the variable to connect inside the subModel 1
   * @param subModel2 second subModel where the variable is located
   * @param name2  name of the variable to connect inside the subModel 2
   * @param forceConnection @b true if whe should ignore the flow type for continuous variable
   */
  void createConnection(boost::shared_ptr<SubModel> &subModel1, const std::string & name1, boost::shared_ptr<SubModel> &subModel2,
                        const std::string &name2, bool forceConnection = false);

  /**
   * @brief create a connection bewteen a variable and a calculated variable
   *
   * @param subModel1  first subModel where the calculated variable is located
   * @param numVar index of the calculated variable inside the subModel 1
   * @param subModel2 second  subModel where the variable is located
   * @param yNum index of the variable inside the subModel 2
   */
  void createCalculatedVariableConnection(boost::shared_ptr<SubModel> &subModel1, const int & numVar, boost::shared_ptr<SubModel> &subModel2, const int &yNum);

  /**
   * @brief struct used identify properties from a subModel found with a variable name
   */
  struct findSubModelFromVarName_t {
    boost::shared_ptr<SubModel> subModel_;  ///< The SubModel containing the variable, NULL if not found
    bool isNetwork_;  ///< true if the subModel found is the network
    bool isDynParam_;  ///< true if the variable is a dynamic parameter
    std::string variableNameInSubModel_;  ///< The accurate name of the variable in the subModel

    /**
     * @brief default constructor
     */
    findSubModelFromVarName_t() :isNetwork_(false),
            isDynParam_(false) {}
    /**
     * @brief constructor
     *
     * @param subModel  The SubModel containing the variable, NULL if not found
     * @param isNetwork true if the subModel found is the network
     * @param isDynParam true if the variable is a dynamic parameter
     * @param variableNameInSubModel The accurate name of the variable in the subModel
     */
    findSubModelFromVarName_t(boost::shared_ptr<SubModel> subModel,
        bool isNetwork, bool isDynParam, std::string variableNameInSubModel) :subModel_(subModel),
            isNetwork_(isNetwork),
            isDynParam_(isDynParam),
            variableNameInSubModel_(variableNameInSubModel){}
  };
  /**
   * @brief find the subModel which contains this variable
   *
   * @param modelName  name of the submodel
   * @param varName  name of the variable
   * @return the subModel which contains this variable or nullptr if not found
   */
  findSubModelFromVarName_t findSubModel(const std::string& modelName, const std::string& varName);

 private:
  /**
   * @brief delete all informations about the local buffers (size, buffers, etc...)
   *
   */
  void cleanBuffers();

  std::map<int, int> mapAssociationF_;  ///< association between an index of f functions and a subModel
  std::map<int, int> mapAssociationG_;  ///< association between an index of g functions and a subModel
  std::vector<std::string> yNames_;  ///< names of all variables y
  std::vector<boost::shared_ptr<SubModel> > subModels_;  ///< list of each sub models
  std::map<std::string, size_t > subModelByName_;  ///< map associating a sub model name to its index in subModels_
  boost::unordered_map<std::string, std::vector<boost::shared_ptr<SubModel> > > subModelByLib_;  ///< associates a lib and each SubModel created with it
  boost::shared_ptr<ConnectorContainer> connectorContainer_;  ///< list of each connector
  std::vector<double> zSave_;  ///< save of the last discretes values
  propertyF_t* fType_;  ///< local buffer to fill with the property of each continuous equation (Algebraic or Differential)
  propertyContinuousVar_t* yType_;  ///< local buffer to fill with the property of each variable (Algebraic / Differential / External)

  int sizeF_;  ///< number of the residuals functions
  int sizeZ_;  ///< number of discretes values
  int sizeG_;  ///< number of root functions
  int sizeMode_;  ///< number of mode
  int sizeY_;  ///< number of continuous values
  bool zChange_;  ///< @b true if one discrete value has changed
  bool modeChange_;  ///< @b true if one mode has changed
  modeChangeType_t modeChangeType_;  ///< type of mode change

  unsigned int offsetFOptional_;  ///< offset in whole F buffer for optional equations
  std::set<int> numVarsOptional_;  ///< index of optional variables

  double* fLocal_;  ///< local buffer to fill with the residual values
  state_g* gLocal_;  ///< local buffer to fill with the roots values
  double* yLocal_;  ///< local buffer to use when accessing continuous variables
  double* ypLocal_;  ///< local buffer to use when accessing derivatives of continuous variables
  double* zLocal_;  ///< local buffer to use when accessing discretes variables
};  ///< Class for Multiple-Model


}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELMULTI_H_
