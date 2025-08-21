/* customize emacs: */
/* -*- compile-command: "gcc -g -Wall -o shm-reader shm-reader.c" -*- */
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

#include "sim-control.h"

/* globals */
simControlGlobal_t *simControlGlobal;
int simControlGlobalId;



int main()
{
  int charsRead;
  char inBuffer[64];
  int calcLimit;
  /*
   * Locate the segment.
   */
  if ((simControlGlobalId = shmget(simControlGlobalKey,
                      sizeof(simControlGlobal_t), 0666)) < 0) {
    perror("shmget");
    return -1;
  }
  printf("shared memory key %x id %d created\n",
         simControlGlobalKey, simControlGlobalId);


  /*
   * Now we attach the segment to our data space.
   */
  if ((simControlGlobal = shmat(simControlGlobalId, NULL, 0))
      == (void *) -1) {
    perror("shmat");
    return 1;
  }


  for(;;){
    printf("status:");
    switch (simControlGlobal->simControlStatus)
      {
      case SIMSTAT_INIT:
        printf("init\n");
        break;
      case SIMSTAT_RUN:
        printf("run\n");
        break;
      case SIMSTAT_FREEZE:
        printf("freeze\n");
        break;
      case SIMSTAT_FAIL:
        printf("fail\n");
        break;
      default:
        printf("undefined\n");
      }
    /* check status of process PrThr1*/
    switch(simControlGlobal->statusPrThr1)
      {
      case PROCSTAT_STEPPING:
        printf("PrThr1 is stepping\n");
        break;
      case PROCSTAT_READY:
        printf("PrThr1 ready\n");
        break;
      default:
        break;
      }
    printf("enter command (x to exit) -> ");
    charsRead = scanf("%s", inBuffer);
    if (charsRead > 0)
      switch (inBuffer[0])
        {
        case 'r':
          simControlGlobal->simControlStatus = SIMSTAT_RUN;
          break;
        case 'f':
          simControlGlobal->simControlStatus = SIMSTAT_FREEZE;
          break;
        case 't':
          /* set calc limit for thread */
          if (sscanf(&inBuffer[1], "%d", &calcLimit) > 0)
            {
              printf("loop limit of thread set to %d\n", calcLimit);
              simControlGlobal->prthr1_LoopLimit = calcLimit;
            }
          break;
        case 'c':
          /* set calc limit for client */
          if (sscanf(&inBuffer[1], "%d", &calcLimit) > 0)
            {
              printf("loop limit of client set to %d\n", calcLimit);
              simControlGlobal->prclient1_LoopLimit = calcLimit;
            }
          break;
        case 'p':
          /* set calc limit for python client */
          if (sscanf(&inBuffer[1], "%d", &calcLimit) > 0)
            {
              printf("loop limit of python client set to %d\n", calcLimit);
              simControlGlobal->prclientPy_LoopLimit = calcLimit;
            }
          break;
        case 'x':
          /* send exit to masterRT task */
          simControlGlobal->simControlStatus = SIMSTAT_EXIT;
          printf("bye\n");
          goto out;
          break;
        default:
          break;
        }
    }

 out:
    if(shmdt(simControlGlobal) != 0)
        fprintf(stderr, "Could not close memory segment.\n");

    return 0;
}
