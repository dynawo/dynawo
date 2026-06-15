within Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses;
record TransformerParameters "Parameter sets for the transformers of the RVS test system"

  type tfoPreset = enumeration(trafo_1101_101, trafo_1102_102, trafo_1103_103, trafo_1104_104, trafo_1105_105, trafo_1106_106, trafo_1107_107, trafo_1108_108, trafo_1109_109, trafo_1110_110, trafo_1113_113, trafo_1114_114, trafo_1115_115, trafo_1116_116, trafo_1118_118, trafo_1119_119, trafo_1120_120, trafo_103_124, trafo_109_111, trafo_109_112, trafo_110_111, trafo_110_112) "Transformer names";
  type tfoParams = enumeration(SNom, R, X, t1st, tNext, Uc20Pu) "Transformer parameters";

  final constant Integer NbTap = 33 "Number of taps";
  final constant Types.PerUnit rTfoMaxPu = 1.1 "Maximum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit rTfoMinPu = 0.9 "Minimum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit[tfoPreset, tfoParams] tfoParamValues = {
    {150, 0.3, 15,   30, 5, 1.03413},
    {150, 0.3, 15,   30, 5, 1.03574},
    {250, 0.3, 15,   30, 5, 1.00508},
    {100, 0.3, 15,   30, 5, 1.0},
    {100, 0.3, 15,   30, 5, 1.00338},
    {200, 0.3, 15,   30, 5, 1.02547},
    {200, 0.3, 15,   30, 5, 1.02857},
    {250, 0.3, 15,   30, 5, 1.01284},
    {250, 0.3, 15,   30, 5, 1.01811},
    {250, 0.3, 15,   30, 5, 1.00948},
    {350, 0.3, 15,   30, 5, 1.01993},
    {250, 0.3, 15,   30, 5, 1.00841},
    {400, 0.3, 15,   30, 5, 1.01063},
    {150, 0.3, 15,   30, 5, 1.01588},
    {450, 0.3, 15,   30, 5, 1.04241},
    {250, 0.3, 15,   30, 5, 1.01758},
    {200, 0.3, 15,   30, 5, 1.03469},
    {400, 0.8, 33.6, 30, 5, 0.955},
    {400, 0.8, 33.6, 30, 5, 0.9872},
    {400, 0.8, 33.6, 30, 5, 0.9851},
    {400, 0.8, 33.6, 30, 5, 0.9872},
    {400, 0.8, 33.6, 30, 5, 0.9851}}
    "Matrix of transformer parameters";
                                      // trafo_1101_101
                                      // trafo_1102_102
                                      // trafo_1103_103
                                      // trafo_1104_104
                                      // trafo_1105_105
                                      // trafo_1106_106
                                      // trafo_1107_107
                                      // trafo_1108_108
                                      // trafo_1109_109
                                      // trafo_1110_110
                                      // trafo_1113_113
                                      // trafo_1114_114
                                      // trafo_1115_115
                                      // trafo_1116_116
                                      // trafo_1118_118
                                      // trafo_1119_119
                                      // trafo_1120_120
                                      // trafo_103_124
                                      // trafo_109_111
                                      // trafo_109_112
                                      // trafo_110_111
                                      // trafo_110_112

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The TransformerParameters record keeps parameters for transformers and their LTCs in a parameter matrix. Values were taken from the report.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the transformer frame that has chosen the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the transformer enumeration.</div></body></html>"));
end TransformerParameters;
