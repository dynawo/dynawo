within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a;

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

model base_der_a "Base model for der_a"
  // Injector
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the injector (in MVA)";
  parameter Types.CurrentModulePu IMaxPu "Maximum current of the injector in pu (base UNom, SNom)";
  parameter Boolean PPriority "If true, prioritise active power over reactive power";
  parameter Real PLL_Kp = 3 "PLL proportional coefficient";
  parameter Real PLL_Ki = 10 "PLL integral coefficient";

  // Filters
  parameter Types.Time tFilterU "Voltage measurement first order time constant in s";
  parameter Types.Time tFilterOmega "First order time constant for the frequency estimation in s";
  parameter Types.Time tRateLim = 1e-3 "Current slew limiter delay in s";
  parameter Types.Time tP "P measurement first order time constant in s";
  parameter Types.Time tG "Output current time constant in s";
  parameter Types.Time tPord "Active power time constant in s";
  parameter Types.Time tIq "Reactive current time constant in s";

  // Frequency support
  parameter Types.AngularVelocityPu fDeadZoneMaxPu "Upper value of frequency dead zone in pu (base omegaNom)";
  parameter Types.AngularVelocityPu fDeadZoneMinPu "Lower value of frequency dead zone in pu (base omegaNom)";
  parameter Real DdnPu "Power reduction factor for over-frequency in pu (base SNom)";
  parameter Real DupPu "Power increase factor for under-frequency in pu (base SNom)";
  parameter Types.AngularVelocityPu feMaxPu "Maximum frequency error correction in pu (base omegaNom)";
  parameter Types.AngularVelocityPu feMinPu "Minimum frequency error correction in pu (base omegaNom)";
  parameter Real Kpg "PI proportional coefficient of frequency support in pu (base SNom, omegaNom)";
  parameter Real Kig "PI integral coefficient of frequency support in pu (base SNom, omegaNom)";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SNom)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SNom)";
  parameter Types.PerUnit DPMaxPu "Maximum active power rise rate in pu (base SNom)";
  parameter Types.PerUnit DPMinPu "Minimum active power drop rate in pu (base SNom)";
  parameter Boolean Freq_flag "True if inverters support frequency";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMinPu "Minimum frequency before start of disconnections in pu (base omegaNom)";
  parameter Types.Time tOmegaMaxPu "Time-lag for over-frequency trips in s";
  parameter Types.Time tOmegaMinPu "Time-lag for under-frequency trips in s";
  parameter Types.CurrentModulePu IpRateLimMax "Maximum rise rate of the active current in pu (base SNom)";
  parameter Types.CurrentModulePu IpRateLimMin "Minimum drop rate of the active current in pu (base SNom)";

  // Voltage support
  parameter Boolean PF_flag "True for constant power factor, false for constant reactive power";
  parameter Types.VoltageModulePu VRefPu = 1 "Voltage reference in pu (base UNom)";
  parameter Types.VoltageModulePu VDeadzoneMaxPu "Upper value of voltage dead zone in pu (base UNom)";
  parameter Types.VoltageModulePu VDeadzoneMinPu "Lower value of voltage dead zone in pu (base UNom)";
  parameter Real KQsupportPu "Proportional coefficient of reactive support in pu (base SNom, UNom)";
  parameter Types.CurrentModulePu iQSupportMaxPu "Maximum reactive support current command (base SNom, UNom)";
  parameter Types.CurrentModulePu iQSupportMinPu "Maximum reactive support current command (base SNom, UNom)";

  // Initial values
  parameter Types.PerUnit P0Pu "Start value of active power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit Q0Pu "Start value of reactive power at terminal in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at terminal in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage phase angle at terminal in rad";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit Id0Pu "Start value of d-axs current at injector in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base UNom, SNom) (generator convention)";

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = -P0Pu*SystemBase.SnRef/SNom) "Available power from the DC source in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = -Q0Pu*SystemBase.SnRef/SNom) "Reactive power setpoint in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-232, -262}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {160, -336}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -102}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Types.PerUnit partialTrippingRatio(start = 1) "Coefficient for partial tripping of generators, equals 1 if no trips, 0 if all units are tripped";

  Dynawo.Electrical.Sources.InjectorIDQ injector(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UPhase0 = UPhase0, i0Pu = i0Pu, s0Pu = s0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {250, -220}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {310, -212}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {100, 8.88178e-16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UFilter(T = tFilterU, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-150, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {-190, -220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-216, -226}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-70, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder iQcmdFirstOrder(T = tG, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {150, -276}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder omegaFilter(T = tFilterOmega, y_start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-290, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(
    Placement(visible = true, transformation(origin = {190, -276}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IpPartialTripping annotation(
    Placement(visible = true, transformation(origin = {110, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product IqPartialTripping annotation(
    Placement(visible = true, transformation(origin = {110, -276}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping1(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {70, -144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression PartialTripping2(y = partialTrippingRatio) annotation(
    Placement(visible = true, transformation(origin = {70, -296}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter annotation(
    Placement(visible = true, transformation(origin = {57, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter1 annotation(
    Placement(visible = true, transformation(origin = {57, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = 0.01, k = 1, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -241}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.CurrentLimitsCalculationPV currentLimitsCalculation1(IMaxPu = IMaxPu, PPriority = PPriority) annotation(
    Placement(visible = true, transformation(origin = {10, -221}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = 0.01, k = 1, y_start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {50, -201}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Controls.PLL.PLL pll(Ki = PLL_Ki, Kp = PLL_Kp, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {210, -330}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression omegaRef(y = omegaRefPu) annotation(
    Placement(visible = true, transformation(origin = {-330, -76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-310, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-260, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter frequencyErrorLimit(limitsAtInit = true, uMax = feMaxPu, uMin = feMinPu) annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindup powerPIAntiWinDupPu(Ki = Kpg, Kp = Kig, Y0 = -P0Pu*SystemBase.SnRef/SNom, YMax = PMaxPu, YMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {70, -32}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze powerRateLimit(T = tPord, UseRateLim = true, Y0 = -P0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {118, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant frequencyFlag(k = Freq_flag) annotation(
    Placement(visible = true, transformation(origin = {50, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant dPmax(k = DPMaxPu) annotation(
    Placement(visible = true, transformation(origin = {86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant dPmin(k = DPMinPu) annotation(
    Placement(visible = true, transformation(origin = {86, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-150, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone frequencyDeadZone(deadZoneAtInit = true, uMax = fDeadZoneMaxPu, uMin = fDeadZoneMinPu) annotation(
    Placement(visible = true, transformation(origin = {-228, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tP, y_start = -P0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {-50, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Vref(k = VRefPu) annotation(
    Placement(visible = true, transformation(origin = {-270, -350}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-230, -350}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone voltageDeadZone(deadZoneAtInit = true, uMax = VDeadzoneMaxPu, uMin = VDeadzoneMinPu) annotation(
    Placement(visible = true, transformation(origin = {-190, -350}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = KQsupportPu) annotation(
    Placement(visible = true, transformation(origin = {-150, -350}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-190, -270}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain pf(k = Q0Pu/P0Pu) annotation(
    Placement(visible = true, transformation(origin = {-244, -278}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder IqCmdFilter(T = tIq, y_start = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze IpRateLimiter(T = tRateLim, UseRateLim = true, Y0 = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IpRateMax(k = IpRateLimMax) annotation(
    Placement(visible = true, transformation(origin = {130, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant IpRateMin(k = IpRateLimMin) annotation(
    Placement(visible = true, transformation(origin = {130, -194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = DdnPu) annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = DupPu) annotation(
    Placement(visible = true, transformation(origin = {-190, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter down(limitsAtInit = true, uMax = 0, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {-150, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter up(limitsAtInit = true, uMax = 999, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder pOrderFilter(T = tPord, y_start = -P0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {154, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter reactiveSupportLimit(limitsAtInit = true, uMax = iQSupportMaxPu, uMin = iQSupportMinPu) annotation(
    Placement(visible = true, transformation(origin = {-110, -350}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter pOrdLimit(limitsAtInit = true, uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(visible = true, transformation(origin = {190, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder pOrderFilterQ(T = tP, y_start = -P0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(visible = true, transformation(origin = {-270, -170}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.InverterBasedGeneration.BaseClasses.der_a.FRT FRT(FhPu = OmegaMaxPu, FlPu = OmegaMinPu, tfh = tOmegaMaxPu, tfl = tOmegaMinPu) annotation(
    Placement(visible = true, transformation(origin = {-370, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant PFflag annotation(
    Placement(visible = true, transformation(origin = {-210, -310}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  connect(injector.terminal, terminal) annotation(
    Line(points = {{261.5, -212}, {310, -212}}, color = {0, 0, 255}));
  connect(UFilter.y, max.u1) annotation(
    Line(points = {{-299, -214}, {-202, -214}}, color = {0, 0, 127}));
  connect(constant1.y, max.u2) annotation(
    Line(points = {{-211.6, -226}, {-201.6, -226}}, color = {0, 0, 127}));
  connect(iQcmdFirstOrder.y, gain.u) annotation(
    Line(points = {{161, -276}, {177, -276}}, color = {0, 0, 127}));
  connect(variableLimiter.y, firstOrder2.u) annotation(
    Line(points = {{68, -270}, {80, -270}, {80, -241}, {62, -241}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, firstOrder3.u) annotation(
    Line(points = {{68, -170}, {80, -170}, {80, -201}, {62, -201}}, color = {0, 0, 127}));
  connect(firstOrder3.y, currentLimitsCalculation1.ipCmdPu) annotation(
    Line(points = {{39, -201}, {30, -201}, {30, -217}, {21, -217}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{-1, -227}, {-20, -227}, {-20, -263}, {44, -263}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{-1, -219}, {-40, -219}, {-40, -163}, {44, -163}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{-1, -223}, {-40, -223}, {-40, -279}, {44, -279}}, color = {0, 0, 127}));
  connect(firstOrder2.y, currentLimitsCalculation1.iqCmdPu) annotation(
    Line(points = {{39, -241}, {30, -241}, {30, -225}, {21, -225}}, color = {0, 0, 127}));
  connect(currentLimitsCalculation1.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{-1, -215}, {-20, -215}, {-20, -179}, {44, -179}}, color = {0, 0, 127}));
  connect(variableLimiter.y, IqPartialTripping.u1) annotation(
    Line(points = {{68, -270}, {98, -270}}, color = {0, 0, 127}));
  connect(PartialTripping2.y, IqPartialTripping.u2) annotation(
    Line(points = {{81, -296}, {87, -296}, {87, -282}, {97, -282}}, color = {0, 0, 127}));
  connect(IqPartialTripping.y, iQcmdFirstOrder.u) annotation(
    Line(points = {{121, -276}, {137, -276}}, color = {0, 0, 127}));
  connect(gain.y, injector.iqPu) annotation(
    Line(points = {{201, -276}, {222, -276}, {222, -216}, {238.5, -216}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, IpPartialTripping.u2) annotation(
    Line(points = {{68, -170}, {98, -170}}, color = {0, 0, 127}));
  connect(PartialTripping1.y, IpPartialTripping.u1) annotation(
    Line(points = {{81, -144}, {87, -144}, {87, -158}, {97, -158}}, color = {0, 0, 127}));
  connect(pll.phi, injector.UPhase) annotation(
    Line(points = {{222, -328}, {250, -328}, {250, -232}}, color = {0, 0, 127}));
  connect(injector.uPu, pll.uPu) annotation(
    Line(points = {{262, -216}, {280, -216}, {280, -360}, {180, -360}, {180, -324}, {200, -324}}, color = {85, 170, 255}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{160, -336}, {200, -336}}, color = {0, 0, 127}));
  connect(frequencyErrorLimit.y, powerPIAntiWinDupPu.u) annotation(
    Line(points = {{1, -40}, {17, -40}}, color = {0, 0, 127}));
  connect(switch.y, powerRateLimit.u) annotation(
    Line(points = {{81, -32}, {106, -32}}, color = {0, 0, 127}));
  connect(frequencyFlag.y, switch.u2) annotation(
    Line(points = {{50, -59}, {50, -33}, {58, -33}}, color = {255, 0, 255}));
  connect(dPmax.y, powerRateLimit.dyMax) annotation(
    Line(points = {{97, 0}, {99, 0}, {99, -26}, {105, -26}}, color = {0, 0, 127}));
  connect(dPmin.y, powerRateLimit.dyMin) annotation(
    Line(points = {{97, -62}, {99, -62}, {99, -38}, {105, -38}}, color = {0, 0, 127}));
  connect(division.y, variableLimiter1.u) annotation(
    Line(points = {{-139, -170}, {46, -170}}, color = {0, 0, 127}));
  connect(feedback.y, frequencyDeadZone.u) annotation(
    Line(points = {{-251, -40}, {-240, -40}}, color = {0, 0, 127}));
  connect(add3.y, frequencyErrorLimit.u) annotation(
    Line(points = {{-39, -40}, {-23, -40}}, color = {0, 0, 127}));
  connect(PRefPu, add3.u1) annotation(
    Line(points = {{-90, 0}, {-70, 0}, {-70, -32}, {-62, -32}}, color = {0, 0, 127}));
  connect(firstOrder.y, add3.u3) annotation(
    Line(points = {{-61, -90}, {-71, -90}, {-71, -48}, {-63, -48}}, color = {0, 0, 127}));
  connect(max.y, division.u2) annotation(
    Line(points = {{-179, -220}, {-170, -220}, {-170, -176}, {-162, -176}}, color = {0, 0, 127}));
  connect(Vref.y, feedback1.u1) annotation(
    Line(points = {{-259, -350}, {-239, -350}}, color = {0, 0, 127}));
  connect(feedback1.y, voltageDeadZone.u) annotation(
    Line(points = {{-221, -350}, {-203, -350}}, color = {0, 0, 127}));
  connect(voltageDeadZone.y, gain1.u) annotation(
    Line(points = {{-179, -350}, {-163, -350}}, color = {0, 0, 127}));
  connect(PRefPu, switch.u3) annotation(
    Line(points = {{-90, 0}, {50, 0}, {50, -24}, {58, -24}}, color = {0, 0, 127}));
  connect(powerPIAntiWinDupPu.y, switch.u1) annotation(
    Line(points = {{41, -40}, {57, -40}}, color = {0, 0, 127}));
  connect(QRefPu, switch1.u3) annotation(
    Line(points = {{-232, -262}, {-202, -262}}, color = {0, 0, 127}));
  connect(pf.y, switch1.u1) annotation(
    Line(points = {{-233, -278}, {-203, -278}}, color = {0, 0, 127}));
  connect(max.y, division1.u2) annotation(
    Line(points = {{-179, -220}, {-170, -220}, {-170, -276}, {-162, -276}}, color = {0, 0, 127}));
  connect(switch1.y, division1.u1) annotation(
    Line(points = {{-178, -270}, {-176, -270}, {-176, -264}, {-162, -264}}, color = {0, 0, 127}));
  connect(UFilter.y, feedback1.u2) annotation(
    Line(points = {{-298, -214}, {-290, -214}, {-290, -380}, {-230, -380}, {-230, -358}}, color = {0, 0, 127}));
  connect(injector.UPu, UFilter.u) annotation(
    Line(points = {{262, -228}, {270, -228}, {270, -400}, {-340, -400}, {-340, -214}, {-322, -214}}, color = {0, 0, 127}));
  connect(IpPartialTripping.y, IpRateLimiter.u) annotation(
    Line(points = {{122, -164}, {158, -164}}, color = {0, 0, 127}));
  connect(IpRateLimiter.y, injector.idPu) annotation(
    Line(points = {{181, -164}, {224, -164}, {224, -226}, {238, -226}}, color = {0, 0, 127}));
  connect(IpRateMax.y, IpRateLimiter.dyMax) annotation(
    Line(points = {{141, -134}, {150, -134}, {150, -158}, {158, -158}}, color = {0, 0, 127}));
  connect(IpRateMin.y, IpRateLimiter.dyMin) annotation(
    Line(points = {{141, -194}, {150, -194}, {150, -170}, {158, -170}}, color = {0, 0, 127}));
  connect(frequencyDeadZone.y, gain3.u) annotation(
    Line(points = {{-216, -40}, {-210, -40}, {-210, -60}, {-202, -60}}, color = {0, 0, 127}));
  connect(frequencyDeadZone.y, gain2.u) annotation(
    Line(points = {{-216, -40}, {-210, -40}, {-210, -20}, {-202, -20}}, color = {0, 0, 127}));
  connect(gain2.y, down.u) annotation(
    Line(points = {{-178, -20}, {-162, -20}}, color = {0, 0, 127}));
  connect(gain3.y, up.u) annotation(
    Line(points = {{-178, -60}, {-162, -60}}, color = {0, 0, 127}));
  connect(down.y, add1.u1) annotation(
    Line(points = {{-138, -20}, {-130, -20}, {-130, -34}, {-122, -34}}, color = {0, 0, 127}));
  connect(up.y, add1.u2) annotation(
    Line(points = {{-138, -60}, {-130, -60}, {-130, -46}, {-122, -46}}, color = {0, 0, 127}));
  connect(add1.y, add3.u2) annotation(
    Line(points = {{-98, -40}, {-62, -40}}, color = {0, 0, 127}));
  connect(powerRateLimit.y, pOrderFilter.u) annotation(
    Line(points = {{129, -32}, {142, -32}}, color = {0, 0, 127}));
  connect(gain1.y, reactiveSupportLimit.u) annotation(
    Line(points = {{-138, -350}, {-122, -350}}, color = {0, 0, 127}));
  connect(reactiveSupportLimit.y, add.u2) annotation(
    Line(points = {{-98, -350}, {-90, -350}, {-90, -276}, {-82, -276}}, color = {0, 0, 127}));
  connect(pOrderFilter.y, pOrdLimit.u) annotation(
    Line(points = {{165, -32}, {178, -32}}, color = {0, 0, 127}));
  connect(pOrdLimit.y, firstOrder.u) annotation(
    Line(points = {{202, -32}, {210, -32}, {210, -90}, {-38, -90}}, color = {0, 0, 127}));
  connect(pOrdLimit.y, division.u1) annotation(
    Line(points = {{202, -32}, {210, -32}, {210, -110}, {-170, -110}, {-170, -164}, {-162, -164}}, color = {0, 0, 127}));
  connect(constant2.y, feedback.u1) annotation(
    Line(points = {{-298, -40}, {-268, -40}}, color = {0, 0, 127}));
  connect(omegaRef.y, omegaFilter.u) annotation(
    Line(points = {{-318, -76}, {-302, -76}}, color = {0, 0, 127}));
  connect(omegaFilter.y, feedback.u2) annotation(
    Line(points = {{-278, -76}, {-260, -76}, {-260, -48}}, color = {0, 0, 127}));
  connect(add.y, variableLimiter.u) annotation(
    Line(points = {{-58, -270}, {46, -270}}, color = {0, 0, 127}));
  connect(division1.y, IqCmdFilter.u) annotation(
    Line(points = {{-139, -270}, {-123, -270}}, color = {0, 0, 127}));
  connect(IqCmdFilter.y, add.u1) annotation(
    Line(points = {{-98, -270}, {-92, -270}, {-92, -264}, {-82, -264}}, color = {0, 0, 127}));
  connect(pOrderFilterQ.y, pf.u) annotation(
    Line(points = {{-270, -180}, {-270, -278}, {-256, -278}}, color = {0, 0, 127}));
  connect(pOrdLimit.y, pOrderFilterQ.u) annotation(
    Line(points = {{202, -32}, {210, -32}, {210, -110}, {-270, -110}, {-270, -158}}, color = {0, 0, 127}));
  connect(omegaFilter.y, FRT.fMonitoredPu) annotation(
    Line(points = {{-278, -76}, {-270, -76}, {-270, -100}, {-340, -100}, {-340, -110}, {-358, -110}}, color = {0, 0, 127}));
  connect(PFflag.y, switch1.u2) annotation(
    Line(points = {{-210, -298}, {-210, -270}, {-202, -270}}, color = {255, 0, 255}));

  annotation(
    Documentation(preferredView = "diagram"),
    Diagram(coordinateSystem(extent = {{-380, 20}, {320, -400}})));
end base_der_a;
