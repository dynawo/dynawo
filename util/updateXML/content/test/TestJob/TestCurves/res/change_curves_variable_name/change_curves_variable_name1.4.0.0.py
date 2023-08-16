def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___2_EC")
    for load in loads:
        load.curves.change_variable_name("load_PPu", "load_PPu_NAME_CHANGED")

    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
    for modelica_model in modelica_models:
        modelica_model.curves.change_variable_name("generator_QGen", "generator_QGen_NAME_CHANGED")

    model_template_expansions = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_id() == "GEN____2_SM"
    )
    for model_template_expansion in model_template_expansions:
        model_template_expansion.curves.change_variable_name("generator_omegaPu", "generator_omegaPu_NAME_CHANGED")

    networks = jobs.get_networks()
    for network in networks:
        network.curves.change_variable_name("_BUS____2_TN_Upu_value", "_BUS____2_TN_Upu_value_NAME_CHANGED")
