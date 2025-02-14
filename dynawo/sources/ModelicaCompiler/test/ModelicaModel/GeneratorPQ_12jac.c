/* Jacobians 7 */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "GeneratorPQ_12jac.h"
#include "simulation/jacobian_util.h"
#include "util/omc_file.h"
/* constant equations */
/* dynamic equations */

/*
equation index: 37
type: SIMPLE_ASSIGN
generator.PGenPu.$pDERLSJac0.dummyVarLSJac0 = (-generator.terminal.V.re) * generator.terminal.i.re.SeedLSJac0 - generator.terminal.V.im * generator.terminal.i.im.SeedLSJac0
*/
void GeneratorPQ_eqFunction_37(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int baseClockIndex = 0;
  const int subClockIndex = 0;
  const int equationIndexes[2] = {1,37};
  jacobian->tmpVars[0] /* generator.PGenPu.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_TMP_VAR */ = ((-(data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */))) * (jacobian->seedVars[1] /* generator.terminal.i.re.SeedLSJac0 SEED_VAR */) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * (jacobian->seedVars[0] /* generator.terminal.i.im.SeedLSJac0 SEED_VAR */));
  TRACE_POP
}

/*
equation index: 38
type: SIMPLE_ASSIGN
generator.SGenPu.im.$pDERLSJac0.dummyVarLSJac0 = generator.terminal.V.re * generator.terminal.i.im.SeedLSJac0 - generator.terminal.V.im * generator.terminal.i.re.SeedLSJac0
*/
void GeneratorPQ_eqFunction_38(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int baseClockIndex = 0;
  const int subClockIndex = 1;
  const int equationIndexes[2] = {1,38};
  jacobian->tmpVars[1] /* generator.SGenPu.im.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_TMP_VAR */ = ((data->localData[0]->realVars[3] /* generator.terminal.V.re STATE(1) */)) * (jacobian->seedVars[0] /* generator.terminal.i.im.SeedLSJac0 SEED_VAR */) - (((data->localData[0]->realVars[2] /* generator.terminal.V.im STATE(1) */)) * (jacobian->seedVars[1] /* generator.terminal.i.re.SeedLSJac0 SEED_VAR */));
  TRACE_POP
}

/*
equation index: 39
type: SIMPLE_ASSIGN
$res_LSJac0_1.$pDERLSJac0.dummyVarLSJac0 = if generator.running.value then generator.SGenPu.im.$pDERLSJac0.dummyVarLSJac0 else generator.terminal.i.im.SeedLSJac0
*/
void GeneratorPQ_eqFunction_39(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int baseClockIndex = 0;
  const int subClockIndex = 2;
  const int equationIndexes[2] = {1,39};
  modelica_boolean tmp30;
  modelica_real tmp31;
  tmp30 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp30)
  {
    tmp31 = jacobian->tmpVars[1] /* generator.SGenPu.im.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_TMP_VAR */;
  }
  else
  {
    tmp31 = jacobian->seedVars[0] /* generator.terminal.i.im.SeedLSJac0 SEED_VAR */;
  }
  jacobian->resultVars[0] /* $res_LSJac0_1.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_VAR */ = tmp31;
  TRACE_POP
}

/*
equation index: 40
type: SIMPLE_ASSIGN
$res_LSJac0_2.$pDERLSJac0.dummyVarLSJac0 = if generator.running.value then generator.PGenPu.$pDERLSJac0.dummyVarLSJac0 else generator.terminal.i.re.SeedLSJac0
*/
void GeneratorPQ_eqFunction_40(DATA *data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  const int baseClockIndex = 0;
  const int subClockIndex = 3;
  const int equationIndexes[2] = {1,40};
  modelica_boolean tmp32;
  modelica_real tmp33;
  tmp32 = (modelica_boolean)(data->localData[0]->booleanVars[9] /* generator.running.value DISCRETE */);
  if(tmp32)
  {
    tmp33 = jacobian->tmpVars[0] /* generator.PGenPu.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_TMP_VAR */;
  }
  else
  {
    tmp33 = jacobian->seedVars[1] /* generator.terminal.i.re.SeedLSJac0 SEED_VAR */;
  }
  jacobian->resultVars[1] /* $res_LSJac0_2.$pDERLSJac0.dummyVarLSJac0 JACOBIAN_VAR */ = tmp33;
  TRACE_POP
}

OMC_DISABLE_OPT
int GeneratorPQ_functionJacLSJac0_constantEqns(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  int index = GeneratorPQ_INDEX_JAC_LSJac0;

  TRACE_POP
  return 0;
}

int GeneratorPQ_functionJacLSJac0_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH

  int index = GeneratorPQ_INDEX_JAC_LSJac0;
  GeneratorPQ_eqFunction_37(data, threadData, jacobian, parentJacobian);
  GeneratorPQ_eqFunction_38(data, threadData, jacobian, parentJacobian);
  GeneratorPQ_eqFunction_39(data, threadData, jacobian, parentJacobian);
  GeneratorPQ_eqFunction_40(data, threadData, jacobian, parentJacobian);
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacH_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacF_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacD_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacC_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacB_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}
int GeneratorPQ_functionJacA_column(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian, ANALYTIC_JACOBIAN *parentJacobian)
{
  TRACE_PUSH
  TRACE_POP
  return 0;
}

OMC_DISABLE_OPT
int GeneratorPQ_initialAnalyticJacobianLSJac0(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  size_t count;

  FILE* pFile = openSparsePatternFile(data, threadData, "GeneratorPQ_JacLSJac0.bin");

  initAnalyticJacobian(jacobian, 2, 2, 4, NULL, jacobian->sparsePattern);
  jacobian->sparsePattern = allocSparsePattern(2, 4, 2);
  jacobian->availability = JACOBIAN_AVAILABLE;

  /* read lead index of compressed sparse column */
  count = omc_fread(jacobian->sparsePattern->leadindex, sizeof(unsigned int), 2+1, pFile, FALSE);
  if (count != 2+1) {
    throwStreamPrint(threadData, "Error while reading lead index list of sparsity pattern. Expected %d, got %zu", 2+1, count);
  }

  /* read sparse index */
  count = omc_fread(jacobian->sparsePattern->index, sizeof(unsigned int), 4, pFile, FALSE);
  if (count != 4) {
    throwStreamPrint(threadData, "Error while reading row index list of sparsity pattern. Expected %d, got %zu", 4, count);
  }

  /* write color array */
  /* color 1 with 1 columns */
  readSparsePatternColor(threadData, pFile, jacobian->sparsePattern->colorCols, 1, 1, 2);
  /* color 2 with 1 columns */
  readSparsePatternColor(threadData, pFile, jacobian->sparsePattern->colorCols, 2, 1, 2);

  omc_fclose(pFile);

  TRACE_POP
  return 0;
}
int GeneratorPQ_initialAnalyticJacobianH(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
int GeneratorPQ_initialAnalyticJacobianF(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
int GeneratorPQ_initialAnalyticJacobianD(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
int GeneratorPQ_initialAnalyticJacobianC(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
int GeneratorPQ_initialAnalyticJacobianB(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
int GeneratorPQ_initialAnalyticJacobianA(DATA* data, threadData_t *threadData, ANALYTIC_JACOBIAN *jacobian)
{
  TRACE_PUSH
  TRACE_POP
  jacobian->availability = JACOBIAN_NOT_AVAILABLE;
  return 1;
}
