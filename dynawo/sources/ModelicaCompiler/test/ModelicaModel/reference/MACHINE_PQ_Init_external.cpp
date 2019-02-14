#include <math.h>
#include "DYNModelManager.h"
#include "MACHINE_PQ_Init_literal.h"
#include "MACHINE_PQ_Init.h"
namespace DYN {



ModelMACHINE_PQ_Init::Dynawo_Types_AC_ApparentPower ModelMACHINE_PQ_Init::omc_Dynawo_Types_AC_ApparentPower( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_ApparentPower tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Init::Complex ModelMACHINE_PQ_Init::omc_Complex( modelica_real omc_re, modelica_real omc_im)
{
  Complex tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Init::Dynawo_Types_AC_Current ModelMACHINE_PQ_Init::omc_Dynawo_Types_AC_Current( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Current tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

ModelMACHINE_PQ_Init::Dynawo_Types_AC_Voltage ModelMACHINE_PQ_Init::omc_Dynawo_Types_AC_Voltage( modelica_real omc_re, modelica_real omc_im)
{
  Dynawo_Types_AC_Voltage tmp1;
  tmp1._re = omc_re;
  tmp1._im = omc_im;
  return tmp1;
}

}