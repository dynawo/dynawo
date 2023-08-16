def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.change_param_or_ref_name("load_alpha", "load_alpha_NAME_CHANGED")
        load.parset.change_param_or_ref_name("load_P0Pu", "load_P0Pu_NAME_CHANGED")

    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.parset.change_param_or_ref_name("generator_md", "generator_md_NAME_CHANGED")
        gen.parset.change_param_or_ref_name("generator_P0Pu", "generator_P0Pu_NAME_CHANGED")
