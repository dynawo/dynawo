within Dynawo.Examples.RVS.Components.GeneratorWithControl.BaseClasses;
record ParametersHYGOV "Parameter sets for the HYGOV regulations of the RVS test system"

  type genFramePreset = enumeration(g10122, g20122, g30122, g40122, g50122, g60122) "Generator names";
  type exciterParamNames = enumeration(KDroopPerm, KDroopTemp, tR, tF, tG, VelMaxPu, OpeningGateMax, OpeningGateMin, tW, At, DTurb, FlowNoLoad) "Parameter names";

  // KDroopPerm, KDroopTemp, tR, tF, tG, VelMaxPu, OpeningGateMax, OpeningGateMin, tW, At, DTurb, FlowNoLoad
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08},
    {0.05, 0.3, 5, 0.05, 0.5, 0.2, 0.9, 0, 1.25, 1.2, 0.2, 0.08}}
    "Matrix of HYGOV parameters";

  annotation(preferredView = "text");
end ParametersHYGOV;
