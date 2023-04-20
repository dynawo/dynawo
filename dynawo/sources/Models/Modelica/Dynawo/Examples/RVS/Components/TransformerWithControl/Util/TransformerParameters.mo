within Dynawo.Examples.RVS.Components.TransformerWithControl.Util;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record TransformerParameters
  import Dynawo.Types;
  import Modelica.SIunits;

  type tfoPreset = enumeration(trafo_1101_101, trafo_1102_102, trafo_1103_103, trafo_1104_104, trafo_1105_105, trafo_1106_106, trafo_1107_107, trafo_1108_108, trafo_1109_109, trafo_1110_110, trafo_1113_113, trafo_1114_114, trafo_1115_115, trafo_1116_116, trafo_1118_118, trafo_1119_119, trafo_1120_120, trafo_103_124, trafo_109_111, trafo_109_112, trafo_110_111,trafo_110_112);
  type tfoParams = enumeration(SNom, R, X, t1st, tNext, Uc20Pu);

  final constant Integer NbTap = 33;
  final constant Types.PerUnit rTfoMinPu = 0.9;
  final constant Types.PerUnit rTfoMaxPu = 1.1;
  final constant Types.PerUnit[tfoPreset, tfoParams] tfoParamValues = {
    { 150.0, 0.003 *(1 + (10 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (10 - 16) * 0.625 / 100)^2*100, 30,  5, 1.03413}, // trafo_1101_101
    { 150.0, 0.003 *(1 + (11 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (11 - 16) * 0.625 / 100)^2*100, 30,  5, 1.03574}, // trafo_1102_102
    { 250.0, 0.003 *(1 + (5  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (5  - 16) * 0.625 / 100)^2*100, 30, 5, 1.00508}, // trafo_1103_103
    { 100.0, 0.003 *(1 + (4  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (4  - 16) * 0.625 / 100)^2*100, 30, 5, 1.0}, // trafo_1104_104
    { 100.0, 0.003 *(1 + (15 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (15 - 16) * 0.625 / 100)^2*100, 30, 5, 1.00338}, // trafo_1105_105
    { 200.0, 0.003 *(1 + (10 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (10 - 16) * 0.625 / 100)^2*100, 30,  5, 1.02547}, // trafo_1106_106
    { 200.0, 0.003 *(1 + (10 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (10 - 16) * 0.625 / 100)^2*100, 30,  5, 1.02857}, // trafo_1107_107
    { 250.0, 0.003 *(1 + (7  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (7  - 16) * 0.625 / 100)^2*100, 30, 5, 1.01284}, // trafo_1108_108
    { 250.0, 0.003 *(1 + (7  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (7  - 16) * 0.625 / 100)^2*100, 30, 5, 1.01811}, // trafo_1109_109
    { 250.0, 0.003 *(1 + (6  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (6  - 16) * 0.625 / 100)^2*100, 30, 5, 1.00948}, // trafo_1110_110
    { 350.0, 0.003 *(1 + (7  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (7  - 16) * 0.625 / 100)^2*100, 30,  5, 1.01993}, // trafo_1113_113
    { 250.0, 0.003 *(1 + (6  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (6  - 16) * 0.625 / 100)^2*100, 30,  5, 1.00841}, // trafo_1114_114
    { 400.0, 0.003 *(1 + (6  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (6  - 16) * 0.625 / 100)^2*100, 30, 5, 1.01063}, // trafo_1115_115
    { 150.0, 0.003 *(1 + (8  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (8  - 16) * 0.625 / 100)^2*100, 30, 5, 1.01588}, // trafo_1116_116
    { 450.0, 0.003 *(1 + (11 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (11 - 16) * 0.625 / 100)^2*100, 30, 5, 1.04241}, // trafo_1118_118
    { 250.0, 0.003 *(1 + (7  - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (7  - 16) * 0.625 / 100)^2*100, 30,  5, 1.01758}, // trafo_1119_119
    { 200.0, 0.003 *(1 + (10 - 16) * 0.625 / 100)^2*100, 0.15 *(1 + (10 - 16) * 0.625 / 100)^2*100, 30,  5, 1.03469}, // trafo_1120_120
    { 400.0, 0.008 *(1 + (1  - 16) * 0.625 / 100)^2*100, 0.336*(1 + (1  - 16) * 0.625 / 100)^2*100, 30, 5, 0.955}, // trafo_103_124
    { 400.0, 0.008 *(1 + (0  - 16) * 0.625 / 100)^2*100, 0.336*(1 + (0  - 16) * 0.625 / 100)^2*100, 30, 5, 0.9851}, // trafo_109_112
    { 400.0, 0.008 *(1 + (12 - 16) * 0.625 / 100)^2*100, 0.336*(1 + (12 - 16) * 0.625 / 100)^2*100, 30,  5, 0.9872}, // trafo_109_111
    { 400.0, 0.008 *(1 + (13 - 16) * 0.625 / 100)^2*100, 0.336*(1 + (13 - 16) * 0.625 / 100)^2*100, 30,  5, 0.9872}, // trafo_110_111
    { 400.0, 0.008 *(1 + (12 - 16) * 0.625 / 100)^2*100, 0.336*(1 + (12 - 16) * 0.625 / 100)^2*100, 30, 5, 0.9851}  // trafo_110_112
  };

  annotation(
    Documentation(info = "<html><head></head><body>The TransformerParameters record keeps parameters for transformers and their LTCs in a parameter matrix. Values were taken from the report.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the transformer frame that has chosen the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the transformer enumeration.</div></body></html>"));
end TransformerParameters;
