

#include "omc_simulation_settings.h"
#include "meta/meta_modelica.h"
#include "GeneratorPQ_functions.h"

#ifdef __cplusplus
extern "C" {
#endif

#define Complex__desc_added 1
const char* Complex__desc__fields[2] = {"re","im"};
struct record_description Complex__desc = {
  "Complex", /* package_record__X */
  "Complex", /* package.record_X */
  Complex__desc__fields
};

void Complex_construct_p(threadData_t *threadData, void* v_ths ) {
  Complex* ths = (Complex*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void Complex_wrap_vars_p(threadData_t *threadData, void* v_dst , modelica_real in_re, modelica_real in_im) {
  Complex* dst = (Complex*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void Complex_copy_p(void* v_src, void* v_dst) {
  Complex* src = (Complex*)(v_src);
  Complex* dst = (Complex*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}


void Complex_1_2_construct_p(threadData_t *threadData, void* v_ths , modelica_real in_re, modelica_real in_im) {
  Complex* ths = (Complex*)(v_ths);
  ths->_re = in_re;
  ths->_im = in_im;
}

#define Dynawo_Types_ComplexApparentPowerPu__desc_added 1
const char* Dynawo_Types_ComplexApparentPowerPu__desc__fields[2] = {"re","im"};
struct record_description Dynawo_Types_ComplexApparentPowerPu__desc = {
  "Dynawo_Types_ComplexApparentPowerPu", /* package_record__X */
  "Dynawo.Types.ComplexApparentPowerPu", /* package.record_X */
  Dynawo_Types_ComplexApparentPowerPu__desc__fields
};

void Dynawo_Types_ComplexApparentPowerPu_construct_p(threadData_t *threadData, void* v_ths ) {
  Dynawo_Types_ComplexApparentPowerPu* ths = (Dynawo_Types_ComplexApparentPowerPu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void Dynawo_Types_ComplexApparentPowerPu_wrap_vars_p(threadData_t *threadData, void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void Dynawo_Types_ComplexApparentPowerPu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexApparentPowerPu* src = (Dynawo_Types_ComplexApparentPowerPu*)(v_src);
  Dynawo_Types_ComplexApparentPowerPu* dst = (Dynawo_Types_ComplexApparentPowerPu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}


#define Dynawo_Types_ComplexCurrentPu__desc_added 1
const char* Dynawo_Types_ComplexCurrentPu__desc__fields[2] = {"re","im"};
struct record_description Dynawo_Types_ComplexCurrentPu__desc = {
  "Dynawo_Types_ComplexCurrentPu", /* package_record__X */
  "Dynawo.Types.ComplexCurrentPu", /* package.record_X */
  Dynawo_Types_ComplexCurrentPu__desc__fields
};

void Dynawo_Types_ComplexCurrentPu_construct_p(threadData_t *threadData, void* v_ths ) {
  Dynawo_Types_ComplexCurrentPu* ths = (Dynawo_Types_ComplexCurrentPu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void Dynawo_Types_ComplexCurrentPu_wrap_vars_p(threadData_t *threadData, void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexCurrentPu* dst = (Dynawo_Types_ComplexCurrentPu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void Dynawo_Types_ComplexCurrentPu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexCurrentPu* src = (Dynawo_Types_ComplexCurrentPu*)(v_src);
  Dynawo_Types_ComplexCurrentPu* dst = (Dynawo_Types_ComplexCurrentPu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}


#define Dynawo_Types_ComplexVoltagePu__desc_added 1
const char* Dynawo_Types_ComplexVoltagePu__desc__fields[2] = {"re","im"};
struct record_description Dynawo_Types_ComplexVoltagePu__desc = {
  "Dynawo_Types_ComplexVoltagePu", /* package_record__X */
  "Dynawo.Types.ComplexVoltagePu", /* package.record_X */
  Dynawo_Types_ComplexVoltagePu__desc__fields
};

void Dynawo_Types_ComplexVoltagePu_construct_p(threadData_t *threadData, void* v_ths ) {
  Dynawo_Types_ComplexVoltagePu* ths = (Dynawo_Types_ComplexVoltagePu*)(v_ths);
  // ths->_re has no default value.
  // ths->_im has no default value.
}

void Dynawo_Types_ComplexVoltagePu_wrap_vars_p(threadData_t *threadData, void* v_dst , modelica_real in_re, modelica_real in_im) {
  Dynawo_Types_ComplexVoltagePu* dst = (Dynawo_Types_ComplexVoltagePu*)(v_dst);
  dst->_re = in_re;
  dst->_im = in_im;
}

void Dynawo_Types_ComplexVoltagePu_copy_p(void* v_src, void* v_dst) {
  Dynawo_Types_ComplexVoltagePu* src = (Dynawo_Types_ComplexVoltagePu*)(v_src);
  Dynawo_Types_ComplexVoltagePu* dst = (Dynawo_Types_ComplexVoltagePu*)(v_dst);
  dst->_re = src->_re;
  dst->_im = src->_im;
}

#ifdef __cplusplus
}
#endif
