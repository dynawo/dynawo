
#include "MACHINE_PQ_functions.h"
#ifdef __cplusplus
extern "C" {
#endif

#include "MACHINE_PQ_literals.h"
#include "MACHINE_PQ_includes.h"



Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu omc_Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu__desc, _re, _im);
}


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


void omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData_t *threadData, modelica_integer _key)
{
  int _key_ext;
  _key_ext = (int)_key;
  addLogEvent1(_key_ext);
  return;
}
void boxptr_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData_t *threadData, modelica_metatype _key)
{
  modelica_integer tmp1;
  tmp1 = mmc_unbox_integer(_key);
  omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1(threadData, tmp1);
  return;
}
Dynawo_Types_AC_Current$MACHINE$terminal$i omc_Dynawo_Types_AC_Current$MACHINE$terminal$i(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current$MACHINE$terminal$i tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Current$MACHINE$terminal$i(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Current$MACHINE$terminal$i__desc, _re, _im);
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


Dynawo_Types_AC_Voltage$MACHINE$terminal$V omc_Dynawo_Types_AC_Voltage$MACHINE$terminal$V(threadData_t *threadData, modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage$MACHINE$terminal$V tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

modelica_metatype boxptr_Dynawo_Types_AC_Voltage$MACHINE$terminal$V(threadData_t *threadData, modelica_metatype _re, modelica_metatype _im)
{
  return mmc_mk_box3(3, &Dynawo_Types_AC_Voltage$MACHINE$terminal$V__desc, _re, _im);
}


#ifdef __cplusplus
}
#endif
