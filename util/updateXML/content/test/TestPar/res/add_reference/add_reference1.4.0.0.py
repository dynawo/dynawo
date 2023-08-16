def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "LoadAlphaBeta")
    for load in loads:
        load.parset.add_ref("DOUBLE", "load_U0Pu", "IIDM", "v_pu")

    gens1 = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousFourWindingsProportionalRegulations")
    for gen1 in gens1:
        gen1.parset.add_ref("DOUBLE", "myRef", orig_data="PAR", orig_name="myParam", component_id="GEN____1_SM", par_id="5", par_file="myPar.par")

    gens2 = jobs.dyds.get_bbms(lambda bbm: bbm.get_lib_name() == "GeneratorSynchronousThreeWindingsProportionalRegulations")
    for gen2 in gens2:
        gen2.parset.add_ref("DOUBLE", "generator_Q0Pu", orig_data="IIDM", orig_name="q_pu", component_id="GEN____1_SM")
