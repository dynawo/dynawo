# Master Realtime Task

**DANGER**

Code is not tested, yet. Do not use on a production machine.

_master-rt-task_ is supposed to run as root. It may damage your system.

# KWS realtime simulators
KWS uses [Power Plant Simulators](https://www.kws-eg.com/de/kws/campus-leben/simulatoren/) for training. Maintenance is done by the Software Team.
Most of the simulators are created by [GSE Power Systems AB](https://gses.com/).

KWS owns source code for all plant specific parts of the simulation but has no access to the code of the master control tasks of the simulators.

This project demonstrates how master tasks work as far as it is known by KWS.


# Files
  * _master-rt-task.c_ main task of simulator. Executes client- threads and programs in a predefined circle.
  * _client-dynawo.py_ dynawo RT client.
  * _shm-reader.c_ prints out information of the shared memory used by all programs.

# How to run
Shared memory is used to share data for all programs.
Steps to install and run:

  * clone project
  * change to folder _plant_simulator_
  * do a _make_ to build all programs.
  * start dynawo job RTNordic_generator_input/Nordic.jobs in one terminal window
  * do a _sudo su -_ to become _root_ and change into folder _plant_simulator_.
  * start _master-rt-task_ as root
  * start _client-dynawo-receive.py_ a second terminal (no root-privileges necessary)
  * start _shm-reader_ in a third terminal (no root-privileges necessary)

# Operation
Some basic operations can be controlled by _shm-reader_. Type

  * _f_ to switch to _freeze_
  * _r_ to switch to _run_
  * _x_ to exit and stop all other tasks
