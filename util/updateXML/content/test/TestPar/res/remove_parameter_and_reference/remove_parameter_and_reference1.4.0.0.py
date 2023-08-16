def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.remove_param_or_ref("load_alpha")
        load.parset.remove_param_or_ref("load_P0Pu")

    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.parset.remove_param_or_ref("governor_KGover")
        gen.parset.remove_param_or_ref("generator_P0Pu")
