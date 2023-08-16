def update(jobs):
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen in gens:
        gen.connects.change_var_name("generator_terminal", "generator_terminal_NAME_CHANGED")
        gen.connects.change_var_name("generator_switchOffSignal1", "generator_switchOffSignal1_NAME_CHANGED")
