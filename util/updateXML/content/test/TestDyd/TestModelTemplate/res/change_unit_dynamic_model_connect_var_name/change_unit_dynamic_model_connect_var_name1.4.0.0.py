def update(jobs):
    model_templates = jobs.dyds.get_model_templates(
        lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
    )
    for model_template in model_templates:
        unit_dynamic_models = model_template.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.init_connects.change_var_name("Efd0PuLF", "Efd0PuLF_NAME_CHANGED")
            unit_dynamic_model.connects.change_var_name("EfdPu", "EfdPu_NAME_CHANGED")
