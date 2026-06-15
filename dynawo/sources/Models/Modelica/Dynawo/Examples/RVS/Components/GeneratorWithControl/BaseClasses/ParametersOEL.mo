within Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses;
record ParametersOEL "Parameter sets for the OEL regulations of the RVS test system"

  type oelFramePreset = enumeration(all) "OEL preset names";
  type oelParamNames = enumeration(Kmx, ULowPu, t1, t2, t3, Ifd1Pu, Ifd2Pu, Ifd3Pu) "Parameter names";

  // Kmx, ULowPu, t1, t2, t3, Ifd1Pu, Ifd2Pu, Ifd3Pu
  final constant Real[oelFramePreset, oelParamNames] oelParamValues = {
    {0.2, -0.05, 60, 30, 15, 1.1, 1.2, 1.5}}
    "Matrix of OEL parameters";

  annotation(preferredView = "text");
end ParametersOEL;
