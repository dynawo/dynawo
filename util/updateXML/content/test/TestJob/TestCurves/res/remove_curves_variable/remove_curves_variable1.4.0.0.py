def update(jobs):
    loads = jobs.dyds.get_bbms(lambda bbm: bbm.get_id() == "_LOAD___2_EC")
    for load in loads:
        load.curves.remove_variable("load_QPu")

    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
    for modelica_model in modelica_models:
        modelica_model.curves.remove_variable("generator_omegaPu")

    model_template_expansions = jobs.dyds.get_model_template_expansions(
        lambda model_template_expansion: model_template_expansion.get_id() == "GEN____2_SM"
    )
    for model_template_expansion in model_template_expansions:
        model_template_expansion.curves.remove_variable("generator_QGen")

    networks = jobs.get_networks()
    for network in networks:
        network.curves.remove_variable("_BUS____3_TN_Upu_value")
