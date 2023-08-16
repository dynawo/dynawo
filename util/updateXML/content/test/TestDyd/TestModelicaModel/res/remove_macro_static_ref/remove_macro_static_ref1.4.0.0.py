def update(jobs):
   gens = jobs.dyds.get_modelica_models(lambda modelica_model: modelica_model.get_id() in ["GEN____1_SM", "GEN____2_SM"])
   for gen in gens:
      gen.macro_static_refs.remove_macro_static_ref("GEN1")
