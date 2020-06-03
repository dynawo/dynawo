//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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


#include "gtest_dynawo.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "DYNModelModelica.h"
#include "DYNModelManager.h"
#include "DYNSparseMatrix.h"
#include "DYNVariableAliasFactory.h"
#include "DYNVariableAlias.h"
#include "DYNVariableNativeFactory.h"
#include "DYNVariableNative.h"
#include "DYNVariable.h"
#include "DYNExecUtils.h"

namespace DYN {

class MyModelica: public ModelModelica {
 public:
  explicit MyModelica(ModelManager* parent):
    parent_(parent),
    nbCallF_(0),
    nbCallCheckDataCoherence_(0),
    nbCallG_(0),
    nbCallZ_(0),
    nbCallCalcVars_(0),
    nbCallY0_(0),
    nbCallFType_(0),
    nbCallYType_(0) { }

  /**
   * @brief default destructor
   */
  virtual ~MyModelica() { }

 public:
  /**
   * @brief initialise the dyn data structure
   *
   * @param data dyn data to initialize
   */
  virtual void initData(DYNDATA* data) {
    data->nbF = 2;
    data->nbCalculatedVars = 1;
    data->nbModes = 1;
    data->nbVars = 2;
    data->nbZ = 1;
    data->modelData = reinterpret_cast<MODEL_DATA *>(calloc(1, sizeof(MODEL_DATA)));
    data->simulationInfo = reinterpret_cast<SIMULATION_INFO *>(calloc(1, sizeof(SIMULATION_INFO)));
    data->simulationInfo->daeModeData = reinterpret_cast<DAEMODE_DATA *>(calloc(1, sizeof(DAEMODE_DATA)));
    data->localData = reinterpret_cast<SIMULATION_DATA **>(calloc(1, sizeof(SIMULATION_DATA*)));
    data->localData[0] = reinterpret_cast<SIMULATION_DATA *>(calloc(1, sizeof(SIMULATION_DATA)));
    data->modelData->nParametersReal = 1;
    data->modelData->nParametersInteger = 1;
    data->modelData->nParametersBoolean = 0;
    data->modelData->nParametersString = 0;
    data->modelData->nDiscreteReal = 0;
    data->modelData->nVariablesReal = 2;
    data->modelData->nVariablesInteger = 0;
    data->modelData->nVariablesBoolean = 0;
    data->modelData->nVariablesString = 0;
    data->modelData->nAliasReal = 1;
    data->modelData->nAliasInteger = 0;
    data->modelData->nAliasBoolean = 0;
    data->modelData->nAliasString = 0;
    // buffer for all parameters values
    int nb = (data->modelData->nParametersReal > 0) ? data->modelData->nParametersReal : 0;
    data->simulationInfo->realParameter = reinterpret_cast<modelica_real *>(calloc(nb, sizeof(modelica_real)));

    nb = (data->modelData->nParametersBoolean > 0) ? data->modelData->nParametersBoolean : 0;
    data->simulationInfo->booleanParameter = reinterpret_cast<modelica_boolean *>(calloc(nb, sizeof(modelica_boolean)));

    nb = (data->modelData->nParametersInteger > 0) ? data->modelData->nParametersInteger : 0;
    data->simulationInfo->integerParameter = reinterpret_cast<modelica_integer *>(calloc(nb, sizeof(modelica_integer)));

    nb = (data->modelData->nParametersString > 0) ? data->modelData->nParametersString : 0;
    data->simulationInfo->stringParameter = reinterpret_cast<modelica_string *>(calloc(nb, sizeof(modelica_string)));

    nb = (data->modelData->nVariablesReal > 0) ? data->modelData->nVariablesReal : 0;
    data->simulationInfo->realVarsPre = reinterpret_cast<modelica_real *>(calloc(nb, sizeof(modelica_real)));

    nb = (data->modelData->nStates > 0) ? data->modelData->nStates  : 0;
    data->simulationInfo->derivativesVarsPre = reinterpret_cast<modelica_real *>(calloc(nb, sizeof(modelica_real)));

    nb = (data->modelData->nDiscreteReal >0) ? data->modelData->nDiscreteReal : 0;
    data->simulationInfo->discreteVarsPre = reinterpret_cast<modelica_real *>(calloc(nb, sizeof(modelica_real)));

    nb = (data->modelData->nVariablesBoolean > 0) ? data->modelData->nVariablesBoolean : 0;
    data->localData[0]->booleanVars = reinterpret_cast<modelica_boolean *>(calloc(nb, sizeof(modelica_boolean)));
    data->simulationInfo->booleanVarsPre = reinterpret_cast<modelica_boolean *>(calloc(nb, sizeof(modelica_boolean)));

    nb = (data->modelData->nVariablesInteger > 0) ? data->modelData->nVariablesInteger : 0;
    data->simulationInfo->integerDoubleVarsPre = reinterpret_cast<modelica_real *>(calloc(nb, sizeof(modelica_real)));

    nb = (data->modelData->nExtObjs > 0) ? data->modelData->nExtObjs : 0;
    data->simulationInfo->extObjs = reinterpret_cast<void**>(calloc(nb, sizeof(void*)));
  }

  /**
   * @brief initialize the parameters of the model
   *
   */
  void initRpar() {}

  /**
   * @brief calculates the residual functions of the model
   *
   * @param f local buffer to fill
   */
  virtual void setFomc(double* /*f*/, propertyF_t /*type*/) {
    ++nbCallF_;
  }

  unsigned getNbCallF() const {
    return nbCallF_;
  }

  /**
   * @brief  calculates the roots of the model
   *
   * @param g local buffer to fill
   */
  void setGomc(state_g* /*g*/) {
    ++nbCallG_;
  }

  unsigned getNbCallG() const {
    return nbCallG_;
  }

  /**
   * @brief check whether a mode has been triggered
   *
   * @param t the time for which to check
   * @return @b true if a mode has been trigered, @b false otherwise (for use by ModelManager)
   */
  modeChangeType_t evalMode(const double & /*t*/) const {
    return DIFFERENTIAL_MODE;
  }

  /**
   * @brief calculates the discretes values of the model
   *
   */
  virtual void setZomc() {
    ++nbCallZ_;
  }

  unsigned getNbCallZ() const {
    return nbCallZ_;
  }

  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(bool* /*silentZTable*/) { }

  /**
   * @brief calculates the initial values (discretes and continuous) of the model
   *
   */
  void setY0omc() {
    ++nbCallY0_;
  }

  unsigned getNbCallY0() const {
    return nbCallY0_;
  }

  /**
   * @brief set the values of the parameters of the model
   *
   * @param params set of parameters where to read the values of the model's parameters
   */
  void setParameters(boost::shared_ptr<parameters::ParametersSet> /*params*/) {}

  /**
   * @brief defines the variables of the model
   *
   * @param variables vector to fill
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(DYN::VariableNativeFactory::createState("MyVariable", DISCRETE, false));
    variables.push_back(DYN::VariableNativeFactory::createState("MyVariable2", CONTINUOUS, false));
    variables.push_back(DYN::VariableNativeFactory::createState("MyVariable3", CONTINUOUS, false));
    variables.push_back(DYN::VariableNativeFactory::createCalculated("MyVariable4", CONTINUOUS, false));
    variables.push_back(DYN::VariableAliasFactory::create("MyAliasVariable", "MyVariable2", FLOW, false));
  }

  /**
   * @brief defines the parameters of the model
   *
   * @param parameters vector to fill
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) {
    parameters.push_back(ParameterModeler("MyParam2", VAR_TYPE_DOUBLE, INTERNAL_PARAMETER));
    parameters.push_back(ParameterModeler("MyParam", VAR_TYPE_INT, INTERNAL_PARAMETER));
  }


  /**
   * @brief defines the checkSum of the model (in order to check whether it was modified)
   *
   * @param checkSum value of the checkSum
   */
  void checkSum(std::string & /*checkSum*/) {}

#ifdef _ADEPT_
  /**
   * @brief compute the F function based on the ADEPT library
   *
   * @param y values of the continuous variable
   * @param yp values of the derivatives of the continuous variable
   * @param F computes values of the residual functions
   */
  virtual void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &res) {
    ASSERT_EQ(y.size(), 2);
    ASSERT_EQ(yp.size(), 2);
    ASSERT_EQ(res.size(), 2);
    res[0] = 2*y[0]+yp[1];
    res[1] = 0.5*y[1]-yp[0];
  }
#endif

  /**
   * @brief ensure data coherence (asserts, min/max, sanity checks...)
   *
   */
  void checkDataCoherence() {
    ++nbCallCheckDataCoherence_;
  }

  void checkParametersCoherence() const {
    // Dummy class used for testing
  }

  unsigned getNbCallCheckDataCoherence() const {
    return nbCallCheckDataCoherence_;
  }

  /**
   * @brief set formula for modelica model's equation
   * @param fEquationIndex map of equation's formula by idnex as it key
   */
  void setFequations(std::map<int, std::string>& fEquationIndex) {
    fEquationIndex[0] = "MyFEq";
  }

  /**
   * @brief set formula for modelica model's root equation
   * @param gEquationIndex map of root equation's formula by idnex as it key
   */
  void setGequations(std::map<int, std::string>& gEquationIndex) {
    gEquationIndex[0] = "MyGEq";
  }

  /**
   * @brief defines the model type of the model
   *
   * @param modelType model type to set
   */
  void setModelType(std::string /*modelType*/) {}

  /**
   * @brief get the current model manager used
   *
   * @return the current model manager used
   */
  ModelManager* getModelManager() const {
    return parent_;
  }

  /**
   * @brief set the current model manager used
   *
   * @param model current model manager used
   */
  void setModelManager(ModelManager* /*model*/) {}

  /**
   * @brief defines the property of each continuous variables
   *
   * @param yType local buffer to fill
   */
  void setYType_omc(propertyContinuousVar_t* /*yType*/) {
    ++nbCallYType_;
  }

  unsigned getNbCallYType() const {
    return nbCallYType_;
  }

  /**
   * @brief defines the property of each residual function
   *
   * @param fType local buffer to fill
   */
  void setFType_omc(propertyF_t* /*fType*/) {
    ++nbCallFType_;
  }

  unsigned getNbCallFType() const {
    return nbCallFType_;
  }

  /**
   * @brief define the elements of the model
   *
   * @param elements vector of each elements contains in the model
   * @param mapElement map associating an element and the index of the elements contains in it
   */
  void defineElements(std::vector<Element> &/*elements*/, std::map<std::string, int>& /*mapElement*/) {}

  /**
   * @brief set shared parameters default values
   *
   * @return a parameters set filled with default values
   */
  boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues() {
    boost::shared_ptr<parameters::ParametersSet> parametersSet = parameters::ParametersSetFactory::newInstance("SharedModelicaParameters");
    parametersSet->createParameter("MyParam", 2);
    parametersSet->createParameter("MyParam2", 1.);
    return parametersSet;
  }

  /**
   * @brief compute the value of calculated variables
   *
   * @param calculatedVars calculated variables vector
   */
  void evalCalculatedVars(std::vector<double>& /*calculatedVars*/) {
    ++nbCallCalcVars_;
  }

  unsigned getNbCallCalcVars() const {
    return nbCallCalcVars_;
  }
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param y values of the variables used to calculate the variable
   * @param yp values of the derivatives used to calculate the variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned /*iCalculatedVar*/) const {
    return 10.;
  }

#ifdef _ADEPT_
  /**
   * @brief evaluate the value of a calculated variable with ADEPT library
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable
   */
  adept::adouble evalCalculatedVarIAdept(unsigned /*iCalculatedVar*/, unsigned /*indexOffset*/,
      const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &/*yp*/) const {
    return 2*y[0];
  }
#endif

  /**
   * @brief get the index of variables used to define the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return index of variables used to define the jacobian
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned /*iCalculatedVar*/, std::vector<int>& indexes) const {
    indexes.push_back(0);
    indexes.push_back(1);
  }

 private:
  ModelManager* parent_;
  unsigned nbCallF_;
  unsigned nbCallG_;
  unsigned nbCallZ_;
  unsigned nbCallCalcVars_;
  unsigned nbCallY0_;
  unsigned nbCallFType_;
  unsigned nbCallYType_;
  unsigned nbCallCheckDataCoherence_;
};



class MyModelicaInit: public MyModelica {
 public:
  explicit MyModelicaInit(ModelManager* parent):
    MyModelica(parent),
    data_(NULL) { }

  /**
   * @brief default destructor
   */
  virtual ~MyModelicaInit() { }

  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) {
    variables.push_back(DYN::VariableNativeFactory::createState("MyParam2", CONTINUOUS, false));
    variables.push_back(DYN::VariableNativeFactory::createState("MyParam", INTEGER, false));
  }

  void defineParameters(std::vector<ParameterModeler>& /*parameters*/) {
  }

  void setFomc(double* f, propertyF_t /*type*/) {
    f[0] = data_->localData[0]->realVars[0] - 8;
  }

#ifdef _ADEPT_
  /**
   * @brief compute the F function based on the ADEPT library
   *
   * @param y values of the continuous variable
   * @param yp values of the derivatives of the continuous variable
   * @param F computes values of the residual functions
   */
  void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &res) {
    ASSERT_EQ(y.size(), 1);
    ASSERT_EQ(yp.size(), 1);
    ASSERT_EQ(res.size(), 1);
    res[0] = y[0] - 8;
  }
#endif

  void setZomc() {
    data_->localData[0]->integerDoubleVars[0] = 4;
  }

  virtual void initData(DYNDATA* data) {
    data->nbF = 1;
    data->nbCalculatedVars = 0;
    data->nbModes = 0;
    data->nbVars = 1;
    data->nbZ = 0;
    data->modelData = reinterpret_cast<MODEL_DATA *>(calloc(1, sizeof(MODEL_DATA)));
    data->simulationInfo = reinterpret_cast<SIMULATION_INFO *>(calloc(1, sizeof(SIMULATION_INFO)));
    data->simulationInfo->daeModeData = reinterpret_cast<DAEMODE_DATA *>(calloc(1, sizeof(DAEMODE_DATA)));
    data->localData = reinterpret_cast<SIMULATION_DATA **>(calloc(1, sizeof(SIMULATION_DATA*)));
    data->localData[0] = reinterpret_cast<SIMULATION_DATA *>(calloc(1, sizeof(SIMULATION_DATA)));
    data_ = data;
    data->modelData->nParametersReal = 0;
    data->modelData->nParametersInteger = 0;
    data->modelData->nParametersBoolean = 0;
    data->modelData->nParametersString = 0;
    data->modelData->nDiscreteReal = 0;
    data->modelData->nVariablesReal = 1;
    data->modelData->nVariablesInteger = 1;
    data->modelData->nVariablesBoolean = 0;
    data->modelData->nVariablesString = 0;
    data->modelData->nAliasReal = 0;
    data->modelData->nAliasInteger = 0;
    data->modelData->nAliasBoolean = 0;
    data->modelData->nAliasString = 0;
  }

 private:
  DYNDATA* data_;
};

class MyModelManager : public ModelManager {
 public:
  MyModelManager() :
    ModelManager() {
    modelInit_ = new MyModelicaInit(this);
    modelDyn_ = new MyModelica(this);
    modelType_ = "MyModelica";
    name("MyModelManager");
  }

  virtual ~MyModelManager() {}

  void testSize() {
    ASSERT_EQ(dataInit_->nbF, 1);
    ASSERT_EQ(dataInit_->nbCalculatedVars, 0);
    ASSERT_EQ(dataInit_->nbModes, 0);
    ASSERT_EQ(dataInit_->nbVars, 1);
    ASSERT_EQ(dataInit_->nbZ , 0);
    ASSERT_EQ(dataDyn_->nbF, 2);
    ASSERT_EQ(dataDyn_->nbCalculatedVars, 1);
    ASSERT_EQ(dataDyn_->nbModes, 1);
    ASSERT_EQ(dataDyn_->nbVars, 2);
    ASSERT_EQ(dataDyn_->nbZ , 1);
  }

  void testNbCallF(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallF(), ref);
  }

  void testNbCallG(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallG(), ref);
  }

  void testNbCallZ(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallZ(), ref);
  }

  void testNbCallCalcVars(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallCalcVars(), ref);
  }

  void testNbCallY0(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallY0(), ref);
  }

  void testNbCallFType(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallFType(), ref);
  }

  void testNbCallYType(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallYType(), ref);
  }

  void testNbCallCheckDataCoherence(unsigned ref) {
    ASSERT_EQ(dynamic_cast<MyModelica*>(modelDyn_)->getNbCallCheckDataCoherence(), ref);
  }

 protected:
  bool hasInit() const {
    return true;
  }
};

TEST(TestModelManager, TestModelManagerBasics) {
  boost::shared_ptr<MyModelManager> mm = boost::shared_ptr<MyModelManager>(new MyModelManager());
  mm->initializeStaticData();
  mm->testSize();
  boost::dynamic_pointer_cast<SubModel>(mm)->defineParameters();
  boost::dynamic_pointer_cast<SubModel>(mm)->defineParametersInit();
  boost::dynamic_pointer_cast<SubModel>(mm)->defineVariables();
  boost::dynamic_pointer_cast<SubModel>(mm)->defineVariablesInit();

  ASSERT_EQ(mm->getParametersDynamic().size(), 2);
  mm->init(0.);

  ASSERT_EQ(mm->sizeF(), 2);
  ASSERT_EQ(mm->sizeCalculatedVar(), 1);
  ASSERT_EQ(mm->sizeMode(), 1);
  ASSERT_EQ(mm->sizeY(), 2);
  ASSERT_EQ(mm->sizeZ(), 1);

  std::vector<double> y(mm->sizeY(), 0.);
  y[0] = 2;
  y[1] = 4;
  std::vector<double> yp(mm->sizeY(), 0.);
  yp[0] = 1;
  yp[1] = 2;
  std::vector<double> f(mm->sizeF(), 0.);
  std::vector<double> z(mm->sizeZ(), 0.);
  bool* zConnected = new bool[mm->sizeZ()];
  for (size_t i = 0; i < mm->sizeZ(); ++i)
    zConnected[i] = true;
  std::vector<state_g> g(mm->sizeG(), NO_ROOT);
  std::vector<propertyContinuousVar_t> yTypes(mm->sizeY(), UNDEFINED_PROPERTY);
  std::vector<propertyF_t> fTypes(mm->sizeF(), UNDEFINED_EQ);
  mm->setBufferG(&g[0], 0);
  mm->setBufferZ(&z[0], zConnected, 0);
  mm->setBufferY(&y[0], &yp[0], 0);
  mm->setBufferF(&f[0], 0);
  mm->setBufferYType(&yTypes[0], 0);
  mm->setBufferFType(&fTypes[0], 0);
  mm->initSubBuffers();

  mm->checkDataCoherence(0.);
  mm->testNbCallCheckDataCoherence(1);

  mm->evalF(0, UNDEFINED_EQ);
  mm->testNbCallF(1);
  mm->evalG(0);
  mm->testNbCallG(1);
  mm->evalZ(0);
  mm->testNbCallZ(1);
  mm->evalYType();
  mm->testNbCallYType(1);
  mm->evalFType();
  mm->testNbCallFType(1);
  mm->getY0();
  mm->testNbCallY0(1);
  ASSERT_EQ(mm->evalMode(0.), DIFFERENTIAL_MODE);
  mm->evalCalculatedVars();
  mm->testNbCallCalcVars(1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(mm->evalCalculatedVarI(0), 10.);
  std::vector<int> res;
  mm->getIndexesOfVariablesUsedForCalculatedVarI(0, res);
  ASSERT_EQ(res.size(), 2);
  ASSERT_EQ(res[0], 0);
  ASSERT_EQ(res[1], 1);

  mm->setFequations();
  ASSERT_EQ(mm->getFequationByLocalIndex(0), "MyFEq");
  mm->setFequationsInit();

  mm->setGequations();
  ASSERT_EQ(mm->getGequationByLocalIndex(0), "MyGEq");
  mm->setGequationsInit();

  SparseMatrix smj;
  int size = mm->sizeF();
  smj.init(size, size);
  mm->evalJt(0., 1., smj, 0);
  ASSERT_EQ(smj.nbElem(), 4);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[0], 2.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[1], 1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[2], -1);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj.Ax_[3], .5);
  ASSERT_EQ(smj.Ap_[0], 0);
  ASSERT_EQ(smj.Ap_[1], 2);
  ASSERT_EQ(smj.Ap_[2], 4);

  SparseMatrix smj2;
  smj2.init(size, size);
  mm->evalJtPrim(0., 1., smj2, 0);
  ASSERT_EQ(smj2.nbElem(), 2);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[0], 1.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(smj2.Ax_[1], -1.);
  ASSERT_EQ(smj2.Ap_[0], 0);
  ASSERT_EQ(smj2.Ap_[1], 1);
  ASSERT_EQ(smj2.Ap_[2], 2);

  mm->setSharedParametersDefaultValues();
  mm->setSharedParametersDefaultValuesInit();
  for (boost::unordered_map<std::string, ParameterModeler>::const_iterator it = mm->getParametersDynamic().begin(), itEnd = mm->getParametersDynamic().end();
      it != itEnd; ++it) {
    if (it->first == "MyParam")
      ASSERT_EQ(it->second.getValue<int>(), 2);
    else if (it->first == "MyParam2")
      ASSERT_EQ(it->second.getValue<double>(), 1);
    else
      assert(0);
  }
  std::map< std::string, std::string > mapParameters;
  mm->dumpParameters(mapParameters);
  ASSERT_EQ(mapParameters.size(), 1);
  std::map< std::string, std::string > mapVariables;
  mm->dumpVariables(mapVariables);
  ASSERT_EQ(mapVariables.size(), 1);

  mm->defineNames();
  mm->defineNamesInit();

  mm->loadParameters(mapParameters["MyModelica-MyModelManager-parameters.bin"]);
  for (boost::unordered_map<std::string, ParameterModeler>::const_iterator it = mm->getParametersDynamic().begin(), itEnd = mm->getParametersDynamic().end();
      it != itEnd; ++it) {
    if (it->first == "MyParam")
      ASSERT_EQ(it->second.getValue<int>(), 0);
    else if (it->first == "MyParam2")
      ASSERT_EQ(it->second.getValue<double>(), 0);
    else
      assert(0);
  }

  mm->initParams();

  for (boost::unordered_map<std::string, ParameterModeler>::const_iterator it = mm->getParametersDynamic().begin(), itEnd = mm->getParametersDynamic().end();
      it != itEnd; ++it) {
    if (it->first == "MyParam")
      ASSERT_EQ(it->second.getValue<int>(), 4);
    else if (it->first == "MyParam2")
      ASSERT_EQ(it->second.getValue<double>(), 8);
    else
      assert(0);
  }

  mm->printInitValues("res");
  std::stringstream ssDiff;
  executeCommand("diff res/dumpInitValues-MyModelManager_ref.txt res/dumpInitValues-MyModelManager.txt", ssDiff);
  std::cout << ssDiff.str() << std::endl;
  ASSERT_EQ(ssDiff.str(), "Executing command : diff res/dumpInitValues-MyModelManager_ref.txt res/dumpInitValues-MyModelManager.txt\n");
  y[0] = -10;
  mm->loadVariables(mapVariables["MyModelica-MyModelManager-variables.bin"]);
  ASSERT_EQ(y[0], 2);

  std::vector<double> calcVarJRes(2, 0.);
  mm->evalJCalculatedVarI(0, calcVarJRes);
  ASSERT_EQ(calcVarJRes[0], 2);
  ASSERT_EQ(calcVarJRes[1], 0);

  mm->setSubModelParameters();
  delete[] zConnected;
}


}  // namespace DYN
