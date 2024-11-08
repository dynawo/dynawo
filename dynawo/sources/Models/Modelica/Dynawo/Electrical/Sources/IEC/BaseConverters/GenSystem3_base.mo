within Dynawo.Electrical.Sources.IEC.BaseConverters;

model GenSystem3_base "Type 4 generator system module (IEC N°61400-27-1)"
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
  /*
        Equivalent circuit and conventions:
  
          __   fOCB     iGs
         /__\---/------->-- (terminal)
         \__/--------------
  
      */
  extends Parameters.Nominal;
  extends Parameters.Initial;
  extends Parameters.GenSystem3;
  
  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = -IGsRe0Pu * SNom / SystemBase.SnRef), im(start = -IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(visible = true, transformation(origin = {0, 210}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-210, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  input Boolean running(start = true) "True if the converter is running";
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-210, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PAgPu(start = PAg0Pu) "Generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {210, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation rotationWtToGrid(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {1, -19}, extent = {{-7, -21}, {7, 21}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {144, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {124, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {154, -66}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {182, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression iGs(y = -terminal.i * (SystemBase.SnRef / SNom)) annotation(
    Placement(visible = true, transformation(origin = {124, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-189, 46}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation rotationGridToWt(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {1.02426e-05, 54}, extent = {{-8.00002, -24}, {8.00002, 24}}, rotation = 180)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = theta) annotation(
    Placement(visible = true, transformation(origin = {1, -52}, extent = {{9, -10}, {-9, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression realExpression1(y = -theta) annotation(
    Placement(visible = true, transformation(origin = {0, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal1 annotation(
    Placement(visible = true, transformation(origin = {144, 34}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs2(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {176, 34}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorRe annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratorIm annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackP annotation(
    Placement(visible = true, transformation(origin = {-92, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Feedback feedbackQ annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitP annotation(
    Placement(visible = true, transformation(origin = {-156, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter limitQ annotation(
    Placement(visible = true, transformation(origin = {-154, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter rateLimitP(Falling = -9999, Rising = DipMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-124, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter slewRateLimiter(Rising = DiqMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-122, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI piP(T = TIc, k = KPc) annotation(
    Placement(visible = true, transformation(origin = {-59, 59}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Continuous.PI piQ(T = TIc, k = KPc) annotation(
    Placement(visible = true, transformation(origin = {-59, -19}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add addXRe(k2 = -1 / XEqv) annotation(
    Placement(visible = true, transformation(origin = {78, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addXIm(k1 = 1 / XEqv) annotation(
    Placement(visible = true, transformation(origin = {78, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  if fOCB or not running then
    terminal.i = Complex(0, 0);
  else
    Complex(rotationWtToGrid.iGsRePu, rotationWtToGrid.iGsImPu) = -terminal.i * (SystemBase.SnRef / SNom);
  end if;
  connect(uGs.y, product.u1) annotation(
    Line(points = {{135, -72}, {142, -72}}, color = {85, 170, 255}));
  connect(product.y, complexToReal.u) annotation(
    Line(points = {{165, -66}, {169, -66}}, color = {85, 170, 255}));
  connect(complexToReal.re, PAgPu) annotation(
    Line(points = {{194, -60}, {210, -60}}, color = {0, 0, 127}));
  connect(realExpression.y, rotationWtToGrid.theta) annotation(
    Line(points = {{-9, -52}, {-12.5, -52}, {-12.5, -38}, {-8, -38}}, color = {85, 170, 255}));
  connect(realExpression1.y, rotationGridToWt.theta) annotation(
    Line(points = {{11, 92}, {15.5, 92}, {15.5, 76}, {11, 76}}, color = {85, 170, 255}));
  connect(iGs.y, product.u2) annotation(
    Line(points = {{135, -60}, {142, -60}}, color = {85, 170, 255}));
  connect(complexToReal1.u, uGs2.y) annotation(
    Line(points = {{156, 34}, {165, 34}}, color = {85, 170, 255}));
  connect(rotationWtToGrid.iGsImPu, integratorIm.u) annotation(
    Line(points = {{10, -30}, {24, -30}, {24, -40}, {43, -40}}, color = {0, 0, 127}));
  connect(rotationWtToGrid.iGsRePu, integratorRe.u) annotation(
    Line(points = {{10, -8}, {24, -8}, {24, 60}, {43, 60}}, color = {0, 0, 127}));
  connect(const.y, limitP.limit2) annotation(
    Line(points = {{-184, 46}, {-180, 46}, {-180, 52}, {-168, 52}}, color = {0, 0, 127}));
  connect(ipCmdPu, limitP.u) annotation(
    Line(points = {{-210, 60}, {-168, 60}}, color = {0, 0, 127}));
  connect(ipMaxPu, limitP.limit1) annotation(
    Line(points = {{-210, 80}, {-180, 80}, {-180, 68}, {-168, 68}}, color = {0, 0, 127}));
  connect(limitQ.y, slewRateLimiter.u) annotation(
    Line(points = {{-142, -20}, {-134, -20}}, color = {0, 0, 127}));
  connect(limitP.y, rateLimitP.u) annotation(
    Line(points = {{-144, 60}, {-136, 60}}, color = {0, 0, 127}));
  connect(iqCmdPu, limitQ.u) annotation(
    Line(points = {{-210, -20}, {-166, -20}}, color = {0, 0, 127}));
  connect(iqMaxPu, limitQ.limit1) annotation(
    Line(points = {{-210, 0}, {-180, 0}, {-180, -12}, {-166, -12}}, color = {0, 0, 127}));
  connect(iqMinPu, limitQ.limit2) annotation(
    Line(points = {{-210, -40}, {-180, -40}, {-180, -28}, {-166, -28}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, feedbackQ.u1) annotation(
    Line(points = {{-110, -20}, {-98, -20}}, color = {0, 0, 127}));
  connect(rateLimitP.y, feedbackP.u1) annotation(
    Line(points = {{-112, 60}, {-100, 60}}, color = {0, 0, 127}));
  connect(rotationGridToWt.iGsRePu, feedbackP.u2) annotation(
    Line(points = {{-10, 42}, {-16, 42}, {-16, 100}, {-92, 100}, {-92, 68}}, color = {0, 0, 127}));
  connect(rotationGridToWt.iGsImPu, feedbackQ.u2) annotation(
    Line(points = {{-10, 66}, {-18, 66}, {-18, -80}, {-90, -80}, {-90, -28}}, color = {0, 0, 127}));
  connect(feedbackP.y, piP.u) annotation(
    Line(points = {{-82, 60}, {-68, 60}}, color = {0, 0, 127}));
  connect(feedbackQ.y, piQ.u) annotation(
    Line(points = {{-80, -20}, {-74, -20}, {-74, -19}, {-67, -19}}, color = {0, 0, 127}));
  connect(piQ.y, rotationWtToGrid.iqCmdPu) annotation(
    Line(points = {{-52, -18}, {-8, -18}, {-8, -20}}, color = {0, 0, 127}));
  connect(piP.y, rotationWtToGrid.ipCmdPu) annotation(
    Line(points = {{-52, 60}, {-24, 60}, {-24, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(integratorRe.y, addXRe.u1) annotation(
    Line(points = {{56.6, 60}, {65.6, 60}}, color = {0, 0, 127}));
  connect(complexToReal1.im, addXRe.u2) annotation(
    Line(points = {{132, 40}, {60, 40}, {60, 48}, {66, 48}}, color = {0, 0, 127}));
  connect(complexToReal1.re, addXIm.u1) annotation(
    Line(points = {{132, 28}, {60, 28}, {60, -28}, {66, -28}}, color = {0, 0, 127}));
  connect(addXIm.u2, integratorIm.y) annotation(
    Line(points = {{66, -40}, {57, -40}}, color = {0, 0, 127}));
  connect(addXIm.y, realToComplex.im) annotation(
    Line(points = {{89, -34}, {100, -34}, {100, -6}, {132, -6}}, color = {0, 0, 127}));
  connect(addXRe.y, realToComplex.re) annotation(
    Line(points = {{89, 54}, {100, 54}, {100, 6}, {132, 6}}, color = {0, 0, 127}));
  connect(addXIm.y, rotationGridToWt.iqCmdPu) annotation(
    Line(points = {{89, -34}, {100, -34}, {100, -80}, {20, -80}, {20, 54}, {10, 54}}, color = {0, 0, 127}));
  connect(rotationGridToWt.ipCmdPu, addXRe.y) annotation(
    Line(points = {{10, 32}, {18, 32}, {18, 100}, {100, 100}, {100, 54}, {90, 54}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Line(origin = {164.922, -0.0407085}, points = {{-9, 0}, {9, 0}, {51, 0}}, color = {114, 159, 207}), Rectangle(origin = {-1, 9}, lineColor = {23, 156, 125}, lineThickness = 0.75, extent = {{-27, 109}, {27, -109}})}, coordinateSystem(extent = {{-200, -100}, {200, 200}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end GenSystem3_base;
