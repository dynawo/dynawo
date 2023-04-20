within Dynawo.Examples.RVS.Components.GeneratorWithControl.Util;

record ParametersSCRX

  type genFramePreset = enumeration(g10107, g20107, g30107, g10113, g20113, g30113, g10115, g20115, g30115, g40115, g50115, g60115, g10116, g10122, g20122, g30122, g40122, g50122, g60122, g10123, g20123, g30123) "Generator Names";
  type exciterParamNames = enumeration(Ta, Tb, K, Te, EMinPu, EMaxPu) "Parameter Names";
  
  // Ta, Tb, K, Te, EMin, EMax
  final constant Real[genFramePreset, exciterParamNames] exciterParams = {
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4},
    {1, 10, 200, 0.2, -3.2, 4}
  };
end ParametersSCRX;
