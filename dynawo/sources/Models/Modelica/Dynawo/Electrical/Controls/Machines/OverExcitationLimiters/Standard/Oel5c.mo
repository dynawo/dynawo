within Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

model Oel5c "IEEE overexcitation limiter type OEL5C model"

  //Regulation parameters
  parameter Types.PerUnit IBias "OEL reference bias";
  parameter Types.PerUnit IfdLevelPu "OEL activation logic pickup level in pu (base SnRef, user-selected base voltage)";
  parameter Types.PerUnit IfdLimPu "OEL inverse time limit active level in pu (base SnRef, user-selected base voltage)";
  parameter Types.PerUnit IfdPu "OEL inverse time integrator pickup level in pu (base SnRef, user-selected base voltage)";
  parameter Types.PerUnit IfdRef1Pu "OEL reference 1 in pu (base SnRef, user-selected base voltage)";
  parameter Types.PerUnit IfdRef2Pu "OEL reference 2 in pu (base SnRef, user-selected base voltage)";
  parameter Types.PerUnit K1 "Exponent for inverse time function";
  parameter Types.PerUnit KIfdt "OEL inverse time leak gain";
  parameter Types.PerUnit KiOel "OEL integral gain";
  parameter Types.PerUnit KiVfe "Exciter field current regulator integral gain";
  parameter Types.PerUnit KpOel "OEL proportional gain";
  parameter Types.PerUnit KpVfe "Exciter field current regulator proportional gain";
  parameter Boolean Sw1 "OEL reference logic switch";
  parameter Types.Time tBOel "OEL lag time constant in s";
  parameter Types.Time tCOel "OEL lead time constant in s";
  parameter Types.Time tF1 "OEL input transducer time constant in s";
  parameter Types.Time tF2 "Exciter field current transducer time constant in s";
  parameter Types.Time tIfdLevel "OEL activation logic timer setpoint in s";
  parameter Types.Time tOel "OEL inverse time integrator time constant in s";
  parameter Types.PerUnit TolPI "Tolerance on PI limit crossing as a fraction of the difference between limits";
  parameter Types.VoltageModulePu VfeMaxPu "Exciter field current regulator upper limit";
  parameter Types.VoltageModulePu VfeMinPu "Exciter field current regulator lower limit";
  parameter Types.VoltageModulePu VfeRefPu "Exciter field current reference setpoint";
  parameter Types.VoltageModulePu VOel1MaxPu "OEL inverse time upper limit";
  parameter Types.VoltageModulePu VOelMaxPu "OEL PI control upper limit";
  parameter Types.VoltageModulePu VOelMinPu "OEL PI control lower limit";

  final parameter Types.PerUnit K = IfdRef2Pu / (KScale1 * Input0Pu) "OEL lead-lag gain";
  final parameter Types.PerUnit KScale1 = (IfdPu ^ (-K1)) / Input0Pu "Scale factor for OEL input";
  final parameter Types.PerUnit KScale2 = if Vfe0Pu > 0 then VfeRefPu / Vfe0Pu else 0 "Scale factor for exciter field current";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput inputPu(start = Input0Pu) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-280, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput VfePu(start = Vfe0Pu) "Field current signal in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {-280, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {270, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tF1, k = KScale1, y_start = KScale1 * Input0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.Power power1(N = K1, NInteger = true) annotation(
    Placement(visible = true, transformation(origin = {-170, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = 1 / tOel, outMax = VOel1MaxPu, outMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {230, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = Sw1) annotation(
    Placement(visible = true, transformation(origin = {-130, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-180, -140}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tF2, k = KScale2, y_start = KScale2 * Vfe0Pu) annotation(
    Placement(visible = true, transformation(origin = {-230, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction transferFunction(a = {tBOel, 1}, b = {tCOel, 1}, x_start = {KScale1 * Input0Pu}, y_start = KScale1 * Input0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = KIfdt) annotation(
    Placement(visible = true, transformation(origin = {-70, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = VfeRefPu) annotation(
    Placement(visible = true, transformation(origin = {-230, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = KiVfe, Kp = KpVfe, YMax = VfeMaxPu, YMin = VfeMinPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = IBias) annotation(
    Placement(visible = true, transformation(origin = {-130, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = IfdPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.FlipFlopS flipFlopS annotation(
    Placement(visible = true, transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = IfdLimPu) annotation(
    Placement(visible = true, transformation(origin = {-10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqualThreshold lessEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {-10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold1(threshold = IfdLevelPu) annotation(
    Placement(visible = true, transformation(origin = {-170, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold2(threshold = tIfdLevel) annotation(
    Placement(visible = true, transformation(origin = {-10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI1(Ki = KiOel, Kp = KpOel, Tol = TolPI, YMax = VOelMaxPu, YMin = VOelMinPu) annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k2 = -K) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = IfdRef1Pu) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = IfdRef2Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit Input0Pu "Initial input signal";
  parameter Types.VoltageModulePu Vfe0Pu "Initial field current signal in pu (user-selected base voltage)";

equation
  connect(inputPu, firstOrder.u) annotation(
    Line(points = {{-280, -20}, {-242, -20}}, color = {0, 0, 127}));
  connect(VfePu, firstOrder2.u) annotation(
    Line(points = {{-280, -100}, {-242, -100}}, color = {0, 0, 127}));
  connect(const.y, feedback3.u1) annotation(
    Line(points = {{-219, -140}, {-188, -140}}, color = {0, 0, 127}));
  connect(firstOrder2.y, feedback3.u2) annotation(
    Line(points = {{-219, -100}, {-180, -100}, {-180, -132}, {-180, -132}}, color = {0, 0, 127}));
  connect(feedback3.y, limitedPI.u) annotation(
    Line(points = {{-171, -140}, {-143, -140}}, color = {0, 0, 127}));
  connect(const1.y, switch.u1) annotation(
    Line(points = {{-119, -60}, {-100, -60}, {-100, -92}, {-83, -92}}, color = {0, 0, 127}));
  connect(limitedPI.y, switch.u3) annotation(
    Line(points = {{-119, -140}, {-100, -140}, {-100, -108}, {-83, -108}}, color = {0, 0, 127}));
  connect(booleanConstant.y, switch.u2) annotation(
    Line(points = {{-119, -100}, {-83, -100}}, color = {255, 0, 255}));
  connect(switch.y, switch1.u3) annotation(
    Line(points = {{-59, -100}, {200, -100}, {200, -88}, {218, -88}}, color = {0, 0, 127}));
  connect(firstOrder.y, transferFunction.u) annotation(
    Line(points = {{-219, -20}, {-142, -20}}, color = {0, 0, 127}));
  connect(firstOrder.y, power1.u) annotation(
    Line(points = {{-219, -20}, {-200, -20}, {-200, 60}, {-183, 60}}, color = {0, 0, 127}));
  connect(power1.y, add3.u2) annotation(
    Line(points = {{-159, 60}, {-123, 60}}, color = {0, 0, 127}));
  connect(add3.y, limIntegrator.u) annotation(
    Line(points = {{-99, 60}, {-83, 60}}, color = {0, 0, 127}));
  connect(limIntegrator.y, gain.u) annotation(
    Line(points = {{-59, 60}, {-40, 60}, {-40, 100}, {-58, 100}}, color = {0, 0, 127}));
  connect(firstOrder.y, greaterThreshold1.u) annotation(
    Line(points = {{-219, -20}, {-200, -20}, {-200, 140}, {-183, 140}}, color = {0, 0, 127}));
  connect(limIntegrator.y, greaterThreshold.u) annotation(
    Line(points = {{-59, 60}, {-40, 60}, {-40, 100}, {-22, 100}}, color = {0, 0, 127}));
  connect(limIntegrator.y, lessEqualThreshold.u) annotation(
    Line(points = {{-59, 60}, {-22, 60}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, flipFlopS.s) annotation(
    Line(points = {{1, 100}, {20, 100}, {20, 86}, {37, 86}}, color = {255, 0, 255}));
  connect(lessEqualThreshold.y, flipFlopS.r) annotation(
    Line(points = {{1, 60}, {20, 60}, {20, 74}, {37, 74}}, color = {255, 0, 255}));
  connect(greaterThreshold2.y, or1.u1) annotation(
    Line(points = {{1, 140}, {138, 140}}, color = {255, 0, 255}));
  connect(flipFlopS.y, or1.u2) annotation(
    Line(points = {{61, 80}, {120, 80}, {120, 132}, {138, 132}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(or1.y, switch1.u2) annotation(
    Line(points = {{161, 140}, {180, 140}, {180, -80}, {218, -80}}, color = {255, 0, 255}));
  connect(switch1.y, UOelPu) annotation(
    Line(points = {{241, -80}, {270, -80}}, color = {0, 0, 127}));
  connect(greaterThreshold1.y, timer.u) annotation(
    Line(points = {{-159, 140}, {-83, 140}}, color = {255, 0, 255}));
  connect(timer.y, greaterThreshold2.u) annotation(
    Line(points = {{-59, 140}, {-23, 140}}, color = {0, 0, 127}));
  connect(add.y, limitedPI1.u) annotation(
    Line(points = {{1, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(limitedPI1.y, switch1.u1) annotation(
    Line(points = {{161, -60}, {200, -60}, {200, -72}, {218, -72}}, color = {0, 0, 127}));
  connect(gain.y, add3.u1) annotation(
    Line(points = {{-81, 100}, {-140, 100}, {-140, 68}, {-123, 68}}, color = {0, 0, 127}));
  connect(const2.y, add3.u3) annotation(
    Line(points = {{-159, 20}, {-140, 20}, {-140, 52}, {-123, 52}}, color = {0, 0, 127}));
  connect(transferFunction.y, add.u2) annotation(
    Line(points = {{-119, -20}, {-80, -20}, {-80, -66}, {-22, -66}}, color = {0, 0, 127}));
  connect(greaterThreshold2.y, switch2.u2) annotation(
    Line(points = {{1, 140}, {100, 140}, {100, 0}, {2, 0}}, color = {255, 0, 255}));
  connect(const3.y, switch2.u1) annotation(
    Line(points = {{39, 40}, {20, 40}, {20, 8}, {2, 8}}, color = {0, 0, 127}));
  connect(const4.y, switch2.u3) annotation(
    Line(points = {{39, -40}, {20, -40}, {20, -8}, {2, -8}}, color = {0, 0, 127}));
  connect(switch2.y, add.u1) annotation(
    Line(points = {{-21, 0}, {-40, 0}, {-40, -54}, {-23, -54}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-260, -160}, {260, 160}})));
end Oel5c;
