/* DAE residuals */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "simulation/solver/dae_mode.h"

#ifdef __cplusplus
extern "C" {
#endif

/*residual equations*/

/*
equation index: 7
type: SIMPLE_ASSIGN
$DAEres1 = generator.u0Pu.im * generator.i0Pu.im + generator.u0Pu.re * generator.i0Pu.re - generator.P0Pu
*/
OMC_DISABLE_OPT
void GeneratorPQ_INIT_eqFunction_7(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,7};
  (data->simulationInfo->daeModeData->residualVars[1]) /* $DAEres1 DAE_RESIDUAL_VAR */ = ((data->localData[0]->realVars[2] /* generator.u0Pu.im variable */)) * ((data->localData[0]->realVars[0] /* generator.i0Pu.im variable */)) + ((data->localData[0]->realVars[3] /* generator.u0Pu.re variable */)) * ((data->localData[0]->realVars[1] /* generator.i0Pu.re variable */)) - (data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);
  TRACE_POP
}
/*
equation index: 8
type: SIMPLE_ASSIGN
$DAEres0 = generator.u0Pu.im * generator.i0Pu.re + (-generator.u0Pu.re) * generator.i0Pu.im - generator.Q0Pu
*/
OMC_DISABLE_OPT
void GeneratorPQ_INIT_eqFunction_8(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,8};
  (data->simulationInfo->daeModeData->residualVars[0]) /* $DAEres0 DAE_RESIDUAL_VAR */ = ((data->localData[0]->realVars[2] /* generator.u0Pu.im variable */)) * ((data->localData[0]->realVars[1] /* generator.i0Pu.re variable */)) + ((-(data->localData[0]->realVars[3] /* generator.u0Pu.re variable */))) * ((data->localData[0]->realVars[0] /* generator.i0Pu.im variable */)) - (data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);
  TRACE_POP
}

/* for residuals DAE variables */
OMC_DISABLE_OPT
int GeneratorPQ_INIT_evaluateDAEResiduals(DATA *data, threadData_t *threadData, int currentEvalStage)
{
  TRACE_PUSH
  int evalStages;
  data->simulationInfo->callStatistics.functionEvalDAE++;

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_INIT_eqFunction_7(data, threadData);
    threadData->lastEquationSolved = 7;
  }
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0)) {
    GeneratorPQ_INIT_eqFunction_8(data, threadData);
    threadData->lastEquationSolved = 8;
  }

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif

  TRACE_POP
  return 0;
}

/* initialize the daeMode variables */
OMC_DISABLE_OPT
int GeneratorPQ_INIT_initializeDAEmodeData(DATA* data, DAEMODE_DATA* daeModeData)
{
  TRACE_PUSH
  /* sparse patterns */
  const int colPtrIndex[1+2] = {0,2,2};
  const int rowIndex[4] = {0,1,0,1};
  const int algIndexes[2] = {0,1};
  int i = 0;
  
  daeModeData->nResidualVars = 2;
  daeModeData->nAlgebraicDAEVars = 2;
  daeModeData->nAuxiliaryVars = 0;
  
  daeModeData->residualVars = (double*) malloc(sizeof(double)*2);
  daeModeData->auxiliaryVars = (double*) malloc(sizeof(double)*0);
  
  /* set the function pointer */
  daeModeData->evaluateDAEResiduals = GeneratorPQ_INIT_evaluateDAEResiduals;
  
  /* prepare algebraic indexes */
  daeModeData->algIndexes = (int*) malloc(sizeof(int)*2);
  memcpy(daeModeData->algIndexes, algIndexes, 2*sizeof(int));
  /* intialize sparse pattern */
  daeModeData->sparsePattern = allocSparsePattern(2, 4, 2);
  
  /* write lead index of compressed sparse column */
  memcpy(daeModeData->sparsePattern->leadindex, colPtrIndex, (1+2)*sizeof(int));
  /* makek CRS compatible */
  for(i=2;i<2+1;++i)
    daeModeData->sparsePattern->leadindex[i] += daeModeData->sparsePattern->leadindex[i-1];
  /* call sparse index */
  memcpy(daeModeData->sparsePattern->index, rowIndex, 4*sizeof(int));
  
  /* write color array */
  /* color 1 with 1 columns */
  const int indices_1[1] = {0};
  for(i=0; i<1; i++)
    daeModeData->sparsePattern->colorCols[indices_1[i]] = 1;

  /* color 2 with 1 columns */
  const int indices_2[1] = {1};
  for(i=0; i<1; i++)
    daeModeData->sparsePattern->colorCols[indices_2[i]] = 2;
  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
