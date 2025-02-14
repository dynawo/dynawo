#include "omc_simulation_settings.h"
#include "GeneratorPQ_INIT_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "GeneratorPQ_INIT_includes.h"


Complex omc_Complex(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Complex(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Complex__desc, _re, _im);
}

DLLDirection
Complex omc_Complex__omcQ_27constructor_27_fromReal(threadData_t *threadData, modelica_real _re, modelica_real _im)
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_1_2_construct(threadData, _result, _re, _im); // _result has no default value.
  _return: OMC_LABEL_UNUSED
  return _result;
}
modelica_metatype boxptr_Complex__omcQ_27constructor_27_fromReal(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  modelica_real tmp1;
  modelica_real tmp2;
  Complex _result;
  modelica_metatype tmpMeta3;
  modelica_metatype tmpMeta4;
  modelica_metatype out_result;
  tmp1 = mmc_unbox_real(_re);
  tmp2 = mmc_unbox_real(_im);
  _result = omc_Complex__omcQ_27constructor_27_fromReal(threadData, tmp1, tmp2);
  tmpMeta3 = mmc_mk_rcon(_result._re);
  tmpMeta4 = mmc_mk_rcon(_result._im);
  out_result = mmc_mk_box3(3, &Complex__desc, tmpMeta3, tmpMeta4);
  return out_result;
}

Dynawo_Connectors_ComplexCurrentPuConnector omc_Dynawo_Connectors_ComplexCurrentPuConnector(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Connectors_ComplexCurrentPuConnector tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Connectors_ComplexCurrentPuConnector(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Connectors_ComplexCurrentPuConnector__desc, _re, _im);
}

Dynawo_Connectors_ComplexVoltagePuConnector omc_Dynawo_Connectors_ComplexVoltagePuConnector(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Connectors_ComplexVoltagePuConnector tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Connectors_ComplexVoltagePuConnector(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Connectors_ComplexVoltagePuConnector__desc, _re, _im);
}

DLLDirection
Complex omc_Dynawo_Connectors_ComplexVoltagePuConnector__omcQ_27_2A_27_multiply(threadData_t *threadData, Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct(threadData, _c3); // _c3 has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal(threadData, (_c1._re) * (_c2._re) - ((_c1._im) * (_c2._im)), (_c1._re) * (_c2._im) + (_c1._im) * (_c2._re));
  Complex_copy(tmp1, _c3);;
  _return: OMC_LABEL_UNUSED
  return _c3;
}
modelica_metatype boxptr_Dynawo_Connectors_ComplexVoltagePuConnector__omcQ_27_2A_27_multiply(threadData_t *threadData, modelica_metatype _c1, modelica_metatype _c2)
{
  Complex tmp1;
  modelica_metatype tmpMeta2;
  modelica_real tmp3;
  modelica_metatype tmpMeta4;
  modelica_real tmp5;
  Complex tmp6;
  modelica_metatype tmpMeta7;
  modelica_real tmp8;
  modelica_metatype tmpMeta9;
  modelica_real tmp10;
  Complex _c3;
  modelica_metatype tmpMeta11;
  modelica_metatype tmpMeta12;
  modelica_metatype out_c3;
  tmpMeta2 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 2)));
  tmp3 = mmc_unbox_real(tmpMeta2);
  tmp1._re = tmp3;
  tmpMeta4 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 3)));
  tmp5 = mmc_unbox_real(tmpMeta4);
  tmp1._im = tmp5;tmpMeta7 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 2)));
  tmp8 = mmc_unbox_real(tmpMeta7);
  tmp6._re = tmp8;
  tmpMeta9 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 3)));
  tmp10 = mmc_unbox_real(tmpMeta9);
  tmp6._im = tmp10;
  _c3 = omc_Dynawo_Connectors_ComplexVoltagePuConnector__omcQ_27_2A_27_multiply(threadData, tmp1, tmp6);
  tmpMeta11 = mmc_mk_rcon(_c3._re);
  tmpMeta12 = mmc_mk_rcon(_c3._im);
  out_c3 = mmc_mk_box3(3, &Complex__desc, tmpMeta11, tmpMeta12);
  return out_c3;
}

Dynawo_Types_ComplexApparentPowerPu omc_Dynawo_Types_ComplexApparentPowerPu(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_ComplexApparentPowerPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_ComplexApparentPowerPu(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_ComplexApparentPowerPu__desc, _re, _im);
}

DLLDirection
Complex omc_Modelica_ComplexMath_conj(threadData_t *threadData, Complex _c1)
{
  Complex _c2;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct(threadData, _c2); // _c2 has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal(threadData, _c1._re, (-_c1._im));
  Complex_copy(tmp1, _c2);;
  _return: OMC_LABEL_UNUSED
  return _c2;
}
modelica_metatype boxptr_Modelica_ComplexMath_conj(threadData_t *threadData, modelica_metatype _c1)
{
  Complex tmp1;
  modelica_metatype tmpMeta2;
  modelica_real tmp3;
  modelica_metatype tmpMeta4;
  modelica_real tmp5;
  Complex _c2;
  modelica_metatype tmpMeta6;
  modelica_metatype tmpMeta7;
  modelica_metatype out_c2;
  tmpMeta2 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 2)));
  tmp3 = mmc_unbox_real(tmpMeta2);
  tmp1._re = tmp3;
  tmpMeta4 = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 3)));
  tmp5 = mmc_unbox_real(tmpMeta4);
  tmp1._im = tmp5;
  _c2 = omc_Modelica_ComplexMath_conj(threadData, tmp1);
  tmpMeta6 = mmc_mk_rcon(_c2._re);
  tmpMeta7 = mmc_mk_rcon(_c2._im);
  out_c2 = mmc_mk_box3(3, &Complex__desc, tmpMeta6, tmpMeta7);
  return out_c2;
}

DLLDirection
Complex omc_Modelica_ComplexMath_fromPolar(threadData_t *threadData, modelica_real _len, modelica_real _phi)
{
  Complex _c;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct(threadData, _c); // _c has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal(threadData, (_len) * (cos(_phi)), (_len) * (sin(_phi)));
  Complex_copy(tmp1, _c);;
  _return: OMC_LABEL_UNUSED
  return _c;
}
modelica_metatype boxptr_Modelica_ComplexMath_fromPolar(threadData_t *threadData, modelica_metatype _len, modelica_metatype _phi)
{
  modelica_real tmp1;
  modelica_real tmp2;
  Complex _c;
  modelica_metatype tmpMeta3;
  modelica_metatype tmpMeta4;
  modelica_metatype out_c;
  tmp1 = mmc_unbox_real(_len);
  tmp2 = mmc_unbox_real(_phi);
  _c = omc_Modelica_ComplexMath_fromPolar(threadData, tmp1, tmp2);
  tmpMeta3 = mmc_mk_rcon(_c._re);
  tmpMeta4 = mmc_mk_rcon(_c._im);
  out_c = mmc_mk_box3(3, &Complex__desc, tmpMeta3, tmpMeta4);
  return out_c;
}

#ifdef __cplusplus
}
#endif
