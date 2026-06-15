within Dynawo.Examples.RVS.Components.StaticVarCompensators.BaseClasses;
record ParametersSVC "Parameter sets for the static VAR compensators of the RVS test system"

  type svcFramePreset = enumeration(sVarC_10106, sVarC_10114) "SVarC names";
  type svcParamNames = enumeration(UOvPu, BShuntPu, BMin, BMax, VMin, VMax, K, t3, t5) "Generator parameters";

  // UOvPu, BShuntPu, BMin, BMax, VMin, VMax, K, t3, t5
  final constant Real[svcFramePreset, svcParamNames] svcParamValues = {
    {0.5, 0, -50, 100, -50, 100, 150 * 150, 3.45, 0.3},
    {0.5, 0, -50, 200, -50, 200, 150 * 250, 3.55, 0.3}}
    "Matrix of static var compensator parameters";      //K is multiplied by susceptance range
                                                        //K is multiplied by susceptance range

  annotation(preferredView = "text");
end ParametersSVC;
