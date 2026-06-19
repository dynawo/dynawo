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

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Complex__omcQ_27constructor_27_fromReal( modelica_real _re, modelica_real _im) const
{
  Complex _result;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_1_2_construct( _result, _re, _im); // _result has no default value.
  _return: OMC_LABEL_UNUSED
  return _result;
}

ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexCurrentPuConnector ModelGeneratorPQ_Init::omc_Dynawo_Connectors_ComplexCurrentPuConnector( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Connectors_ComplexCurrentPuConnector tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexVoltagePuConnector ModelGeneratorPQ_Init::omc_Dynawo_Connectors_ComplexVoltagePuConnector( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Connectors_ComplexVoltagePuConnector tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Dynawo_Connectors_ComplexVoltagePuConnector__omcQ_27_2A_27_multiply( Complex _c1, Complex _c2)
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

ModelGeneratorPQ_Init::Dynawo_Types_ComplexApparentPowerPu ModelGeneratorPQ_Init::omc_Dynawo_Types_ComplexApparentPowerPu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_ComplexApparentPowerPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Modelica_ComplexMath_conj( Complex _c1)
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

ModelGeneratorPQ_Init::Complex ModelGeneratorPQ_Init::omc_Modelica_ComplexMath_fromPolar( modelica_real _len, modelica_real _phi)
{
  Complex _c;
  Complex tmp1;
  _tailrecursive: OMC_LABEL_UNUSED
  Complex_construct( _c); // _c has no default value.
  tmp1 = omc_Complex__omcQ_27constructor_27_fromReal( (_len) * (cos(_phi)), (_len) * (sin(_phi)));
  Complex_copy(tmp1, _c);;
  _return: OMC_LABEL_UNUSED
  return _c;
}

void ModelGeneratorPQ_Init::Complex_construct_p( void* v_ths ) const {
  Complex* ths = (Complex*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Init::Complex_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) const {
  Complex* dst = (Complex*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Init::Complex_copy_p(void* v_src, void* v_dst) const {
  Complex* src = (Complex*)(v_src);
  Complex* dst = (Complex*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Init::Complex_1_2_construct_p( void* v_ths , modelica_real in_re, modelica_real in_im) const {
  Complex* ths = (Complex*)(v_ths);
  ths->_re = in_re;
  ths->_im = in_im;
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexCurrentPuConnector_construct_p( void* v_ths ) {
  Dynawo_Connectors_ComplexCurrentPuConnector* ths = (Dynawo_Connectors_ComplexCurrentPuConnector*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexCurrentPuConnector_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Connectors_ComplexCurrentPuConnector* dst = (Dynawo_Connectors_ComplexCurrentPuConnector*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexCurrentPuConnector_copy_p(void* v_src, void* v_dst) {
  Dynawo_Connectors_ComplexCurrentPuConnector* src = (Dynawo_Connectors_ComplexCurrentPuConnector*)(v_src);
  Dynawo_Connectors_ComplexCurrentPuConnector* dst = (Dynawo_Connectors_ComplexCurrentPuConnector*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexVoltagePuConnector_construct_p( void* v_ths ) {
  Dynawo_Connectors_ComplexVoltagePuConnector* ths = (Dynawo_Connectors_ComplexVoltagePuConnector*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexVoltagePuConnector_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Connectors_ComplexVoltagePuConnector* dst = (Dynawo_Connectors_ComplexVoltagePuConnector*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Init::Dynawo_Connectors_ComplexVoltagePuConnector_copy_p(void* v_src, void* v_dst) {
  Dynawo_Connectors_ComplexVoltagePuConnector* src = (Dynawo_Connectors_ComplexVoltagePuConnector*)(v_src);
  Dynawo_Connectors_ComplexVoltagePuConnector* dst = (Dynawo_Connectors_ComplexVoltagePuConnector*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

void ModelGeneratorPQ_Init::Dynawo_Types_ComplexApparentPowerPu_construct_p( void* v_ths ) {
  Dynawo_Types_ComplexApparentPowerPu* ths = (Dynawo_Types_ComplexApparentPowerPu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void ModelGeneratorPQ_Init::Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p( void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void ModelGeneratorPQ_Init::Dynawo_Types_ComplexApparentPowerPu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexApparentPowerPu* src = (Dynawo_Types_ComplexApparentPowerPu*)(v_src);
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

}