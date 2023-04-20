within Dynawo.Examples.RVS.Components.GeneratorWithControl.Util;

record ParametersOEL

  type oelFramePreset = enumeration(all) "OEL Preset Names";
  type oelParamNames = enumeration(Kmx, ULowPu, T1, T2, T3, E1, E2, E3) "Parameter Names";
  
  // Kmx, ULowPu, T1, T2, T3, E1, E2, E3
  final constant Real[oelFramePreset, oelParamNames] oelParamValues = {
    {0.2, -0.05, 60, 30, 15, 1.1, 1.2, 1.5}
  };
end ParametersOEL;
