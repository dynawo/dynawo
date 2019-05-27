
#ifndef MACHINE_PQ_Init_h
#define MACHINE_PQ_Init_h

#include "DYNModelModelicaInit.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif

namespace DYN {

  class ModelMACHINE_PQ_Init : public ModelModelicaInit
  {
    public:
    ModelMACHINE_PQ_Init() {dataStructIsInitialized_ = false;}
    ~ModelMACHINE_PQ_Init() {if (dataStructIsInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f);
    void setGomc(state_g * g);
    bool evalMode(const double & t) const;
    void setZomc();
    void setY0omc();
    void setYType_omc(propertyContinuousVar_t* yType);
    void setFType_omc(propertyF_t* fType);
    boost::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues(); ///< set parameter values based on internal Modelica data
    void setParameters(boost::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
#ifdef _ADEPT_
    void evalFAdept( const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
#endif

    void checkDataCoherence ();
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("56ab80ef6355cd3c65b6f1fafd709ad3"); }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructIsInitialized_;
    std::string modelType_;

    private:
    std::string modelType() const { return modelType_; }
    inline void setData(DYNDATA * d){ data = d; }
    void setupDataStruc();
    void initializeDataStruc();
    void deInitializeDataStruc();

    private:
   //External Calls
     typedef struct Dynawo_Types_AC_ApparentPower_s {
       modelica_real _im;
       modelica_real _re;
     } Dynawo_Types_AC_ApparentPower;
     typedef base_array_t Dynawo_Types_AC_ApparentPower_array;
     typedef Dynawo_Types_AC_ApparentPower Complex;
     typedef base_array_t Complex_array;
     typedef Dynawo_Types_AC_ApparentPower Dynawo_Types_AC_Current;
     typedef base_array_t Dynawo_Types_AC_Current_array;
     typedef Dynawo_Types_AC_ApparentPower Dynawo_Types_AC_Voltage;
     typedef base_array_t Dynawo_Types_AC_Voltage_array;
     Dynawo_Types_AC_ApparentPower omc_Dynawo_Types_AC_ApparentPower( modelica_real omc_re, modelica_real omc_im); /* record head */
     Complex omc_Complex( modelica_real omc_re, modelica_real omc_im); /* record head */
     Dynawo_Types_AC_Current omc_Dynawo_Types_AC_Current( modelica_real omc_re, modelica_real omc_im); /* record head */
     Dynawo_Types_AC_Voltage omc_Dynawo_Types_AC_Voltage( modelica_real omc_re, modelica_real omc_im); /* record head */

      // Non-internal parameters 
      double MACHINE_P0Pu_;
      double MACHINE_Q0Pu_;
      double MACHINE_U0Pu_;
      double MACHINE_UPhase0_;

   };
}//end namespace DYN

#endif

