within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard;

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

model Scl2c "IEEE (2016) stator current limiter type SCL2C model"

  //Regulation parameters
  parameter Types.PerUnit C1 "SCL exponent for calculation of first error";
  parameter Types.PerUnit C2 "SCL exponent for calculation of second error";
  parameter Types.PerUnit FixedRd "SCL fixed cooling-down time output";
  parameter Types.PerUnit FixedRu "SCL fixed delay time output";
  parameter Types.CurrentModulePu IInstPu "SCL instantaneous stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IInstUelPu "Underexcited region instantaneous stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu ILimPu "SCL thermal stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IqOelMinPu "SCL OEL minimum reactive current reference value in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IqUelMaxPu "SCL UEL maximum reactive current reference value in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IResetPu "SCL reset-reference, if inactive, in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu ITfPu "SCL thermal reference for inverse time calculations in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IThOffPu "SCL reset threshold value in pu (base SnRef, UNom)";
  parameter Types.PerUnit K1 "SCL gain for calculation of first error";
  parameter Types.PerUnit K2 "SCL gain for calculation of second error";
  parameter Types.PerUnit KdOel "Overexcited PID regulator differential gain";
  parameter Types.PerUnit KdUel "Underexcited PID regulator differential gain";
  parameter Types.PerUnit KFb "SCL timer feedback gain";
  parameter Types.PerUnit KiOel "Overexcited PID regulator integral gain";
  parameter Types.PerUnit KiUel "Underexcited PID regulator integral gain";
  parameter Types.PerUnit KpOel "Overexcited PID regulator proportional gain";
  parameter Types.PerUnit KPRef "SCL reference scaling factor based on active current";
  parameter Types.PerUnit KpUel "Underexcited PID regulator proportional gain";
  parameter Types.PerUnit KIpOel "Overexcited active current scaling factor";
  parameter Types.PerUnit KIpUel "Underexcited active current scaling factor";
  parameter Types.PerUnit KIqOel "Overexcited reactive current scaling factor";
  parameter Types.PerUnit KIqUel "Underexcited reactive current scaling factor";
  parameter Types.PerUnit Krd "SCL reference ramp-down rate in pu/s (base SnRef, UNom)";
  parameter Types.PerUnit Kru "SCL reference ramp-up rate in pu/s (base SnRef, UNom)";
  parameter Types.PerUnit Kzru "SCL thermal reference release threshold";
  parameter Boolean Sw1 "OEL reference ramp logic selection";
  parameter Types.Time tAScl "SCL reference filter time constant in s";
  parameter Types.Time tB1Oel "Overexcited regulator lag time constant 1 in s";
  parameter Types.Time tB1Uel "Underexcited regulator lag time constant 1 in s";
  parameter Types.Time tB2Oel "Overexcited regulator lag time constant 2 in s";
  parameter Types.Time tB2Uel "Underexcited regulator lag time constant 2 in s";
  parameter Types.Time tC1Oel "Overexcited regulator lead time constant 1 in s";
  parameter Types.Time tC1Uel "Underexcited regulator lead time constant 1 in s";
  parameter Types.Time tC2Oel "Overexcited regulator lead time constant 2 in s";
  parameter Types.Time tC2Uel "Underexcited regulator lead time constant 2 in s";
  parameter Types.Time tDOel "Overexcited PID regulator differential time constant in s";
  parameter Types.Time tDUel "Underexcited PID regulator differential time constant in s";
  parameter Types.Time tEnOel "Overexcited activation delay time in s";
  parameter Types.Time tEnUel "Underexcited activation delay time in s";
  parameter Types.Time tIpOel "Overexcited active current time constant in s";
  parameter Types.Time tIpUel "Underexcited active current time constant in s";
  parameter Types.Time tIqOel "Overexcited reactive current time constant in s";
  parameter Types.Time tIqUel "Underexcited reactive current time constant in s";
  parameter Types.Time tItScl "Stator current transducer time constant in s";
  parameter Types.Time tMax "SCL timer maximum level in s";
  parameter Types.Time tMin "SCL timer minimum level in s";
  parameter Types.Time tOff "SCL reset delay time in s";
  parameter Types.Time tScl "SCL timer reference in s";
  parameter Types.Time tVtScl "Terminal voltage transducer time constant in s";
  parameter Types.PerUnit VInvMaxPu "SCL maximum inverse time output";
  parameter Types.PerUnit VInvMinPu "SCL minimum inverse time output";
  parameter Types.VoltageModulePu VOel1MaxPu "Maximum OEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel1MinPu "Minimum OEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MaxPu "Maximum OEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MinPu "Minimum OEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel3MaxPu "Maximum OEL PID output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel3MinPu "Minimum OEL PID output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VtMinPu "SCL OEL minimum voltage reference value in pu (base UNom)";
  parameter Types.VoltageModulePu VtResetPu "SCL OEL voltage reset value in pu (base UNom)";
  parameter Types.VoltageModulePu VUel1MaxPu "Maximum UEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VUel1MinPu "Minimum UEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VUel2MaxPu "Maximum UEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VUel2MinPu "Minimum UEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VUel3MaxPu "Maximum UEL PID output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VUel3MinPu "Minimum UEL PID output limit in pu (base UNom)";

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput itPu(re(start = it0Pu.re), im(start = it0Pu.im)) "Complex stator current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, -146}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Active power generated by the synchronous machine in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-140, 20}, {-100, 60}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QGenPu(start = QGen0Pu) "Reactive power generated by the synchronous machine in pu (base SnRef) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-420, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(extent = {{-140, -20}, {-100, 20}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput utPu(re(start = ut0Pu.re), im(start = ut0Pu.im)) "Complex stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-420, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput USclOelPu(start = 0) "Stator current overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {390, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {160, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput USclUelPu(start = 0) "Stator current underexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {390, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.Complex.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-370, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag(YMax = VUel2MaxPu, YMin = VUel2MinPu, t1 = tC2Uel, t2 = tB2Uel) annotation(
    Placement(visible = true, transformation(origin = {310, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag1(YMax = VUel1MaxPu, YMin = VUel1MinPu, t1 = tC1Uel, t2 = tB1Uel) annotation(
    Placement(visible = true, transformation(origin = {350, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-310, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(visible = true, transformation(origin = {-310, -20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tIpUel, k = KIpUel, y_start = KIpUel * PGen0Pu / Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tIpOel, k = KIpOel, y_start = KIpOel * PGen0Pu / Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tIqOel, k = KIqOel, y_start = KIqOel * QGen0Pu / Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tIqUel, k = KIqUel, y_start = KIqUel * QGen0Pu / Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Pythagoras pythagoras annotation(
    Placement(visible = true, transformation(origin = {-170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Pythagoras pythagoras1 annotation(
    Placement(visible = true, transformation(origin = {-170, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = IqUelMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-230, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = IqOelMinPu) annotation(
    Placement(visible = true, transformation(origin = {-230, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {170, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add31(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {170, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min min1 annotation(
    Placement(visible = true, transformation(origin = {230, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax max1(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {230, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tVtScl, y_start = Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = VtMinPu) annotation(
    Placement(visible = true, transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pidUel(Nd = 1, Td = tDUel, Ti = 1 / KiUel, wd = KdUel / tDUel, wp = KpUel, yMax = VUel3MaxPu, yMin = VUel3MinPu) annotation(
    Placement(visible = true, transformation(origin = {270, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pidOel(Nd = 1, Td = tDOel, Ti = 1 / KiOel, wd = KdOel / tDOel, wp = KpOel, yMax = VOel3MaxPu, yMin = VOel3MinPu) annotation(
    Placement(visible = true, transformation(origin = {270, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag2(YMax = VOel2MaxPu, YMin = VOel2MinPu, t1 = tC2Oel, t2 = tB2Oel) annotation(
    Placement(visible = true, transformation(origin = {310, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag3(YMax = VOel1MaxPu, YMin = VOel1MinPu, t1 = tC1Oel, t2 = tB1Oel) annotation(
    Placement(visible = true, transformation(origin = {350, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Complex.ComplexToPolar complexToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-370, -146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder5(T = tItScl, y_start = Modelica.ComplexMath.'abs'(it0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses.SclReferenceCurrent sclReferenceCurrent(
    C1 = C1,
    C2 = C2,
    FixedRd = FixedRd,
    FixedRu = FixedRu,
    I0Pu = Modelica.ComplexMath.'abs'(it0Pu),
    IInstPu = IInstPu,
    ILimPu = ILimPu,
    IRef0Pu = IRef0Pu,
    ITfPu = ITfPu,
    K1 = K1,
    K2 = K2,
    KFb = KFb,
    KPRef = KPRef,
    Krd = Krd,
    Kru = Kru,
    Kzru = Kzru,
    Sw1 = Sw1,
    VInvMaxPu = VInvMaxPu,
    VInvMinPu = VInvMinPu,
    Vt0Pu = Modelica.ComplexMath.'abs'(ut0Pu),
    VtResetPu = VtResetPu,
    tErr0 = tErr0,
    tInt0 = tInt0,
    tScl = tScl,
    tMax = tMax,
    tMin = tMin) annotation(
    Placement(visible = true, transformation(origin = {-100, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder6(T = tIpOel, k = KPRef, y_start = KPRef * PGen0Pu / Modelica.ComplexMath.'abs'(ut0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-230, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder7(T = tAScl, y_start = IRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-30, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = IInstUelPu, uMin = -999) annotation(
    Placement(visible = true, transformation(origin = {30, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses.SclUelActivation sclUelActivation(
    IInstUelPu = IInstUelPu,
    IResetPu = IResetPu,
    IThOffPu = IThOffPu,
    IUelRef0Pu = IRef0Pu,
    tEnUel = tEnUel,
    tErr0 = tErr0,
    tOff = tOff) annotation(
    Placement(visible = true, transformation(origin = {100, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses.SclOelActivation sclOelActivation(
    IInstPu = IInstPu,
    IOelRef0Pu = IRef0Pu,
    IResetPu = IResetPu,
    IThOffPu = IThOffPu,
    Vt0Pu = Modelica.ComplexMath.'abs'(ut0Pu),
    VtMinPu = VtMinPu,
    VtResetPu = VtResetPu,
    tEnOel = tEnOel,
    tErr0 = tErr0,
    tOff = tOff) annotation(
    Placement(visible = true, transformation(origin = {100, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu it0Pu "Initial complex stator current in pu (base SnRef, UNom)";
  parameter Types.ActivePowerPu PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";
  parameter Types.ComplexVoltagePu ut0Pu "Initial complex stator voltage in pu (base UNom)";

  final parameter Types.CurrentModulePu IRef0Pu = sqrt((PGen0Pu ^ 2 + QGen0Pu ^ 2) / (Modelica.ComplexMath.'abs'(ut0Pu) ^ 2)) "Initial reference current in pu (base SnRef, UNom)";
  final parameter Types.CurrentModulePu IScaled0Pu = Modelica.ComplexMath.'abs'(it0Pu) / ITfPu "Initial scaled current in pu (base SnRef, UNom)";
  final parameter Types.Time tErr0 = tScl - tInt0 "Initial SCL timer error in s";
  final parameter Types.Time tInt0 = (K2 * (IScaled0Pu ^ C2 - 1) + (if IScaled0Pu <= 1 then FixedRu else FixedRd)) / KFb "Initial SCL timer output in s";

equation
  pidOel.u_m = 0;
  pidUel.u_m = 0;

  connect(utPu, complexToPolar.u) annotation(
    Line(points = {{-420, 20}, {-382, 20}}, color = {85, 170, 255}));
  connect(limitedLeadLag.y, limitedLeadLag1.u) annotation(
    Line(points = {{321, 100}, {337, 100}}, color = {0, 0, 127}));
  connect(PGenPu, division.u1) annotation(
    Line(points = {{-420, 80}, {-340, 80}, {-340, 66}, {-322, 66}}, color = {0, 0, 127}));
  connect(complexToPolar.len, division.u2) annotation(
    Line(points = {{-358, 26}, {-340, 26}, {-340, 54}, {-322, 54}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(complexToPolar.len, division1.u2) annotation(
    Line(points = {{-358, 26}, {-340, 26}, {-340, -14}, {-322, -14}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(QGenPu, division1.u1) annotation(
    Line(points = {{-420, -40}, {-340, -40}, {-340, -26}, {-322, -26}}, color = {0, 0, 127}));
  connect(division.y, firstOrder.u) annotation(
    Line(points = {{-299, 60}, {-280, 60}, {-280, 140}, {-242, 140}}, color = {0, 0, 127}));
  connect(division.y, firstOrder1.u) annotation(
    Line(points = {{-299, 60}, {-280, 60}, {-280, -100}, {-242, -100}}, color = {0, 0, 127}));
  connect(division1.y, firstOrder3.u) annotation(
    Line(points = {{-299, -20}, {-260, -20}, {-260, 100}, {-242, 100}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(division1.y, firstOrder2.u) annotation(
    Line(points = {{-299, -20}, {-260, -20}, {-260, -60}, {-242, -60}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder.y, pythagoras.u1) annotation(
    Line(points = {{-219, 140}, {-200, 140}, {-200, 126}, {-182, 126}}, color = {0, 0, 127}));
  connect(firstOrder3.y, pythagoras.u2) annotation(
    Line(points = {{-219, 100}, {-200, 100}, {-200, 114}, {-182, 114}}, color = {0, 0, 127}));
  connect(firstOrder2.y, pythagoras1.u1) annotation(
    Line(points = {{-219, -60}, {-200, -60}, {-200, -74}, {-182, -74}}, color = {0, 0, 127}));
  connect(firstOrder1.y, pythagoras1.u2) annotation(
    Line(points = {{-219, -100}, {-200, -100}, {-200, -86}, {-182, -86}}, color = {0, 0, 127}));
  connect(firstOrder3.y, add.u1) annotation(
    Line(points = {{-219, 100}, {-200, 100}, {-200, 86}, {-182, 86}}, color = {0, 0, 127}));
  connect(const.y, add.u2) annotation(
    Line(points = {{-219, 60}, {-200, 60}, {-200, 74}, {-183, 74}}, color = {0, 0, 127}));
  connect(const1.y, add1.u1) annotation(
    Line(points = {{-219, -20}, {-200, -20}, {-200, -34}, {-182, -34}}, color = {0, 0, 127}));
  connect(firstOrder2.y, add1.u2) annotation(
    Line(points = {{-219, -60}, {-200, -60}, {-200, -46}, {-182, -46}}, color = {0, 0, 127}));
  connect(add3.y, min1.u1) annotation(
    Line(points = {{181, 120}, {200, 120}, {200, 106}, {218, 106}}, color = {0, 0, 127}));
  connect(add.y, min1.u2) annotation(
    Line(points = {{-159, 80}, {200, 80}, {200, 94}, {218, 94}}, color = {0, 0, 127}));
  connect(pythagoras1.y, add31.u2) annotation(
    Line(points = {{-159, -80}, {20, -80}, {20, -120}, {158, -120}}, color = {0, 0, 127}));
  connect(pythagoras.y, add3.u2) annotation(
    Line(points = {{-159, 120}, {158, 120}}, color = {0, 0, 127}));
  connect(add1.y, max1.u[1]) annotation(
    Line(points = {{-159, -40}, {200, -40}, {200, -46}, {220, -46}}, color = {0, 0, 127}));
  connect(add31.y, max1.u[2]) annotation(
    Line(points = {{181, -120}, {200, -120}, {200, -46}, {220, -46}}, color = {0, 0, 127}));
  connect(firstOrder4.y, add2.u2) annotation(
    Line(points = {{-219, 20}, {140, 20}, {140, 34}, {157, 34}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(const2.y, add2.u1) annotation(
    Line(points = {{121, 60}, {140, 60}, {140, 46}, {158, 46}}, color = {0, 0, 127}));
  connect(add2.y, max1.u[3]) annotation(
    Line(points = {{181, 40}, {200, 40}, {200, -46}, {220, -46}}, color = {0, 0, 127}));
  connect(complexToPolar.len, firstOrder4.u) annotation(
    Line(points = {{-358, 26}, {-340, 26}, {-340, 20}, {-242, 20}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(min1.y, pidUel.u_s) annotation(
    Line(points = {{241, 100}, {257, 100}}, color = {0, 0, 127}));
  connect(max1.yMax, pidOel.u_s) annotation(
    Line(points = {{241, -40}, {258, -40}}, color = {0, 0, 127}));
  connect(pidUel.y, limitedLeadLag.u) annotation(
    Line(points = {{281, 100}, {297, 100}}, color = {0, 0, 127}));
  connect(limitedLeadLag2.y, limitedLeadLag3.u) annotation(
    Line(points = {{321, -40}, {338, -40}}, color = {0, 0, 127}));
  connect(itPu, complexToPolar1.u) annotation(
    Line(points = {{-420, -146}, {-382, -146}}, color = {85, 170, 255}));
  connect(complexToPolar1.len, firstOrder5.u) annotation(
    Line(points = {{-358, -140}, {-242, -140}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pidOel.y, limitedLeadLag2.u) annotation(
    Line(points = {{281, -40}, {298, -40}}, color = {0, 0, 127}));
  connect(firstOrder5.y, sclReferenceCurrent.IPu) annotation(
    Line(points = {{-219, -140}, {-124, -140}}, color = {0, 0, 127}));
  connect(firstOrder7.y, add31.u3) annotation(
    Line(points = {{-19, -140}, {140, -140}, {140, -128}, {158, -128}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(firstOrder7.y, limiter.u) annotation(
    Line(points = {{-19, -140}, {0, -140}, {0, 100}, {18, 100}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(limiter.y, add3.u3) annotation(
    Line(points = {{41, 100}, {60, 100}, {60, 112}, {158, 112}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(division.y, firstOrder6.u) annotation(
    Line(points = {{-299, 60}, {-280, 60}, {-280, -180}, {-242, -180}}, color = {0, 0, 127}));
  connect(sclUelActivation.IUelBiasPu, add3.u1) annotation(
    Line(points = {{122, 160}, {140, 160}, {140, 128}, {158, 128}}, color = {0, 0, 127}));
  connect(limiter.y, sclUelActivation.IUelRefPu) annotation(
    Line(points = {{41, 100}, {60, 100}, {60, 144}, {76, 144}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(pythagoras.y, sclUelActivation.IUelActPu) annotation(
    Line(points = {{-159, 120}, {20, 120}, {20, 176}, {76, 176}}, color = {0, 0, 127}));
  connect(sclReferenceCurrent.tErr, sclUelActivation.tErr) annotation(
    Line(points = {{-78, -128}, {-60, -128}, {-60, 160}, {76, 160}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(sclReferenceCurrent.tErr, sclOelActivation.tErr) annotation(
    Line(points = {{-78, -128}, {-60, -128}, {-60, -100}, {40, -100}, {40, -80}, {76, -80}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(firstOrder4.y, sclReferenceCurrent.VtFiltPu) annotation(
    Line(points = {{-219, 20}, {-140, 20}, {-140, -124}, {-124, -124}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(firstOrder6.y, sclReferenceCurrent.IPRefPu) annotation(
    Line(points = {{-219, -180}, {-140, -180}, {-140, -156}, {-124, -156}}, color = {0, 0, 127}));
  connect(pythagoras1.y, sclOelActivation.IOelActPu) annotation(
    Line(points = {{-159, -80}, {20, -80}, {20, -64}, {75, -64}}, color = {0, 0, 127}));
  connect(firstOrder7.y, sclOelActivation.IOelRefPu) annotation(
    Line(points = {{-19, -140}, {60, -140}, {60, -96}, {76, -96}}, color = {0, 0, 127}, pattern = LinePattern.Dash));
  connect(sclOelActivation.IOelBiasPu, add31.u1) annotation(
    Line(points = {{122, -80}, {140, -80}, {140, -112}, {158, -112}}, color = {0, 0, 127}));
  connect(firstOrder4.y, sclOelActivation.VtFiltPu) annotation(
    Line(points = {{-219, 20}, {140, 20}, {140, -64}, {124, -64}}, color = {0, 0, 127}, pattern = LinePattern.DashDot));
  connect(sclReferenceCurrent.IRefPu, firstOrder7.u) annotation(
    Line(points = {{-78, -140}, {-42, -140}}, color = {0, 0, 127}));
  connect(limitedLeadLag1.y, USclUelPu) annotation(
    Line(points = {{361, 100}, {389, 100}}, color = {0, 0, 127}));
  connect(limitedLeadLag3.y, USclOelPu) annotation(
    Line(points = {{361, -40}, {389, -40}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -200}, {380, 180}})));
end Scl2c;
