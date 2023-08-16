def update(jobs):
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.set_lib_name("dynawo_SolverIDA_NAME_CHANGED")
