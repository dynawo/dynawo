/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#include "simulation/solver/events.h"

/* FIXME these defines are ugly and hard to read, why not use direct function pointers instead? */
#define prefixedName_performSimulation GeneratorPQ_performSimulation
#define prefixedName_updateContinuousSystem GeneratorPQ_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation GeneratorPQ_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>


/* dummy VARINFO and FILEINFO */
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int GeneratorPQ_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int GeneratorPQ_dataReconciliationInputNames(DATA *data, char ** names){
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_dataReconciliationUnmeasuredVariables(DATA *data, char ** names)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_setb_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}


OMC_DISABLE_OPT
int GeneratorPQ_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  GeneratorPQ_functionLocalKnownVars(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int GeneratorPQ_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


int GeneratorPQ_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  GeneratorPQ_functionLocalKnownVars(data, threadData);
  /* no ODE systems */

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "GeneratorPQ_12jac.h"
#include "GeneratorPQ_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks GeneratorPQ_callback = {
   (int (*)(DATA *, threadData_t *, void *)) GeneratorPQ_performSimulation,    /* performSimulation */
   (int (*)(DATA *, threadData_t *, void *)) GeneratorPQ_performQSSSimulation,    /* performQSSSimulation */
   GeneratorPQ_updateContinuousSystem,    /* updateContinuousSystem */
   GeneratorPQ_callExternalObjectDestructors,    /* callExternalObjectDestructors */
   NULL,    /* initialNonLinearSystem */
   GeneratorPQ_initialLinearSystem,    /* initialLinearSystem */
   NULL,    /* initialMixedSystem */
   #if !defined(OMC_NO_STATESELECTION)
   GeneratorPQ_initializeStateSets,
   #else
   NULL,
   #endif    /* initializeStateSets */
   GeneratorPQ_initializeDAEmodeData,
   GeneratorPQ_functionODE,
   GeneratorPQ_functionAlgebraics,
   GeneratorPQ_functionDAE,
   GeneratorPQ_functionLocalKnownVars,
   GeneratorPQ_input_function,
   GeneratorPQ_input_function_init,
   GeneratorPQ_input_function_updateStartValues,
   GeneratorPQ_data_function,
   GeneratorPQ_output_function,
   GeneratorPQ_setc_function,
   GeneratorPQ_setb_function,
   GeneratorPQ_function_storeDelayed,
   GeneratorPQ_function_storeSpatialDistribution,
   GeneratorPQ_function_initSpatialDistribution,
   GeneratorPQ_updateBoundVariableAttributes,
   GeneratorPQ_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   NULL,
   GeneratorPQ_functionRemovedInitialEquations,
   GeneratorPQ_updateBoundParameters,
   GeneratorPQ_checkForAsserts,
   GeneratorPQ_function_ZeroCrossingsEquations,
   GeneratorPQ_function_ZeroCrossings,
   GeneratorPQ_function_updateRelations,
   GeneratorPQ_zeroCrossingDescription,
   GeneratorPQ_relationDescription,
   GeneratorPQ_function_initSample,
   GeneratorPQ_INDEX_JAC_A,
   GeneratorPQ_INDEX_JAC_B,
   GeneratorPQ_INDEX_JAC_C,
   GeneratorPQ_INDEX_JAC_D,
   GeneratorPQ_INDEX_JAC_F,
   GeneratorPQ_INDEX_JAC_H,
   GeneratorPQ_initialAnalyticJacobianA,
   GeneratorPQ_initialAnalyticJacobianB,
   GeneratorPQ_initialAnalyticJacobianC,
   GeneratorPQ_initialAnalyticJacobianD,
   GeneratorPQ_initialAnalyticJacobianF,
   GeneratorPQ_initialAnalyticJacobianH,
   GeneratorPQ_functionJacA_column,
   GeneratorPQ_functionJacB_column,
   GeneratorPQ_functionJacC_column,
   GeneratorPQ_functionJacD_column,
   GeneratorPQ_functionJacF_column,
   GeneratorPQ_functionJacH_column,
   GeneratorPQ_linear_model_frame,
   GeneratorPQ_linear_model_datarecovery_frame,
   GeneratorPQ_mayer,
   GeneratorPQ_lagrange,
   GeneratorPQ_pickUpBoundsForInputsInOptimization,
   GeneratorPQ_setInputData,
   GeneratorPQ_getTimeGrid,
   GeneratorPQ_symbolicInlineSystem,
   GeneratorPQ_function_initSynchronous,
   GeneratorPQ_function_updateSynchronous,
   GeneratorPQ_function_equationsSynchronous,
   GeneratorPQ_inputNames,
   GeneratorPQ_dataReconciliationInputNames,
   GeneratorPQ_dataReconciliationUnmeasuredVariables,
   NULL,
   NULL,
   NULL,
   NULL,
   -1,
   NULL,
   NULL,
   -1

};

#define _OMC_LIT_RESOURCE_0_name_data "Complex"
#define _OMC_LIT_RESOURCE_0_dir_data "/home/rosiereflo/.openmodelica/libraries/Complex 3.2.3+maint.om"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_name,7,_OMC_LIT_RESOURCE_0_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir,63,_OMC_LIT_RESOURCE_0_dir_data);

#define _OMC_LIT_RESOURCE_1_name_data "Dynawo"
#define _OMC_LIT_RESOURCE_1_dir_data "/home/rosiereflo/Projects/dynawo_bis/dynawo/install/gcc11/2292_om_1.24.4/Debug/shared/dynawo/ddb/Dynawo"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_1_name,6,_OMC_LIT_RESOURCE_1_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir,103,_OMC_LIT_RESOURCE_1_dir_data);

#define _OMC_LIT_RESOURCE_2_name_data "GeneratorPQ"
#define _OMC_LIT_RESOURCE_2_dir_data "/home/rosiereflo/Projects/dynawo_bis/dynawo/build/gcc11/2292_om_1.24.4/Debug/shared/dynawo/M/M/P/GeneratorPQ"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_2_name,11,_OMC_LIT_RESOURCE_2_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir,108,_OMC_LIT_RESOURCE_2_dir_data);

#define _OMC_LIT_RESOURCE_3_name_data "Modelica"
#define _OMC_LIT_RESOURCE_3_dir_data "/home/rosiereflo/.openmodelica/libraries/Modelica 3.2.3+maint.om"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_name,8,_OMC_LIT_RESOURCE_3_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir,64,_OMC_LIT_RESOURCE_3_dir_data);

#define _OMC_LIT_RESOURCE_4_name_data "ModelicaServices"
#define _OMC_LIT_RESOURCE_4_dir_data "/home/rosiereflo/.openmodelica/libraries/ModelicaServices 3.2.3+maint.om"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_name,16,_OMC_LIT_RESOURCE_4_name_data);
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir,72,_OMC_LIT_RESOURCE_4_dir_data);

static const MMC_DEFSTRUCTLIT(_OMC_LIT_RESOURCES,10,MMC_ARRAY_TAG) {MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_0_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_1_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_2_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_3_dir), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_name), MMC_REFSTRINGLIT(_OMC_LIT_RESOURCE_4_dir)}};
void GeneratorPQ_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &GeneratorPQ_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "GeneratorPQ";
  data->modelData->modelFilePrefix = "GeneratorPQ";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "/home/rosiereflo/Projects/dynawo_bis/dynawo/build/gcc11/2292_om_1.24.4/Debug/shared/dynawo/M/M/P/GeneratorPQ";
  data->modelData->modelGUID = "{0b9dbdd7-dc9d-41ad-ab74-da608aebc768}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "GeneratorPQ_init.c"
    ;
  static const char contents_info[] =
    #include "GeneratorPQ_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "GeneratorPQ_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "GeneratorPQ_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  data->modelData->modelDataXml.fileName = "GeneratorPQ_info.json";
  data->modelData->resourcesDir = NULL;
  data->modelData->runTestsuite = 0;
  data->modelData->nStates = 4;
  data->modelData->nVariablesReal = 16;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 3;
  data->modelData->nVariablesBoolean = 13;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 14;
  data->modelData->nParametersInteger = 2;
  data->modelData->nParametersBoolean = 4;
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 3;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 0;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 5;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 5;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 10;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 112;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 1;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 7;
  data->modelData->nOptimizeConstraints = 0;
  data->modelData->nOptimizeFinalConstraints = 0;
  data->modelData->nDelayExpressions = 0;
  data->modelData->nBaseClocks = 0;
  data->modelData->nSpatialDistributions = 0;
  data->modelData->nSensitivityVars = 0;
  data->modelData->nSensitivityParamVars = 0;
  data->modelData->nSetcVars = 0;
  data->modelData->ndataReconVars = 0;
  data->modelData->nSetbVars = 0;
  data->modelData->nRelatedBoundaryConditions = 0;
  data->modelData->linearizationDumpLanguage = OMC_LINEARIZE_DUMP_LANGUAGE_MODELICA;
}

static int rml_execution_failed()
{
  fflush(NULL);
  fprintf(stderr, "Execution failed!\n");
  fflush(NULL);
  return 1;
}


#if defined(__MINGW32__) || defined(_MSC_VER)

#if !defined(_UNICODE)
#define _UNICODE
#endif
#if !defined(UNICODE)
#define UNICODE
#endif

#include <windows.h>
char** omc_fixWindowsArgv(int argc, wchar_t **wargv)
{
  char** newargv;
  /* Support for non-ASCII characters
  * Read the unicode command line arguments and translate it to char*
  */
  newargv = (char**)malloc(argc*sizeof(char*));
  for (int i = 0; i < argc; i++) {
    newargv[i] = omc_wchar_to_multibyte_str(wargv[i]);
  }
  return newargv;
}

#define OMC_MAIN wmain
#define OMC_CHAR wchar_t
#define OMC_EXPORT __declspec(dllexport) extern

#else
#define omc_fixWindowsArgv(N, A) (A)
#define OMC_MAIN main
#define OMC_CHAR char
#define OMC_EXPORT extern
#endif

#if defined(threadData)
#undef threadData
#endif
/* call the simulation runtime main from our main! */
#if defined(OMC_DLL_MAIN_DEFINE)
OMC_EXPORT int omcDllMain(int argc, OMC_CHAR **argv)
#else
int OMC_MAIN(int argc, OMC_CHAR** argv)
#endif
{
  char** newargv = omc_fixWindowsArgv(argc, argv);
  /*
    Set the error functions to be used for simulation.
    The default value for them is 'functions' version. Change it here to 'simulation' versions
  */
  omc_assert = omc_assert_simulation;
  omc_assert_withEquationIndexes = omc_assert_simulation_withEquationIndexes;

  omc_assert_warning_withEquationIndexes = omc_assert_warning_simulation_withEquationIndexes;
  omc_assert_warning = omc_assert_warning_simulation;
  omc_terminate = omc_terminate_simulation;
  omc_throw = omc_throw_simulation;

  int res;
  DATA data;
  MODEL_DATA modelData;
  SIMULATION_INFO simInfo;
  data.modelData = &modelData;
  data.simulationInfo = &simInfo;
  measure_time_flag = 0;
  compiledInDAEMode = 1;
  compiledWithSymSolver = 0;
  MMC_INIT(0);
  omc_alloc_interface.init();
  {
    MMC_TRY_TOP()
  
    MMC_TRY_STACK()
  
    GeneratorPQ_setupDataStruc(&data, threadData);
    res = _main_initRuntimeAndSimulation(argc, newargv, &data, threadData);
    if(res == 0) {
      res = _main_SimulationRuntime(argc, newargv, &data, threadData);
    }
    
    MMC_ELSE()
    rml_execution_failed();
    fprintf(stderr, "Stack overflow detected and was not caught.\nSend us a bug report at https://trac.openmodelica.org/OpenModelica/newticket\n    Include the following trace:\n");
    printStacktraceMessages();
    fflush(NULL);
    return 1;
    MMC_CATCH_STACK()
    
    MMC_CATCH_TOP(return rml_execution_failed());
  }

  fflush(NULL);
  return res;
}

#ifdef __cplusplus
}
#endif
