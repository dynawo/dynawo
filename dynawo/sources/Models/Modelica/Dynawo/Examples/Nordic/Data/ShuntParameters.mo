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

record ShuntParameters
  import Dynawo;

  extends Dynawo.Examples.Nordic.Data.BaseClasses.OperatingPoints;

  //Shunt parameters
  type shuntParams = enumeration(BPu, U0Pu, UPhase0) "Shunt parameters";
  type shuntPreset = enumeration(shunt_1022, shunt_1041, shunt_1043, shunt_1044, shunt_1045, shunt_4012, shunt_4041, shunt_4043, shunt_4046, shunt_4051, shunt_4071) "Shunt names";

  //BPu, U0Pu, UPhase0
  final constant Real[operatingPoints, shuntPreset, shuntParams] shuntValues = {{
    {-0.5, 1.051246, -0.3323992}, // shunt_1022
    {-2.5, 1.012404, -1.428931}, // shunt_1041
    {-2.0, 1.027439, -1.339932}, // shunt_1043
    {-2.0, 1.006587, -1.181759}, // shunt_1044
    {-2.0, 1.011054, -1.250746}, // shunt_1045
    { 1.0, 1.023550, -0.096629612}, // shunt_4012
    {-2.0, 1.050602, -0.9476349}, // shunt_4041
    {-2.0, 1.036973, -1.108472}, // shunt_4043
    {-1.0, 1.035719, -1.118889}, // shunt_4046
    {-1.0, 1.065927, -1.239354}, // shunt_4051
    { 4.0, 1.048445, -0.087138198}  // shunt_4071
    },{
    {-0.5, 1.103760,  0.060633987}, // shunt_1022
    {-2.5, 1.017878, -0.7537084}, // shunt_1041
    {-2.0, 1.034356, -0.6753710}, // shunt_1043
    {-2.0, 1.015032, -0.5326422}, // shunt_1044
    {-2.0, 1.013074, -0.5571344}, // shunt_1045
    { 1.0, 1.043175,  0.1962191}, // shunt_4012
    {-2.0, 1.108570, -0.3598998}, // shunt_4041
    {-2.0, 1.087052, -0.4719299}, // shunt_4043
    {-1.0, 1.078382, -0.4808147}, // shunt_4046
    {-1.0, 1.100456, -0.4398814}, // shunt_4051
    { 4.0, 1.049594,  0.041868888}  // shunt_4071
    }} "Matrix of shunt parameters";

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The ShuntParameters record keeps parameters for shunts in a parameter matrix.<div><br></div><div>Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.</div><div><br><div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the shunt whose name is the preset.</div><div><br></div><div>To add a preset, append a vector to the matrices and add an entry in the shunt enumeration.</div></div></body></html>"));
end ShuntParameters;
