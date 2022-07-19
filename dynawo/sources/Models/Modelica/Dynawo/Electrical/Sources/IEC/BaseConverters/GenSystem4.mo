within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GenSystem4 "Type 4 generator system module (IEC N°61400-27-1)"

  /*
    Equivalent circuit and conventions:

      __           iGs
     /__\----------->-- (terminal)
     \__/--------------

  */
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Control parameters
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMinPu "Minimum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kipaw "Antiwindup gain for active current" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kiqaw "Antiwindup gain for reactive current" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant in s" annotation(
    Dialog(tab = "Control"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = UGsRe0Pu), im(start = UGsIm0Pu)), i(re(start = -IGsRe0Pu * SNom / SystemBase.SnRef), im(start = -IGsIm0Pu * SNom / SystemBase.SnRef))) "Converter terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput fOCB(start = true) "Breaker position, true if closed, false if open" annotation(
    Placement(visible = true, transformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-150, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput PaGPu(start = PaG0Pu) "Active power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.IEC.BaseConverters.RefFrameRotation iECFrameRotation(IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {1.58946e-07, -4.76837e-07}, extent = {{-20, -60}, {20, 60}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup(DyMax = DipMaxPu, DyMin = -999, Kaw = Kipaw, UseLimits = true, Y0 = -P0Pu * SystemBase.SnRef / (SNom * U0Pu), YMax = 999, tI = tG) annotation(
    Placement(visible = true, transformation(origin = {-90, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.AbsLimRateLimFirstOrderAntiWindup absLimRateLimFirstOrderAntiWindup1(DyMax = DiqMaxPu, DyMin = DiqMinPu, Kaw = Kiqaw, UseLimits = true, Y0 = Q0Pu * SystemBase.SnRef / (SNom * U0Pu), YMax = 999, tI = tG) annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = -999) annotation(
    Placement(visible = true, transformation(origin = {-145, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex iGs annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Sources.ComplexExpression uGs(y = terminal.V) annotation(
    Placement(visible = true, transformation(origin = {10, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {70, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit PaG0Pu "Initial active power at converter terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  if fOCB then
    Complex(iECFrameRotation.iGsRePu, iECFrameRotation.iGsImPu) = -terminal.i * (SystemBase.SnRef / SNom);
  else
    terminal.i = Complex(0, 0);
  end if;

  connect(iECFrameRotation.iGsImPu, iGs.im) annotation(
    Line(points = {{26, -30}, {40, -30}, {40, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(iECFrameRotation.iGsRePu, iGs.re) annotation(
    Line(points = {{26, 30}, {40, 30}, {40, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(theta, iECFrameRotation.theta) annotation(
    Line(points = {{-150, -80}, {-60, -80}, {-60, -54}, {-26, -54}}, color = {0, 0, 127}));
  connect(ipMaxPu, absLimRateLimFirstOrderAntiWindup.yMax) annotation(
    Line(points = {{-150, 80}, {-120, 80}, {-120, 66}, {-102, 66}}, color = {0, 0, 127}));
  connect(const.y, absLimRateLimFirstOrderAntiWindup.yMin) annotation(
    Line(points = {{-139.5, 40}, {-120, 40}, {-120, 54}, {-102, 54}}, color = {0, 0, 127}));
  connect(uGs.y, product.u1) annotation(
    Line(points = {{22, -80}, {40, -80}, {40, -66}, {58, -66}}, color = {85, 170, 255}));
  connect(iGs.y, product.u2) annotation(
    Line(points = {{82, 0}, {100, 0}, {100, -40}, {40, -40}, {40, -54}, {58, -54}}, color = {85, 170, 255}));
  connect(product.y, complexToReal.u) annotation(
    Line(points = {{82, -60}, {98, -60}}, color = {85, 170, 255}));
  connect(complexToReal.re, PaGPu) annotation(
    Line(points = {{122, -54}, {130, -54}, {130, -60}, {150, -60}}, color = {0, 0, 127}));
  connect(iqCmdPu, absLimRateLimFirstOrderAntiWindup1.u) annotation(
    Line(points = {{-150, 0}, {-102, 0}}, color = {0, 0, 127}));
  connect(ipCmdPu, absLimRateLimFirstOrderAntiWindup.u) annotation(
    Line(points = {{-150, 60}, {-102, 60}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup1.y, iECFrameRotation.iqCmdPu) annotation(
    Line(points = {{-78, 0}, {-26, 0}}, color = {0, 0, 127}));
  connect(absLimRateLimFirstOrderAntiWindup.y, iECFrameRotation.ipCmdPu) annotation(
    Line(points = {{-79, 60}, {-40, 60}, {-40, 54}, {-26, 54}}, color = {0, 0, 127}));
  connect(iqMaxPu, absLimRateLimFirstOrderAntiWindup1.yMax) annotation(
    Line(points = {{-150, 20}, {-120, 20}, {-120, 6}, {-102, 6}}, color = {0, 0, 127}));
  connect(iqMinPu, absLimRateLimFirstOrderAntiWindup1.yMin) annotation(
    Line(points = {{-150, -20}, {-120, -20}, {-120, -6}, {-102, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(graphics = {Line(origin = {90.7207, -0.279255}, points = {{-9, 0}, {9, 0}, {51, 0}}, color = {114, 159, 207})}, coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Generator"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end GenSystem4;
