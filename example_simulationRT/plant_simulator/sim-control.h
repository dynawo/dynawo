#include <time.h>
#include <complex.h>

typedef enum {
  SIMSTAT_UNDEF = 0,
  SIMSTAT_INIT,
  SIMSTAT_FREEZE,
  SIMSTAT_STEP,
  SIMSTAT_RUN,
  SIMSTAT_HOLD,
  SIMSTAT_TERM,
  SIMSTAT_FAIL,
  SIMSTAT_IPCR,
  SIMSTAT_RESUME,
  SIMSTAT_EXIT,
} simControlStatus_t;

typedef enum {
  PROCSTAT_READY = 0,
  PROCSTAT_STEPPING,
} proccessStatus_t;

/* key for shared memory */
const key_t simControlGlobalKey = 0x00000180;

typedef struct _simControlGlobal {
  simControlStatus_t simControlStatus;
  int frame;
  time_t startTime;
  struct timespec simulationTime;
  proccessStatus_t statusBasicModel;
  double resultPrThr1;
  pthread_t prthr1_tid1;
  proccessStatus_t statusPrThr1;
  int prthr1_LoopLimit;
  long prclient1_periodNs;
  double resultPrClient1;
  pid_t prclient1_pid;
  proccessStatus_t statusPrClient1;
  int prclient1_LoopLimit;
  long prclientPy_periodNs;
  double resultPrClientPy;
  pid_t prclientPy_pid;
  proccessStatus_t statusPrClientPy;
  int prclientPy_LoopLimit;
  long prclientDyPy_periodNs;
  double resultPrClientDyPy;
  pid_t prclientDyPy_pid;
  proccessStatus_t statusPrClientDyPy;
  int prclientDyPy_LoopLimit;
  /* dynawo IO */
  /* in: send to dynawo */
  double dynIn_g06_injection_PRefPu;
  double dynIn_g06_injection_QRefPu;
  double dynOut_bus_BG06_U;
  double dynOut_bus_BG06_UPhase;
  double dynOut_bus_1042_U;
  double dynOut_bus_1042_UPhase;
  double dynOut_line_1042_1044a_P1Pu;
  double dynOut_line_1042_1044a_Q1Pu;
  double dynOut_line_1042_1044b_P1Pu;
  double dynOut_line_1042_1044b_Q1Pu;
  double dynOut_line_1042_1045_P1Pu;
  double dynOut_line_1042_1045_Q1Pu;
} simControlGlobal_t;
