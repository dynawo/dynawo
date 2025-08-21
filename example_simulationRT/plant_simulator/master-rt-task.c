/* -*- compile-command: "make"  -*- */
/* customize emacs, has to be placed in first line of code */

/*
 * POSIX Real Time Example
 * using a single pthread as RT thread
 */

#include <limits.h>
#include <unistd.h>
#include <pthread.h>
#include <signal.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <math.h>

#include "sim-control.h"

/* some global definitions */

/* 40 Hz for master task */
const int masterRtFramesPerS = 40;
const long masterRtPeriodNs = 25000000;

/* struct to control simulation */
simControlGlobal_t *simControlGlobal;
int simControlGlobalId;
simControlStatus_t LastStatus = SIMSTAT_UNDEF;

/****************************************************************************/

/****************************************************************************/

struct period_info {
    struct timespec next_period;
    long period_ns;
};

/* for process thread 1 */
pthread_cond_t prthr1_cond1 = PTHREAD_COND_INITIALIZER;
pthread_mutex_t prthr1_lock = PTHREAD_MUTEX_INITIALIZER;
volatile  proccessStatus_t  prthr1_stepping;

/* for processes client 1 and client python */
const char *prClient1Name = "client-rt-task";
const char *prClientPyName = "client-rt-task.py";
const char *prClientDyPyName = "client-dynawo.py";
/****************************************************************************/

static void inc_period(struct period_info *pinfo)
{
    pinfo->next_period.tv_nsec += pinfo->period_ns;

    while (pinfo->next_period.tv_nsec >= 1000000000) {
        /* timespec nsec overflow */
        pinfo->next_period.tv_sec++;
        pinfo->next_period.tv_nsec -= 1000000000;
    }
}

static void inc_frame(int framesPerS)
{
  simControlGlobal->frame += 1;
  /* restart frame every second */
  if (simControlGlobal->frame >= framesPerS)
    simControlGlobal->frame = 0;
}

static void inc_simulationTime(int step)
{
    simControlGlobal->simulationTime.tv_nsec += step;

    while (simControlGlobal->simulationTime.tv_nsec >= 1000000000) {
        /* timespec nsec overflow */
        simControlGlobal->simulationTime.tv_sec++;
        simControlGlobal->simulationTime.tv_nsec -= 1000000000;
    }
}

/* simulation processes */

/* init part */

int initBasicModel()
{
  /* just reset simulation time */
  simControlGlobal->startTime = time(NULL);
  simControlGlobal->simulationTime.tv_sec = 0;
  simControlGlobal->simulationTime.tv_nsec = 0;
  return 0;
}

int initPrClientDyPy()
{
  char callBuffer[256];

  printf("make sure that dynawo is running on dynawo machine ..\n");

  /* set cycle time */
  simControlGlobal->prclientDyPy_periodNs = 1000000000;
  /* reset pid */
  simControlGlobal->prclientDyPy_pid = -1;
  /* start client in background */
  sprintf(callBuffer, "./%s &", prClientDyPyName);
  if (system(callBuffer) != 0)
    {
      printf("Start of %s failed\n",prClientDyPyName);
    }
  return 0;
}

/* step part */

/* just a simple example for a RT process.
   A more realistic process runs as a child or thread process
   or on a separate machine linked via ethernet or memory cuppling */

int stepBasicModel(int step)
{
  int back = 0;
  time_t gmt;
  struct tm *localtm;
  char TimeBuffer[40];

  /* trigger to start
     A SIG_USER1 may be used for it */
  simControlGlobal->statusBasicModel = PROCSTAT_STEPPING;
  if (simControlGlobal->simControlStatus == SIMSTAT_RUN)
    {
      /* report simulation time for even seconds */
      if ((simControlGlobal->simulationTime.tv_nsec == 0)
          && !(simControlGlobal->simulationTime.tv_sec % 2))
        {
          gmt = time(NULL);
          localtm = localtime(&gmt);
          strftime(TimeBuffer, sizeof(TimeBuffer), "%b %d %H:%M:%S", localtm);

          printf("time %s simulated %ld.%03ld\n",TimeBuffer,
                 simControlGlobal->simulationTime.tv_sec,
                 simControlGlobal->simulationTime.tv_nsec / 1000000);
        }
      /* action of process
         here: just increment simulation time */
      inc_simulationTime(step);
    }
  /* important:
     provide ready signal for master task */
  simControlGlobal->statusBasicModel = PROCSTAT_READY;

  return back;
}

int stepPrClientDyPy()
{
  if (simControlGlobal->prclientDyPy_pid > 0)
    {
      /* send SIGUSR1 to process */
      if (kill(simControlGlobal->prclientDyPy_pid, SIGUSR1) != 0)
        {
          printf("SIGUSR1 to pid %d failed\n",
                 simControlGlobal->prclientDyPy_pid);
          simControlGlobal->prclientDyPy_pid = -1;
        }
      else
        simControlGlobal->statusPrClientDyPy = PROCSTAT_STEPPING;
    }
  return 0;
}

/* check status */
proccessStatus_t checkBasicModel()
{
  /* just return status */
  return simControlGlobal->statusBasicModel;
}

proccessStatus_t checkPrClientDyPy()
{
  /* just return status */
  return simControlGlobal->statusPrClientDyPy;
}

/* summarized operations for all processes */

int initProcesses()
{
  int back = 0;

  /* shared memory handling for simControlGlobal */
  if ((simControlGlobalId
       = shmget(simControlGlobalKey,
                sizeof(simControlGlobal_t), IPC_CREAT | 0666)) < 0)
    {
      perror("shmget");
      printf("error shmget\n");
      back = -1;
      return back;
    }
  printf("shared memory key %x id %d created\n",
         simControlGlobalKey, simControlGlobalId);

  if ((simControlGlobal = shmat(simControlGlobalId, NULL, 0))
      == (void *) -1)
    {
      perror("shmat");
      back = -1;
      return back;
    }

  /* for master RT process */
  simControlGlobal->frame = 0;
  simControlGlobal->simControlStatus = SIMSTAT_INIT;
  /* add init for all processes here */
  /* handling of return value back has to be improved */
  back = initBasicModel();
  back = initPrClientDyPy();
  return back;
}

int triggerProcesses(long stepNS)
{
  int back = 0;
  int everyXframe;

  /* handling of return value back has to be improved */
  back = stepBasicModel(stepNS);
  everyXframe = simControlGlobal->prclientDyPy_periodNs / masterRtPeriodNs;
  if (!(simControlGlobal->frame % everyXframe))
    /* step task every x frame*/
    back = stepPrClientDyPy();
  return back;
}

int cleanupProcesses()
{
  time_t gmt;
  struct tm *localtm;
  char TimeBuffer[40];

  /* get local time */
  gmt = time(NULL);
  localtm = localtime(&gmt);
  strftime(TimeBuffer, sizeof(TimeBuffer), "%b %d %H:%M:%S", localtm);

  printf("simulation ended at %s\n", TimeBuffer);
  printf("simulation time %ld.%03ld s\n",
         simControlGlobal->simulationTime.tv_sec,
         simControlGlobal->simulationTime.tv_nsec / 1000000);

  printf("waiting for clients ..\n");
  sleep(5);
  printf("kill clients ..\n");
  if (simControlGlobal->prclient1_pid > 0)
    {
      /* try sigusr1 first */
      if (kill(simControlGlobal->prclient1_pid, SIGUSR1) == 0)
        /* there is somebody */
        kill(simControlGlobal->prclient1_pid, SIGTERM);
      else
        printf("kill failded, no client 1 (pid %d)\n",
               simControlGlobal->prclient1_pid);
    }
  if (simControlGlobal->prclientPy_pid > 0)
    {
      /* try sigusr1 first */
      if (kill(simControlGlobal->prclientPy_pid, SIGUSR1) == 0)
        /* there is somebody */
        kill(simControlGlobal->prclientPy_pid, SIGTERM);
      else
        printf("kill failded, no client Py (pid %d)\n",
               simControlGlobal->prclientPy_pid);
    }
  if (simControlGlobal->prclientDyPy_pid > 0)
    {
      /* try sigusr1 first */
      if (kill(simControlGlobal->prclientDyPy_pid, SIGUSR1) == 0)
        /* there is somebody */
        kill(simControlGlobal->prclientDyPy_pid, SIGTERM);
      else
        printf("kill failded, no client Py (pid %d)\n",
               simControlGlobal->prclientDyPy_pid);
    }
  sleep(5);
  printf("detaching shared memory\n");
  if (shmdt(simControlGlobal))
    printf("Could not close memory segment.\n");
  return 0;
}

simControlStatus_t checkReadyProcesses()
{
  simControlStatus_t back = SIMSTAT_RUN;

  /* add check for all processes here */
  if (checkBasicModel() != PROCSTAT_READY)
    {
      printf("BasicModel failed\n");
      back = SIMSTAT_FAIL;
    }
  if (checkPrClientDyPy() != PROCSTAT_READY)
    {
      printf("ClientDyPy failed\n");
      back = SIMSTAT_FAIL;
      /* report only once */
      simControlGlobal->statusPrClientDyPy = PROCSTAT_READY;
    }
  return back;
}

static void init_periodic_task(struct period_info *pinfo, long PeriodNs)
{
    pinfo->period_ns = PeriodNs;

    clock_gettime(CLOCK_MONOTONIC, &(pinfo->next_period));

    /* init for all RT processes */
    initProcesses();
}

static int do_periodic_task()
{
  int back = 1;

  inc_frame(masterRtFramesPerS);

  switch (simControlGlobal->simControlStatus)
    {
    case SIMSTAT_INIT:
      if (LastStatus != simControlGlobal->simControlStatus)
        printf("status: init\n");
      break;
    case SIMSTAT_RUN:
      if (LastStatus != simControlGlobal->simControlStatus)
        printf("status: run\n");
      break;
    case SIMSTAT_FREEZE:
      if (LastStatus != simControlGlobal->simControlStatus)
        printf("status: freeze\n");
      break;
    case SIMSTAT_EXIT:
      /* exit loop */
      back = 0;
      break;
    default:
      /* set status undefined */
      simControlGlobal->simControlStatus = SIMSTAT_UNDEF;
      break;
    }

  /* trigger all child processes */
  if (!(simControlGlobal->frame % 2))
    {
      /* using even frames we trigger processes in 20 HZ
         if master runs on 40 HZ */
      if (checkReadyProcesses() == SIMSTAT_FAIL)
        {
          simControlGlobal->simControlStatus = SIMSTAT_FAIL;
          printf("fail: process not ready\n");
        }
      triggerProcesses(2 * masterRtPeriodNs);
    }

  /* remember last status */
  LastStatus = simControlGlobal->simControlStatus;

  return back;
}

static int cleanup_periodic_task()
{
  /* cleanup all */
  cleanupProcesses();
  return 0;
}
/****************************************************************************/

static void wait_rest_of_period(struct period_info *pinfo)
{
    inc_period(pinfo);

    /* for simplicity, ignoring possibilities of signal wakes */
    clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME,
            &pinfo->next_period, NULL);
}

/****************************************************************************/

void *masterRT_task()
{
    struct period_info pinfo;

    init_periodic_task(&pinfo, masterRtPeriodNs);

    while (do_periodic_task()) {
      wait_rest_of_period(&pinfo);
    }

    cleanup_periodic_task();
    return NULL;
}

int main(int argc, char* argv[])
{
  struct sched_param param;
  pthread_attr_t attr;
  pthread_t thread;
  int ret;

  /* Lock memory */
        if(mlockall(MCL_CURRENT|MCL_FUTURE) == -1) {
                printf("mlockall failed: %m\n");
                exit(-2);
        }

        /* Initialize pthread attributes (default values) */
        ret = pthread_attr_init(&attr);
        if (ret) {
                printf("init pthread attributes failed\n");
                goto out;
        }

        /* Set a specific stack size  */
        ret = pthread_attr_setstacksize(&attr, PTHREAD_STACK_MIN);
        if (ret) {
            printf("pthread setstacksize failed\n");
            goto out;
        }

        /* Set scheduler policy and priority of pthread */
        ret = pthread_attr_setschedpolicy(&attr, SCHED_FIFO);
        if (ret) {
                printf("pthread setschedpolicy failed\n");
                goto out;
        }
        param.sched_priority = 80;
        ret = pthread_attr_setschedparam(&attr, &param);
        if (ret) {
                printf("pthread setschedparam failed\n");
                goto out;
        }
        /* Use scheduling parameters of attr */
        ret = pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
        if (ret) {
                printf("pthread setinheritsched failed\n");
                goto out;
        }

        /* Create a pthread with specified attributes */
        printf("creating thread ..\n");
        ret = pthread_create(&thread, &attr, masterRT_task, NULL);
        if (ret) {
                printf("create pthread failed\n");
                goto out;
        }

        /* Join the thread and wait until it is done */
        ret = pthread_join(thread, NULL);
        if (ret)
          printf("join pthread failed: %m\n");

 out:
        return ret;
}
