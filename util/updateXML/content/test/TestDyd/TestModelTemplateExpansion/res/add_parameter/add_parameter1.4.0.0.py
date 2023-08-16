def update(jobs):
    gens1 = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineThreeWindingsTemplate"
    )
    for gen1 in gens1:
        gen1.parset.add_param("DOUBLE", "myParam1", 0.215)

    gens2 = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineFourWindingsTemplate"
    )
    for gen2 in gens2:
        gen2.parset.add_param("BOOL", "myParam2", True)
