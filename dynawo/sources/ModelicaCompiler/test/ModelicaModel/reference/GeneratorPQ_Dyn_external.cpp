#include <math.h>
#include "DYNModelManager.h"
#include "GeneratorPQ_Dyn_literal.h"
#include "GeneratorPQ_Dyn.h"
namespace DYN {



ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex( modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQuot_2B( Complex _c1, Complex _c2)
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

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQuot_2A_multiply( Complex _c1, Complex _c2)
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

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQuot_2A_scalarProduct( Complex_array _c1, Complex_array _c2)
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

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQuot_2D_negate( Complex _c1)
{
  Complex _c2;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = omc_Complex( (-_c1._re), (-_c1._im));
  _c2._re = tmp1._re;
  _c2._im = tmp1._im;
  _return: OMC_LABEL_UNUSED
  return _c2;
}

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQuot_636F6E7374727563746F72_fromReal( modelica_real _re, modelica_real _im)
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  _result = omc_Complex( _re, _im);
  _return: OMC_LABEL_UNUSED
  return _result;
}

void ModelGeneratorPQ_Dyn::omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( modelica_integer _key)
{
  int _key_ext;
  _key_ext = (int)_key;
  addLogEvent1(_key_ext);
  return;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_ApparentPower ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_ApparentPower( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_ApparentPower$generator$SGenPu ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_ApparentPower$generator$SGenPu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower$generator$SGenPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_Current ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_Current( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_Current$generator$terminal$i ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_Current$generator$terminal$i( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current$generator$terminal$i tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_Voltage ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_Voltage( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_AC_Voltage$generator$terminal$V ModelGeneratorPQ_Dyn::omc_Dynawo_Types_AC_Voltage$generator$terminal$V( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage$generator$terminal$V tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_real ModelGeneratorPQ_Dyn::omc_Modelica_ComplexMath__omcQuot_616273( Complex _c)
{
  modelica_real _result;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  _tailrecursive: OMC_LABEL_UNUSED
  tmp1 = _c._re;
  tmp2 = _c._im;
  _result = sqrt((tmp1 * tmp1) + (tmp2 * tmp2));
  _return: OMC_LABEL_UNUSED
  return _result;
}

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Modelica_ComplexMath_conj( Complex _c1)
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

}