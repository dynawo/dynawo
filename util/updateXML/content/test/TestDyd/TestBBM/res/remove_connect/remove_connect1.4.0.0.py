def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___2_EC")
    for load in loads:
        load.connects.remove_connect("load_terminal")

    omega_refs = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "OMEGA_REF")
    for omega_ref in omega_refs:
        omega_ref.connects.remove_connect("omegaRef_grp_0")
        omega_ref.connects.remove_connect("numcc_node_0")

    gens1 = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "GEN____1_SM")
    for gen1 in gens1:
        gen1.connects.remove_connect("generator_switchOffSignal1")

    gens2 = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "GEN____2_SM")
    for gen2 in gens2:
        gen2.connects.remove_connect("generator_terminal")
        gen2.connects.remove_connect("generator_switchOffSignal1")
