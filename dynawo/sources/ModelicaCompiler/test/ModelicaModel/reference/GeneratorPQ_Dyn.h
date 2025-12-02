
#ifndef GeneratorPQ__Dyn_h
#define GeneratorPQ__Dyn_h


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

  class ModelGeneratorPQ_Dyn : public ModelModelica
  {
    public:
    ModelGeneratorPQ_Dyn() {
        dataStructInitialized_ = false;
        hasCheckDataCoherence_ = false;
    }
    ~ModelGeneratorPQ_Dyn() {if (dataStructInitialized_) deInitializeDataStruc();}


    public:
    void initData(DYNDATA * d);
    void initRpar();
    void setFomc(double * f, propertyF_t type);
    void setGomc(state_g * g);
    modeChangeType_t evalMode(const double t) const;
    void setZomc();
    void collectSilentZ(BitMask* silentZTable);
    void setOomc();
    void setY0omc();
    void callCustomParametersConstructors();
    void evalStaticYType_omc(propertyContinuousVar_t* yType);
    void evalStaticFType_omc(propertyF_t* fType);
    void evalDynamicYType_omc(propertyContinuousVar_t* yType);
    void evalDynamicFType_omc(propertyF_t* fType);
    std::shared_ptr<parameters::ParametersSet> setSharedParametersDefaultValues();
    void setParameters( std::shared_ptr<parameters::ParametersSet> params );
    void defineVariables(std::vector< boost::shared_ptr<Variable> >& variables);
    void defineParameters(std::vector<ParameterModeler>& parameters);
    void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement);
    void evalCalculatedVars(std::vector<double>& calculatedVars);
    double evalCalculatedVarI(unsigned iCalculatedVar) const;
    void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const;
#ifdef _ADEPT_
    void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F);
    adept::adouble evalCalculatedVarIAdept(unsigned iCalculatedVar, unsigned indexOffset, const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp) const;
#endif

    void checkDataCoherence ();
    void checkParametersCoherence () const;
    void setFequations (std::map<int,std::string>& fEquationIndex);
    void setGequations (std::map<int,std::string>& gEquationIndex);

    inline void setModelType(std::string modelType) { modelType_ = modelType; }
    inline ModelManager * getModelManager() const { return modelManager_; }
    inline void setModelManager (ModelManager * model) { modelManager_ = model; }
    void checkSum(std::string & checkSum) { checkSum = std::string("daf03e62e277633827ac5620f5a84bc3"); }
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
     #define Complex_construct( ths ) Complex_construct_p( &ths )
     #define Complex_copy(src,dst) Complex_copy_p(&src, &dst)
     #define Complex_wrap_vars( dst , in_re, in_im) Complex_wrap_vars_p( &dst , in_re, in_im)
     // #define Complex_copy_to_vars(src,...) Complex_copy_to_vars_p(&src, __VA_ARGS__)
     #define alloc_Complex_array(dst,ndims,...) generic_array_create(NULL, dst, Complex_construct_p, ndims, sizeof(Complex), __VA_ARGS__)
     #define Complex_array_copy_data(src,dst)   generic_array_copy_data(src, &dst, Complex_copy_p, sizeof(Complex))
     #define Complex_array_alloc_copy(src,dst)  generic_array_alloc_copy(src, &dst, Complex_copy_p, sizeof(Complex))
     #define Complex_array_get(src,ndims,...)   (*(Complex*)(generic_array_get(&src, sizeof(Complex), __VA_ARGS__)))
     #define Complex_set(dst,val,...)           generic_array_set(&dst, &val, Complex_copy_p, sizeof(Complex), __VA_ARGS__)
     #define Complex_1_2_construct( ths , in_re, in_im) Complex_1_2_construct_p( &ths , in_re, in_im)
     #define alloc_Complex_1_2_array(dst,ndims,...) generic_array_create(NULL, dst, Complex_1_2_construct_p, ndims, sizeof(Complex), __VA_ARGS__)
     #define Dynawo_Types_ComplexApparentPowerPu_construct( ths ) Dynawo_Types_ComplexApparentPowerPu_construct_p( &ths )
     #define Dynawo_Types_ComplexApparentPowerPu_copy(src,dst) Dynawo_Types_ComplexApparentPowerPu_copy_p(&src, &dst)
     #define Dynawo_Types_ComplexApparentPowerPu_wrap_vars( dst , in_re, in_im) Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexApparentPowerPu_copy_to_vars(src,...) Dynawo_Types_ComplexApparentPowerPu_copy_to_vars_p(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexApparentPowerPu_array(dst,ndims,...) generic_array_create(NULL, dst, Dynawo_Types_ComplexApparentPowerPu_construct_p, ndims, sizeof(Dynawo_Types_ComplexApparentPowerPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexApparentPowerPu_array_copy_data(src,dst)   generic_array_copy_data(src, &dst, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu))
     #define Dynawo_Types_ComplexApparentPowerPu_array_alloc_copy(src,dst)  generic_array_alloc_copy(src, &dst, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu))
     #define Dynawo_Types_ComplexApparentPowerPu_array_get(src,ndims,...)   (*(Dynawo_Types_ComplexApparentPowerPu*)(generic_array_get(&src, sizeof(Dynawo_Types_ComplexApparentPowerPu), __VA_ARGS__)))
     #define Dynawo_Types_ComplexApparentPowerPu_set(dst,val,...)           generic_array_set(&dst, &val, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexCurrentPu_construct( ths ) Dynawo_Types_ComplexCurrentPu_construct_p( &ths )
     #define Dynawo_Types_ComplexCurrentPu_copy(src,dst) Dynawo_Types_ComplexCurrentPu_copy_p(&src, &dst)
     #define Dynawo_Types_ComplexCurrentPu_wrap_vars( dst , in_re, in_im) Dynawo_Types_ComplexCurrentPu_wrap_vars_p( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexCurrentPu_copy_to_vars(src,...) Dynawo_Types_ComplexCurrentPu_copy_to_vars_p(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexCurrentPu_array(dst,ndims,...) generic_array_create(NULL, dst, Dynawo_Types_ComplexCurrentPu_construct_p, ndims, sizeof(Dynawo_Types_ComplexCurrentPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexCurrentPu_array_copy_data(src,dst)   generic_array_copy_data(src, &dst, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu))
     #define Dynawo_Types_ComplexCurrentPu_array_alloc_copy(src,dst)  generic_array_alloc_copy(src, &dst, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu))
     #define Dynawo_Types_ComplexCurrentPu_array_get(src,ndims,...)   (*(Dynawo_Types_ComplexCurrentPu*)(generic_array_get(&src, sizeof(Dynawo_Types_ComplexCurrentPu), __VA_ARGS__)))
     #define Dynawo_Types_ComplexCurrentPu_set(dst,val,...)           generic_array_set(&dst, &val, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexVoltagePu_construct( ths ) Dynawo_Types_ComplexVoltagePu_construct_p( &ths )
     #define Dynawo_Types_ComplexVoltagePu_copy(src,dst) Dynawo_Types_ComplexVoltagePu_copy_p(&src, &dst)
     #define Dynawo_Types_ComplexVoltagePu_wrap_vars( dst , in_re, in_im) Dynawo_Types_ComplexVoltagePu_wrap_vars_p( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexVoltagePu_copy_to_vars(src,...) Dynawo_Types_ComplexVoltagePu_copy_to_vars_p(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexVoltagePu_array(dst,ndims,...) generic_array_create(NULL, dst, Dynawo_Types_ComplexVoltagePu_construct_p, ndims, sizeof(Dynawo_Types_ComplexVoltagePu), __VA_ARGS__)
     #define Dynawo_Types_ComplexVoltagePu_array_copy_data(src,dst)   generic_array_copy_data(src, &dst, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu))
     #define Dynawo_Types_ComplexVoltagePu_array_alloc_copy(src,dst)  generic_array_alloc_copy(src, &dst, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu))
     #define Dynawo_Types_ComplexVoltagePu_array_get(src,ndims,...)   (*(Dynawo_Types_ComplexVoltagePu*)(generic_array_get(&src, sizeof(Dynawo_Types_ComplexVoltagePu), __VA_ARGS__)))
     #define Dynawo_Types_ComplexVoltagePu_set(dst,val,...)           generic_array_set(&dst, &val, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu), __VA_ARGS__)
     #define boxvar_Complex MMC_REFSTRUCTLIT(boxvar_lit_Complex)
     #define boxvar_Complex__omcQ_27_2D_27_negate MMC_REFSTRUCTLIT(boxvar_lit_Complex__omcQ_27_2D_27_negate)
     #define boxvar_Complex__omcQ_27constructor_27_fromReal MMC_REFSTRUCTLIT(boxvar_lit_Complex__omcQ_27constructor_27_fromReal)
     #define boxvar_Dynawo_NonElectrical_Logs_Timeline_logEvent1 MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_NonElectrical_Logs_Timeline_logEvent1)
     #define boxvar_Dynawo_Types_ComplexApparentPowerPu MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_ComplexApparentPowerPu)
     #define boxvar_Dynawo_Types_ComplexCurrentPu MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_ComplexCurrentPu)
     #define boxvar_Dynawo_Types_ComplexVoltagePu MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_ComplexVoltagePu)
     #define boxvar_Dynawo_Types_ComplexVoltagePu__omcQ_27_2A_27_multiply MMC_REFSTRUCTLIT(boxvar_lit_Dynawo_Types_ComplexVoltagePu__omcQ_27_2A_27_multiply)
     #define boxvar_Modelica_ComplexMath__omcQ_27abs_27 MMC_REFSTRUCTLIT(boxvar_lit_Modelica_ComplexMath__omcQ_27abs_27)
     #define boxvar_Modelica_ComplexMath_conj MMC_REFSTRUCTLIT(boxvar_lit_Modelica_ComplexMath_conj)
     typedef struct {
       modelica_real _re;
       modelica_real _im;
     } Complex;
     void Complex_construct_p( void* v_ths ) const;
     void Complex_copy_p(void* v_src, void* v_dst) const;
     void Complex_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) const;
     // void Complex_copy_to_vars_p(void* v_src , modelica_real* in_re, modelica_real* in_im) const;
     typedef base_array_t Complex_array;
     void Complex_1_2_construct_p( void* v_ths , modelica_real in_re, modelica_real in_im) const;
     typedef Complex Dynawo_Types_ComplexApparentPowerPu;
     void Dynawo_Types_ComplexApparentPowerPu_construct_p( void* v_ths );
     void Dynawo_Types_ComplexApparentPowerPu_copy_p(void* v_src, void* v_dst);
     void Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im);
     // void Dynawo_Types_ComplexApparentPowerPu_copy_to_vars_p(void* v_src , modelica_real* in_re, modelica_real* in_im);
     typedef base_array_t Dynawo_Types_ComplexApparentPowerPu_array;
     typedef Complex Dynawo_Types_ComplexCurrentPu;
     void Dynawo_Types_ComplexCurrentPu_construct_p( void* v_ths );
     void Dynawo_Types_ComplexCurrentPu_copy_p(void* v_src, void* v_dst);
     void Dynawo_Types_ComplexCurrentPu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im);
     // void Dynawo_Types_ComplexCurrentPu_copy_to_vars_p(void* v_src , modelica_real* in_re, modelica_real* in_im);
     typedef base_array_t Dynawo_Types_ComplexCurrentPu_array;
     typedef Complex Dynawo_Types_ComplexVoltagePu;
     void Dynawo_Types_ComplexVoltagePu_construct_p( void* v_ths );
     void Dynawo_Types_ComplexVoltagePu_copy_p(void* v_src, void* v_dst);
     void Dynawo_Types_ComplexVoltagePu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im);
     // void Dynawo_Types_ComplexVoltagePu_copy_to_vars_p(void* v_src , modelica_real* in_re, modelica_real* in_im);
     typedef base_array_t Dynawo_Types_ComplexVoltagePu_array;
     Complex omc_Complex ( modelica_real omc_re, modelica_real omc_im);
     Complex omc_Complex__omcQ_27_2D_27_negate( Complex _c1) const;
     Complex omc_Complex__omcQ_27constructor_27_fromReal( modelica_real _re, modelica_real _im) const;
     void omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( modelica_integer _key);
     void boxptr_Dynawo_NonElectrical_Logs_Timeline_logEvent1( modelica_metatype _key);
     Dynawo_Types_ComplexApparentPowerPu omc_Dynawo_Types_ComplexApparentPowerPu ( modelica_real omc_re, modelica_real omc_im);
     Dynawo_Types_ComplexCurrentPu omc_Dynawo_Types_ComplexCurrentPu ( modelica_real omc_re, modelica_real omc_im);
     Dynawo_Types_ComplexVoltagePu omc_Dynawo_Types_ComplexVoltagePu ( modelica_real omc_re, modelica_real omc_im);
     Complex omc_Dynawo_Types_ComplexVoltagePu__omcQ_27_2A_27_multiply( Complex _c1, Complex _c2);
     modelica_real omc_Modelica_ComplexMath__omcQ_27abs_27( Complex _c);
     modelica_metatype boxptr_Modelica_ComplexMath__omcQ_27abs_27( modelica_metatype _c);
     Complex omc_Modelica_ComplexMath_conj( Complex _c1);
     modelica_metatype boxptr_Modelica_ComplexMath_conj( modelica_metatype _c1);

#ifdef _ADEPT_
     #define Complex_construct_adept( ths ) Complex_construct_p_adept( &ths )
     #define Complex_copy_adept(src,dst) Complex_copy_p_adept(&src, &dst)
     #define Complex_wrap_vars_adept( dst , in_re, in_im) Complex_wrap_vars_p_adept( &dst , in_re, in_im)
     // #define Complex_copy_to_vars_adept(src,...) Complex_copy_to_vars_p_adept(&src, __VA_ARGS__)
     #define alloc_Complex_array_adept(dst,ndims,...) generic_array_create_adept(NULL, dst, Complex_construct_p, ndims, sizeof(Complex), __VA_ARGS__)
     #define Complex_array_copy_data_adept(src,dst)   generic_array_copy_data_adept(src, &dst, Complex_copy_p, sizeof(Complex))
     #define Complex_array_alloc_copy_adept(src,dst)  generic_array_alloc_copy_adept(src, &dst, Complex_copy_p, sizeof(Complex))
     #define Complex_set_adept(dst,val,...)           generic_array_set_adept(&dst, &val, Complex_copy_p, sizeof(Complex), __VA_ARGS__)
     #define Complex_1_2_construct_adept( ths , in_re, in_im) Complex_1_2_construct_p_adept( &ths , in_re, in_im)
     #define alloc_Complex_1_2_array_adept(dst,ndims,...) generic_array_create_adept(NULL, dst, Complex_1_2_construct_p, ndims, sizeof(Complex), __VA_ARGS__)
     #define Dynawo_Types_ComplexApparentPowerPu_construct_adept( ths ) Dynawo_Types_ComplexApparentPowerPu_construct_p_adept( &ths )
     #define Dynawo_Types_ComplexApparentPowerPu_copy_adept(src,dst) Dynawo_Types_ComplexApparentPowerPu_copy_p_adept(&src, &dst)
     #define Dynawo_Types_ComplexApparentPowerPu_wrap_vars_adept( dst , in_re, in_im) Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p_adept( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexApparentPowerPu_copy_to_vars_adept(src,...) Dynawo_Types_ComplexApparentPowerPu_copy_to_vars_p_adept(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexApparentPowerPu_array_adept(dst,ndims,...) generic_array_create_adept(NULL, dst, Dynawo_Types_ComplexApparentPowerPu_construct_p, ndims, sizeof(Dynawo_Types_ComplexApparentPowerPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexApparentPowerPu_array_copy_data_adept(src,dst)   generic_array_copy_data_adept(src, &dst, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu))
     #define Dynawo_Types_ComplexApparentPowerPu_array_alloc_copy_adept(src,dst)  generic_array_alloc_copy_adept(src, &dst, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu))
     #define Dynawo_Types_ComplexApparentPowerPu_set_adept(dst,val,...)           generic_array_set_adept(&dst, &val, Dynawo_Types_ComplexApparentPowerPu_copy_p, sizeof(Dynawo_Types_ComplexApparentPowerPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexCurrentPu_construct_adept( ths ) Dynawo_Types_ComplexCurrentPu_construct_p_adept( &ths )
     #define Dynawo_Types_ComplexCurrentPu_copy_adept(src,dst) Dynawo_Types_ComplexCurrentPu_copy_p_adept(&src, &dst)
     #define Dynawo_Types_ComplexCurrentPu_wrap_vars_adept( dst , in_re, in_im) Dynawo_Types_ComplexCurrentPu_wrap_vars_p_adept( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexCurrentPu_copy_to_vars_adept(src,...) Dynawo_Types_ComplexCurrentPu_copy_to_vars_p_adept(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexCurrentPu_array_adept(dst,ndims,...) generic_array_create_adept(NULL, dst, Dynawo_Types_ComplexCurrentPu_construct_p, ndims, sizeof(Dynawo_Types_ComplexCurrentPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexCurrentPu_array_copy_data_adept(src,dst)   generic_array_copy_data_adept(src, &dst, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu))
     #define Dynawo_Types_ComplexCurrentPu_array_alloc_copy_adept(src,dst)  generic_array_alloc_copy_adept(src, &dst, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu))
     #define Dynawo_Types_ComplexCurrentPu_set_adept(dst,val,...)           generic_array_set_adept(&dst, &val, Dynawo_Types_ComplexCurrentPu_copy_p, sizeof(Dynawo_Types_ComplexCurrentPu), __VA_ARGS__)
     #define Dynawo_Types_ComplexVoltagePu_construct_adept( ths ) Dynawo_Types_ComplexVoltagePu_construct_p_adept( &ths )
     #define Dynawo_Types_ComplexVoltagePu_copy_adept(src,dst) Dynawo_Types_ComplexVoltagePu_copy_p_adept(&src, &dst)
     #define Dynawo_Types_ComplexVoltagePu_wrap_vars_adept( dst , in_re, in_im) Dynawo_Types_ComplexVoltagePu_wrap_vars_p_adept( &dst , in_re, in_im)
     // #define Dynawo_Types_ComplexVoltagePu_copy_to_vars_adept(src,...) Dynawo_Types_ComplexVoltagePu_copy_to_vars_p_adept(&src, __VA_ARGS__)
     #define alloc_Dynawo_Types_ComplexVoltagePu_array_adept(dst,ndims,...) generic_array_create_adept(NULL, dst, Dynawo_Types_ComplexVoltagePu_construct_p, ndims, sizeof(Dynawo_Types_ComplexVoltagePu), __VA_ARGS__)
     #define Dynawo_Types_ComplexVoltagePu_array_copy_data_adept(src,dst)   generic_array_copy_data_adept(src, &dst, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu))
     #define Dynawo_Types_ComplexVoltagePu_array_alloc_copy_adept(src,dst)  generic_array_alloc_copy_adept(src, &dst, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu))
     #define Dynawo_Types_ComplexVoltagePu_set_adept(dst,val,...)           generic_array_set_adept(&dst, &val, Dynawo_Types_ComplexVoltagePu_copy_p, sizeof(Dynawo_Types_ComplexVoltagePu), __VA_ARGS__)
#endif
      // Non-internal parameters 
      double generator_AlphaPuPNom_;
      double generator_PGen0Pu_;
      double generator_PMax_;
      double generator_PMin_;
      double generator_PNom_;
      double generator_QGen0Pu_;
      double generator_U0Pu_;
      double generator_i0Pu_im_;
      double generator_i0Pu_re_;
      double generator_u0Pu_im_;
      double generator_u0Pu_re_;
      modelica_real generator_SwitchOffSignal10_;
      modelica_real generator_SwitchOffSignal20_;
      modelica_real generator_SwitchOffSignal30_;
      int generator_NbSwitchOffSignals_;
      int generator_State0_;

  };
}//end namespace DYN

#endif

