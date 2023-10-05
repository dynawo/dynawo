within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;

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

model VRNordic "Voltage regulator model for the Nordic 32 test system used for voltage stability studies"

  parameter Types.VoltageModulePu EfdMaxPu "Upper limit of excitation voltage in pu (user-selected base voltage)";
  parameter Real OelMode "For positive field current error signal : if 1, OEL output constant, if 0, OEL output equal to error signal";
  parameter Types.CurrentModulePu IrLimPu "Rotor current limit in pu (base SNom, UNom)";
  parameter Types.PerUnit KPss "Gain of PSS";
  parameter Types.PerUnit KTgr "Gain of transient gain reduction";
  parameter Types.Time tDerOmega "Derivative time constant of first PSS filter for angular frequency, in s";
  parameter Types.Time tLagPss "Lag time constant of second and third PSS filters in s";
  parameter Types.Time tLagTgr "Lag time constant of transient gain reduction in s";
  parameter Types.Time tLeadPss "Lead time constant of second and third PSS filters in s";
  parameter Types.Time tLeadTgr "Lead time constant of transient gain reduction in s";
  parameter Types.Time tOelMin "Lower limit of OEL timer in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IrPu(start = Ir0Pu) "Rotor current in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsPu(start = Us0Pu) "Stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-300, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput efdPu(start = Efd0Pu) "Excitation voltage in pu (user-selected base voltage)" annotation(
    Placement(visible = true, transformation(origin = {290, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Connectors.ImPin efdPuPin(value(start = Efd0Pu)) "Pin for connecting efdPu to the generator";

  Modelica.Blocks.Math.Min min annotation(
    Placement(visible = true, transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(k = KPss, T = tDerOmega) annotation(
    Placement(visible = true, transformation(origin = {-190, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag1(a = {tLagPss, 1}, b = {tLeadPss, 1}) annotation(
    Placement(visible = true, transformation(origin = {-150, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag2(a = {tLagPss, 1}, b = {tLeadPss, 1}) annotation(
    Placement(visible = true, transformation(origin = {-110, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 0.1) annotation(
    Placement(visible = true, transformation(origin = {-70, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback dIf annotation(
    Placement(visible = true, transformation(origin = {-240, 80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = IrLimPu) annotation(
    Placement(visible = true, transformation(origin = {-270, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain kMulDU(k = KTgr) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.BaseClasses.OELNordic overExcitationLimitation(OelMode = OelMode, Y0 = -1) annotation(
    Placement(visible = true, transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 10) annotation(
    Placement(visible = true, transformation(origin = {190, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {140, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(outMax = EfdMaxPu, outMin = 0, y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback dOmega annotation(
    Placement(visible = true, transformation(origin = {-240, -120}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = SystemBase.omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {-270, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator timer(outMax = 99, outMin = tOelMin, y_start = tOelMin) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag(a = {tLagTgr, 1}, b = {tLeadTgr, 1}, x_scaled(start = {Efd0Pu}), x_start = {Efd0Pu}, y(start = Efd0Pu), y_start = Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback dU annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu Efd0Pu "Initial excitation voltage in pu (user-selected base voltage)";
  parameter Types.CurrentModulePu Ir0Pu "Initial rotor current in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage in pu (base UNom)";

  final parameter Types.VoltageModule UsRef0Pu = Efd0Pu / KTgr + Us0Pu "Reference stator voltage in pu (base UNom)";

equation
  efdPu = efdPuPin.value;

  connect(kMulDU.y, leadLag.u) annotation(
    Line(points = {{61, 0}, {77, 0}}, color = {0, 0, 127}));
  connect(leadLag2.y, limiter.u) annotation(
    Line(points = {{-99, -120}, {-82, -120}}, color = {0, 0, 127}));
  connect(leadLag1.y, leadLag2.u) annotation(
    Line(points = {{-139, -120}, {-122, -120}}, color = {0, 0, 127}));
  connect(derivative.y, leadLag1.u) annotation(
    Line(points = {{-179, -120}, {-162, -120}}, color = {0, 0, 127}));
  connect(limIntegrator.y, efdPu) annotation(
    Line(points = {{241, 0}, {290, 0}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{149, 0}, {178, 0}}, color = {0, 0, 127}));
  connect(gain.y, limIntegrator.u) annotation(
    Line(points = {{201, 0}, {218, 0}}, color = {0, 0, 127}));
  connect(greaterEqualThreshold.y, switch.u2) annotation(
    Line(points = {{-99, 40}, {-62, 40}}, color = {255, 0, 255}));
  connect(dIf.y, overExcitationLimitation.u) annotation(
    Line(points = {{-231, 80}, {-220, 80}, {-220, 40}, {-202, 40}}, color = {0, 0, 127}));
  connect(min.y, kMulDU.u) annotation(
    Line(points = {{21, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(switch.y, min.u1) annotation(
    Line(points = {{-39, 40}, {-20, 40}, {-20, 6}, {-2, 6}}, color = {0, 0, 127}));
  connect(gain1.y, switch.u1) annotation(
    Line(points = {{-139, 80}, {-80, 80}, {-80, 48}, {-62, 48}}, color = {0, 0, 127}));
  connect(dIf.y, gain1.u) annotation(
    Line(points = {{-231, 80}, {-162, 80}}, color = {0, 0, 127}));
  connect(overExcitationLimitation.y, timer.u) annotation(
    Line(points = {{-179.2, 40}, {-162.2, 40}}, color = {0, 0, 127}));
  connect(timer.y, greaterEqualThreshold.u) annotation(
    Line(points = {{-139, 40}, {-122, 40}}, color = {0, 0, 127}));
  connect(dOmega.y, derivative.u) annotation(
    Line(points = {{-231, -120}, {-202, -120}}, color = {0, 0, 127}));
  connect(leadLag.y, feedback1.u1) annotation(
    Line(points = {{102, 0}, {132, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, feedback1.u2) annotation(
    Line(points = {{242, 0}, {260, 0}, {260, -40}, {140, -40}, {140, -8}}, color = {0, 0, 127}));
  connect(IrPu, dIf.u1) annotation(
    Line(points = {{-300, 80}, {-248, 80}}, color = {0, 0, 127}));
  connect(const2.y, dIf.u2) annotation(
    Line(points = {{-258, 120}, {-240, 120}, {-240, 88}}, color = {0, 0, 127}));
  connect(omegaPu, dOmega.u1) annotation(
    Line(points = {{-300, -120}, {-248, -120}}, color = {0, 0, 127}));
  connect(const.y, dOmega.u2) annotation(
    Line(points = {{-259, -80}, {-240, -80}, {-240, -112}}, color = {0, 0, 127}));
  connect(UsPu, dU.u2) annotation(
    Line(points = {{-300, -40}, {-220, -40}, {-220, -8}, {-220, -8}}, color = {0, 0, 127}));
  connect(const1.y, dU.u1) annotation(
    Line(points = {{-259, 0}, {-229, 0}}, color = {0, 0, 127}));
  connect(limiter.y, add.u2) annotation(
    Line(points = {{-59, -120}, {-40, -120}, {-40, -60}, {-140, -60}, {-140, -26}, {-122, -26}}, color = {0, 0, 127}));
  connect(dU.y, add.u1) annotation(
    Line(points = {{-211, 0}, {-140, 0}, {-140, -14}, {-122, -14}}, color = {0, 0, 127}));
  connect(add.y, switch.u3) annotation(
    Line(points = {{-99, -20}, {-80, -20}, {-80, 32}, {-62, 32}}, color = {0, 0, 127}));
  connect(add.y, min.u2) annotation(
    Line(points = {{-99, -20}, {-20, -20}, {-20, -6}, {-2, -6}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 120}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, extent = {{-60, 20}, {60, -20}}, textString = "%name"), Text(extent = {{-97, 117}, {97, -117}}, textString = "AVR, EXC,
OEL, PSS")}),
    uses(Modelica(version = "3.2.3")),
    Documentation(info = "<html><head></head><body>This model implements the AVR, PSS and overexcitation limiter of the generator frames in the Nordic 32 test system used for voltage stability studies.<div>The overexcitation limiter uses a delayed activation with specifics depending on the generator.&nbsp;</div><div>Certain generators reduce the delay by assigning a linear function to the error signal of the excitation current and its limit, this is implemented in the overexcitation limitation model.</div></body></html>"),
    Diagram(coordinateSystem(extent = {{-280, -140}, {280, 140}})));
end VRNordic;
