def update(jobs):
    gens = jobs.dyds.get_model_templates(
        lambda model_template: model_template.get_id() in ["MachineThreeWindingsTemplate",
                                                            "MachineFourWindingsTemplate"]
    )
    for gen in gens:
        gen.static_refs.remove_static_ref("generator_PGenPu")
        gen.static_refs.remove_static_ref("generator_QGenPu")
