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
#include "DYNVariable.h"
#include "DYNBitMask.h"

namespace DYN {
class SubModel;
class ConnectorContainer;

/**
 * @brief Model carrying multiple models
 */
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
   * @copydoc Model::evalF(const double t, const double* y, const double* yp, double* f)
   */
  void evalF(const double t, const double* y, const double* yp, double* f);

  /**
   * @copydoc Model::evalFDiff(const double t, const double* y, const double* yp, double* f)
   */
  void evalFDiff(const double t, const double* y, const double* yp, double* f);

  /**
   * @copydoc Model::evalFMode(const double t, const double* y, const double* yp, double* f)
   */
  void evalFMode(const double t, const double* y, const double* yp, double* f);

  /**
   * @copydoc Model::copyContinuousVariables(const double* y, const double* yp)
   */
  void copyContinuousVariables(const double* y, const double* yp);

  /**
   * @copydoc Model::copyDiscreteVariables(const double* z)
   */
  void copyDiscreteVariables(const double* z);

  /**
   * @copydoc Model::evalG(double t, std::vector<state_g> &g)
   */
  void evalG(double t, std::vector<state_g>& g);

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
   * @copydoc Model::checkDataCoherence(const double t)
   */
  void checkDataCoherence(const double t);

  /**
   * @copydoc Model::checkParametersCoherence() const
   */
  void checkParametersCoherence() const;

  /**
   * @copydoc Model::setFequationsModel()
   */
  void setFequationsModel();

  /**
   * @copydoc Model::setGequationsModel()
   */
  void setGequationsModel();

  /**
   * @copydoc Model::getY0(const double t0, std::vector<double>& y0, std::vector<double>& yp0)
   */
  void getY0(const double t0, std::vector<double>& y0, std::vector<double>& yp0);

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
   * @copydoc Model::notifyTimeStep()
   */
  void notifyTimeStep();

  /**
   * @brief retrieve if at least one non-silent discrete variable has changed
   *
   *
   * @return @b true if at least one non-silent discrete variable has changed
   */
  bool zChange() const;

  /**
   * @brief get the type of z that were modified
   * @return type of z that were modified
   */
  inline zChangeType_t getSilentZChangeType() const {
    return silentZChange_;
  }

  /**
   * @copydoc Model::initSilentZ(bool enableSilentZ)
   */
  void initSilentZ(bool enableSilentZ);

  /**
   * @copydoc Model::getFType() const
   */
  inline const std::vector<propertyF_t>& getFType() const {
    return fType_;
  }

  /**
   * @copydoc Model::evalStaticFType()
   */
  void evalStaticFType();

  /**
   * @copydoc Model::evalDynamicFType()
   */
  void evalDynamicFType();

  /**
   * @copydoc Model::getYType()
   */
  inline const std::vector<propertyContinuousVar_t>& getYType() const {
    return yType_;
  }

  /**
   * @copydoc Model::evalStaticYType()
   */
  void evalStaticYType();

  /**
   * @copydoc Model::evalStaticYType()
   */
  void evalDynamicYType();

  /**
   * @copydoc Model::setIsInitProcess(bool isInitProcess)
   */
  void setIsInitProcess(bool isInitProcess);

  /**
   * @copydoc Model::setInitialTime(const double t0)
   */
  void setInitialTime(const double t0);

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
   * @brief get informations about residual functions
   *
   * @param globalFIndex global index of the residual functions to find
   * @param subModelName name of the subModel who contains the residual functions
   * @param localFIndex local index of the residual functions inside the subModel
   * @param fEquation equation formula related to local index
   */
  void getFInfos(const int globalFIndex, std::string& subModelName, int& localFIndex, std::string& fEquation) const;

  /**
   * @brief get informations about root functions
   *
   * @param globalGIndex global index of the root functions to find
   * @param subModelName name of the subModel who contains the root functions
   * @param localGIndex local index of the root functions inside the subModel
   * @param gEquation equation formula related to local index
   */
  void getGInfos(const int globalGIndex, std::string& subModelName, int& localGIndex, std::string& gEquation) const;

  // ==============================
  // interface SIMULATION <-> MODEL
  // ==============================

  /**
   * @brief initialize the model
   *
   * @param t0 time to use to initialize the model
   */
  void init(const double t0);

  /**
   * @copydoc Model::initBuffers()
   */
  void initBuffers();

  /**
   * @copydoc Model::printModel() const
   */
  void printModel() const;

  /**
   * @copydoc Model::printModelValues(const std::string & directory, const std::string& dumpFileName)
   */
  void printModelValues(const std::string& directory, const std::string& dumpFileName);

  /**
   * @copydoc Model::evalCalculatedVariables(const double t, const std::vector<double>& y, const std::vector<double>& yp,const std::vector<double>& z)
   */
  void evalCalculatedVariables(const double t, const std::vector<double>& y, const std::vector<double>& yp, const std::vector<double>& z);

  /**
  * @brief update the subset of calculated variables needed for curves
  *
  * @param curvesCollection set of curves
  */
  void updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection>& curvesCollection) const;

  /**
   * @copydoc Model::dumpParameters(std::map< std::string, std::string> & mapParameters)
   */
  void dumpParameters(std::map< std::string, std::string>& mapParameters);

  /**
   * @copydoc Model::getModelParameterValue(const std::string & curveModelName, const std::string & curveVariable, double & value, bool & found)
   */
  void getModelParameterValue(const std::string& curveModelName, const std::string& curveVariable, double& value, bool& found);

  /**
   * @copydoc Model::loadParameters(const std::map< std::string, std::string> & mapParameters)
   */
  void loadParameters(const std::map< std::string, std::string>& mapParameters);

  /**
   * @copydoc Model::dumpVariables(std::map< std::string, std::string> & mapVariables)
   */
  void dumpVariables(std::map< std::string, std::string>& mapVariables);

  /**
   * @copydoc Model::loadVariables(const std::map< std::string, std::string> & mapVariables)
   */
  void loadVariables(const std::map< std::string, std::string>& mapVariables);

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
  bool initCurves(boost::shared_ptr<curves::Curve>& curve);

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
  void connectElements(const boost::shared_ptr<SubModel>& subModel1, const std::string& name1, const boost::shared_ptr<SubModel>& subModel2,
                       const std::string& name2);
  /**

   * @brief seek all variables that are connected by a connection
   *
   * @param subModel1 first subModel where the variable is located
   * @param name1 name of the variable to connect inside the subModel 1
   * @param subModel2 second subModel where the variable is located
   * @param name2 name of the variable to connect inside the subModel 2
   * @param variables outputs: after the call contains all couples variable1->variable2 connected by this connection
   */
  void findVariablesConnectedBy(const boost::shared_ptr<SubModel>& subModel1, const std::string& name1,
      const boost::shared_ptr<SubModel>& subModel2, const std::string& name2, std::vector<std::pair<std::string, std::string> >& variables) const;

  /**
   * @brief find a sub model inside the model multi thanks to its name
   *
   * @param name name of the subModel to find
   *
   * @return the subModel if it exists
   */
  boost::shared_ptr<SubModel> findSubModelByName(const std::string& name) const;

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
  * @brief Copy the discrete variable values from the model data structure to the solver data structure
  *
  * @param z vector of discrete values from the solver data structure
  */
  void getCurrentZ(std::vector<double>& z) const;

  /**
   * @copydoc Model::setCurrentZ(const std::vector<double>& z)
   */
  void setCurrentZ(const std::vector<double>& z);

  /**
   * @brief set local initialization solver parameters
   *
   * @param localInitParameters local initialization solver parameters
   */
  void setLocalInitParameters(boost::shared_ptr<parameters::ParametersSet> localInitParameters);

 private:
  /**
   * @brief create a submodel for a calculated variable when connecting a state and a calculated variables
   *
   * @tparam T a type of connector (CONTINUOUS <-> CONTINUOUS / DISCRETE <-> DISCRETE)
   * @param connectorSubModel type of connector
   * @param name name of the submodel created
   * @param subModel submodel owning the calculated variable to connect
   * @param variable the calculated variable to connect
   * @return a submodel for the calculated variable
   */
  template<class T>
  boost::shared_ptr<SubModel>
  setConnector(T connectorSubModel, const std::string& name,
             const boost::shared_ptr<SubModel>& subModel, const boost::shared_ptr<Variable>& variable) {
    connectorSubModel->name(name);
    connectorSubModel->setVariableName(variable->getName());
    connectorSubModel->setParams(subModel, variable->getIndex());
    return boost::dynamic_pointer_cast<SubModel>(connectorSubModel);
  }

  /**
   * @brief copy the new values of discretes variables to the variables connected to it
   *
   * @return the type of discrete variable that has changed
   */
  zChangeType_t propagateZModif();

  /**
   * @brief connect a variable of subModel1 to a variable of subModel2
   *
   * @param subModel1 first subModel where the variable is located
   * @param name1  name of the variable to connect inside the subModel 1
   * @param subModel2 second subModel where the variable is located
   * @param name2  name of the variable to connect inside the subModel 2
   * @param forceConnection @b true if we should ignore the flow type for continuous variable
   * @param throwIfCalculatedVarConn @b true if we should throw if two calculated variables are connected together
   */
  void createConnection(const boost::shared_ptr<SubModel>& subModel1, const std::string& name1, const boost::shared_ptr<SubModel>& subModel2,
                        const std::string& name2, bool forceConnection = false, bool throwIfCalculatedVarConn = true);

  /**
   * @brief create a connection bewteen a variable and a calculated variable
   *
   * @param subModel1  first subModel where the calculated variable is located
   * @param variable1 calculated variable of the subModel 1
   * @param subModel2 second  subModel where the variable is located
   * @param variable2 variable of the subModel 2
   */
  void createCalculatedVariableConnection(const boost::shared_ptr<SubModel>& subModel1, const boost::shared_ptr<Variable>& variable1,
      const boost::shared_ptr<SubModel>& subModel2, const boost::shared_ptr<Variable>& variable2);

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
    findSubModelFromVarName_t(boost::shared_ptr<SubModel>& subModel,
        bool isNetwork, bool isDynParam, std::string variableNameInSubModel) : subModel_(subModel),
            isNetwork_(isNetwork),
            isDynParam_(isDynParam),
            variableNameInSubModel_(variableNameInSubModel) {}
  };
  /**
   * @brief find the subModel which contains this variable
   *
   * @param modelName  name of the submodel
   * @param varName  name of the variable
   * @return the subModel which contains this variable or nullptr if not found
   */
  findSubModelFromVarName_t findSubModel(const std::string& modelName, const std::string& varName) const;

  /**
   * @brief set the silent flag for discrete variables
   */
  void collectSilentZ();

  /**
   * @copydoc Model::printToFile()
   */
  void printToFile(const std::string& suffix = "", bool printY = true, bool printYp = true, bool printZ = true);

  /**
   * @copydoc Model::printToFileVector()
   */
  void printVectorToFile(const std::string& folderName, const std::string& fileNamePrefix, double* vector, int vectorSize, int numPrint);

 private:
  /**
   * @brief delete all informations about the local buffers (size, buffers, etc...)
   *
   */
  void cleanBuffers();

  boost::unordered_map<int, int> mapAssociationF_;  ///< association between an index of f functions and a subModel
  boost::unordered_map<int, int> mapAssociationG_;  ///< association between an index of g functions and a subModel
  std::vector<std::string> yNames_;  ///< names of all variables y
  std::vector<boost::shared_ptr<SubModel> > subModels_;  ///< list of each sub models
  boost::unordered_map<std::string, size_t > subModelByName_;  ///< map associating a sub model name to its index in subModels_
  boost::unordered_map<std::string, std::vector<boost::shared_ptr<SubModel> > > subModelByLib_;  ///< associates a lib and each SubModel created with it
  boost::unordered_map<size_t, std::vector<size_t > >
    subModelIdxToConnectorCalcVarsIdx_;  ///< associates a subModel index to the associated calculated variables connectors indexes
  boost::shared_ptr<ConnectorContainer> connectorContainer_;  ///< list of each connector
  std::vector<double> zSave_;  ///< save of the last discretes values
  std::vector<propertyF_t> fType_;  ///< local buffer to fill with the property of each continuous equation (Algebraic or Differential)
  std::vector<propertyContinuousVar_t> yType_;  ///< local buffer to fill with the property of each variable (Algebraic / Differential / External)

  int sizeF_;  ///< number of the residuals functions
  int sizeZ_;  ///< number of discretes values
  int sizeG_;  ///< number of root functions
  int sizeMode_;  ///< number of mode
  int sizeY_;  ///< number of continuous values
  zChangeType_t silentZChange_;  ///< @b indicates which types of silent Z has changed
  bool modeChange_;  ///< @b true if one mode has changed
  modeChangeType_t modeChangeType_;  ///< type of mode change

  unsigned int offsetFOptional_;  ///< offset in whole F buffer for optional equations
  std::set<int> numVarsOptional_;  ///< index of optional variables

  double* fLocal_;  ///< local buffer to fill with the residual values
  state_g* gLocal_;  ///< local buffer to fill with the roots values
  double* yLocal_;  ///< local buffer to use when accessing continuous variables
  double* ypLocal_;  ///< local buffer to use when accessing derivatives of continuous variables
  double* zLocal_;  ///< local buffer to use when accessing discretes variables
  bool* zConnectedLocal_;  ///< local buffer to use when accessing discretes variables connection status
  BitMask* silentZ_;  ///< local buffer indicating if the corresponding discrete variable is silent
  bool silentZInitialized_;  ///< true if silentZ were collected
  std::vector<size_t> notUsedInDiscreteEqSilentZIndexes_;  ///< indexes of silent discrete variables not used in discrete equations
  std::vector<size_t> notUsedInContinuousEqSilentZIndexes_;  ///< indexes of silent discrete variables not used in continuous equations
  std::vector<size_t> nonSilentZIndexes_;  ///< indexes of non silent discrete variables

  boost::shared_ptr<parameters::ParametersSet> localInitParameters_;  ///< local initialization solver parameters set
};  ///< Class for Multiple-Model


}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELMULTI_H_
