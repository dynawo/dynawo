def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
    for modelica_model in modelica_models:
        unit_dynamic_models1 = modelica_model.get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "governor")
        for unit_dynamic_model1 in unit_dynamic_models1:
            unit_dynamic_model1.init_connects.change_var_name("Pm0Pu", "Pm0Pu_NAME_CHANGED")
            unit_dynamic_model1.connects.change_var_name("PmPu", "PmPu_NAME_CHANGED")
        unit_dynamic_models2 = modelica_model.get_unit_dynamic_models(lambda unit_dynamic_model: unit_dynamic_model.get_id() == "generator")
        for unit_dynamic_model2 in unit_dynamic_models2:
            unit_dynamic_model2.init_connects.change_var_name("UStator0Pu", "UStator0Pu_NAME_CHANGED")
            unit_dynamic_model2.connects.change_var_name("efdPu.value", "efdPu.value_NAME_CHANGED")
