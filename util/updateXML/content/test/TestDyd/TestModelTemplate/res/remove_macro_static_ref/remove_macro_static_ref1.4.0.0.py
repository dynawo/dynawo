def update(jobs):
    gens = jobs.dyds.get_model_templates(
        lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
    )
    for gen in gens:
        gen.macro_static_refs.remove_macro_static_ref("GEN")
