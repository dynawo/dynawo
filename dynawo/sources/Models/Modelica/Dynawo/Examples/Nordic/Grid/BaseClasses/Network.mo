within Dynawo.Examples.Nordic.Grid.BaseClasses;

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

model Network "Nordic test grid with buses, lines and shunts"
  import Modelica.SIunits;
  import Dynawo.Electrical;

  Electrical.Buses.Bus bus_B01 annotation(
    Placement(visible = true, transformation(origin = {-55, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B02 annotation(
    Placement(visible = true, transformation(origin = {35, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B03 annotation(
    Placement(visible = true, transformation(origin = {-65, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B04 annotation(
    Placement(visible = true, transformation(origin = {-25, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B05 annotation(
    Placement(visible = true, transformation(origin = {-25, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B11 annotation(
    Placement(visible = true, transformation(origin = {21, 115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B12 annotation(
    Placement(visible = true, transformation(origin = {39, 115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B13 annotation(
    Placement(visible = true, transformation(origin = {85, 115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B22 annotation(
    Placement(visible = true, transformation(origin = {-40, 35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B31 annotation(
    Placement(visible = true, transformation(origin = {-35, 5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B32 annotation(
    Placement(visible = true, transformation(origin = {-89, 5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B41 annotation(
    Placement(visible = true, transformation(origin = {-81, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B42 annotation(
    Placement(visible = true, transformation(origin = {55, 5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B43 annotation(
    Placement(visible = true, transformation(origin = {25, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B47 annotation(
    Placement(visible = true, transformation(origin = {61, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B46 annotation(
    Placement(visible = true, transformation(origin = {71, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B51 annotation(
    Placement(visible = true, transformation(origin = {35, -115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B61 annotation(
    Placement(visible = true, transformation(origin = {-95, -65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B62 annotation(
    Placement(visible = true, transformation(origin = {-100, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B63 annotation(
    Placement(visible = true, transformation(origin = {-80, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B71 annotation(
    Placement(visible = true, transformation(origin = {-95, 115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_B72 annotation(
    Placement(visible = true, transformation(origin = {-88, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG01 annotation(
    Placement(visible = true, transformation(origin = {25, 85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG02 annotation(
    Placement(visible = true, transformation(origin = {75, 145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG03 annotation(
    Placement(visible = true, transformation(origin = {85, 85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG04 annotation(
    Placement(visible = true, transformation(origin = {-85, 35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG05 annotation(
    Placement(visible = true, transformation(origin = {-45, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG06 annotation(
    Placement(visible = true, transformation(origin = {35, -65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG07 annotation(
    Placement(visible = true, transformation(origin = {-53, -45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG08 annotation(
    Placement(visible = true, transformation(origin = {-77, 5}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG09 annotation(
    Placement(visible = true, transformation(origin = {-25, 145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG10 annotation(
    Placement(visible = true, transformation(origin = {-35, 85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG11 annotation(
    Placement(visible = true, transformation(origin = {35, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG12 annotation(
    Placement(visible = true, transformation(origin = {-4, 35}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG13 annotation(
    Placement(visible = true, transformation(origin = {-70, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG14 annotation(
    Placement(visible = true, transformation(origin = {50, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG15 annotation(
    Placement(visible = true, transformation(origin = {80, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG16 annotation(
    Placement(visible = true, transformation(origin = {20, -115}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG17 annotation(
    Placement(visible = true, transformation(origin = {-78, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG18 annotation(
    Placement(visible = true, transformation(origin = {-95, -145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG19 annotation(
    Placement(visible = true, transformation(origin = {-75, 145}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_BG20 annotation(
    Placement(visible = true, transformation(origin = {-75, 65}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Buses.Bus bus_1011 annotation(
    Placement(visible = true, transformation(origin = {30, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1012 annotation(
    Placement(visible = true, transformation(origin = {30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1013 annotation(
    Placement(visible = true, transformation(origin = {80, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1014 annotation(
    Placement(visible = true, transformation(origin = {80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1021 annotation(
    Placement(visible = true, transformation(origin = {-80, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1022 annotation(
    Placement(visible = true, transformation(origin = {-40, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1041 annotation(
    Placement(visible = true, transformation(origin = {-60, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1042 annotation(
    Placement(visible = true, transformation(origin = {30, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1043 annotation(
    Placement(visible = true, transformation(origin = {-60, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1044 annotation(
    Placement(visible = true, transformation(origin = {-20, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_1045 annotation(
    Placement(visible = true, transformation(origin = {-17, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_2031 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_2032 annotation(
    Placement(visible = true, transformation(origin = {-80, 21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4011 annotation(
    Placement(visible = true, transformation(origin = {-30, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4012 annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4021 annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4022 annotation(
    Placement(visible = true, transformation(origin = {-10, 49}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4031 annotation(
    Placement(visible = true, transformation(origin = {-13, 21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4032 annotation(
    Placement(visible = true, transformation(origin = {30, 21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4041 annotation(
    Placement(visible = true, transformation(origin = {-78, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4042 annotation(
    Placement(visible = true, transformation(origin = {50, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4043 annotation(
    Placement(visible = true, transformation(origin = {30, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4044 annotation(
    Placement(visible = true, transformation(origin = {-6, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4045 annotation(
    Placement(visible = true, transformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4046 annotation(
    Placement(visible = true, transformation(origin = {70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4047 annotation(
    Placement(visible = true, transformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4051 annotation(
    Placement(visible = true, transformation(origin = {14, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4061 annotation(
    Placement(visible = true, transformation(origin = {-92.5, -50.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));
  Electrical.Buses.Bus bus_4062 annotation(
    Placement(visible = true, transformation(origin = {-87, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4063 annotation(
    Placement(visible = true, transformation(origin = {-87, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.Bus bus_4071 annotation(
    Placement(visible = true, transformation(origin = {-80, 130}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Electrical.Buses.Bus bus_4072 annotation(
    Placement(visible = true, transformation(origin = {-82.5, 80.5}, extent = {{-7.5, -7.5}, {7.5, 7.5}}, rotation = 0)));

  Electrical.Lines.Line line_1011_1013a(BPu = 4.0841e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 11.83 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {50, 128}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1011_1013b(BPu = 4.0841e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 11.83 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {50, 125}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1012_1014a(BPu = 5.3407e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 2.37 / XBase_130, XPu = 15.21 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {55, 98}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1012_1014b(BPu = 5.3407e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 2.37 / XBase_130, XPu = 15.21 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {55, 95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1013_1014a(BPu = 2.9845e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.18 / XBase_130, XPu = 8.450 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {75, 113}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_1013_1014b(BPu = 2.9845e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.18 / XBase_130, XPu = 8.450 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {78, 113}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_1021_1022a(BPu = 8.9535e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 5.07 / XBase_130, XPu = 33.80 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-63, 45}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1021_1022b(BPu = 8.9535e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 5.07 / XBase_130, XPu = 33.80 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-63, 42}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1041_1043a(BPu = 3.6128e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 10.14 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-65, -75}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Electrical.Lines.Line line_1041_1043b(BPu = 3.6128e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 10.14 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-62, -75}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Electrical.Lines.Line line_1041_1045a(BPu = 7.3827e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 2.53 / XBase_130, XPu = 20.28 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-35, -84}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1041_1045b(BPu = 7.3827e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 2.53 / XBase_130, XPu = 20.28 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-35, -87}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1042_1044a(BPu = 1.7750e-4 * XBase_130, GPu = 0 * XBase_130, RPu = 6.42 / XBase_130, XPu = 47.32 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {10, -74}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1042_1044b(BPu = 1.7750e-4 * XBase_130, GPu = 0 * XBase_130, RPu = 6.42 / XBase_130, XPu = 47.32 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {10, -71}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1042_1045(BPu = 1.7750e-4 * XBase_130, GPu = 0 * XBase_130, RPu = 8.45 / XBase_130, XPu = 50.70 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {10, -85}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1043_1044a(BPu = 4.7124e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 13.52 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-40, -63}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_1043_1044b(BPu = 4.7124e-5 * XBase_130, GPu = 0 * XBase_130, RPu = 1.69 / XBase_130, XPu = 13.52 / XBase_130) annotation(
    Placement(visible = true, transformation(origin = {-40, -66}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_2031_2032a(BPu = 1.5708e-5 * XBase_220, GPu = 0 * XBase_220, RPu = 5.81 / XBase_220, XPu = 43.56 / XBase_220) annotation(
    Placement(visible = true, transformation(origin = {-60, 18}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_2031_2032b(BPu = 1.5708e-5 * XBase_220, GPu = 0 * XBase_220, RPu = 5.81 / XBase_220, XPu = 43.56 / XBase_220) annotation(
    Placement(visible = true, transformation(origin = {-60, 15}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4011_4012(BPu = 6.2832e-5 * XBase_400, GPu = 0 * XBase_400, RPu = 1.60 / XBase_400, XPu = 12.80 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-34, 118}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4011_4021(BPu = 5.6234e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 9.60 / XBase_400, XPu = 96.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {5, 88}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4011_4022(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-10, 88}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4011_4071(BPu = 4.3825e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 8.00 / XBase_400, XPu = 72.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-53, 120}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4012_4022(BPu = 3.2830e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 56.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-20, 75}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4012_4071(BPu = 4.6810e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 8.00 / XBase_400, XPu = 80.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-53, 117}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4021_4032(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {23, 40}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4021_4042(BPu = 9.3777e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 16.0 / XBase_400, XPu = 96.0 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {44, 22}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4022_4031a(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-17, 40}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4022_4031b(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-13, 40}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4031_4032(BPu = 9.4248e-5 * XBase_400, GPu = 0 * XBase_400, RPu = 1.60 / XBase_400, XPu = 16.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {8, 21}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4031_4041a(BPu = 7.4927e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 9.60 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-22, 6}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4031_4041b(BPu = 7.4927e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 9.60 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-19, 6}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4032_4042(BPu = 6.2518e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 16.0 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {34, 9}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4032_4044(BPu = 7.4927e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 9.60 / XBase_400, XPu = 80.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-6, -4}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4041_4044(BPu = 2.8117e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 4.80 / XBase_400, XPu = 48.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-40, -15}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4041_4061(BPu = 4.0684e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 9.60 / XBase_400, XPu = 72.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-87, -35}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4042_4043(BPu = 1.5551e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 24.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {41, -20}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4042_4044(BPu = 1.8693e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 32.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {3, -17}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4043_4044(BPu = 9.4248e-5 * XBase_400, GPu = 0 * XBase_400, RPu = 1.60 / XBase_400, XPu = 16.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {12, -34}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4043_4046(BPu = 9.4248e-5 * XBase_400, GPu = 0 * XBase_400, RPu = 1.60 / XBase_400, XPu = 16.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {49, -49}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4043_4047(BPu = 1.8693e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 32.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {50, -68}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4044_4045a(BPu = 1.8693e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 32.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {1, -61}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4044_4045b(BPu = 1.8693e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 32.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-2, -61}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4045_4051a(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {5, -120}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4045_4051b(BPu = 3.7542e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 6.40 / XBase_400, XPu = 64.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {8, -120}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4045_4062(BPu = 7.4927e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 17.6 / XBase_400, XPu = 128.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-40, -117}, extent = {{5, -5}, {-5, 5}}, rotation = 0)));
  Electrical.Lines.Line line_4046_4047(BPu = 1.5551e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 1.60 / XBase_400, XPu = 24.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {79, -67}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4061_4062(BPu = 1.8693e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 3.20 / XBase_400, XPu = 32.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-87, -80}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4062_4063a(BPu = 2.8117e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 4.80 / XBase_400, XPu = 48.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-90, -120}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4062_4063b(BPu = 2.8117e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 4.80 / XBase_400, XPu = 48.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-87, -120}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4071_4072a(BPu = 9.3777e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 4.80 / XBase_400, XPu = 48.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-84, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Electrical.Lines.Line line_4071_4072b(BPu = 9.3777e-4 * XBase_400, GPu = 0 * XBase_400, RPu = 4.80 / XBase_400, XPu = 48.00 / XBase_400) annotation(
    Placement(visible = true, transformation(origin = {-79, 105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

  Electrical.Shunts.ShuntB shunt_1022(BPu = BPu_shunt_1022, u0Pu = u0Pu_shunt_1022, s0Pu = s0Pu_shunt_1022, i0Pu = i0Pu_shunt_1022) annotation(
    Placement(visible = true, transformation(origin = {-33.5, 56.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1041(BPu = BPu_shunt_1041, u0Pu = u0Pu_shunt_1041, s0Pu = s0Pu_shunt_1041, i0Pu = i0Pu_shunt_1041) annotation(
    Placement(visible = true, transformation(origin = {-66.5, -94.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1043(BPu = BPu_shunt_1043, u0Pu = u0Pu_shunt_1043, s0Pu = s0Pu_shunt_1043, i0Pu = i0Pu_shunt_1043) annotation(
    Placement(visible = true, transformation(origin = {-55.5, -67.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1044(BPu = BPu_shunt_1044, u0Pu = u0Pu_shunt_1044, s0Pu = s0Pu_shunt_1044, i0Pu = i0Pu_shunt_1044) annotation(
    Placement(visible = true, transformation(origin = {-15.5, -67.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_1045(BPu = BPu_shunt_1045, u0Pu = u0Pu_shunt_1045, s0Pu = s0Pu_shunt_1045, i0Pu = i0Pu_shunt_1045) annotation(
    Placement(visible = true, transformation(origin = {-12.5, -83.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4012(BPu = BPu_shunt_4012, u0Pu = u0Pu_shunt_4012, s0Pu = s0Pu_shunt_4012, i0Pu = i0Pu_shunt_4012) annotation(
    Placement(visible = true, transformation(origin = {-22.5, 106.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4041(BPu = BPu_shunt_4041, u0Pu = u0Pu_shunt_4041, s0Pu = s0Pu_shunt_4041, i0Pu = i0Pu_shunt_4041) annotation(
    Placement(visible = true, transformation(origin = {-94.5, -14.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4043(BPu = BPu_shunt_4043, u0Pu = u0Pu_shunt_4043, s0Pu = s0Pu_shunt_4043, i0Pu = i0Pu_shunt_4043) annotation(
    Placement(visible = true, transformation(origin = {24.5, -23.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4046(BPu = BPu_shunt_4046, u0Pu = u0Pu_shunt_4046, s0Pu = s0Pu_shunt_4046, i0Pu = i0Pu_shunt_4046) annotation(
    Placement(visible = true, transformation(origin = {76.5, -22.5}, extent = {{-2.5, 2.5}, {2.5, -2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4051(BPu = BPu_shunt_4051, u0Pu = u0Pu_shunt_4051, s0Pu = s0Pu_shunt_4051, i0Pu = i0Pu_shunt_4051) annotation(
    Placement(visible = true, transformation(origin = {21.5, -134.5}, extent = {{-2.5, -2.5}, {2.5, 2.5}}, rotation = 0)));
  Electrical.Shunts.ShuntB shunt_4071(BPu = BPu_shunt_4071, u0Pu = u0Pu_shunt_4071, s0Pu = s0Pu_shunt_4071, i0Pu = i0Pu_shunt_4071) annotation(
    Placement(visible = true, transformation(origin = {-85.5, 136.5}, extent = {{2.5, 2.5}, {-2.5, -2.5}}, rotation = 0)));

protected
  final parameter SIunits.Impedance XBase_130 = 130 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter SIunits.Impedance XBase_220 = 220 ^ 2 / Electrical.SystemBase.SnRef;
  final parameter SIunits.Impedance XBase_400 = 400 ^ 2 / Electrical.SystemBase.SnRef;

  // shunt_1022 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1022 = -0.5;
  final parameter Types.VoltageModulePu U0Pu_shunt_1022 = 1.0512;
  final parameter Types.Angle UPhase0_shunt_1022 = SIunits.Conversions.from_deg(-19.05);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1022 = BPu_shunt_1022 * U0Pu_shunt_1022 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1022 = Complex(0, Q0Pu_shunt_1022);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1022 = ComplexMath.fromPolar(U0Pu_shunt_1022, UPhase0_shunt_1022);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1022 = ComplexMath.conj(s0Pu_shunt_1022 / u0Pu_shunt_1022);
  // shunt_1041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1041 = -2.5;
  final parameter Types.VoltageModulePu U0Pu_shunt_1041 = 1.0124;
  final parameter Types.Angle UPhase0_shunt_1041 = SIunits.Conversions.from_deg(-81.87);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1041 = BPu_shunt_1041 * U0Pu_shunt_1041 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1041 = Complex(0, Q0Pu_shunt_1041);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1041 = ComplexMath.fromPolar(U0Pu_shunt_1041, UPhase0_shunt_1041);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1041 = ComplexMath.conj(s0Pu_shunt_1041 / u0Pu_shunt_1041);
  // shunt_1043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1043 = -2;
  final parameter Types.VoltageModulePu U0Pu_shunt_1043 = 1.0274;
  final parameter Types.Angle UPhase0_shunt_1043 = SIunits.Conversions.from_deg(-76.77);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1043 = BPu_shunt_1043 * U0Pu_shunt_1043 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1043 = Complex(0, Q0Pu_shunt_1043);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1043 = ComplexMath.fromPolar(U0Pu_shunt_1043, UPhase0_shunt_1043);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1043 = ComplexMath.conj(s0Pu_shunt_1043 / u0Pu_shunt_1043);
  // shunt_1044 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1044 = -2;
  final parameter Types.VoltageModulePu U0Pu_shunt_1044 = 1.0066;
  final parameter Types.Angle UPhase0_shunt_1044 = SIunits.Conversions.from_deg(-67.71);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1044 = BPu_shunt_1044 * U0Pu_shunt_1044 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1044 = Complex(0, Q0Pu_shunt_1044);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1044 = ComplexMath.fromPolar(U0Pu_shunt_1044, UPhase0_shunt_1044);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1044 = ComplexMath.conj(s0Pu_shunt_1044 / u0Pu_shunt_1044);
  // shunt_1045 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_1045 = -2;
  final parameter Types.VoltageModulePu U0Pu_shunt_1045 = 1.0111;
  final parameter Types.Angle UPhase0_shunt_1045 = SIunits.Conversions.from_deg(-71.66);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_1045 = BPu_shunt_1045 * U0Pu_shunt_1045 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_1045 = Complex(0, Q0Pu_shunt_1045);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_1045 = ComplexMath.fromPolar(U0Pu_shunt_1045, UPhase0_shunt_1045);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_1045 = ComplexMath.conj(s0Pu_shunt_1045 / u0Pu_shunt_1045);
  // shunt_4012 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4012 = 1;
  final parameter Types.VoltageModulePu U0Pu_shunt_4012 = 1.0235;
  final parameter Types.Angle UPhase0_shunt_4012 = SIunits.Conversions.from_deg(-5.54);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4012 = BPu_shunt_4012 * U0Pu_shunt_4012 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4012 = Complex(0, Q0Pu_shunt_4012);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4012 = ComplexMath.fromPolar(U0Pu_shunt_4012, UPhase0_shunt_4012);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4012 = ComplexMath.conj(s0Pu_shunt_4012 / u0Pu_shunt_4012);
  // shunt_4041 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4041 = -2;
  final parameter Types.VoltageModulePu U0Pu_shunt_4041 = 1.0506;
  final parameter Types.Angle UPhase0_shunt_4041 = SIunits.Conversions.from_deg(-54.30);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4041 = BPu_shunt_4041 * U0Pu_shunt_4041 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4041 = Complex(0, Q0Pu_shunt_4041);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4041 = ComplexMath.fromPolar(U0Pu_shunt_4041, UPhase0_shunt_4041);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4041 = ComplexMath.conj(s0Pu_shunt_4041 / u0Pu_shunt_4041);
  // shunt_4043 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4043 = -2;
  final parameter Types.VoltageModulePu U0Pu_shunt_4043 = 1.037;
  final parameter Types.Angle UPhase0_shunt_4043 = SIunits.Conversions.from_deg(-63.51);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4043 = BPu_shunt_4043 * U0Pu_shunt_4043 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4043 = Complex(0, Q0Pu_shunt_4043);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4043 = ComplexMath.fromPolar(U0Pu_shunt_4043, UPhase0_shunt_4043);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4043 = ComplexMath.conj(s0Pu_shunt_4043 / u0Pu_shunt_4043);
  // shunt_4046 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4046 = -1;
  final parameter Types.VoltageModulePu U0Pu_shunt_4046 = 1.0357;
  final parameter Types.Angle UPhase0_shunt_4046 = SIunits.Conversions.from_deg(-64.11);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4046 = BPu_shunt_4046 * U0Pu_shunt_4046 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4046 = Complex(0, Q0Pu_shunt_4046);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4046 = ComplexMath.fromPolar(U0Pu_shunt_4046, UPhase0_shunt_4046);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4046 = ComplexMath.conj(s0Pu_shunt_4046 / u0Pu_shunt_4046);
  // shunt_4051 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4051 = -1;
  final parameter Types.VoltageModulePu U0Pu_shunt_4051 = 1.0659;
  final parameter Types.Angle UPhase0_shunt_4051 = SIunits.Conversions.from_deg(-71.01);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4051 = BPu_shunt_4051 * U0Pu_shunt_4051 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4051 = Complex(0, Q0Pu_shunt_4051);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4051 = ComplexMath.fromPolar(U0Pu_shunt_4051, UPhase0_shunt_4051);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4051 = ComplexMath.conj(s0Pu_shunt_4051 / u0Pu_shunt_4051);
  // shunt_4071 init values:
  // negative values for capacitors, positive values for inductors (reversed in PESTR)
  final parameter Types.PerUnit BPu_shunt_4071 = 4;
  final parameter Types.VoltageModulePu U0Pu_shunt_4071 = 1.0484;
  final parameter Types.Angle UPhase0_shunt_4071 = SIunits.Conversions.from_deg(-4.99);
  final parameter Types.ReactivePowerPu Q0Pu_shunt_4071 = BPu_shunt_4071 * U0Pu_shunt_4071 ^ 2;
  final parameter Types.ComplexApparentPowerPu s0Pu_shunt_4071 = Complex(0, Q0Pu_shunt_4071);
  final parameter Types.ComplexVoltagePu u0Pu_shunt_4071 = ComplexMath.fromPolar(U0Pu_shunt_4071, UPhase0_shunt_4071);
  final parameter Types.ComplexCurrentPu i0Pu_shunt_4071 = ComplexMath.conj(s0Pu_shunt_4071 / u0Pu_shunt_4071);

equation
  line_1011_1013a.switchOffSignal1.value = false;
  line_1011_1013a.switchOffSignal2.value = false;
  line_1011_1013b.switchOffSignal1.value = false;
  line_1011_1013b.switchOffSignal2.value = false;
  line_1012_1014a.switchOffSignal1.value = false;
  line_1012_1014a.switchOffSignal2.value = false;
  line_1012_1014b.switchOffSignal1.value = false;
  line_1012_1014b.switchOffSignal2.value = false;
  line_1013_1014a.switchOffSignal1.value = false;
  line_1013_1014a.switchOffSignal2.value = false;
  line_1013_1014b.switchOffSignal1.value = false;
  line_1013_1014b.switchOffSignal2.value = false;
  line_1021_1022a.switchOffSignal1.value = false;
  line_1021_1022a.switchOffSignal2.value = false;
  line_1021_1022b.switchOffSignal1.value = false;
  line_1021_1022b.switchOffSignal2.value = false;
  line_1041_1043a.switchOffSignal1.value = false;
  line_1041_1043a.switchOffSignal2.value = false;
  line_1041_1043b.switchOffSignal1.value = false;
  line_1041_1043b.switchOffSignal2.value = false;
  line_1041_1045a.switchOffSignal1.value = false;
  line_1041_1045a.switchOffSignal2.value = false;
  line_1041_1045b.switchOffSignal1.value = false;
  line_1041_1045b.switchOffSignal2.value = false;
  line_1042_1044a.switchOffSignal1.value = false;
  line_1042_1044a.switchOffSignal2.value = false;
  line_1042_1044b.switchOffSignal1.value = false;
  line_1042_1044b.switchOffSignal2.value = false;
  line_1042_1045.switchOffSignal1.value = false;
  line_1042_1045.switchOffSignal2.value = false;
  line_1043_1044a.switchOffSignal1.value = false;
  line_1043_1044a.switchOffSignal2.value = false;
  line_1043_1044b.switchOffSignal1.value = false;
  line_1043_1044b.switchOffSignal2.value = false;
  line_2031_2032a.switchOffSignal1.value = false;
  line_2031_2032a.switchOffSignal2.value = false;
  line_2031_2032b.switchOffSignal1.value = false;
  line_2031_2032b.switchOffSignal2.value = false;
  line_4011_4012.switchOffSignal1.value = false;
  line_4011_4012.switchOffSignal2.value = false;
  line_4011_4021.switchOffSignal1.value = false;
  line_4011_4021.switchOffSignal2.value = false;
  line_4011_4022.switchOffSignal1.value = false;
  line_4011_4022.switchOffSignal2.value = false;
  line_4011_4071.switchOffSignal1.value = false;
  line_4011_4071.switchOffSignal2.value = false;
  line_4012_4022.switchOffSignal1.value = false;
  line_4012_4022.switchOffSignal2.value = false;
  line_4012_4071.switchOffSignal1.value = false;
  line_4012_4071.switchOffSignal2.value = false;
  line_4021_4032.switchOffSignal1.value = false;
  line_4021_4032.switchOffSignal2.value = false;
  line_4021_4042.switchOffSignal1.value = false;
  line_4021_4042.switchOffSignal2.value = false;
  line_4022_4031a.switchOffSignal1.value = false;
  line_4022_4031a.switchOffSignal2.value = false;
  line_4022_4031b.switchOffSignal1.value = false;
  line_4022_4031b.switchOffSignal2.value = false;
  line_4031_4032.switchOffSignal1.value = false;
  line_4031_4032.switchOffSignal2.value = false;
  line_4031_4041a.switchOffSignal1.value = false;
  line_4031_4041a.switchOffSignal2.value = false;
  line_4031_4041b.switchOffSignal1.value = false;
  line_4031_4041b.switchOffSignal2.value = false;
  line_4032_4042.switchOffSignal1.value = false;
  line_4032_4042.switchOffSignal2.value = false;
//line_4032_4044.switchOffSignal1.value = false; // to be disconnected to clear short circuit
  line_4032_4044.switchOffSignal2.value = false;
  line_4041_4044.switchOffSignal1.value = false;
  line_4041_4044.switchOffSignal2.value = false;
  line_4041_4061.switchOffSignal1.value = false;
  line_4041_4061.switchOffSignal2.value = false;
  line_4042_4043.switchOffSignal1.value = false;
  line_4042_4043.switchOffSignal2.value = false;
  line_4042_4044.switchOffSignal1.value = false;
  line_4042_4044.switchOffSignal2.value = false;
  line_4043_4044.switchOffSignal1.value = false;
  line_4043_4044.switchOffSignal2.value = false;
  line_4043_4046.switchOffSignal1.value = false;
  line_4043_4046.switchOffSignal2.value = false;
  line_4043_4047.switchOffSignal1.value = false;
  line_4043_4047.switchOffSignal2.value = false;
  line_4044_4045a.switchOffSignal1.value = false;
  line_4044_4045a.switchOffSignal2.value = false;
  line_4044_4045b.switchOffSignal1.value = false;
  line_4044_4045b.switchOffSignal2.value = false;
  line_4045_4051a.switchOffSignal1.value = false;
  line_4045_4051a.switchOffSignal2.value = false;
  line_4045_4051b.switchOffSignal1.value = false;
  line_4045_4051b.switchOffSignal2.value = false;
  line_4045_4062.switchOffSignal1.value = false;
  line_4045_4062.switchOffSignal2.value = false;
  line_4046_4047.switchOffSignal1.value = false;
  line_4046_4047.switchOffSignal2.value = false;
  line_4061_4062.switchOffSignal1.value = false;
  line_4061_4062.switchOffSignal2.value = false;
  line_4062_4063a.switchOffSignal1.value = false;
  line_4062_4063a.switchOffSignal2.value = false;
  line_4062_4063b.switchOffSignal1.value = false;
  line_4062_4063b.switchOffSignal2.value = false;
  line_4071_4072a.switchOffSignal1.value = false;
  line_4071_4072a.switchOffSignal2.value = false;
  line_4071_4072b.switchOffSignal1.value = false;
  line_4071_4072b.switchOffSignal2.value = false;

  connect(line_1011_1013b.terminal2, bus_1013.terminal) annotation(
    Line(points = {{55, 125}, {73, 125}, {73, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(line_1011_1013a.terminal2, bus_1013.terminal) annotation(
    Line(points = {{55, 128}, {71, 128}, {71, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(line_1011_1013b.terminal1, bus_1011.terminal) annotation(
    Line(points = {{45, 125}, {27, 125}, {27, 130}, {30, 130}}, color = {0, 0, 255}));
  connect(line_1011_1013a.terminal1, bus_1011.terminal) annotation(
    Line(points = {{45, 128}, {30, 128}, {30, 130}}, color = {0, 0, 255}));
  connect(line_1012_1014b.terminal2, bus_1014.terminal) annotation(
    Line(points = {{60, 95}, {73, 95}, {73, 100}, {80, 100}, {80, 100}}, color = {0, 0, 255}));
  connect(line_1012_1014a.terminal2, bus_1014.terminal) annotation(
    Line(points = {{60, 98}, {71, 98}, {71, 100}, {80, 100}, {80, 100}}, color = {0, 0, 255}));
  connect(line_1012_1014b.terminal1, bus_1012.terminal) annotation(
    Line(points = {{50, 95}, {37, 95}, {37, 100}, {30, 100}, {30, 100}}, color = {0, 0, 255}));
  connect(line_1012_1014a.terminal1, bus_1012.terminal) annotation(
    Line(points = {{50, 98}, {39, 98}, {39, 100}, {30, 100}, {30, 100}}, color = {0, 0, 255}));
  connect(line_1013_1014b.terminal1, bus_1013.terminal) annotation(
    Line(points = {{78, 118}, {78, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(line_1013_1014a.terminal1, bus_1013.terminal) annotation(
    Line(points = {{75, 118}, {75, 130}, {80, 130}}, color = {0, 0, 255}));
  connect(line_1013_1014b.terminal2, bus_1014.terminal) annotation(
    Line(points = {{78, 108}, {78, 100}, {80, 100}}, color = {0, 0, 255}));
  connect(line_1013_1014a.terminal2, bus_1014.terminal) annotation(
    Line(points = {{75, 108}, {75, 100}, {80, 100}}, color = {0, 0, 255}));
  connect(line_1021_1022a.terminal1, bus_1021.terminal) annotation(
    Line(points = {{-68, 45}, {-76, 45}, {-76, 50}, {-80, 50}}, color = {0, 0, 255}));
  connect(line_1021_1022b.terminal1, bus_1021.terminal) annotation(
    Line(points = {{-68, 42}, {-78, 42}, {-78, 50}, {-80, 50}}, color = {0, 0, 255}));
  connect(line_1021_1022a.terminal2, bus_1022.terminal) annotation(
    Line(points = {{-58, 45}, {-49, 45}, {-49, 50}, {-40, 50}}, color = {0, 0, 255}));
  connect(line_1021_1022b.terminal2, bus_1022.terminal) annotation(
    Line(points = {{-58, 42}, {-47, 42}, {-47, 50}, {-40, 50}}, color = {0, 0, 255}));
  connect(line_1041_1045b.terminal1, bus_1041.terminal) annotation(
    Line(points = {{-40, -87}, {-51, -87}, {-51, -90}, {-60, -90}}, color = {0, 0, 255}));
  connect(line_1041_1045a.terminal1, bus_1041.terminal) annotation(
    Line(points = {{-40, -84}, {-53, -84}, {-53, -90}, {-60, -90}}, color = {0, 0, 255}));
  connect(line_1041_1043b.terminal1, bus_1041.terminal) annotation(
    Line(points = {{-62, -80}, {-62, -85.5}, {-60, -85.5}, {-60, -90}}, color = {0, 0, 255}));
  connect(line_1041_1043a.terminal1, bus_1041.terminal) annotation(
    Line(points = {{-65, -80}, {-65, -90}, {-60, -90}}, color = {0, 0, 255}));
  connect(line_1041_1045a.terminal2, bus_1045.terminal) annotation(
    Line(points = {{-30, -84}, {-17, -84}, {-17, -90}}, color = {0, 0, 255}));
  connect(line_1041_1045b.terminal2, bus_1045.terminal) annotation(
    Line(points = {{-30, -87}, {-19, -87}, {-19, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(line_1041_1043a.terminal2, bus_1043.terminal) annotation(
    Line(points = {{-65, -70}, {-65, -70}, {-65, -60}, {-60, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(line_1041_1043b.terminal2, bus_1043.terminal) annotation(
    Line(points = {{-62, -70}, {-62, -70}, {-62, -60}, {-60, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(line_1042_1045.terminal2, bus_1045.terminal) annotation(
    Line(points = {{5, -85}, {-8, -85}, {-8, -90}, {-17, -90}}, color = {0, 0, 255}));
  connect(line_1042_1044b.terminal1, bus_1042.terminal) annotation(
    Line(points = {{15, -71}, {23, -71}, {23, -80}, {30, -80}, {30, -80}}, color = {0, 0, 255}));
  connect(line_1042_1044a.terminal2, bus_1044.terminal) annotation(
    Line(points = {{5, -74}, {-13, -74}, {-13, -60}, {-20, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(line_1042_1044b.terminal2, bus_1044.terminal) annotation(
    Line(points = {{5, -71}, {-11, -71}, {-11, -60}, {-20, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(line_1042_1044a.terminal1, bus_1042.terminal) annotation(
    Line(points = {{15, -74}, {21, -74}, {21, -80}, {30, -80}}, color = {0, 0, 255}));
  connect(line_1042_1045.terminal1, bus_1042.terminal) annotation(
    Line(points = {{15, -85}, {21, -85}, {21, -80}, {30, -80}}, color = {0, 0, 255}));
  connect(line_1043_1044b.terminal2, bus_1044.terminal) annotation(
    Line(points = {{-35, -66}, {-27, -66}, {-27, -60}, {-20, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(line_1043_1044a.terminal2, bus_1044.terminal) annotation(
    Line(points = {{-35, -63}, {-29, -63}, {-29, -60}, {-20, -60}, {-20, -60}}, color = {0, 0, 255}));
  connect(line_1043_1044b.terminal1, bus_1043.terminal) annotation(
    Line(points = {{-45, -66}, {-53, -66}, {-53, -60}, {-60, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(line_1043_1044a.terminal1, bus_1043.terminal) annotation(
    Line(points = {{-45, -63}, {-51, -63}, {-51, -60}, {-60, -60}, {-60, -60}}, color = {0, 0, 255}));
  connect(line_2031_2032a.terminal2, bus_2032.terminal) annotation(
    Line(points = {{-65, 18}, {-71, 18}, {-71, 21}, {-80, 21}}, color = {0, 0, 255}));
  connect(line_2031_2032b.terminal2, bus_2032.terminal) annotation(
    Line(points = {{-65, 15}, {-72, 15}, {-72, 21}, {-80, 21}}, color = {0, 0, 255}));
  connect(line_2031_2032a.terminal1, bus_2031.terminal) annotation(
    Line(points = {{-55, 18}, {-49, 18}, {-49, 20}, {-40, 20}}, color = {0, 0, 255}));
  connect(line_2031_2032b.terminal1, bus_2031.terminal) annotation(
    Line(points = {{-55, 15}, {-48, 15}, {-48, 20}, {-40, 20}}, color = {0, 0, 255}));
  connect(line_4011_4022.terminal1, bus_4011.terminal) annotation(
    Line(points = {{-10, 93}, {-10, 118}, {-23, 118}, {-23, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(line_4011_4021.terminal2, bus_4021.terminal) annotation(
    Line(points = {{5, 83}, {5, 83}, {5, 60}, {21, 60}, {21, 50}, {30, 50}, {30, 50}}, color = {0, 0, 255}));
  connect(line_4011_4021.terminal1, bus_4011.terminal) annotation(
    Line(points = {{5, 93}, {5, 120}, {-21, 120}, {-21, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(line_4011_4012.terminal1, bus_4011.terminal) annotation(
    Line(points = {{-34, 123}, {-34, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(line_4011_4012.terminal2, bus_4012.terminal) annotation(
    Line(points = {{-34, 113}, {-34, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(line_4011_4022.terminal2, bus_4022.terminal) annotation(
    Line(points = {{-10, 83}, {-10, 49}}, color = {0, 0, 255}));
  connect(line_4011_4071.terminal1, bus_4011.terminal) annotation(
    Line(points = {{-48, 120}, {-39, 120}, {-39, 130}, {-30, 130}}, color = {0, 0, 255}));
  connect(line_4011_4071.terminal2, bus_4071.terminal) annotation(
    Line(points = {{-58, 120}, {-73, 120}, {-73, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(line_4012_4071.terminal1, bus_4012.terminal) annotation(
    Line(points = {{-48, 117}, {-39, 117}, {-39, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(line_4012_4071.terminal2, bus_4071.terminal) annotation(
    Line(points = {{-58, 117}, {-75, 117}, {-75, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(line_4012_4022.terminal2, bus_4022.terminal) annotation(
    Line(points = {{-20, 70}, {-20, 70}, {-20, 49}, {-10, 49}, {-10, 49}}, color = {0, 0, 255}));
  connect(line_4012_4022.terminal1, bus_4012.terminal) annotation(
    Line(points = {{-20, 80}, {-20, 80}, {-20, 100}, {-30, 100}, {-30, 100}}, color = {0, 0, 255}));
  connect(line_4021_4032.terminal2, bus_4032.terminal) annotation(
    Line(points = {{23, 35}, {23, 21}, {30, 21}}, color = {0, 0, 255}));
  connect(line_4021_4042.terminal2, bus_4042.terminal) annotation(
    Line(points = {{44, 17}, {44, 17}, {44, -10}, {50, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(line_4021_4042.terminal1, bus_4021.terminal) annotation(
    Line(points = {{44, 27}, {44, 40}, {39, 40}, {39, 50}, {30, 50}}, color = {0, 0, 255}));
  connect(line_4021_4032.terminal1, bus_4021.terminal) annotation(
    Line(points = {{23, 45}, {23, 50}, {30, 50}}, color = {0, 0, 255}));
  connect(line_4022_4031b.terminal2, bus_4031.terminal) annotation(
    Line(points = {{-13, 35}, {-13, 21}}, color = {0, 0, 255}));
  connect(line_4022_4031a.terminal2, bus_4031.terminal) annotation(
    Line(points = {{-17, 35}, {-17, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(line_4022_4031a.terminal1, bus_4022.terminal) annotation(
    Line(points = {{-17, 45}, {-17, 49}, {-10, 49}}, color = {0, 0, 255}));
  connect(line_4022_4031b.terminal1, bus_4022.terminal) annotation(
    Line(points = {{-13, 45}, {-13, 48.75}, {-10, 48.75}, {-10, 49}}, color = {0, 0, 255}));
  connect(line_4031_4032.terminal1, bus_4031.terminal) annotation(
    Line(points = {{3, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(line_4031_4032.terminal2, bus_4032.terminal) annotation(
    Line(points = {{13, 21}, {30, 21}}, color = {0, 0, 255}));
  connect(line_4031_4041a.terminal1, bus_4031.terminal) annotation(
    Line(points = {{-22, 11}, {-22, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(line_4031_4041b.terminal1, bus_4031.terminal) annotation(
    Line(points = {{-19, 11}, {-19, 21}, {-13, 21}}, color = {0, 0, 255}));
  connect(line_4031_4041a.terminal2, bus_4041.terminal) annotation(
    Line(points = {{-22, 1}, {-22, -5}, {-72, -5}, {-72, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(line_4031_4041b.terminal2, bus_4041.terminal) annotation(
    Line(points = {{-19, 1}, {-19, -7}, {-70, -7}, {-70, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(line_4032_4042.terminal1, bus_4032.terminal) annotation(
    Line(points = {{34, 14}, {34, 21}, {30, 21}}, color = {0, 0, 255}));
  connect(line_4032_4044.terminal1, bus_4032.terminal) annotation(
    Line(points = {{-6, 1}, {-6, 16}, {24, 16}, {24, 21}, {30, 21}}, color = {0, 0, 255}));
  connect(line_4032_4042.terminal2, bus_4042.terminal) annotation(
    Line(points = {{34, 4}, {34, 4}, {34, -3}, {41, -3}, {41, -10}, {50, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(line_4032_4044.terminal2, bus_4044.terminal) annotation(
    Line(points = {{-6, -9}, {-6, -9}, {-6, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4041_4044.terminal1, bus_4041.terminal) annotation(
    Line(points = {{-45, -15}, {-50, -15}, {-50, -10}, {-78, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(line_4041_4061.terminal2, bus_4061.terminal) annotation(
    Line(points = {{-87, -40}, {-87, -40}, {-87, -50}, {-92, -50}, {-92, -50}}, color = {0, 0, 255}));
  connect(line_4041_4044.terminal2, bus_4044.terminal) annotation(
    Line(points = {{-35, -15}, {-15, -15}, {-15, -30}, {-6, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4041_4061.terminal1, bus_4041.terminal) annotation(
    Line(points = {{-87, -30}, {-87, -10}, {-78, -10}}, color = {0, 0, 255}));
  connect(line_4042_4044.terminal1, bus_4042.terminal) annotation(
    Line(points = {{3, -12}, {3, -12}, {3, -10}, {50, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(line_4042_4044.terminal2, bus_4044.terminal) annotation(
    Line(points = {{3, -22}, {3, -22}, {3, -30}, {-6, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4042_4043.terminal2, bus_4043.terminal) annotation(
    Line(points = {{41, -25}, {41, -30}, {30, -30}}, color = {0, 0, 255}));
  connect(line_4042_4043.terminal1, bus_4042.terminal) annotation(
    Line(points = {{41, -15}, {41, -10}, {50, -10}}, color = {0, 0, 255}));
  connect(line_4043_4044.terminal1, bus_4043.terminal) annotation(
    Line(points = {{17, -34}, {17, -34}, {21, -34}, {21, -30}, {30, -30}}, color = {0, 0, 255}));
  connect(line_4043_4046.terminal2, bus_4046.terminal) annotation(
    Line(points = {{54, -49}, {61, -49}, {61, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(line_4043_4044.terminal2, bus_4044.terminal) annotation(
    Line(points = {{7, -34}, {3, -34}, {3, -30}, {-6, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4043_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{50, -73}, {50, -80}, {68, -80}, {68, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(line_4043_4047.terminal1, bus_4043.terminal) annotation(
    Line(points = {{50, -63}, {50, -52}, {38, -52}, {38, -30}, {30, -30}}, color = {0, 0, 255}));
  connect(line_4043_4046.terminal1, bus_4043.terminal) annotation(
    Line(points = {{44, -49}, {39, -49}, {39, -30}, {30, -30}}, color = {0, 0, 255}));
  connect(line_4044_4045b.terminal1, bus_4044.terminal) annotation(
    Line(points = {{-2, -56}, {-2, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4044_4045a.terminal1, bus_4044.terminal) annotation(
    Line(points = {{1, -56}, {1, -30}, {-6, -30}}, color = {0, 0, 255}));
  connect(line_4044_4045b.terminal2, bus_4045.terminal) annotation(
    Line(points = {{-2, -66}, {-2, -66}, {-2, -110}, {0, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(line_4044_4045a.terminal2, bus_4045.terminal) annotation(
    Line(points = {{1, -66}, {1, -66}, {1, -110}, {0, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(line_4045_4062.terminal2, bus_4062.terminal) annotation(
    Line(points = {{-45, -117}, {-78, -117}, {-78, -110}, {-87, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(line_4045_4062.terminal1, bus_4045.terminal) annotation(
    Line(points = {{-35, -117}, {-8, -117}, {-8, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(line_4045_4051a.terminal2, bus_4051.terminal) annotation(
    Line(points = {{5, -125}, {5, -125}, {5, -130}, {14, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(line_4045_4051b.terminal2, bus_4051.terminal) annotation(
    Line(points = {{8, -125}, {8, -130}, {14, -130}}, color = {0, 0, 255}));
  connect(line_4045_4051a.terminal1, bus_4045.terminal) annotation(
    Line(points = {{5, -115}, {5, -115}, {5, -110}, {0, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(line_4045_4051b.terminal1, bus_4045.terminal) annotation(
    Line(points = {{8, -115}, {8, -115}, {8, -110}, {0, -110}, {0, -110}}, color = {0, 0, 255}));
  connect(line_4046_4047.terminal1, bus_4046.terminal) annotation(
    Line(points = {{79, -62}, {79, -62}, {79, -30}, {70, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(line_4046_4047.terminal2, bus_4047.terminal) annotation(
    Line(points = {{79, -72}, {79, -85}, {71, -85}, {71, -110}, {70, -110}}, color = {0, 0, 255}));
  connect(line_4062_4063a.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-90, -125}, {-90, -125}, {-90, -130}, {-87, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(line_4062_4063b.terminal2, bus_4063.terminal) annotation(
    Line(points = {{-87, -125}, {-87, -125}, {-87, -130}, {-87, -130}}, color = {0, 0, 255}));
  connect(line_4061_4062.terminal2, bus_4062.terminal) annotation(
    Line(points = {{-87, -85}, {-87, -85}, {-87, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(line_4061_4062.terminal1, bus_4061.terminal) annotation(
    Line(points = {{-87, -75}, {-87, -75}, {-87, -50}, {-92, -50}, {-92, -50}}, color = {0, 0, 255}));
  connect(line_4062_4063a.terminal1, bus_4062.terminal) annotation(
    Line(points = {{-90, -115}, {-90, -115}, {-90, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(line_4062_4063b.terminal1, bus_4062.terminal) annotation(
    Line(points = {{-87, -115}, {-87, -115}, {-87, -110}, {-87, -110}}, color = {0, 0, 255}));
  connect(line_4071_4072b.terminal1, bus_4071.terminal) annotation(
    Line(points = {{-79, 110}, {-79, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(line_4071_4072a.terminal1, bus_4071.terminal) annotation(
    Line(points = {{-84, 110}, {-84, 130}, {-80, 130}}, color = {0, 0, 255}));
  connect(line_4071_4072b.terminal2, bus_4072.terminal) annotation(
    Line(points = {{-79, 100}, {-79, 81}, {-82, 81}}, color = {0, 0, 255}));
  connect(line_4071_4072a.terminal2, bus_4072.terminal) annotation(
    Line(points = {{-84, 100}, {-84, 81}, {-82, 81}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-100, -150}, {100, 150}}, grid = {1, 1}, preserveAspectRatio = false, initialScale = 0.1)),
    Icon(coordinateSystem(extent = {{-100, -150}, {100, 150}}, grid = {1, 1}, preserveAspectRatio = false)),
    version = "",
    uses(Dynawo(version = "1.0.1")),
    __OpenModelica_commandLineOptions = "",
    Documentation(info = "<html><head></head><body>This model represents the static network of the Nordic 32 test system. It consists of 74 buses, 52 lines and 11 shunts. Data for the lines have been taken from the&nbsp;<span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015</span>.<div>The model forms the basis for the Nordic 32 test system. It can be extended to add specific transformers, loads or generators.</div></body></html>"));
end Network;
