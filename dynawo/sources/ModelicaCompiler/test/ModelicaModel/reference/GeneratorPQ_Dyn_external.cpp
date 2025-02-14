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

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQ_27_2D_27_negate( Complex _c1) const
{
  Complex _c2;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct( _c2); // _c2 has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal( (-_c1._re), (-_c1._im));
  Complex_copy(tmp1, _c2);;
  _return: OMC_LABEL_UNUSED
  return _c2;
}

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Complex__omcQ_27constructor_27_fromReal( modelica_real _re, modelica_real _im) const
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_1_2_construct( _result, _re, _im); // _result has no default value.
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

ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexApparentPowerPu ModelGeneratorPQ_Dyn::omc_Dynawo_Types_ComplexApparentPowerPu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_ComplexApparentPowerPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexCurrentPu ModelGeneratorPQ_Dyn::omc_Dynawo_Types_ComplexCurrentPu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_ComplexCurrentPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexVoltagePu ModelGeneratorPQ_Dyn::omc_Dynawo_Types_ComplexVoltagePu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_ComplexVoltagePu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Dyn::Complex ModelGeneratorPQ_Dyn::omc_Dynawo_Types_ComplexVoltagePu__omcQ_27_2A_27_multiply( Complex _c1, Complex _c2)
{
  Complex _c3;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct( _c3); // _c3 has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal( (_c1._re) * (_c2._re) - ((_c1._im) * (_c2._im)), (_c1._re) * (_c2._im) + (_c1._im) * (_c2._re));
  Complex_copy(tmp1, _c3);;
  _return: OMC_LABEL_UNUSED
  return _c3;
}

modelica_real ModelGeneratorPQ_Dyn::omc_Modelica_ComplexMath__omcQ_27abs_27( Complex _c)
{
  modelica_real _result;
  modelica_real tmp1;
  modelica_real tmp2;
  modelica_real tmp3;
  _tailrecursive: OMC_LABEL_UNUSED
  // _result has no default value.
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
  Complex_construct( _c2); // _c2 has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal( _c1._re, (-_c1._im));
  Complex_copy(tmp1, _c2);;
  _return: OMC_LABEL_UNUSED
  return _c2;
}

void ModelGeneratorPQ_Dyn::Complex_construct_p( void* v_ths ) const {
  Complex* ths = (Complex*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Dyn::Complex_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) const {
  Complex* dst = (Complex*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Dyn::Complex_copy_p(void* v_src, void* v_dst) const {
  Complex* src = (Complex*)(v_src);
  Complex* dst = (Complex*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Dyn::Complex_1_2_construct_p( void* v_ths , modelica_real in_re, modelica_real in_im) const {
  Complex* ths = (Complex*)(v_ths);
  ths->_re = in_re;
  ths->_im = in_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexApparentPowerPu_construct_p( void* v_ths ) {
  Dynawo_Types_ComplexApparentPowerPu* ths = (Dynawo_Types_ComplexApparentPowerPu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexApparentPowerPu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexApparentPowerPu* src = (Dynawo_Types_ComplexApparentPowerPu*)(v_src);
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexCurrentPu_construct_p( void* v_ths ) {
  Dynawo_Types_ComplexCurrentPu* ths = (Dynawo_Types_ComplexCurrentPu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexCurrentPu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexCurrentPu* dst = (Dynawo_Types_ComplexCurrentPu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexCurrentPu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexCurrentPu* src = (Dynawo_Types_ComplexCurrentPu*)(v_src);
  Dynawo_Types_ComplexCurrentPu* dst = (Dynawo_Types_ComplexCurrentPu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexVoltagePu_construct_p( void* v_ths ) {
  Dynawo_Types_ComplexVoltagePu* ths = (Dynawo_Types_ComplexVoltagePu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexVoltagePu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexVoltagePu* dst = (Dynawo_Types_ComplexVoltagePu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Dyn::Dynawo_Types_ComplexVoltagePu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexVoltagePu* src = (Dynawo_Types_ComplexVoltagePu*)(v_src);
  Dynawo_Types_ComplexVoltagePu* dst = (Dynawo_Types_ComplexVoltagePu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

}