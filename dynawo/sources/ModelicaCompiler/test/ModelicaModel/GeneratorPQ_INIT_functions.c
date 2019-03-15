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

DLLExport
Complex omc_Complex__omcQuot_2B(threadData_t *threadData, Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex(threadData, _c1._re + _c2._re, _c1._im + _c2._im);
  _c3._re = tmp1._re;
  _c3._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c3;
}
modelica_metatype boxptr_Complex__omcQuot_2B(threadData_t *threadData, modelica_metatype _c1, modelica_metatype _c2)
{
  Complex tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  Complex tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  Complex _c3;
  modelica_metatype out_c3;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._re = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._im = tmp3;tmpMeta[2] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 2)));
  tmp5 = mmc_unbox_real(tmpMeta[2]);
  tmp4._re = tmp5;
  tmpMeta[3] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 3)));
  tmp6 = mmc_unbox_real(tmpMeta[3]);
  tmp4._im = tmp6;
  _c3 = omc_Complex__omcQuot_2B(threadData, tmp1, tmp4);
  tmpMeta[4] = mmc_mk_rcon(_c3._re);
  tmpMeta[5] = mmc_mk_rcon(_c3._im);
  out_c3 = mmc_mk_box3(3, &Complex__desc, tmpMeta[4], tmpMeta[5]);
  return out_c3;
}

DLLExport
Complex omc_Complex__omcQuot_2A_multiply(threadData_t *threadData, Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex(threadData, (_c1._re) * (_c2._re) - ((_c1._im) * (_c2._im)), (_c1._re) * (_c2._im) + (_c1._im) * (_c2._re));
  _c3._re = tmp1._re;
  _c3._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c3;
}
modelica_metatype boxptr_Complex__omcQuot_2A_multiply(threadData_t *threadData, modelica_metatype _c1, modelica_metatype _c2)
{
  Complex tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  Complex tmp4;
  modelica_real tmp5;
  modelica_real tmp6;
  Complex _c3;
  modelica_metatype out_c3;
  modelica_metatype tmpMeta[6] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._re = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._im = tmp3;tmpMeta[2] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 2)));
  tmp5 = mmc_unbox_real(tmpMeta[2]);
  tmp4._re = tmp5;
  tmpMeta[3] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c2), 3)));
  tmp6 = mmc_unbox_real(tmpMeta[3]);
  tmp4._im = tmp6;
  _c3 = omc_Complex__omcQuot_2A_multiply(threadData, tmp1, tmp4);
  tmpMeta[4] = mmc_mk_rcon(_c3._re);
  tmpMeta[5] = mmc_mk_rcon(_c3._im);
  out_c3 = mmc_mk_box3(3, &Complex__desc, tmpMeta[4], tmpMeta[5]);
  return out_c3;
}

DLLExport
Complex omc_Complex__omcQuot_2A_scalarProduct(threadData_t *threadData, Complex_array _c1, Complex_array _c2)
{
  Complex _c3;
  Complex tmp1;
  Complex tmp2;
  Complex tmp3;
  modelica_integer tmp4;
  modelica_integer tmp5;
  modelica_integer tmp6;
  modelica_integer tmp7;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1._re = 0.0;
  tmp1._im = 0.0;
  tmp2 = tmp1;
  _c3._re = tmp2._re;
  _c3._im = tmp2._im;

  tmp7 = size_of_dimension_base_array(_c1, ((modelica_integer) 1));
  tmp4 = ((modelica_integer) 1); tmp5 = 1; tmp6 = tmp7;
  if(!(((tmp5 > 0) && (tmp4 > tmp6)) || ((tmp5 < 0) && (tmp4 < tmp6))))
  {
    modelica_integer _i;
    for(_i = ((modelica_integer) 1); in_range_integer(_i, tmp4, tmp6); _i += tmp5)
    {
      tmp3 = omc_Complex__omcQuot_2B(threadData, _c3, omc_Complex__omcQuot_2A_multiply(threadData,  (*((Complex*)(generic_array_element_addr(&_c1, sizeof(Complex), 1, /* modelica_integer */ (modelica_integer)_i)))),  (*((Complex*)(generic_array_element_addr(&_c2, sizeof(Complex), 1, /* modelica_integer */ (modelica_integer)_i))))));
      _c3._re = tmp3._re;
      _c3._im = tmp3._im;
    }
  }
  _return: OMC_LABEL_UNUSED
  return _c3;
}
modelica_metatype boxptr_Complex__omcQuot_2A_scalarProduct(threadData_t *threadData, modelica_metatype _c1, modelica_metatype _c2)
{
  Complex _c3;
  modelica_metatype out_c3;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  _c3 = omc_Complex__omcQuot_2A_scalarProduct(threadData, *((base_array_t*)_c1), *((base_array_t*)_c2));
  tmpMeta[0] = mmc_mk_rcon(_c3._re);
  tmpMeta[1] = mmc_mk_rcon(_c3._im);
  out_c3 = mmc_mk_box3(3, &Complex__desc, tmpMeta[0], tmpMeta[1]);
  return out_c3;
}

DLLExport
Complex omc_Complex__omcQuot_636F6E7374727563746F72_fromReal(threadData_t *threadData, modelica_real _re, modelica_real _im)
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  _result = omc_Complex(threadData, _re, _im);
  _return: OMC_LABEL_UNUSED
  return _result;
}
modelica_metatype boxptr_Complex__omcQuot_636F6E7374727563746F72_fromReal(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  modelica_real tmp1;
  modelica_real tmp2;
  Complex _result;
  modelica_metatype out_result;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmp1 = mmc_unbox_real(_re);
  tmp2 = mmc_unbox_real(_im);
  _result = omc_Complex__omcQuot_636F6E7374727563746F72_fromReal(threadData, tmp1, tmp2);
  tmpMeta[0] = mmc_mk_rcon(_result._re);
  tmpMeta[1] = mmc_mk_rcon(_result._im);
  out_result = mmc_mk_box3(3, &Complex__desc, tmpMeta[0], tmpMeta[1]);
  return out_result;
}

Dynawo_Types_AC_ApparentPower omc_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_ApparentPower(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_ApparentPower__desc, _re, _im);
}

Dynawo_Types_AC_Current omc_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Current(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Current__desc, _re, _im);
}

Dynawo_Types_AC_Voltage omc_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Voltage(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Voltage__desc, _re, _im);
}

DLLExport
Complex omc_Modelica_ComplexMath_conj(threadData_t *threadData, Complex _c1)
{
  Complex _c2;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex(threadData, _c1._re, (-_c1._im));
  _c2._re = tmp1._re;
  _c2._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c2;
}
modelica_metatype boxptr_Modelica_ComplexMath_conj(threadData_t *threadData, modelica_metatype _c1)
{
  Complex tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  Complex _c2;
  modelica_metatype out_c2;
  modelica_metatype tmpMeta[4] __attribute__((unused)) = {0};
  tmpMeta[0] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 2)));
  tmp2 = mmc_unbox_real(tmpMeta[0]);
  tmp1._re = tmp2;
  tmpMeta[1] = (MMC_FETCH(MMC_OFFSET(MMC_UNTAGPTR(_c1), 3)));
  tmp3 = mmc_unbox_real(tmpMeta[1]);
  tmp1._im = tmp3;
  _c2 = omc_Modelica_ComplexMath_conj(threadData, tmp1);
  tmpMeta[2] = mmc_mk_rcon(_c2._re);
  tmpMeta[3] = mmc_mk_rcon(_c2._im);
  out_c2 = mmc_mk_box3(3, &Complex__desc, tmpMeta[2], tmpMeta[3]);
  return out_c2;
}

DLLExport
Complex omc_Modelica_ComplexMath_fromPolar(threadData_t *threadData, modelica_real _len, modelica_real _phi)
{
  Complex _c;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex(threadData, (_len) * (cos(_phi)), (_len) * (sin(_phi)));
  _c._re = tmp1._re;
  _c._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c;
}
modelica_metatype boxptr_Modelica_ComplexMath_fromPolar(threadData_t *threadData, modelica_metatype _len, modelica_metatype _phi)
{
  modelica_real tmp1;
  modelica_real tmp2;
  Complex _c;
  modelica_metatype out_c;
  modelica_metatype tmpMeta[2] __attribute__((unused)) = {0};
  tmp1 = mmc_unbox_real(_len);
  tmp2 = mmc_unbox_real(_phi);
  _c = omc_Modelica_ComplexMath_fromPolar(threadData, tmp1, tmp2);
  tmpMeta[0] = mmc_mk_rcon(_c._re);
  tmpMeta[1] = mmc_mk_rcon(_c._im);
  out_c = mmc_mk_box3(3, &Complex__desc, tmpMeta[0], tmpMeta[1]);
  return out_c;
}

modelica_real omc_Modelica_Math_cos(threadData_t *threadData, modelica_real _u)
{
  double _u_ext;
  double _y_ext;
  modelica_real _y;
  _u_ext = (double)_u;
  _y_ext = cos(_u_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}
modelica_metatype boxptr_Modelica_Math_cos(threadData_t *threadData, modelica_metatype _u)
{
  modelica_real tmp1;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_real(_u);
  _y = omc_Modelica_Math_cos(threadData, tmp1);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

modelica_real omc_Modelica_Math_sin(threadData_t *threadData, modelica_real _u)
{
  double _u_ext;
  double _y_ext;
  modelica_real _y;
  _u_ext = (double)_u;
  _y_ext = sin(_u_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}
modelica_metatype boxptr_Modelica_Math_sin(threadData_t *threadData, modelica_metatype _u)
{
  modelica_real tmp1;
  modelica_real _y;
  modelica_metatype out_y;
  tmp1 = mmc_unbox_real(_u);
  _y = omc_Modelica_Math_sin(threadData, tmp1);
  out_y = mmc_mk_rcon(_y);
  return out_y;
}

#ifdef __cplusplus
}
#endif
