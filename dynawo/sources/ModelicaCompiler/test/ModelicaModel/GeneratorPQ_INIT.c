/* Main Simulation File */

#if defined(__cplusplus)
extern "C" {
#endif

#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#include "simulation/solver/events.h"

/* FIXME these defines are ugly and hard to read, why not use direct function pointers instead? */
#define prefixedName_performSimulation GeneratorPQ_INIT_performSimulation
#define prefixedName_updateContinuousSystem GeneratorPQ_INIT_updateContinuousSystem
#include <simulation/solver/perform_simulation.c.inc>

#define prefixedName_performQSSSimulation GeneratorPQ_INIT_performQSSSimulation
#include <simulation/solver/perform_qss_simulation.c.inc>


/* dummy VARINFO and FILEINFO */
const VAR_INFO dummyVAR_INFO = omc_dummyVarInfo;

int GeneratorPQ_INIT_input_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_input_function_init(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_input_function_updateStartValues(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_inputNames(DATA *data, char ** names){
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_data_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_dataReconciliationInputNames(DATA *data, char ** names){
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_dataReconciliationUnmeasuredVariables(DATA *data, char ** names)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_output_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_setc_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}

int GeneratorPQ_INIT_setb_function(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH


  TRACE_POP
  return 0;
}


OMC_DISABLE_OPT
int GeneratorPQ_INIT_functionDAE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
  int equationIndexes[1] = {0};
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_DAE);
#endif

  data->simulationInfo->needToIterate = 0;
  data->simulationInfo->discreteCall = 1;
  GeneratorPQ_INIT_functionLocalKnownVars(data, threadData);
  data->simulationInfo->discreteCall = 0;
  
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_DAE);
#endif
  TRACE_POP
  return 0;
}


int GeneratorPQ_INIT_functionLocalKnownVars(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH

  
  TRACE_POP
  return 0;
}


int GeneratorPQ_INIT_functionODE(DATA *data, threadData_t *threadData)
{
  TRACE_PUSH
#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_tick(SIM_TIMER_FUNCTION_ODE);
#endif

  
  data->simulationInfo->callStatistics.functionODE++;
  
  GeneratorPQ_INIT_functionLocalKnownVars(data, threadData);
  /* no ODE systems */

#if !defined(OMC_MINIMAL_RUNTIME)
  if (measure_time_flag) rt_accumulate(SIM_TIMER_FUNCTION_ODE);
#endif

  TRACE_POP
  return 0;
}

/* forward the main in the simulation runtime */
extern int _main_SimulationRuntime(int argc, char**argv, DATA *data, threadData_t *threadData);

#include "GeneratorPQ_INIT_12jac.h"
#include "GeneratorPQ_INIT_13opt.h"

struct OpenModelicaGeneratedFunctionCallbacks GeneratorPQ_INIT_callback = {
   (int (*)(DATA *, threadData_t *, void *)) GeneratorPQ_INIT_performSimulation,    /* performSimulation */
   (int (*)(DATA *, threadData_t *, void *)) GeneratorPQ_INIT_performQSSSimulation,    /* performQSSSimulation */
   GeneratorPQ_INIT_updateContinuousSystem,    /* updateContinuousSystem */
   GeneratorPQ_INIT_callExternalObjectDestructors,    /* callExternalObjectDestructors */
   NULL,    /* initialNonLinearSystem */
   GeneratorPQ_INIT_initialLinearSystem,    /* initialLinearSystem */
   NULL,    /* initialMixedSystem */
   #if !defined(OMC_NO_STATESELECTION)
   GeneratorPQ_INIT_initializeStateSets,
   #else
   NULL,
   #endif    /* initializeStateSets */
   GeneratorPQ_INIT_initializeDAEmodeData,
   GeneratorPQ_INIT_functionODE,
   GeneratorPQ_INIT_functionAlgebraics,
   GeneratorPQ_INIT_functionDAE,
   GeneratorPQ_INIT_functionLocalKnownVars,
   GeneratorPQ_INIT_input_function,
   GeneratorPQ_INIT_input_function_init,
   GeneratorPQ_INIT_input_function_updateStartValues,
   GeneratorPQ_INIT_data_function,
   GeneratorPQ_INIT_output_function,
   GeneratorPQ_INIT_setc_function,
   GeneratorPQ_INIT_setb_function,
   GeneratorPQ_INIT_function_storeDelayed,
   GeneratorPQ_INIT_function_storeSpatialDistribution,
   GeneratorPQ_INIT_function_initSpatialDistribution,
   GeneratorPQ_INIT_updateBoundVariableAttributes,
   GeneratorPQ_INIT_functionInitialEquations,
   1, /* useHomotopy - 0: local homotopy (equidistant lambda), 1: global homotopy (equidistant lambda), 2: new global homotopy approach (adaptive lambda), 3: new local homotopy approach (adaptive lambda)*/
   NULL,
   GeneratorPQ_INIT_functionRemovedInitialEquations,
   GeneratorPQ_INIT_updateBoundParameters,
   GeneratorPQ_INIT_checkForAsserts,
   GeneratorPQ_INIT_function_ZeroCrossingsEquations,
   GeneratorPQ_INIT_function_ZeroCrossings,
   GeneratorPQ_INIT_function_updateRelations,
   GeneratorPQ_INIT_zeroCrossingDescription,
   GeneratorPQ_INIT_relationDescription,
   GeneratorPQ_INIT_function_initSample,
   GeneratorPQ_INIT_INDEX_JAC_A,
   GeneratorPQ_INIT_INDEX_JAC_B,
   GeneratorPQ_INIT_INDEX_JAC_C,
   GeneratorPQ_INIT_INDEX_JAC_D,
   GeneratorPQ_INIT_INDEX_JAC_F,
   GeneratorPQ_INIT_INDEX_JAC_H,
   GeneratorPQ_INIT_initialAnalyticJacobianA,
   GeneratorPQ_INIT_initialAnalyticJacobianB,
   GeneratorPQ_INIT_initialAnalyticJacobianC,
   GeneratorPQ_INIT_initialAnalyticJacobianD,
   GeneratorPQ_INIT_initialAnalyticJacobianF,
   GeneratorPQ_INIT_initialAnalyticJacobianH,
   GeneratorPQ_INIT_functionJacA_column,
   GeneratorPQ_INIT_functionJacB_column,
   GeneratorPQ_INIT_functionJacC_column,
   GeneratorPQ_INIT_functionJacD_column,
   GeneratorPQ_INIT_functionJacF_column,
   GeneratorPQ_INIT_functionJacH_column,
   GeneratorPQ_INIT_linear_model_frame,
   GeneratorPQ_INIT_linear_model_datarecovery_frame,
   GeneratorPQ_INIT_mayer,
   GeneratorPQ_INIT_lagrange,
   GeneratorPQ_INIT_pickUpBoundsForInputsInOptimization,
   GeneratorPQ_INIT_setInputData,
   GeneratorPQ_INIT_getTimeGrid,
   GeneratorPQ_INIT_symbolicInlineSystem,
   GeneratorPQ_INIT_function_initSynchronous,
   GeneratorPQ_INIT_function_updateSynchronous,
   GeneratorPQ_INIT_function_equationsSynchronous,
   GeneratorPQ_INIT_inputNames,
   GeneratorPQ_INIT_dataReconciliationInputNames,
   GeneratorPQ_INIT_dataReconciliationUnmeasuredVariables,
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

#define _OMC_LIT_RESOURCE_2_name_data "GeneratorPQ_INIT"
#define _OMC_LIT_RESOURCE_2_dir_data "/home/rosiereflo/Projects/dynawo_bis/dynawo/build/gcc11/2292_om_1.24.4/Debug/shared/dynawo/M/M/P/GeneratorPQ"
static const MMC_DEFSTRINGLIT(_OMC_LIT_RESOURCE_2_name,16,_OMC_LIT_RESOURCE_2_name_data);
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
void GeneratorPQ_INIT_setupDataStruc(DATA *data, threadData_t *threadData)
{
  assertStreamPrint(threadData,0!=data, "Error while initialize Data");
  threadData->localRoots[LOCAL_ROOT_SIMULATION_DATA] = data;
  data->callback = &GeneratorPQ_INIT_callback;
  OpenModelica_updateUriMapping(threadData, MMC_REFSTRUCTLIT(_OMC_LIT_RESOURCES));
  data->modelData->modelName = "GeneratorPQ_INIT";
  data->modelData->modelFilePrefix = "GeneratorPQ_INIT";
  data->modelData->resultFileName = NULL;
  data->modelData->modelDir = "/home/rosiereflo/Projects/dynawo_bis/dynawo/build/gcc11/2292_om_1.24.4/Debug/shared/dynawo/M/M/P/GeneratorPQ";
  data->modelData->modelGUID = "{0a0d580b-d281-4b54-8618-73a9d800387e}";
  #if defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME)
  data->modelData->initXMLData = NULL;
  data->modelData->modelDataXml.infoXMLData = NULL;
  #else
  #if defined(_MSC_VER) /* handle joke compilers */
  {
  /* for MSVC we encode a string like char x[] = {'a', 'b', 'c', '\0'} */
  /* because the string constant limit is 65535 bytes */
  static const char contents_init[] =
    #include "GeneratorPQ_INIT_init.c"
    ;
  static const char contents_info[] =
    #include "GeneratorPQ_INIT_info.c"
    ;
    data->modelData->initXMLData = contents_init;
    data->modelData->modelDataXml.infoXMLData = contents_info;
  }
  #else /* handle real compilers */
  data->modelData->initXMLData =
  #include "GeneratorPQ_INIT_init.c"
    ;
  data->modelData->modelDataXml.infoXMLData =
  #include "GeneratorPQ_INIT_info.c"
    ;
  #endif /* defined(_MSC_VER) */
  #endif /* defined(OPENMODELICA_XML_FROM_FILE_AT_RUNTIME) */
  data->modelData->modelDataXml.fileName = "GeneratorPQ_INIT_info.json";
  data->modelData->resourcesDir = NULL;
  data->modelData->runTestsuite = 0;
  data->modelData->nStates = 0;
  data->modelData->nVariablesReal = 4;
  data->modelData->nDiscreteReal = 0;
  data->modelData->nVariablesInteger = 0;
  data->modelData->nVariablesBoolean = 0;
  data->modelData->nVariablesString = 0;
  data->modelData->nParametersReal = 6;
  data->modelData->nParametersInteger = 0;
  data->modelData->nParametersBoolean = 0;
  data->modelData->nParametersString = 0;
  data->modelData->nInputVars = 0;
  data->modelData->nOutputVars = 0;
  data->modelData->nAliasReal = 4;
  data->modelData->nAliasInteger = 0;
  data->modelData->nAliasBoolean = 0;
  data->modelData->nAliasString = 0;
  data->modelData->nZeroCrossings = 0;
  data->modelData->nSamples = 0;
  data->modelData->nRelations = 0;
  data->modelData->nMathEvents = 0;
  data->modelData->nExtObjs = 0;
  data->modelData->modelDataXml.modelInfoXmlLength = 0;
  data->modelData->modelDataXml.nFunctions = 8;
  data->modelData->modelDataXml.nProfileBlocks = 0;
  data->modelData->modelDataXml.nEquations = 9;
  data->modelData->nMixedSystems = 0;
  data->modelData->nLinearSystems = 1;
  data->modelData->nNonLinearSystems = 0;
  data->modelData->nStateSets = 0;
  data->modelData->nJacobians = 6;
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
  
    GeneratorPQ_INIT_setupDataStruc(&data, threadData);
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


