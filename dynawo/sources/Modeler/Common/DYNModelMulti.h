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
#include <fstream>
#include <iostream>
#include <sstream>
#include <armadillo>
#include <eigen3/Eigen/Eigenvalues>

#include "DYNModel.h"
#include "DYNVariable.h"

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
   * @copydoc Model::evalFDiff(const double t, double* y, double* yp, double* f)
   */
  void evalFDiff(const double t, double* y, double* yp, double* f);

  /**
   * @copydoc Model::evalFMode(const double t, double* y, double* yp, double* f)
   */
  void evalFMode(const double t, double* y, double* yp, double* f);

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
   * @brief retrieve if at least one silent discrete variable has changed
   *
   *
   * @return @b true at least one silent discrete variable has changed
   */
  inline bool getSilentZChange() const {
    return silentZChange_;
  }

  /**
   * @brief enable or disable the possibility to break discrete variable propagation loop if only silent z are modified
   *
   *
   * @param enableSilentZ whether to enable or disable silent z
   */
  inline void setEnableSilentZ(bool enableSilentZ) {
    enableSilentZ_ = enableSilentZ;
  }

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

  // ===============================================================================================================================//
  //                                                     FUNCTIONS FOR MODAL ANALYSIS
  // ===============================================================================================================================//
  /**
   * @copydoc Model::evalLinearise() const
   */
  void evalLinearise(const double t);
  /**
   * @copydoc Model::subParticipation() const
   */
  void subParticipation(const double t, int nbrMode);
  /**
   * @copydoc Model::allModes() const
   */
  void allModes(const double t);
  /**
   * @copydoc Model::evalmodalAnalysis() const
   */
  void evalmodalAnalysis(const double t, const double partFactor);

  // fonction to creat an integer vector of Eigenlib type from a given file
  Eigen::VectorXi createEigenVectorXi(int & n, Eigen::VectorXi &v, std::string fileName);

  // fonction to creat a double matrix of EigenLib type from a given file
  Eigen::MatrixXd createEigenMatrixXd(int & nrs, std::string fileName);

  // function to dump a double Eigenlib matrix
  void writeToFile(Eigen::MatrixXd x, std::string fileName);

  // function to dump a double complex Eigenlib matrix
  void writeToFileComplex(Eigen::MatrixXcd x, std::string fileName);

  // function to return the differential state associated to selected modes
  std::vector<std::string> getStateMode(std::vector<std::string> &varDiff, std::vector<int> &indexS);

  // function to return the damping vector of a given modes
  std::vector<float> computeDamping(std::vector<double> &realPart, std::vector<double> &imagPart);

  // function to return the frequency vector of a given modes
  std::vector<float> computeFrequency(std::vector<double> &imagPart);

  // function to return the values associated to a given indices
  std::vector<float> getValueIndex(Eigen::MatrixXd &mat, std::vector<double> &indModes,
std::vector<double> &indexPartMax, unsigned int n);

  // function to return the type of given modes
  std::string getModeType(std::string inLine, std::vector<std::string> &strVector);

  // funtion to dump the stables modes
  void printToFileStableModes(std::string fileName, std::vector<std::string> &states, std::vector<std::string> &strVec,
std::vector<double> &vr, std::vector<double> &vi, std::vector<float> &freq, std::vector<float> &damp, std::vector<float> &phas,
std::vector<float> &part, std::vector<double> &ivi, std::vector<double> &unsvi, std::vector<double> &iR,
std::vector<std::string> &namesMachines);

  // funtion to dump the unstables modes
  void printToFileUnstableModes(std::string fileName, std::vector<std::string> &states, std::vector<std::string> &strVec, std::vector<double> &vr,
std::vector<double> &vi, std::vector<float> &freq, std::vector<float> &damp, std::vector<float> &phas,
std::vector<float> &part, std::vector<double> &ivi, std::vector<std::string> &namesMachines);

  // funtion to dump the real modes
  void printToFileRealModes(std::string fileName, std::vector<std::string> &states, std::vector<std::string> &strVec, std::vector<double> &vr,
std::vector<float> &part, std::vector<double> &ir, std::vector<std::string> &namesMachines);

  // funtion to return the index position of maximum value of each column of a given matrix
  std::vector<double> getIndexPositionMax(Eigen::MatrixXd &mat);

  // funtion to return the index position of a string in a given file
  std::vector<int> getIndexPositionString(std::vector<std::string> &varCombined, std::string in_out);

  // function to eliminate the redundancy in a given vector of integer
  void uniqueVector(std::vector <int> & v);

  // function to extrat an integer from a given string
  std::string extractIntegerWords(std::string str);

  // function to return an Eigenlib matrix of phase position of all modes
  Eigen::MatrixXd createEigenArgMatrix(Eigen::MatrixXcd &mat);

  // function to convert a double array of Eigenlib type to std double vector
  std::vector<double> convertEigenArrayToStdVector(Eigen::ArrayXd &v1);

  // function to convert a double array of Eigenlib type to std double vector
  std::vector<std::complex<double> > convertEigenArrayCToStdVector(Eigen::ArrayXcd &v1);
  // function to return the names of participating machines
  std::vector<std::string> nameMachine(std::vector<int> &indexVect);

  // function to return the index positons of differential  (var = 1) / algebraic (var = 2) equations
  std::vector<int> getIndexEquation(int var);

  // function to return the names of dynamic devices
  std::string getVariableNameDevices(int index);

  // function to return the index positions of differential (var = 1) / algebraic (var = 2) variables
  std::vector<int> getIndexVariable(int var);

  // function to return the names of dynamic devices associated to differential/algebraic variables according the value of variable var
  // var = 1: returns the names of devices associated to differential variables,
  // var = 2: returns the names of devices associated to algebraic variables
  std::vector<std::string> getNameDynamicDevices(int var);

  // Function that returns the index positions of most participation states of each dynamic device involved in a given mode
  std::vector<int> getIndexMostCoupledDevices(std::vector<std::string> &statesofCoupledDevices, std::vector<int> &indexSelecPart,
std::vector<std::string> &namesD);

  // dump the coupled devices of stable and unstable complex modes
  void printToFileCoupledDevices(std::string fileName, std::vector<double> &irealPartImag_, Eigen::MatrixXd &matRelativeRealParticipation,
Eigen::MatrixXd &phaseMatrix, Eigen::VectorXcd &eigenValComplex, std::vector<std::string> &strVec, const double partFactor);

  // return the names of differential/algebraic variables
  std::vector<std::string> getNameVariable(int var);

  //  function that returns the index positions according the type of state: ROT; SMD, SMQ, INJ, OTH, ....
  //  var = 1: returns the indices of ROT, 2 of SMD, 3 of SMQ, default: INJ et OTH
  std::vector<int> getIndexTypeState(std::vector<std::string> &statesDiff, std::string type, int var);

  // function to return the sub participation factors of a given mode
  double getSubPart(int &nbMode, std::vector<int> &indexState, Eigen::MatrixXd &part);

  // function to return the index positions of non-zero elements in a given vector (For example vector of imag parts)
  std::vector<double> getIndexImagPart(std::vector<double> &imagPart, std::vector<double> &allImagPart);

  //  Function that returns the non-zero Imaginary parts, the purely real parts, and the indices of purely real parts
  //  1 : Imaginary parts, 2: Real Parts, 3: Indices of purely real parts
  std::vector<double> getImagRealIndexPart(Eigen::ArrayXd &imagEigen, Eigen::ArrayXd &realEigen, int var);
  //  Function that returns the stable real parts associated to the imaginary parts that are different to zero,
  //  the index position of stable real parts associated to the imaginary parts that are different ot zero,
  //  the unstable real parts associated to the imaginary parts that are different to zero and the index
  //  positions of unstable real parts.
  std::vector<double> getStableUnstableIndexofModes(std::vector<double> &iImagPartNotZero, Eigen::ArrayXd &realEigen,
std::vector<double> &imaginaryPartNotZero, int var);

  // function to return the index positions of state associated at the most important participation of a given mode (stable, real, unstable)
  std::vector<int> getIndexState(std::vector<double> &indexMaxPart, std::vector<double> &indexUSPart);

  //  function to construct a submatrix from another matrix
  Eigen::MatrixXd contructSubMatrix(Eigen::MatrixXd &x, int nr, int nc, std::vector<int> &index1, std::vector<int> &index2);

  // function to return the state matrix A
  Eigen::MatrixXd getMatrixA(const double t);

  // function to return the input matrix B
  Eigen::MatrixXd getMatrixB(const double t);

  // function to return the output matrix C
  Eigen::MatrixXd getMatrixC();

  // function to return the output matrix RSA
  Eigen::MatrixXd getMatrixRSM(const double t);

  // function to return the index associated to rotational states of a given mode
  std::vector<int> getIndexRot();

  // function to return the indices associated to SMD states of a given mode
  std::vector<int> getIndexSMD();

  // function to return the indices associated to SMQ states of a given mode
  std::vector<int> getIndexSMQ();

  // function to return the indices associated to OTH (other) states of a given mode
  std::vector<int> getIndexOTH();

  // function to return the indices associated to Injector states of a given mode
  std::vector<int> getIndexINJ();

  // function to return the indices associated to Governor states of a given mode
  std::vector<int> getIndexGOV();

  // function to return the indices associated to Avr states of a given mode
  std::vector<int> getIndexAVR();

  // funtion to dump the subparticipation factors associated to a given mode
  void printSubParticipation(int nbrMode, Eigen::MatrixXd &A, Eigen::VectorXcd &eigenComp);

  // function to dump an std vector
  void writeToFileStd(std::vector<int> x, std::string fileName);

  // function to dump an std vector

  void writeToFileComplexStd(std::vector<std::complex<double> > x, std::string fileName);
  // function to dump a string vector
  void writeToFileString(std::vector<std::string> x, std::string fileName);

  // function that returns the name of machines of a given power system without redundancy
  std::vector<std::string> nameMachineDiff();

  // function that returns the name of machines of a given power system with redundancy
  std::vector<std::string> nameDynamicDevicesDiff();

  std::vector<int> getRelevantIndex(std::vector<int> coupledClass);

  Eigen::MatrixXd contructReducedMatrix(const double t, std::vector<int> coupledClass);

  std::vector<int> getLessRelevantIndex(std::vector<int> coupledClass);
  // Function get the sub matrix of A
  Eigen::MatrixXd getSubMatrix(Eigen::MatrixXd A, std::vector<int> indexi, std::vector<int> indexj);

  void largeScaleModalAnalysis(const double t);

  Eigen::MatrixXcd contructMMatrix(const double t, std::vector<int> coupledClass);

  double getCond(Eigen::MatrixXcd Acond);

  // fonction assures the conversion of eigen matrix to armadillo matrix
  arma::mat example_cast_arma(Eigen::MatrixXd eigen_A);
  // ==================================================================================================================== //
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
   * @copydoc Model::printModel() const
   */
  void printModel() const;

  /**
   * @copydoc Model::printInitValues(const std::string & directory)
   */
  void printInitValues(const std::string & directory);

  /**
   * @copydoc Model::evalCalculatedVariables(const double & t, const std::vector<double> &y, const std::vector<double> &yp,const std::vector<double> &z)
   */
  void evalCalculatedVariables(const double & t, const std::vector<double> &y, const std::vector<double> &yp, const std::vector<double> &z);

  /**
   * @copydoc Model::updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection)
   */
  void updateCalculatedVarForCurves(boost::shared_ptr<curves::CurvesCollection> curvesCollection);

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
  bool initCurves(boost::shared_ptr<curves::Curve>& curve);

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
   * @param variable1 calculated variable of the subModel 1
   * @param subModel2 second  subModel where the variable is located
   * @param variable2 variable of the subModel 2
   */
  void createCalculatedVariableConnection(boost::shared_ptr<SubModel> &subModel1, const boost::shared_ptr<Variable>& variable1,
      boost::shared_ptr<SubModel> &subModel2, const boost::shared_ptr<Variable>& variable2);

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

  /**
   * @brief set the silent flag for discrete variables
   */
  void collectSilentZ();

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
  propertyF_t* fType_;  ///< local buffer to fill with the property of each continuous equation (Algebraic or Differential)
  propertyContinuousVar_t* yType_;  ///< local buffer to fill with the property of each variable (Algebraic / Differential / External)
  std::ofstream outputFile;
  std::vector<std::string> _yNames;  ///< names of all variables y

  int sizeF_;  ///< number of the residuals functions
  int sizeZ_;  ///< number of discretes values
  int sizeG_;  ///< number of root functions
  int sizeMode_;  ///< number of mode
  int sizeY_;  ///< number of continuous values
  bool zChange_;  ///< @b true if at least one non-silent discrete value has changed
  bool silentZChange_;  ///< @b true if at least one silent discrete value has changed
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
  bool* silentZ_;  ///< local buffer indicating if the corresponding discrete variable is used only in residual equations
  bool enableSilentZ_;  ///< enable or disable the use of silentZ in the discrete variable propagation loop
  std::vector<size_t> silentZIndexes_;  ///< indexes of silent discrete variables
  std::vector<size_t> nonSilentZIndexes_;  ///< indexes of non silent discrete variables
};  ///< Class for Multiple-Model


}  // namespace DYN

#endif  // MODELER_COMMON_DYNMODELMULTI_H_
