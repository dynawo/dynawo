def update(jobs):
    gens = jobs.dyds.get_model_templates(
        lambda model_template: model_template.get_id() in ["MachineThreeWindingsTemplate",
                                                            "MachineFourWindingsTemplate"]
    )
    for gen in gens:
        gen.static_refs.change_var_name("generator_PGenPu", "generator_PGenPu_NAME_CHANGED")
        gen.static_refs.change_var_name("generator_QGenPu", "generator_QGenPu_NAME_CHANGED")
