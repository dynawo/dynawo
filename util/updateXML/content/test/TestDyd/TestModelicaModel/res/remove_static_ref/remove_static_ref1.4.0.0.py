def update(jobs):
   gens = jobs.dyds.get_modelica_models(
      lambda modelica_model: modelica_model.get_id() in ["GEN____1_SM",
                                                         "GEN____2_SM",
                                                         "GEN____3_SM",
                                                         "GEN____4_SM",
                                                         "GEN____5_SM"]
   )
   for gen in gens:
      gen.static_refs.remove_static_ref("generator_PGenPu")
      gen.static_refs.remove_static_ref("generator_QGenPu")
