within Dynawo.Examples.Nordic.Components.TransformerWithControl;
record TransformerParameters "Parameter sets for the transformers of the Nordic 32 test system"

  type tfoPreset = enumeration(trafo_11_1011, trafo_12_1012, trafo_13_1013, trafo_22_1022, trafo_1_1041, trafo_2_1042, trafo_3_1043, trafo_4_1044, trafo_5_1045, trafo_31_2031, trafo_32_2032, trafo_41_4041, trafo_42_4042, trafo_43_4043, trafo_46_4046, trafo_47_4047, trafo_51_4051, trafo_61_4061, trafo_62_4062, trafo_63_4063, trafo_71_4071, trafo_72_4072) "Transformer names";
  type tfoParams = enumeration(SNom, X, t1st, tNext, Uc20Pu) "Transformer parameters";

  final constant Integer NbTap = 33 "Number of taps";
  final constant Types.PerUnit rTfoMaxPu = 1.20 "Maximum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit rTfoMinPu = 0.88 "Minimum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit[tfoPreset, tfoParams] tfoParamValues = {
    { 400.0, 10, 30,  8, 1.0617817233},
    { 600.0, 10, 30,  9, 1.0633877608},
    { 200.0, 10, 30, 10, 1.0548135150},
    { 560.0, 10, 30, 11, 1.0512620890},
    {1200.0, 10, 29, 12, 1.0126592731},
    { 600.0, 10, 29,  8, 1.0145882308},
    { 460.0, 10, 29,  9, 1.0276763645},
    {1600.0, 10, 29, 10, 1.0069023865},
    {1400.0, 10, 29, 11, 1.0113193551},
    { 200.0, 10, 29, 12, 1.0279822095},
    { 400.0, 10, 31,  8, 1.0694910726},
    {1080.0, 10, 31,  9, 1.0508697568},
    { 800.0, 10, 31, 10, 1.0431566105},
    {1800.0, 10, 31, 11, 1.0372543274},
    {1400.0, 10, 31, 12, 1.0359493468},
    { 200.0, 10, 30,  8, 1.0592054548},
    {1600.0, 10, 30,  9, 1.0660813685},
    {1000.0, 10, 30, 10, 1.0388494513},
    { 600.0, 10, 30, 11, 1.0561122946},
    {1180.0, 10, 30, 12, 1.0535950291},
    { 600.0, 10, 31,  9, 1.0484438970},
    {4000.0, 10, 31, 11, 1.0590066267}}
    "Matrix of transformer parameters"; // trafo_11_1011
                                        // trafo_12_1012
                                        // trafo_13_1013
                                        // trafo_22_1022
                                        // trafo_1_1041
                                        // trafo_2_1042
                                        // trafo_3_1043
                                        // trafo_4_1044
                                        // trafo_5_1045
                                        // trafo_31_2031
                                        // trafo_32_2032
                                        // trafo_41_4041
                                        // trafo_42_4042
                                        // trafo_43_4043
                                        // trafo_46_4046
                                        // trafo_47_4047
                                        // trafo_51_4051
                                        // trafo_61_4061
                                        // trafo_62_4062
                                        // trafo_63_4063
                                        // trafo_71_4071
                                        // trafo_72_4072

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The TransformerParameters record keeps parameters for transformers and their LTCs in a parameter matrix. Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the transformer frame whose name is the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the transformer enumeration.</div></body></html>"));
end TransformerParameters;
