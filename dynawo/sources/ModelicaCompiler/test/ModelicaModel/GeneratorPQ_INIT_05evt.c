/* Events: Sample, Zero Crossings, Relations, Discrete Changes */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif

/* Initializes the raw time events of the simulation using the now
   calcualted parameters. */
void GeneratorPQ_INIT_function_initSample(DATA *data, threadData_t *threadData)
{
  long i=0;
}

const char *GeneratorPQ_INIT_zeroCrossingDescription(int i, int **out_EquationIndexes)
{
  *out_EquationIndexes = NULL;
  return "empty";
}

/* forwarded equations */

int GeneratorPQ_INIT_function_ZeroCrossingsEquations(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  data->simulationInfo->callStatistics.functionZeroCrossingsEquations++;

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_function_ZeroCrossings(DATA *data, threadData_t *threadData, double *gout)
{
  TRACE_PUSH
  
  data->simulationInfo->callStatistics.functionZeroCrossings++;
  
  
  TRACE_POP
  return 0;
}

const char *GeneratorPQ_INIT_relationDescription(int i)
{
  return "empty";
}

int GeneratorPQ_INIT_function_updateRelations(DATA *data, threadData_t *threadData, int evalforZeroCross)
{
  TRACE_PUSH
  
  if(evalforZeroCross) {
  } else {
  }
  
  TRACE_POP
  return 0;
}

#if defined(__cplusplus)
}
#endif

