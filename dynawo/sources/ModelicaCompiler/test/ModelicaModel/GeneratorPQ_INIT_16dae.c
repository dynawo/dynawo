/* DAE residuals */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "simulation/solver/dae_mode.h"

#ifdef __cplusplus
extern "C" {
#endif

/*residual equations*/

/*
equation index: 8
type: SIMPLE_ASSIGN
generator._QGen0Pu = -generator.Q0Pu
*/
void GeneratorPQ_INIT_eqFunction_8(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,8};
  data->localData[0]->realVars[1] /* generator.QGen0Pu variable */ = (-data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */);
  TRACE_POP
}
/*
equation index: 9
type: SIMPLE_ASSIGN
generator._PGen0Pu = -generator.P0Pu
*/
void GeneratorPQ_INIT_eqFunction_9(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,9};
  data->localData[0]->realVars[0] /* generator.PGen0Pu variable */ = (-data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */);
  TRACE_POP
}
/*
equation index: 10
type: SIMPLE_ASSIGN
generator._s0Pu._re = generator.P0Pu
*/
void GeneratorPQ_INIT_eqFunction_10(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,10};
  data->localData[0]->realVars[5] /* generator.s0Pu.re variable */ = data->simulationInfo->realParameter[0] /* generator.P0Pu PARAM */;
  TRACE_POP
}
/*
equation index: 11
type: SIMPLE_ASSIGN
generator._s0Pu._im = generator.Q0Pu
*/
void GeneratorPQ_INIT_eqFunction_11(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,11};
  data->localData[0]->realVars[4] /* generator.s0Pu.im variable */ = data->simulationInfo->realParameter[1] /* generator.Q0Pu PARAM */;
  TRACE_POP
}
/*
equation index: 12
type: SIMPLE_ASSIGN
$cse2 = cos(generator.UPhase0)
*/
void GeneratorPQ_INIT_eqFunction_12(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,12};
  $P$cse2 = cos(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);
  TRACE_POP
}
/*
equation index: 13
type: SIMPLE_ASSIGN
generator._u0Pu._re = generator.U0Pu * $cse2
*/
void GeneratorPQ_INIT_eqFunction_13(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,13};
  data->localData[0]->realVars[7] /* generator.u0Pu.re variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($P$cse2);
  TRACE_POP
}
/*
equation index: 14
type: SIMPLE_ASSIGN
$cse1 = sin(generator.UPhase0)
*/
void GeneratorPQ_INIT_eqFunction_14(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,14};
  $P$cse1 = sin(data->simulationInfo->realParameter[3] /* generator.UPhase0 PARAM */);
  TRACE_POP
}
/*
equation index: 15
type: SIMPLE_ASSIGN
generator._u0Pu._im = generator.U0Pu * $cse1
*/
void GeneratorPQ_INIT_eqFunction_15(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,15};
  data->localData[0]->realVars[6] /* generator.u0Pu.im variable */ = (data->simulationInfo->realParameter[2] /* generator.U0Pu PARAM */) * ($P$cse1);
  TRACE_POP
}
/*
equation index: 16
type: SIMPLE_ASSIGN
$DAEres0 = generator.u0Pu.im * generator.i0Pu.re + (-generator.u0Pu.re) * generator.i0Pu.im - generator.s0Pu.im
*/
void GeneratorPQ_INIT_eqFunction_16(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,16};
  $P$DAEres0 = (data->localData[0]->realVars[6] /* generator.u0Pu.im variable */) * (data->localData[0]->realVars[3] /* generator.i0Pu.re variable */) + ((-data->localData[0]->realVars[7] /* generator.u0Pu.re variable */)) * (data->localData[0]->realVars[2] /* generator.i0Pu.im variable */) - data->localData[0]->realVars[4] /* generator.s0Pu.im variable */;
  TRACE_POP
}
/*
equation index: 17
type: SIMPLE_ASSIGN
$DAEres1 = generator.u0Pu.im * generator.i0Pu.im + generator.u0Pu.re * generator.i0Pu.re - generator.s0Pu.re
*/
void GeneratorPQ_INIT_eqFunction_17(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  const int equationIndexes[2] = {1,17};
  $P$DAEres1 = (data->localData[0]->realVars[6] /* generator.u0Pu.im variable */) * (data->localData[0]->realVars[2] /* generator.i0Pu.im variable */) + (data->localData[0]->realVars[7] /* generator.u0Pu.re variable */) * (data->localData[0]->realVars[3] /* generator.i0Pu.re variable */) - data->localData[0]->realVars[5] /* generator.s0Pu.re variable */;
  TRACE_POP
}

/* for residuals DAE variables */
OMC_DISABLE_OPT
int GeneratorPQ_INIT_evaluateDAEResiduals(DATA *data, threadData_t *threadData, int currentEvalStage)
{
  TRACE_PUSH
  int evalStages;
  data->simulationInfo->callStatistics.functionEvalDAE++;

  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_8(data, threadData);
  evalStages = 0+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_9(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_10(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_11(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_12(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_13(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_14(data, threadData);
  evalStages = 0+1+2+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_15(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_16(data, threadData);
  evalStages = 0+1+8;
  if ((evalStages & currentEvalStage) && !((currentEvalStage!=EVAL_DISCRETE)?(0):0))
    GeneratorPQ_INIT_eqFunction_17(data, threadData);
  
  TRACE_POP
  return 0;
}

/* initialize the daeMode variables */
OMC_DISABLE_OPT
int GeneratorPQ_INIT_initializeDAEmodeData(DATA *inData, DAEMODE_DATA* daeModeData)
{
  TRACE_PUSH
  DATA* data = ((DATA*)inData);
  /* sparse patterns */
  const int colPtrIndex[1+2] = {0,2,2};
  const int rowIndex[4] = {0,1,0,1};
  const int algIndexes[2] = {2,3};
  int i = 0;
  
  daeModeData->nResidualVars = 2;
  daeModeData->nAlgebraicDAEVars = 2;
  daeModeData->nAuxiliaryVars = 2;
  
  daeModeData->residualVars = (double*) malloc(sizeof(double)*2);
  daeModeData->auxiliaryVars = (double*) malloc(sizeof(double)*2);
  
  /* set the function pointer */
  daeModeData->evaluateDAEResiduals = GeneratorPQ_INIT_evaluateDAEResiduals;
  
  /* prepare algebraic indexes */
  daeModeData->algIndexes = (int*) malloc(sizeof(int)*2);
  memcpy(daeModeData->algIndexes, algIndexes, 2*sizeof(int));
  /* intialize sparse pattern */
  daeModeData->sparsePattern = (SPARSE_PATTERN*) malloc(sizeof(SPARSE_PATTERN));
  
  daeModeData->sparsePattern->leadindex = (unsigned int*) malloc((2+1)*sizeof(int));
  daeModeData->sparsePattern->index = (unsigned int*) malloc(4*sizeof(int));
  daeModeData->sparsePattern->numberOfNoneZeros = 4;
  daeModeData->sparsePattern->colorCols = (unsigned int*) malloc(2*sizeof(int));
  daeModeData->sparsePattern->maxColors = 2;
  
  /* write lead index of compressed sparse column */
  memcpy(daeModeData->sparsePattern->leadindex, colPtrIndex, (1+2)*sizeof(int));
  /* makek CRS compatible */
  for(i=2;i<2+1;++i)
    daeModeData->sparsePattern->leadindex[i] += daeModeData->sparsePattern->leadindex[i-1];
  /* call sparse index */
  memcpy(daeModeData->sparsePattern->index, rowIndex, 4*sizeof(int));
  
  /* write color array */
  daeModeData->sparsePattern->colorCols[1] = 1;
  daeModeData->sparsePattern->colorCols[0] = 2;
  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
