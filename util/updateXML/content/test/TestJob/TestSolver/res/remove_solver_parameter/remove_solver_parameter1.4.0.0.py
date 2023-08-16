def update(jobs):
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.parset.remove_param_or_ref("relAccuracy")
