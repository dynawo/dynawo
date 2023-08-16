def update(jobs):
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.set_lib_name("GeneratorSynchronousFourWindingsProportionalRegulations_NAME_CHANGED")
