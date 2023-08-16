def update(jobs):
   gens = jobs.dyds.get_modelica_models(
      lambda modelica_model: modelica_model.get_id() in ["GEN____1_SM",
                                                         "GEN____2_SM",
                                                         "GEN____3_SM",
                                                         "GEN____4_SM",
                                                         "GEN____5_SM"]
   )
   for gen in gens:
      gen.static_refs.change_var_name("generator_PGenPu", "generator_PGenPu_NAME_CHANGED")
      gen.static_refs.change_var_name("generator_QGenPu", "generator_QGenPu_NAME_CHANGED")
