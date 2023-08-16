def update(jobs):
   gens = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() == "GEN____1_SM")
   for gen in gens:
      unit_dynamic_models = gen.get_unit_dynamic_models(
         lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
      )
      for unit_dynamic_model in unit_dynamic_models:
         unit_dynamic_model.macro_connects.remove_macro_connect("GEN_VOLTAGE_REGULATOR_CONNECTOR_1")
         unit_dynamic_model.macro_connects.remove_macro_connect("GEN_VOLTAGE_REGULATOR_CONNECTOR_2")
