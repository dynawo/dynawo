within Dynawo.Examples.RVS.Components.GeneratorWithControl.Util;

record ParametersIEEET1

  type genFramePreset = enumeration(g10118, g10121) "Generator Names";
  type exciterParamNames = enumeration(Tr, Ka, Ta, URegMaxPu, URegMinPu, Ke, Te, Kf, Tf, e1, s1, e2, s2) "Parameter Names";
  
  // Tr, Ka, Ta, URegMax, URegMin, Ke, Te, Kf, Tf, e1, s1, e2, s2
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47},
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47}
  };
end ParametersIEEET1;
