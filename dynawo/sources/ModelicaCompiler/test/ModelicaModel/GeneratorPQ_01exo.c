/* External objects file */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif

void GeneratorPQ_callExternalObjectDestructors(DATA *data, threadData_t *threadData)
{
  if(data->simulationInfo->extObjs)
  {
    free(data->simulationInfo->extObjs);
    data->simulationInfo->extObjs = 0;
  }
}
#if defined(__cplusplus)
}
#endif

