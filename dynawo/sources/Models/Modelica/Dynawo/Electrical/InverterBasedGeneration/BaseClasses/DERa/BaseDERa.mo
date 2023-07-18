within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.DERa;

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

model BaseDERa "Base model for der_a (Distributed Energy Resources model)"
  // Injector
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the injector (in MVA)";
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";
  parameter Boolean PPriority "If true, prioritise active power over reactive power";
  parameter Real KpPll = 3 "PLL proportional coefficient";
  parameter Real KiPll = 10 "PLL integral coefficient";

  // Filters
  parameter Types.Time tFilterU "Voltage measurement first order time constant in s";
  parameter Types.Time tFilterOmega "First order time constant for the frequency estimation in s";
  parameter Types.Time tRateLim = 1e-3 "Current slew limiter delay in s";
  parameter Types.Time tP "P measurement first order time constant in s";
  parameter Types.Time tG "Output current time constant in s";
  parameter Types.Time tPord "Active power time constant in s";
  parameter Types.Time tIq "Reactive current time constant in s";

  // Frequency support
  parameter Types.AngularVelocityPu FDbd1Pu "Lower value of frequency dead zone in pu (base omegaNom)";
  parameter Types.AngularVelocityPu FDbd2Pu "Upper value of frequency dead zone in pu (base omegaNom)";
  parameter Real DdnPu "Power reduction factor for over-frequency in pu (base SNom)";
  parameter Real DupPu "Power increase factor for under-frequency in pu (base SNom)";
  parameter Types.AngularVelocityPu FEMaxPu "Maximum frequency error correction in pu (base omegaNom)";
  parameter Types.AngularVelocityPu FEMinPu "Minimum frequency error correction in pu (base omegaNom)";
  parameter Real Kpg "PI proportional coefficient of frequency support in pu (base SNom, omegaNom)";
  parameter Real Kig "PI integral coefficient of frequency support in pu (base SNom, omegaNom)";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SNom)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SNom)";
  parameter Types.PerUnit DPMaxPu "Maximum active power rise rate in pu (base SNom)";
  parameter Types.PerUnit DPMinPu "Minimum active power drop rate in pu (base SNom)";
  parameter Boolean FreqFlag "True if inverters support frequency";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before start of disconnections in pu (base omegaNom)";
  parameter Types.Time tOmegaMaxPu "Time-lag for over-frequency trips in s";
  parameter Types.Time tOmegaMinPu "Time-lag for under-frequency trips in s";
  parameter Types.CurrentModulePu IpRateLimMax "Maximum rise rate of the active current in pu (base SNom)";
  parameter Types.CurrentModulePu IpRateLimMin "Minimum drop rate of the active current in pu (base SNom)";

  // Voltage support
  parameter Boolean PfFlag "True for constant power factor, false for constant reactive power";
  parameter Types.VoltageModulePu VRefPu = 1 "Voltage reference in pu (base UNom)";
  parameter Types.VoltageModulePu Dbd1Pu "Lower value of voltage dead zone in pu (base UNom)";
  parameter Types.VoltageModulePu Dbd2Pu "Upper value of voltage dead zone in pu (base UNom)";
  parameter Real Kqv "Proportional coefficient of reactive support in pu (base SNom, UNom)";
  parameter Types.CurrentModulePu Iqh1 "Maximum reactive support current command (base SNom, UNom)";
  parameter Types.CurrentModulePu Iql1 "Maximum reactive support current command (base SNom, UNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-460, 100}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput PFaRef(start = acos(PF0)) "Power factor angle reference in rad" annotation(
    Placement(visible = true, transformation(origin = {-460, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-101, -380}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Available power from the DC source in pu (base SNom)" annotation(
    Placement(transformation(origin = {-460, 200}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Reactive power setpoint in pu (base SNom)" annotation(
    Placement(transformation(origin = {-320, -160}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {430, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit partialTrippingRatio(start = 1) "Coefficient for partial tripping of generators, equals 1 if no trips, 0 if all units are tripped";

  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {360, -80}, extent = {{20, 20}, {-20, -20}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder UFilter(T = tFilterU, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-410, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max1 annotation(
    Placement(visible = true, transformation(origin = {-210, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-270, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-50, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder iQcmdFirstOrder(T = tG, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {210, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder omegaFilter(T = tFilterOmega, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {250, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IpPartialTripping annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IqPartialTripping annotation(
    Placement(visible = true, transformation(origin = {170, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping1(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping2(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {110, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 0.01, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationB currentLimitsCalculation1(IMaxPu = IMaxPu, PQFlag = PPriority) annotation(
    Placement(visible = true, transformation(origin = {40, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 0.01, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPll, Kp = KpPll, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(transformation(origin = {-400, 112}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant constant2(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-350, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-300, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter frequencyErrorLimit(uMax = FEMaxPu, uMin = FEMinPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup powerPIAntiWinDupPu(Ki = Kpg, Kp = Kig, Y0 = -P0Pu*SystemBase.SnRef / SNom, YMax = PMaxPu, YMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {110, 180}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter powerRateLimit(Rising = DPMaxPu, Falling = DPMinPu, y_start = -P0Pu * SystemBase.SnRef / SNom, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {150, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant frequencyFlag(k = FreqFlag) annotation(
    Placement(visible = true, transformation(origin = {50, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-150, -100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone frequencyDeadZone(uMax = FDbd2Pu, uMin = FDbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-250, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tP, y_start = -P0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {-30, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vref(k = VRefPu) annotation(
    Placement(visible = true, transformation(origin = {-410, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-360, -200}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone voltageDeadZone(uMax = Dbd2Pu, uMin = Dbd1Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kqv) annotation(
    Placement(visible = true, transformation(origin = {-270, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-230, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder IqCmdFilter(T = tIq, y_start = -Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze IpRateLimiter(T = tRateLim, UseRateLim = true, Y0 = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {230, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IpRateMax(k = IpRateLimMax) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IpRateMin(k = IpRateLimMin) annotation(
    Placement(visible = true, transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = DdnPu) annotation(
    Placement(visible = true, transformation(origin = {-190, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = DupPu) annotation(
    Placement(visible = true, transformation(origin = {-190, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter down(uMax = 0, uMin = -999, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-150, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter up(uMax = 999, uMin = 0, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-150, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-90, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder pOrderFilter(T = tPord, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {190, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter reactiveSupportLimit(uMax = Iqh1, uMin = Iql1, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {-230, -200}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter pOrdLimit(uMax = PMaxPu, uMin = PMinPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(visible = true, transformation(origin = {230, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.DERa.FRT FRT(FhPu = OmegaMaxPu, FlPu = OmegaMinPu, tfh = tOmegaMaxPu, tfl = tOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-250, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PFFlag(k = PfFlag) annotation(
    Placement(visible = true, transformation(origin = {-290, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-320, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Tan tan annotation(
    Placement(visible = true, transformation(origin = {-350, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial values
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit Id0Pu "Start value of d-axs current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit PF0 "Start value of power factor";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at terminal in rad";

equation
  connect(injector.terminal, terminal) annotation(
    Line(points = {{383, -95.8}, {430, -95.8}}, color = {0, 0, 255}));
  connect(UFilter.y, max1.u1) annotation(
    Line(points = {{-399, -20}, {-240, -20}, {-240, -34}, {-222, -34}}, color = {0, 0, 127}));
  connect(constant1.y, max1.u2) annotation(
    Line(points = {{-259, -60}, {-240, -60}, {-240, -46}, {-222, -46}}, color = {0, 0, 127}));
  connect(iQcmdFirstOrder.y, gain.u) annotation(
    Line(points = {{221, -180}, {237, -180}}, color = {0, 0, 127}));
  connect(variableLimiter.y, firstOrder2.u) annotation(
    Line(points = {{121, -140}, {140, -140}, {140, -100}, {123, -100}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, firstOrder3.u) annotation(
    Line(points = {{121, -20}, {140, -20}, {140, -60}, {123, -60}}, color = {0, 0, 127}));
  connect(firstOrder3.y, currentLimitsCalculation1.ipCmdPu) annotation(
    Line(points = {{99, -60}, {80, -60}, {80, -72}, {62, -72}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{18, -92}, {0, -92}, {0, -132}, {98, -132}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{18, -76}, {-20, -76}, {-20, -12}, {98, -12}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{18, -84}, {-20, -84}, {-20, -148}, {98, -148}}, color = {0, 0, 127}));
  connect(firstOrder2.y, currentLimitsCalculation1.iqCmdPu) annotation(
    Line(points = {{99, -100}, {80, -100}, {80, -88}, {62, -88}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{18, -68}, {0, -68}, {0, -28}, {98, -28}}, color = {0, 0, 127}));
  connect(variableLimiter.y, IqPartialTripping.u1) annotation(
    Line(points = {{121, -140}, {140, -140}, {140, -174}, {157, -174}}, color = {0, 0, 127}));
  connect(PartialTripping2.y, IqPartialTripping.u2) annotation(
    Line(points = {{121, -200}, {140, -200}, {140, -186}, {157, -186}}, color = {0, 0, 127}));
  connect(IqPartialTripping.y, iQcmdFirstOrder.u) annotation(
    Line(points = {{181, -180}, {197, -180}}, color = {0, 0, 127}));
  connect(gain.y, injector.iqPu) annotation(
    Line(points = {{261, -180}, {320, -180}, {320, -88}, {337, -88}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, IpPartialTripping.u2) annotation(
    Line(points = {{121, -20}, {140, -20}, {140, -6}, {159, -6}}, color = {0, 0, 127}));
  connect(PartialTripping1.y, IpPartialTripping.u1) annotation(
    Line(points = {{121, 40}, {140, 40}, {140, 6}, {158, 6}}, color = {0, 0, 127}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{-378, 114}, {-374, 114}, {-374, 60}, {360, 60}, {360, -56}}, color = {0, 0, 127}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{384, -86}, {380, -86}, {380, 220}, {-432, 220}, {-432, 124}, {-422, 124}}, color = {85, 170, 255}));
  connect(frequencyErrorLimit.y, powerPIAntiWinDupPu.u) annotation(
    Line(points = {{21, 140}, {37, 140}}, color = {0, 0, 127}));
  connect(switch.y, powerRateLimit.u) annotation(
    Line(points = {{121, 180}, {138, 180}}, color = {0, 0, 127}));
  connect(frequencyFlag.y, switch.u2) annotation(
    Line(points = {{61, 180}, {98, 180}}, color = {255, 0, 255}));
  connect(division.y, variableLimiter1.u) annotation(
    Line(points = {{-39, -20}, {98, -20}}, color = {0, 0, 127}));
  connect(feedback.y, frequencyDeadZone.u) annotation(
    Line(points = {{-291, 140}, {-262, 140}}, color = {0, 0, 127}));
  connect(add3.y, frequencyErrorLimit.u) annotation(
    Line(points = {{-19, 140}, {-3, 140}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-460, 200}, {-60, 200}, {-60, 148}, {-42, 148}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u3) annotation(
    Line(points = {{-41, 100}, {-60, 100}, {-60, 132}, {-42, 132}}, color = {0, 0, 127}));
  connect(max1.y, division.u2) annotation(
    Line(points = {{-199, -40}, {-180, -40}, {-180, -26}, {-62, -26}}, color = {0, 0, 127}));
  connect(Vref.y, feedback1.u1) annotation(
    Line(points = {{-399, -200}, {-368, -200}}, color = {0, 0, 127}));
  connect(feedback1.y, voltageDeadZone.u) annotation(
    Line(points = {{-351, -200}, {-323, -200}}, color = {0, 0, 127}));
  connect(voltageDeadZone.y, gain1.u) annotation(
    Line(points = {{-299, -200}, {-283, -200}}, color = {0, 0, 127}));
  connect(PRefPu, switch.u3) annotation(
    Line(points = {{-460, 200}, {80, 200}, {80, 188}, {98, 188}}, color = {0, 0, 127}));
  connect(powerPIAntiWinDupPu.y, switch.u1) annotation(
    Line(points = {{61, 140}, {80, 140}, {80, 172}, {98, 172}}, color = {0, 0, 127}));
  connect(QRefPu, switch1.u3) annotation(
    Line(points = {{-320, -160}, {-260, -160}, {-260, -128}, {-242, -128}}, color = {0, 0, 127}));
  connect(max1.y, division1.u2) annotation(
    Line(points = {{-199, -40}, {-180, -40}, {-180, -94}, {-162, -94}}, color = {0, 0, 127}));
  connect(switch1.y, division1.u1) annotation(
    Line(points = {{-219, -120}, {-180, -120}, {-180, -106}, {-162, -106}}, color = {0, 0, 127}));
  connect(UFilter.y, feedback1.u2) annotation(
    Line(points = {{-399, -20}, {-360, -20}, {-360, -192}}, color = {0, 0, 127}));
  connect(injector.UPu, UFilter.u) annotation(
    Line(points = {{383, -64}, {400, -64}, {400, -220}, {-440, -220}, {-440, -20}, {-422, -20}}, color = {0, 0, 127}));
  connect(IpPartialTripping.y, IpRateLimiter.u) annotation(
    Line(points = {{181, 0}, {218, 0}}, color = {0, 0, 127}));
  connect(IpRateLimiter.y, injector.idPu) annotation(
    Line(points = {{241, 0}, {320, 0}, {320, -68}, {337, -68}}, color = {0, 0, 127}));
  connect(IpRateMax.y, IpRateLimiter.dyMax) annotation(
    Line(points = {{181, 40}, {200, 40}, {200, 7}, {218, 7}}, color = {0, 0, 127}));
  connect(IpRateMin.y, IpRateLimiter.dyMin) annotation(
    Line(points = {{181, -40}, {200, -40}, {200, -6}, {218, -6}}, color = {0, 0, 127}));
  connect(frequencyDeadZone.y, gain3.u) annotation(
    Line(points = {{-239, 140}, {-220, 140}, {-220, 120}, {-203, 120}}, color = {0, 0, 127}));
  connect(frequencyDeadZone.y, gain2.u) annotation(
    Line(points = {{-239, 140}, {-220, 140}, {-220, 160}, {-203, 160}}, color = {0, 0, 127}));
  connect(gain2.y, down.u) annotation(
    Line(points = {{-179, 160}, {-163, 160}}, color = {0, 0, 127}));
  connect(gain3.y, up.u) annotation(
    Line(points = {{-179, 120}, {-163, 120}}, color = {0, 0, 127}));
  connect(down.y, add1.u1) annotation(
    Line(points = {{-139, 160}, {-120, 160}, {-120, 146}, {-102, 146}}, color = {0, 0, 127}));
  connect(up.y, add1.u2) annotation(
    Line(points = {{-139, 120}, {-120, 120}, {-120, 134}, {-102, 134}}, color = {0, 0, 127}));
  connect(add1.y, add3.u2) annotation(
    Line(points = {{-79, 140}, {-42, 140}}, color = {0, 0, 127}));
  connect(powerRateLimit.y, pOrderFilter.u) annotation(
    Line(points = {{161, 180}, {178, 180}}, color = {0, 0, 127}));
  connect(gain1.y, reactiveSupportLimit.u) annotation(
    Line(points = {{-259, -200}, {-243, -200}}, color = {0, 0, 127}));
  connect(reactiveSupportLimit.y, add.u2) annotation(
    Line(points = {{-219, -200}, {-80, -200}, {-80, -146}, {-62, -146}}, color = {0, 0, 127}));
  connect(pOrderFilter.y, pOrdLimit.u) annotation(
    Line(points = {{201, 180}, {218, 180}}, color = {0, 0, 127}));
  connect(pOrdLimit.y, firstOrder.u) annotation(
    Line(points = {{241, 180}, {260, 180}, {260, 100}, {-18, 100}}, color = {0, 0, 127}));
  connect(pOrdLimit.y, division.u1) annotation(
    Line(points = {{241, 180}, {260, 180}, {260, 100}, {0, 100}, {0, 40}, {-80, 40}, {-80, -14}, {-62, -14}}, color = {0, 0, 127}));
  connect(constant2.y, feedback.u1) annotation(
    Line(points = {{-339, 140}, {-309, 140}}, color = {0, 0, 127}));
  connect(omegaFilter.y, feedback.u2) annotation(
    Line(points = {{-339, 100}, {-300, 100}, {-300, 132}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{-39, -140}, {98, -140}}, color = {0, 0, 127}));
  connect(division1.y, IqCmdFilter.u) annotation(
    Line(points = {{-139, -100}, {-123, -100}}, color = {0, 0, 127}));
  connect(IqCmdFilter.y, add.u1) annotation(
    Line(points = {{-99, -100}, {-80, -100}, {-80, -134}, {-62, -134}}, color = {0, 0, 127}));
  connect(omegaFilter.y, FRT.fMonitoredPu) annotation(
    Line(points = {{-339, 100}, {-262, 100}}, color = {0, 0, 127}));
  connect(PFFlag.y, switch1.u2) annotation(
    Line(points = {{-279, -120}, {-242, -120}}, color = {255, 0, 255}));
  connect(PFaRef, tan.u) annotation(
    Line(points = {{-460, 40}, {-362, 40}}, color = {0, 0, 127}));
  connect(tan.y, product.u2) annotation(
    Line(points = {{-339, 40}, {-325, 40}, {-325, 22}, {-327, 22}}, color = {0, 0, 127}));
  connect(firstOrder.y, product.u1) annotation(
    Line(points = {{-40, 100}, {-100, 100}, {-100, 40}, {-314, 40}, {-314, 22}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-320, -1}, {-320, -80}, {-260, -80}, {-260, -112}, {-242, -112}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-460, 100}, {-422, 100}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, omegaFilter.u) annotation(
    Line(points = {{-378, 122}, {-370, 122}, {-370, 100}, {-362, 100}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-440, -220}, {440, 220}}), graphics),
    Icon(graphics = {Text(origin = {-24, 11}, extent = {{-48, 27}, {98, -53}}, textString = "der_a")}));
end BaseDERa;
