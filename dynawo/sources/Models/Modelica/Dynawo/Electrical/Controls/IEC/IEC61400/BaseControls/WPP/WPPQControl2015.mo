within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WPP;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPPQControl2015 "Reactive power control module for wind power plants (IEC N°61400-27-1:2015)"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses.BaseWPPQControl(combiTable1Ds2(table = TableQwpUErr));
  extends Dynawo.Electrical.Wind.IEC.Parameters.TableQControl2015;

  //QControl parameters
  extends Dynawo.Electrical.Wind.IEC.Parameters.QControlWPP2015;
  
  //Input variables
  Modelica.Blocks.Interfaces.RealInput PWPPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Active power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 54}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWPPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QWPRefPu(start = -Q0Pu * SystemBase.SnRef / SNom ) "Reference reactive power communicated to WP in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-340, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tanPhi(start = Q0Pu / P0Pu) "Tangent phi (can be figured as QPu / PPu)" annotation(
    Placement(visible = true, transformation(origin = {-220, 180}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-49, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UWPPu(start = U0Pu) "Voltage module communicated to WP in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UWPRefPu(start = U0Pu) "Reference voltage module communicated to WP in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-340, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput xWTRefPu(start = XWT0Pu) "Reference reactive power or voltage communicated to WT in pu (base SNom or UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {360, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tWPPFiltQ, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-290, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tWPQFiltQ, y_start = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {-290, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tWPUFiltQ, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFeedthroughFreezeLimDetection absLimRateLimFeedthroughFreezeLimDetection1(DyMax = DXRefMaxPu, DyMin = DXRefMinPu, U0 = XWT0Pu, Y0 = XWT0Pu, YMax = XRefMaxPu, YMin = XRefMinPu, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {326, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction1(a = {txfv, 1}, b = {txft, 1}, x_start = {XWT0Pu}, y_start = XWT0Pu) annotation(
    Placement(visible = true, transformation(origin = {296, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false) annotation(
    Placement(visible = true, transformation(origin = {260, 138}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation
  connect(or2.y, antiWindupIntegrator.fMin) annotation(
    Line(points = {{218, 20}, {174, 20}, {174, 48}}, color = {255, 0, 255}));
  connect(or2.y, antiWindupIntegrator.fMax) annotation(
    Line(points = {{218, 20}, {178, 20}, {178, 48}}, color = {255, 0, 255}));
  connect(PWPPu, firstOrder.u) annotation(
    Line(points = {{-340, 54}, {-302, 54}}, color = {0, 0, 127}));
  connect(QWPPu, firstOrder1.u) annotation(
    Line(points = {{-340, -100}, {-302, -100}}, color = {0, 0, 127}));
  connect(UWPPu, firstOrder2.u) annotation(
    Line(points = {{-340, -40}, {-302, -40}}, color = {0, 0, 127}));
  connect(firstOrder2.y, lessThreshold.u) annotation(
    Line(points = {{-279, -40}, {-220, -40}, {-220, -140}, {-122, -140}}, color = {0, 0, 127}));
  connect(lessThreshold.y, absLimRateLimFirstOrderFreeze.freeze) annotation(
    Line(points = {{-98, -140}, {-90, -140}, {-90, -20}, {-110, -20}, {-110, 8}}, color = {255, 0, 255}));
  connect(lessThreshold.y, or2.u[1]) annotation(
    Line(points = {{-98, -140}, {270, -140}, {270, 20}, {240, 20}}, color = {255, 0, 255}));
  connect(QWPRefPu, multiSwitch.u[1]) annotation(
    Line(points = {{-340, 100}, {-80, 100}}, color = {0, 0, 127}));
  connect(multiSwitch.y, feedback2.u1) annotation(
    Line(points = {{-58, 100}, {12, 100}}, color = {0, 0, 127}));
  connect(multiSwitch.y, gain1.u) annotation(
    Line(points = {{-58, 100}, {0, 100}, {0, 140}, {158, 140}}, color = {0, 0, 127}));
  connect(firstOrder1.y, feedback2.u2) annotation(
    Line(points = {{-279, -100}, {20, -100}, {20, 92}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection1.y, xWTRefPu) annotation(
    Line(points = {{338, 100}, {360, 100}}, color = {0, 0, 127}));
  connect(lessThreshold.y, absLimRateLimFeedthroughFreezeLimDetection1.freeze) annotation(
    Line(points = {{-98, -140}, {342, -140}, {342, 126}, {326, 126}, {326, 112}}, color = {255, 0, 255}));
  connect(multiSwitch1.y, gain2.u) annotation(
    Line(points = {{82, 100}, {158, 100}}, color = {0, 0, 127}));
  connect(multiSwitch1.y, antiWindupIntegrator.u) annotation(
    Line(points = {{82, 100}, {120, 100}, {120, 60}, {158, 60}}, color = {0, 0, 127}));
  connect(absLimRateLimFeedthroughFreezeLimDetection.y, transferFunction1.u) annotation(
    Line(points = {{272, 100}, {284, 100}}, color = {0, 0, 127}));
  connect(transferFunction1.y, absLimRateLimFeedthroughFreezeLimDetection1.u) annotation(
    Line(points = {{308, 100}, {316, 100}}, color = {0, 0, 127}));
  connect(booleanConstant.y, absLimRateLimFeedthroughFreezeLimDetection.freeze) annotation(
    Line(points = {{260, 128}, {260, 112}}, color = {255, 0, 255}));
  connect(firstOrder.y, product.u2) annotation(
    Line(points = {{-279, 54}, {-162, 54}}, color = {0, 0, 127}));
  connect(tanPhi, product.u1) annotation(
    Line(points = {{-220, 180}, {-220, 66}, {-162, 66}}, color = {0, 0, 127}));
  connect(UWPRefPu, feedback.u1) annotation(
    Line(points = {{-340, 0}, {-228, 0}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback.u2) annotation(
    Line(points = {{-279, -40}, {-220, -40}, {-220, -8}}, color = {0, 0, 127}));
  connect(firstOrder1.y, gain.u) annotation(
    Line(points = {{-278, -100}, {-200, -100}, {-200, -72}, {-122, -72}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end WPPQControl2015;
