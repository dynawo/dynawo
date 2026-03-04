within Dynawo.Electrical.InverterBasedGeneration.BaseClasses;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BaseIBG "Generic model of inverter-based generation (IBG)"
  // Rating
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the injector (in MVA)";

  // PLL
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";

  // Filters
  parameter Types.Time tFilterOmega "First order time constant for the frequency estimation in s";
  parameter Types.Time tFilterU "Voltage measurement first order time constant in s";
  parameter Types.Time tG "Current commands filter in s";
  parameter Types.Time tRateLim = 1e-2 "Current slew limiter delay in s";

  // Frequency support
  parameter Types.AngularVelocityPu OmegaDeadBandPu "Deadband of the overfrequency contribution in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before start of disconnections in pu (base omegaNom)";

  // Voltage support
  parameter Real kRCA "Slope of reactive current decrease for high voltages in pu (base UNom, SNom)";
  parameter Real kRCI "Slope of reactive current increase for low voltages in pu (base UNom, SNom)";
  parameter Real m "Current injection just outside of lower deadband in pu (base IMaxPu)";
  parameter Real n "Current injection just outside of upper deadband in pu (base IMaxPu)";
  parameter Types.VoltageModulePu UMaxPu "Maximum voltage over which the unit is disconnected in pu (base UNom)";
  parameter Types.VoltageModulePu US1 "Lower voltage limit of deadband in pu (base UNom)";
  parameter Types.VoltageModulePu US2 "Higher voltage limit of deadband in pu (base UNom)";

  // Low voltage ride through
  parameter Types.Time tLVRTMax "Time delay of trip for small voltage dips in s";
  parameter Types.Time tLVRTMin "Time delay of trip for severe voltage dips in s";
  parameter Types.Time tLVRTInt "Time delay of trip for intermediate voltage dips in s";
  parameter Types.VoltageModulePu ULVRTArmingPu "Voltage threshold under which the automaton is activated after tLVRTMax in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTIntPu "Voltage threshold under which the automaton is activated after tLVRTMin in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTMinPu "Voltage threshold under which the automaton is activated instantaneously in pu (base UNom)";

  parameter Real IpSlewMaxPu "Active current slew limit (both up and down) in pu (base UNom, SNom)";
  parameter Real IqSlewMaxPu "Reactive current slew limit (both up and down) in pu (base UNom, SNom) (not in the original model, can use arbitrarily large value to bypass it)";
  parameter Types.VoltageModulePu UPLLFreezePu "PLL freeze voltage threshold in pu (base UNom)";
  parameter Types.VoltageModulePu UQPrioPu "Voltage under which priority is given to reactive current injection in pu (base UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PextPu(start = -P0Pu*SystemBase.SnRef/SNom) "Available power from the DC source in pu (base SNom)" annotation(
    Placement(transformation(origin = {-420, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iQrefPu(start = IqRef0Pu) "Target reactive current in pu (base UNom, SNom)" annotation(
    Placement(transformation(origin = {-420, -180}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-420, 160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {390, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {340, -60}, extent = {{20, 20}, {-20, -20}}, rotation = 180)));
  Dynawo.Electrical.Controls.PLL.PLLFreeze PLLFreeze(OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu, Ki = Ki, Kp = Kp) annotation(
    Placement(visible = true, transformation(origin = {40, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UFilter(T = tFilterU, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessThreshold Vfreeze(threshold = UPLLFreezePu) annotation(
    Placement(visible = true, transformation(origin = {-150, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter iPLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max uLowerBound annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold currentPriority(threshold = UQPrioPu) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG.LimitUpdating limitUpdating(IMaxPu = IMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG.VoltageSupport voltageSupport(IMaxPu = IMaxPu, US1 = US1, US2 = US2, kRCA = kRCA, kRCI = kRCI, m = m, n = n) annotation(
    Placement(visible = true, transformation(origin = {-150, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-90, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter iQLimiter(homotopyType = Modelica.Blocks.Types.VariableLimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {70, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder iQcmdFirstOrder(T = tG, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder omegaFilter(T = tFilterOmega, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-330, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-210, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Controls.Machines.Protections.OVA overVoltageProtection(UMaxPu = UMaxPu, tLagAction = 0)  annotation(
    Placement(transformation(origin = {-150, 120}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter iPSlewLimit(DuMax = IpSlewMaxPu, DuMin = -99, Y0 = Id0Pu, tS = tRateLim) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter iQSlewLimit(DuMax = IqSlewMaxPu, Y0 = -Iq0Pu, tS = tRateLim) annotation(
    Placement(visible = true, transformation(origin = {170, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder iPcmdFirstOrder(T = tG, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {210, -160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder iQLimitFilter(T = 0.01, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder iDLimitFilter(T = 0.01, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  // Initial values
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit Id0Pu "Start value of d-axs current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqRef0Pu "Start value of the reference q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at terminal in rad";

equation
  connect(injector.terminal, terminal) annotation(
    Line(points = {{363, -76}, {389.375, -76}, {389.375, -80}, {390, -80}}, color = {0, 0, 255}));
  connect(injector.UPu, UFilter.u) annotation(
    Line(points = {{363, -44}, {380, -44}, {380, 79.9}, {-138, 79.9}, {-138, 80}}, color = {0, 0, 127}));
  connect(UFilter.y, Vfreeze.u) annotation(
    Line(points = {{-161, 80}, {-180, 80}, {-180, 160}, {-162, 160}}, color = {0, 0, 127}));
  connect(injector.uPu, PLLFreeze.uPu) annotation(
    Line(points = {{363, -67}, {400, -67}, {400, 200}, {0, 200}, {0, 172}, {18, 172}}, color = {85, 170, 255}));
  connect(division.y, iPLimiter.u) annotation(
    Line(points = {{-19, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(const.y, iPLimiter.limit2) annotation(
    Line(points = {{59, 0}, {40, 0}, {40, 32}, {58, 32}}, color = {0, 0, 127}));
  connect(UFilter.y, uLowerBound.u1) annotation(
    Line(points = {{-161, 80}, {-180, 80}, {-180, 26}, {-142, 26}}, color = {0, 0, 127}));
  connect(constant1.y, uLowerBound.u2) annotation(
    Line(points = {{-141, -20}, {-160, -20}, {-160, 14}, {-142, 14}}, color = {0, 0, 127}));
  connect(uLowerBound.y, division.u2) annotation(
    Line(points = {{-119, 20}, {-60, 20}, {-60, 34}, {-42, 34}}, color = {0, 0, 127}));
  connect(UFilter.y, currentPriority.u) annotation(
    Line(points = {{-161, 80}, {-180, 80}, {-180, -60}, {-162, -60}}, color = {0, 0, 127}));
  connect(UFilter.y, voltageSupport.Um) annotation(
    Line(points = {{-161, 80}, {-180, 80}, {-180, -140}, {-161, -140}}, color = {0, 0, 127}));
  connect(voltageSupport.IqSupPu, add.u1) annotation(
    Line(points = {{-139, -140}, {-120, -140}, {-120, -154}, {-102, -154}}, color = {0, 0, 127}));
  connect(iQrefPu, add.u2) annotation(
    Line(points = {{-420, -180}, {-120, -180}, {-120, -166}, {-102, -166}}, color = {0, 0, 127}));
  connect(add.y, iQLimiter.u) annotation(
    Line(points = {{-79, -160}, {58, -160}}, color = {0, 0, 127}));
  connect(iQLimiter.y, iQcmdFirstOrder.u) annotation(
    Line(points = {{81, -160}, {118, -160}}, color = {0, 0, 127}));
  connect(PLLFreeze.omegaPLLPu, omegaFilter.u) annotation(
    Line(points = {{62, 170}, {88, 170}, {88, 100}, {-360, 100}, {-360, 120}, {-342, 120}}, color = {0, 0, 127}));
  connect(PextPu, add2.u2) annotation(
    Line(points = {{-420, 20}, {-240, 20}, {-240, 54}, {-222, 54}}, color = {0, 0, 127}));
  connect(add2.y, division.u1) annotation(
    Line(points = {{-199, 60}, {-60, 60}, {-60, 46}, {-42, 46}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(UFilter.y, overVoltageProtection.UMonitoredPu) annotation(
    Line(points = {{-160, 80}, {-180, 80}, {-180, 120}, {-162, 120}}, color = {0, 0, 127}));
  connect(iPcmdFirstOrder.y, iPSlewLimit.u) annotation(
    Line(points = {{141, 40}, {158, 40}}, color = {0, 0, 127}));
  connect(iPLimiter.y, iPcmdFirstOrder.u) annotation(
    Line(points = {{81, 40}, {118, 40}}, color = {0, 0, 127}));
  connect(currentPriority.y, limitUpdating.PPriority) annotation(
    Line(points = {{-139, -60}, {-62, -60}}, color = {255, 0, 255}));
  connect(iQLimiter.y, iQLimitFilter.u) annotation(
    Line(points = {{81, -160}, {100, -160}, {100, -80.5}, {82, -80.5}, {82, -80}}, color = {0, 0, 127}));
  connect(limitUpdating.IqCmdPu, iQLimitFilter.y) annotation(
    Line(points = {{-62, -68}, {-80, -68}, {-80, -80}, {59, -80}}, color = {0, 0, 127}));
  connect(iPLimiter.y, iDLimitFilter.u) annotation(
    Line(points = {{81, 40}, {100, 40}, {100, -40}, {82, -40}}, color = {0, 0, 127}));
  connect(iDLimitFilter.y, limitUpdating.IpCmdPu) annotation(
    Line(points = {{59, -40}, {-80, -40}, {-80, -52}, {-62, -52}}, color = {0, 0, 127}));
  connect(limitUpdating.IpMaxPu, iPLimiter.limit1) annotation(
    Line(points = {{-39, -54}, {0, -54}, {0, 48}, {58, 48}}, color = {0, 0, 127}));
  connect(Vfreeze.y, PLLFreeze.freeze) annotation(
    Line(points = {{-139, 160}, {0.5, 160}, {0.5, 156}, {18, 156}}, color = {255, 0, 255}));
  connect(omegaRefPu, PLLFreeze.omegaRefPu) annotation(
    Line(points = {{-420, 160}, {-360, 160}, {-360, 200}, {-20, 200}, {-20, 148}, {18, 148}}, color = {0, 0, 127}));
  connect(PLLFreeze.phi, injector.UPhase) annotation(
    Line(points = {{62, 162}, {340, 162}, {340, -37}, {340, -37}}, color = {0, 0, 127}));
  connect(limitUpdating.IqMaxPu, iQLimiter.limit1) annotation(
    Line(points = {{-39, -64}, {40, -64}, {40, -152}, {58, -152}}, color = {0, 0, 127}));
  connect(limitUpdating.IqMinPu, iQLimiter.limit2) annotation(
    Line(points = {{-39, -68}, {0, -68}, {0, -168}, {58, -168}}, color = {0, 0, 127}));
  connect(iQcmdFirstOrder.y, iQSlewLimit.u) annotation(
    Line(points = {{141, -160}, {157, -160}}, color = {0, 0, 127}));
  connect(iQSlewLimit.y, gain.u) annotation(
    Line(points = {{181, -160}, {197, -160}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
    <p> Generic model of inverter-based generation as defined in p28 of Gilles Chaspierre's PhD thesis 'Reduced-order modelling of active distribution networks for large-disturbance simulations'. Available: https://orbi.uliege.be/handle/2268/251602 </p></html>"),
    Diagram(coordinateSystem(extent = {{-400, -200}, {400, 200}}), graphics),
    Icon(graphics = {Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "IBG")}));
end BaseIBG;
