def update(jobs):
    modelica_models = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
    for modelica_model in modelica_models:
        unit_dynamic_models = modelica_model.get_unit_dynamic_models(
            lambda unit_dynamic_model: unit_dynamic_model.get_name() == "Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous"
        )
        for unit_dynamic_model in unit_dynamic_models:
            unit_dynamic_model.set_name("Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous_NAME_CHANGED")
