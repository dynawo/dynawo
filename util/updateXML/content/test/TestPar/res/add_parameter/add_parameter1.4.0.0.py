def update(jobs):
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.parset.add_param("DOUBLE", "generator_mq", 0.215)

    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.add_param("DOUBLE", "load_gamma", 42.5)
