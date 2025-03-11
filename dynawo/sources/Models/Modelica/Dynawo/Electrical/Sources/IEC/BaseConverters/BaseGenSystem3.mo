within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseGenSystem3 "Base class of Type 3 generator system module (IEC N°61400-27-1)"

  /*
  Equivalent circuit and conventions:

     __   fOCB     iGs
    /__\---/------->-- (terminal)
    \__/--------------

  */

  extends Dynawo.Electrical.Wind.IEC.Parameters.GenSystem3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  
  //Inputs
  Modelica.Blocks.Interfaces.BooleanInput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(visible = true, transformation(origin = {0, 330}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-230, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  input Boolean running(start = true) "True if the converter is running";
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-230, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  
  //Outputs
  Modelica.Blocks.Interfaces.RealOutput PAgPu(start = PAg0Pu) "Generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {230, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add addXIm(k1 = 1 / XEqv) annotation(
    Placement(visible = true, transformation(origin = {78, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addXRe(k2 = -1 / XEqv) annotation(
    Placement(visible = true, transformation(origin = {78, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToPAg annotation(
    Placement(visible = true, transformation(origin = {182, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToRealUGs annotation(
    Placement(visible = true, transformation(origin = {144, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-157, 44}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression iGs(y = -terminal.i * (SystemBase.SnRef / SNom)) annotation(
    Placement(visible = true, transformation(origin = {124, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitP(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitQ(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product productPAg(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {154, -66}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitP(Falling = -9999, Rising = DipMaxPu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu), y(start=-P0Pu * SystemBase.SnRef / (SNom * U0Pu))) annotation(
    Placement(visible = true, transformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitQ(Rising = DiqMaxPu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu), y(start=Q0Pu * SystemBase.SnRef / (SNom * U0Pu))) annotation(
    Placement(visible = true, transformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplexIGs annotation(
    Placement(visible = true, transformation(origin = {200, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation rotationWtToGrid(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {1, -19}, extent = {{-7, -21}, {7, 21}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = -IGsRe0Pu * SNom / SystemBase.SnRef), im(start = -IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression theta2(y = theta) annotation(
    Placement(visible = true, transformation(origin = {1, -52}, extent = {{9, -10}, {-9, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {124, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs2(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {176, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  
equation
  if fOCB or not running then
    terminal.i = Complex(0, 0);
  else
    realToComplexIGs.y = -terminal.i * (SystemBase.SnRef / SNom);
  end if;

  connect(uGs.y, productPAg.u1) annotation(
    Line(points = {{135, -72}, {142, -72}}, color = {85, 170, 255}));
  connect(productPAg.y, complexToPAg.u) annotation(
    Line(points = {{165, -66}, {169, -66}}, color = {85, 170, 255}));
  connect(complexToPAg.re, PAgPu) annotation(
    Line(points = {{194, -60}, {230, -60}}, color = {0, 0, 127}));
  connect(iGs.y, productPAg.u2) annotation(
    Line(points = {{135, -60}, {142, -60}}, color = {85, 170, 255}));
  connect(complexToRealUGs.u, uGs2.y) annotation(
    Line(points = {{156, 34}, {165, 34}}, color = {85, 170, 255}));
  connect(const.y, limitP.limit2) annotation(
    Line(points = {{-151.5, 44}, {-149.75, 44}, {-149.75, 52}, {-142, 52}}, color = {0, 0, 127}));
  connect(ipMaxPu, limitP.limit1) annotation(
    Line(points = {{-230, 80}, {-150, 80}, {-150, 68}, {-142, 68}}, color = {0, 0, 127}));
  connect(limitQ.y, rateLimitQ.u) annotation(
    Line(points = {{-119, -20}, {-112, -20}}, color = {0, 0, 127}));
  connect(limitP.y, rateLimitP.u) annotation(
    Line(points = {{-119, 60}, {-112, 60}}, color = {0, 0, 127}));
  connect(iqMaxPu, limitQ.limit1) annotation(
    Line(points = {{-230, 0}, {-150, 0}, {-150, -12}, {-142, -12}}, color = {0, 0, 127}));
  connect(iqMinPu, limitQ.limit2) annotation(
    Line(points = {{-230, -40}, {-150, -40}, {-150, -28}, {-142, -28}}, color = {0, 0, 127}));
  connect(complexToRealUGs.im, addXRe.u2) annotation(
    Line(points = {{132, 40}, {60, 40}, {60, 48}, {66, 48}}, color = {0, 0, 127}));
  connect(complexToRealUGs.re, addXIm.u1) annotation(
    Line(points = {{132, 28}, {60, 28}, {60, -28}, {66, -28}}, color = {0, 0, 127}));
  connect(addXIm.y, realToComplexIGs.im) annotation(
    Line(points = {{89, -34}, {100, -34}, {100, -6}, {188, -6}}, color = {0, 0, 127}));
  connect(addXRe.y, realToComplexIGs.re) annotation(
    Line(points = {{89, 54}, {100, 54}, {100, 6}, {188, 6}}, color = {0, 0, 127}));
  connect(theta2.y, rotationWtToGrid.theta) annotation(
    Line(points = {{-8, -52}, {-14, -52}, {-14, -38}, {-8, -38}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Rectangle(origin = {-1, 9}, lineColor = {23, 156, 125}, fillColor = {23, 156, 125}, fillPattern = FillPattern.Solid, lineThickness = 0.75, extent = {{-27, 109}, {27, -109}})}, coordinateSystem(extent = {{-220, -100}, {220, 320}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end BaseGenSystem3;
