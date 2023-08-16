def update(jobs):
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.parset.add_param("DOUBLE", "my_param", 42)
