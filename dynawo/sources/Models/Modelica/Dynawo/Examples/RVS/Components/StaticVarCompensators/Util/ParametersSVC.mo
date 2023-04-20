within Dynawo.Examples.RVS.Components.StaticVarCompensators.Util;

record ParametersSVC
  import Dynawo.Electrical.SystemBase.SnRef;

  type svcFramePreset = enumeration(sVarC_10106, sVarC_10114) "SVarC Names";
  type svcParamNames = enumeration(SBase, UNom, UovPu, BShuntPu, BMin, BMax, VMin, VMax, K, T1, T2, T3, T4, T5) "Generator parameters";
  
  // SBase, UNom, UovPu, BShuntPu, BMin, BMax, VMin, VMax, K, T1, T2, T3, T4, T5
  final constant Real[svcFramePreset, svcParamNames] svcParamValues = {
    {1, 18, 0.5, 0, -50, 100, -50, 100, 150 * 150, 0, 0, 3.45, 0, 0.3}, //K needs to be multiplied by susceptance range
    {1, 18, 0.5, 0, -50, 200, -50, 200, 150 * 250, 0, 0, 3.55, 0, 0.3}  //K needs to be multiplied by susceptance range
  };
  
end ParametersSVC;
