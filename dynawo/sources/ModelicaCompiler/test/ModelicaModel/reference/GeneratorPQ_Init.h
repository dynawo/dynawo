
#ifndef GeneratorPQ_Init_h
#define GeneratorPQ_Init_h

#include "DYNModelModelica.h"
#include "DYNModelManagerCommon.h"
#include "PARParametersSet.h"
#include "PARParameter.h"
#include "DYNSubModel.h"
#include "DYNVariableForModel.h"
#include "DYNParameter.h"
#ifdef _ADEPT_
#include "adept.h"
#endif

namespace DYN {

  class ModelGeneratorPQ_Init : public ModelModelica
  {
    public:
    ModelGeneratorPQ_Init() {
        dataStructInitialized_ = false;
        hasCheckDataCoherence_ = false;
    }
    ~ModelGeneratorPQ_Init() {if (dataStructInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f, propertyF_t type);
    void setGomc(state_g * g);
    modeChangeType_t evalMode(const double t) const;
    void setZomc();
    void collectSilentZ(BitMask* silentZTable);
    void setY0omc();
    void callCustomParametersConstructors();
    void evalStaticYType_omc(propertyContinuousVar_t* yType);
    void evalStaticFType_omc(propertyF_t* fType);
    void evalDynamicYType_omc(propertyContinuousVar_t* yType);
    void evalDynamicFType_omc(propertyF_t* fType);
    std::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues(); ///< set parameter values based on internal Modelica data
    void setParameters(std::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
    void evalCalculatedVars(std::vector<double>& calculatedVars);
    double evalCalculatedVarI(unsigned iCalculatedVar) const;
    void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;
#ifdef _ADEPT_
    void evalFAdept( const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
    adept::adouble evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp) const;
#endif

    void checkDataCoherence ();
    void checkParametersCoherence () const;
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("2332cec478d37f127168a3de7ff3c7fe"); }
    inline bool isDataStructInitialized() const { return dataStructInitialized_; }

    private:
    DYNDATA * data;
    ModelManager * modelManager_;
    bool dataStructInitialized_;
    std::string modelType_;

    private:
    const std::string& modelType() const { return modelType_; }
    inline void setData(DYNDATA * d){ data = d; }
    void setupDataStruc();
    void initializeDataStruc();
    void deInitializeDataStruc();

    private:
   //External Calls
     typedef struct Complex_s {
       modelica_real _im;
       modelica_real _re;
     } Complex;
     typedef base_array_t Complex_array;
     typedef Complex Dynawo_Types_AC_ApparentPower;
     typedef base_array_t Dynawo_Types_AC_ApparentPower_array;
     typedef Complex Dynawo_Types_AC_Current;
     typedef base_array_t Dynawo_Types_AC_Current_array;
     typedef Complex Dynawo_Types_AC_Voltage;
     typedef base_array_t Dynawo_Types_AC_Voltage_array;
     Complex omc_Complex ( modelica_real omc_re, modelica_real omc_im);
     Complex omc_Complex__omcQuot_2B( Complex _c1, Complex _c2);
     Complex omc_Complex__omcQuot_2A_multiply( Complex _c1, Complex _c2);
     Complex omc_Complex__omcQuot_2A_scalarProduct( Complex_array _c1, Complex_array _c2);
     Complex omc_Complex__omcQuot_636F6E7374727563746F72_fromReal( modelica_real _re, modelica_real _im);
     Dynawo_Types_AC_ApparentPower omc_Dynawo_Types_AC_ApparentPower ( modelica_real omc_re, modelica_real omc_im);
     Dynawo_Types_AC_Current omc_Dynawo_Types_AC_Current ( modelica_real omc_re, modelica_real omc_im);
     Dynawo_Types_AC_Voltage omc_Dynawo_Types_AC_Voltage ( modelica_real omc_re, modelica_real omc_im);
     Complex omc_Modelica_ComplexMath_conj( Complex _c1);
     modelica_metatype boxptr_Modelica_ComplexMath_conj( modelica_metatype _c1);
     Complex omc_Modelica_ComplexMath_fromPolar( modelica_real _len, modelica_real _phi);
     modelica_metatype boxptr_Modelica_ComplexMath_fromPolar( modelica_metatype _len, modelica_metatype _phi);
     modelica_real omc_Modelica_Math_cos( modelica_real _u);
     modelica_metatype boxptr_Modelica_Math_cos( modelica_metatype _u);
     modelica_real omc_Modelica_Math_sin( modelica_real _u);
     modelica_metatype boxptr_Modelica_Math_sin( modelica_metatype _u);

#ifdef _ADEPT_
     typedef struct Complex_s_adept {
       adept::adouble _im;
       adept::adouble _re;
     } Complex_adept;
     typedef Complex_adept Dynawo_Types_AC_ApparentPower_adept ;
     typedef Complex_adept Dynawo_Types_AC_Current_adept ;
     typedef Complex_adept Dynawo_Types_AC_Voltage_adept ;
#endif
      // Non-internal parameters 
      double generator_P0Pu_;
      double generator_Q0Pu_;
      double generator_U0Pu_;
      double generator_UPhase0_;

   };
}//end namespace DYN

#endif

