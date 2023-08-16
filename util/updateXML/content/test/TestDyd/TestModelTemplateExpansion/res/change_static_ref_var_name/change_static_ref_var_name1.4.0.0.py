def update(jobs):
    gens = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() == "MachineThreeWindingsTemplate"
    )
    for gen in gens:
        gen.static_refs.change_var_name("generator_PGenPu", "generator_PGenPu_NAME_CHANGED")
        gen.static_refs.change_var_name("generator_QGenPu", "generator_QGenPu_NAME_CHANGED")
