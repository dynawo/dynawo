within Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses;
record ParametersEXAC "Parameter sets for the EXAC regulations of the RVS test system"

  type genFramePreset = enumeration(g10101, g20101, g30101, g40101, g10102, g20102, g30102, g40102) "Generator names";
  type exciterParamNames = enumeration(tR, tB, tC, Ka, tA, VrMaxPu, VrMinPu, tE, Kf, tF, Kc, Kd, Ke, VExcLowPu, VExcSatLowPu, VExcHighPu, VExcSatHighPu) "Parameter names";

  // tR, tB, tC, Ka, tA, VrMaxPu, VrMinPu, tE, Kf, tF, Kc, Kd, Ke, VExcLowPu, VExcSatLowPu, VExcHighPu, VExcSatHighPu
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1},
    {1e-5, 1e-5, 1e-5, 400, 0.02, 9, -5.43, 0.8, 0.03, 1, 0.2, 0.48, 1, 5.25, 0.03, 7, 0.1}}
    "Matrix of EXAC parameters";

  annotation(preferredView = "text");
end ParametersEXAC;
