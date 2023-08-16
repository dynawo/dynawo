import os
import sys

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)

from Ticket import ticket

@ticket(990)
def update(jobs):
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.set_lib_name("dynawo_SolverIDA_NAME_CHANGED")
