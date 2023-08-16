def update(jobs):
    gens = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() in ["MachineFourWindingsTemplate",
                                                                                        "MachineThreeWindingsTemplate"]
    )
    for gen in gens:
        gen.static_refs.remove_static_ref("generator_PGenPu")
        gen.static_refs.remove_static_ref("generator_QGenPu")
