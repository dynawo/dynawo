def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.set_lib_name("LoadAlphaBeta_NAME_CHANGED")
        load.parset.change_param_or_ref_name("load_alpha", "load_alpha_NAME_CHANGED")
        load.curves.change_variable_name("load_PPu", "load_PPu_NAME_CHANGED")
        load.final_state_values.change_variable_name("load_PPu", "load_PPu_NAME_CHANGED")
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsProportionalRegulations")
    for gen in gens:
        gen.set_lib_name("GeneratorSynchronousThreeWindingsProportionalRegulations_NAME_CHANGED")
        gen.parset.change_param_or_ref_name("generator_md", "generator_md_NAME_CHANGED")
        gen.curves.change_variable_name("generator_omegaPu", "generator_omegaPu_NAME_CHANGED")
        gen.final_state_values.change_variable_name("generator_omegaPu", "generator_omegaPu_NAME_CHANGED")
    networks = jobs.get_networks()
    for network in networks:
        network.parset.change_param_or_ref_name("load_Tp", "load_Tp_NAME_CHANGED")
        network.parset.change_param_or_ref_name("load_alpha", "load_alpha_NAME_CHANGED")
        network.curves.change_variable_name("_BUS____2_TN_Upu_value", "_BUS____2_TN_Upu_value_NAME_CHANGED")
        network.final_state_values.change_variable_name("_BUS____2_TN_Upu_value", "_BUS____2_TN_Upu_value_NAME_CHANGED")
    solvers = jobs.get_solvers()
    for solver in solvers:
        solver.parset.change_param_or_ref_name("minStep", "minStep_NAME_CHANGED")
        solver.parset.change_param_or_ref_name("maxStep", "maxStep_NAME_CHANGED")
