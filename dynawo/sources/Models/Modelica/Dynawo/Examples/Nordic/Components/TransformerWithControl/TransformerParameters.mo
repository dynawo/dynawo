within Dynawo.Examples.Nordic.Components.TransformerWithControl;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record TransformerParameters "Parameter sets for the transformers of the Nordic 32 test system"

  type tfoPreset = enumeration(trafo_11_1011, trafo_12_1012, trafo_13_1013, trafo_22_1022, trafo_1_1041, trafo_2_1042, trafo_3_1043, trafo_4_1044, trafo_5_1045, trafo_31_2031, trafo_32_2032, trafo_41_4041, trafo_42_4042, trafo_43_4043, trafo_46_4046, trafo_47_4047, trafo_51_4051, trafo_61_4061, trafo_62_4062, trafo_63_4063, trafo_71_4071, trafo_72_4072) "Transformer names";
  type tfoParams = enumeration(SNom, X, t1st, tNext, Uc20Pu) "Transformer parameters";

  final constant Integer NbTap = 33 "Number of taps";
  final constant Types.PerUnit rTfoMaxPu = 1.20 "Maximum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit rTfoMinPu = 0.88 "Minimum transformation ratio in pu : U2/U1 in no load conditions";
  final constant Types.PerUnit[tfoPreset, tfoParams] tfoParamValues = {
    { 400.0, 10, 30,  8, 1.0617817233}, // trafo_11_1011
    { 600.0, 10, 30,  9, 1.0633877608}, // trafo_12_1012
    { 200.0, 10, 30, 10, 1.0548135150}, // trafo_13_1013
    { 560.0, 10, 30, 11, 1.0512620890}, // trafo_22_1022
    {1200.0, 10, 29, 12, 1.0126592731}, // trafo_1_1041
    { 600.0, 10, 29,  8, 1.0145882308}, // trafo_2_1042
    { 460.0, 10, 29,  9, 1.0276763645}, // trafo_3_1043
    {1600.0, 10, 29, 10, 1.0069023865}, // trafo_4_1044
    {1400.0, 10, 29, 11, 1.0113193551}, // trafo_5_1045
    { 200.0, 10, 29, 12, 1.0279822095}, // trafo_31_2031
    { 400.0, 10, 31,  8, 1.0694910726}, // trafo_32_2032
    {1080.0, 10, 31,  9, 1.0508697568}, // trafo_41_4041
    { 800.0, 10, 31, 10, 1.0431566105}, // trafo_42_4042
    {1800.0, 10, 31, 11, 1.0372543274}, // trafo_43_4043
    {1400.0, 10, 31, 12, 1.0359493468}, // trafo_46_4046
    { 200.0, 10, 30,  8, 1.0592054548}, // trafo_47_4047
    {1600.0, 10, 30,  9, 1.0660813685}, // trafo_51_4051
    {1000.0, 10, 30, 10, 1.0388494513}, // trafo_61_4061
    { 600.0, 10, 30, 11, 1.0561122946}, // trafo_62_4062
    {1180.0, 10, 30, 12, 1.0535950291}, // trafo_63_4063
    { 600.0, 10, 31,  9, 1.0484438970}, // trafo_71_4071
    {4000.0, 10, 31, 11, 1.0590066267}  // trafo_72_4072
  } "Matrix of transformer parameters";

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The TransformerParameters record keeps parameters for transformers and their LTCs in a parameter matrix. Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the transformer frame whose name is the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the transformer enumeration.</div></body></html>"));
end TransformerParameters;
