within Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses;
record ParametersIEEET1 "Parameter sets for the IEEET1 regulations of the RVS test system"

  type genFramePreset = enumeration(g10118, g10121) "Generator names";
  type exciterParamNames = enumeration(tR, Ka, tA, EfdRawMaxPu, EfdRawMinPu, Ke, tE, Kf, tF,EfdLowPu, EfdSatLowPu, EfdHighPu, EfdSatHighPu) "Parameter names";

  // tR, Ka, tA, EfdRawMaxPu, EfdRawMinPu, Ke, tE, Kf, tF, EfdLowPu, EfdSatLowPu, EfdHighPu, EfdSatHighPu
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47},
    {1e-5, 400, 0.04, 7.3, -7.3, 1, 0.8, 0.03, 1, 3.375, 0.035, 4.5, 0.47}}
    "Matrix of IEEET1 parameters";

  annotation(preferredView = "text");
end ParametersIEEET1;
