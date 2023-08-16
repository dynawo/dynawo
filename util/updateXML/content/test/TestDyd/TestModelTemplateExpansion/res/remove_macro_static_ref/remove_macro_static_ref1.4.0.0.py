def update(jobs):
    gens = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_template_id() in ["MachineFourWindingsTemplate",
                                                                                        "MachineThreeWindingsTemplate"]
    )
    for gen in gens:
        gen.macro_static_refs.remove_macro_static_ref("GEN")
        gen.macro_static_refs.remove_macro_static_ref("GEN1")
        gen.macro_static_refs.remove_macro_static_ref("GEN2")
