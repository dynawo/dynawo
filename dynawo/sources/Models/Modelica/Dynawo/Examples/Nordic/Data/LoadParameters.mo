within Dynawo.Examples.Nordic.Data;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

record LoadParameters
  import Dynawo;

  extends Dynawo.Examples.Nordic.Data.BaseClasses.OperatingPoints;

  //Load parameters
  type loadParams = enumeration(P0Pu, Q0Pu, U0Pu, UPhase0) "Load parameters";
  type loadPreset = enumeration(load_01, load_02, load_03, load_04, load_05, load_11, load_12, load_13, load_22, load_31, load_32, load_41, load_42, load_43, load_46, load_47, load_51, load_61, load_62, load_63, load_71, load_72) "Load names";

  //P0Pu, Q0Pu, U0Pu, UPhase0
  final constant Real[operatingPoints, loadPreset, loadParams] loadValues = {{
    { 6.0, 1.482, 0.9988009, -1.478398}, // load_01
    { 3.3, 0.710, 1.0011910, -1.230248}, // load_02
    { 2.6, 0.838, 0.9974228, -1.395666}, // load_03
    { 8.4, 0.252, 0.9996420, -1.233435}, // load_04
    { 7.2, 1.904, 0.9960814, -1.301834}, // load_05
    { 2.0, 0.688, 1.0025660, -0.1648865}, // load_11
    { 3.0, 0.838, 0.9975072, -0.1035778}, // load_12
    { 1.0, 0.344, 0.9957253, -0.027582390}, // load_13
    { 2.8, 0.799, 0.9952281, -0.3821220}, // load_22
    { 1.0, 0.247, 1.0041920, -0.6888105}, // load_31
    { 2.0, 0.396, 0.9977580, -0.4672544},  // load_32
    { 5.4, 1.314, 0.9967414, -0.9973125}, // load_41
    { 4.0, 1.274, 0.9952245, -1.050958}, // load_42
    { 9.0, 2.546, 1.0012870, -1.157611}, // load_43
    { 7.0, 2.118, 0.9990333, -1.168198}, // load_46
    { 1.0, 0.440, 0.9949639, -1.088663}, // load_47
    { 8.0, 2.582, 0.9977574, -1.288738}, // load_51
    { 5.0, 1.225, 0.9948822, -1.060873}, // load_61
    { 3.0, 0.838, 1.0002120, -0.9979323}, // load_62
    { 5.9, 2.646, 0.9991999, -0.9335496}, // load_63
    { 3.0, 0.838, 1.0027570, -0.1361431}, // load_71
    {20.0, 3.961, 0.9974027, -0.1191375}  // load_72
    },{
    { 6.0, 1.482, 0.9941214, -0.8036354}, // load_01
    { 3.3, 0.710, 0.9929625, -0.5674498}, // load_02
    { 2.6, 0.838, 0.9941552, -0.7314653}, // load_03
    { 8.4, 0.252, 0.9978839, -0.5844976}, // load_04
    { 7.2, 1.904, 0.9981326, -0.6080171}, // load_05
    { 2.0, 0.688, 1.0059280,  0.1340256}, // load_11
    { 3.0, 0.838, 1.0008540,  0.1886482}, // load_12
    { 1.0, 0.344, 1.0041950,  0.2679330}, // load_13
    { 2.8, 0.799, 1.0066180,  0.012012796}, // load_22
    { 1.0, 0.247, 1.0013210, -0.1789084}, // load_31
    { 2.0, 0.396, 1.0052560,  0.033078119},  // load_32
    { 5.4, 1.314, 1.0036940, -0.4089010}, // load_41
    { 4.0, 1.274, 0.9993935, -0.4389001}, // load_42
    { 9.0, 2.546, 1.0005700, -0.5211374}, // load_43
    { 7.0, 2.118, 1.0010010, -0.5299331}, // load_46
    { 1.0, 0.440, 1.0029370, -0.4542393}, // load_47
    { 8.0, 2.582, 1.0016060, -0.4888929}, // load_51
    { 5.0, 1.225, 1.0064600, -0.4361369}, // load_61
    { 3.0, 0.838, 1.0081850, -0.3626608}, // load_62
    { 5.9, 2.646, 1.0083070, -0.2989589}, // load_63
    { 3.0, 0.838, 1.0038930, -0.0070269261}, // load_71
    {20.0, 3.961, 0.9959809, -0.094556138}  // load_72
    }} "Matrix of load parameters";

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The LoadParameters record keeps parameters for loads in a parameter matrix.<div><br></div><div>Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.</div><div><br><div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the shunt whose name is the preset.</div><div><br></div><div>To add a preset, append a vector to the matrices and add an entry in the shunt enumeration.</div></div></body></html>"));
end LoadParameters;
