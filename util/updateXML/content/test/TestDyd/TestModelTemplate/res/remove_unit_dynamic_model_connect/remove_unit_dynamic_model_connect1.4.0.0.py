def update(jobs):
   model_templates1 = jobs.dyds.get_model_templates(
      lambda model_template: model_template.get_id() == "MachineThreeWindingsTemplate"
   )
   for model_template1 in model_templates1:
      unit_dynamic_models1 = model_template1.get_unit_dynamic_models(
         lambda unit_dynamic_model: unit_dynamic_model.get_id() == "voltageRegulator"
      )
      for unit_dynamic_model1 in unit_dynamic_models1:
         unit_dynamic_model1.init_connects.remove_connect("Us0Pu")
         unit_dynamic_model1.connects.remove_connect("EfdPu")
      unit_dynamic_models2 = model_template1.get_unit_dynamic_models(
         lambda unit_dynamic_model: unit_dynamic_model.get_id() == "generator"
      )
      for unit_dynamic_model2 in unit_dynamic_models2:
         unit_dynamic_model2.init_connects.remove_connect("Pm0Pu")
         unit_dynamic_model2.connects.remove_connect("PmPu.value")

   model_templates2 = jobs.dyds.get_model_templates(
      lambda model_template: model_template.get_id() == "MachineFourWindingsTemplate"
   )
   for model_template2 in model_templates2:
      unit_dynamic_models3 = model_template2.get_unit_dynamic_models(
         lambda unit_dynamic_model: unit_dynamic_model.get_id() == "governor"
      )
      for unit_dynamic_model3 in unit_dynamic_models3:
         unit_dynamic_model3.init_connects.remove_connect("Pm0Pu")
         unit_dynamic_model3.connects.remove_connect("omegaPu")
