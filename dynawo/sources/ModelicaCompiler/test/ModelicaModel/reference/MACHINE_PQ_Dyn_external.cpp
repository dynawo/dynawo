#include <math.h>
#include "DYNModelManager.h"
#include "MACHINE_PQ_Dyn_literal.h"
#include "MACHINE_PQ_Dyn.h"
namespace DYN {



ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower$MACHINE$SGenPu tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Dyn::Complex ModelMACHINE_PQ_Dyn::omc_Complex( modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_ApparentPower ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_ApparentPower( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

void ModelMACHINE_PQ_Dyn::omc_Dynawo_NonElectrical_Logs_Timeline_logEvent1( modelica_integer _key)
{
  int _key_ext;
  _key_ext = (int)_key;
  addLogEvent1(_key_ext);
  return;
}

ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_Current$MACHINE$terminal$i ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_Current$MACHINE$terminal$i( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current$MACHINE$terminal$i tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_Current ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_Current( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_Voltage ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_Voltage( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Dyn::Dynawo_Types_AC_Voltage$MACHINE$terminal$V ModelMACHINE_PQ_Dyn::omc_Dynawo_Types_AC_Voltage$MACHINE$terminal$V( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage$MACHINE$terminal$V tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

}