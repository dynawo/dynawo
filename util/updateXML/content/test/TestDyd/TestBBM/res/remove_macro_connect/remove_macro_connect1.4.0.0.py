def update(jobs):
    gens = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "GEN____1_SM")
    for gen in gens:
        gen.macro_connects.remove_macro_connect("GEN_NETWORK_CONNECTOR")

    omega_refs = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "OMEGA_REF")
    for omega_ref in omega_refs:
        omega_ref.macro_connects.remove_macro_connect("GEN_OMEGAREF_CONNECTOR")
