/* Algebraic */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"

#ifdef __cplusplus
extern "C" {
#endif

/* for continuous time variables */
int GeneratorPQ_functionAlgebraics(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  
  data->simulationInfo->callStatistics.functionAlgebraics++;
  
  /* no Alg systems */

  GeneratorPQ_function_savePreSynchronous(data, threadData);
  
  TRACE_POP
  return 0;
}

#ifdef __cplusplus
}
#endif
