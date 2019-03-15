#include <math.h>
#include "DYNModelManager.h"
#include "GeneratorPQ_Init_literal.h"
#include "GeneratorPQ_Init.h"
namespace DYN {



ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex( modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex__omcQuot_2B( Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex( _c1._re + _c2._re, _c1._im + _c2._im);
  _c3._re = tmp1._re;
  _c3._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c3;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex__omcQuot_2A_multiply( Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex( (_c1._re) * (_c2._re) - ((_c1._im) * (_c2._im)), (_c1._re) * (_c2._im) + (_c1._im) * (_c2._re));
  _c3._re = tmp1._re;
  _c3._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c3;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex__omcQuot_2A_scalarProduct( Complex_array _c1, Complex_array _c2)
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
      tmp3 = omc_Complex__omcQuot_2B( _c3, omc_Complex__omcQuot_2A_multiply(  (*((Complex*)(generic_array_element_addr(&_c1, sizeof(Complex), 1, /* modelica_integer */ (modelica_integer)_i)))),  (*((Complex*)(generic_array_element_addr(&_c2, sizeof(Complex), 1, /* modelica_integer */ (modelica_integer)_i))))));
      _c3._re = tmp3._re;
      _c3._im = tmp3._im;
    }
  }
  _return: OMC_LABEL_UNUSED
  return _c3;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex__omcQuot_636F6E7374727563746F72_fromReal( modelica_real _re, modelica_real _im)
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  _result = omc_Complex( _re, _im);
  _return: OMC_LABEL_UNUSED
  return _result;
}

ModelGeneratorPQ_Init::Dynawo_Types_AC_ApparentPower ModelGeneratorPQ_Init::omc_Dynawo_Types_AC_ApparentPower( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Dynawo_Types_AC_Current ModelGeneratorPQ_Init::omc_Dynawo_Types_AC_Current( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Dynawo_Types_AC_Voltage ModelGeneratorPQ_Init::omc_Dynawo_Types_AC_Voltage( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Modelica_ComplexMath_conj( Complex _c1)
{
  Complex _c2;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex( _c1._re, (-_c1._im));
  _c2._re = tmp1._re;
  _c2._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c2;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Modelica_ComplexMath_fromPolar( modelica_real _len, modelica_real _phi)
{
  Complex _c;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex( (_len) * (cos(_phi)), (_len) * (sin(_phi)));
  _c._re = tmp1._re;
  _c._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c;
}

modelica_real ModelGeneratorPQ_Init::omc_Modelica_Math_cos( modelica_real _u)
{
  double _u_ext;
  double _y_ext;
  modelica_real _y;
  _u_ext = (double)_u;
  _y_ext = cos(_u_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}

modelica_real ModelGeneratorPQ_Init::omc_Modelica_Math_sin( modelica_real _u)
{
  double _u_ext;
  double _y_ext;
  modelica_real _y;
  _u_ext = (double)_u;
  _y_ext = sin(_u_ext);
  _y = (modelica_real)_y_ext;
  return _y;
}

}