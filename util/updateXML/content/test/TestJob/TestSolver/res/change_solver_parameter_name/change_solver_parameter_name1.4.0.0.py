def update(jobs):
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.parset.change_param_or_ref_name("minStep", "minStep_NAME_CHANGED")
