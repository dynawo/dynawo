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

model Oel2c "IEEE (2016) overexcitation limiter type OEL2C model"

  //Regulation parameters
  parameter Types.PerUnit C1 "OEL exponent for calculation of first error";
  parameter Types.PerUnit C2 "OEL exponent for calculation of second error";
  parameter Types.PerUnit FixedRd "OEL fixed cooling-down time output";
  parameter Types.PerUnit FixedRu "OEL fixed delay time output";
  parameter Types.CurrentModulePu IInstPu "OEL instantaneous field current limit";
  parameter Types.CurrentModulePu ILimPu "OEL thermal field current limit";
  parameter Types.CurrentModulePu IResetPu "OEL reset-reference, if OEL is inactive";
  parameter Types.CurrentModulePu ITfPu "OEL reference for inverse time calculations";
  parameter Types.CurrentModulePu IThOffPu "OEL reset threshold value";
  parameter Types.PerUnit K1 "OEL gain for calculation of first error";
  parameter Types.PerUnit K2 "OEL gain for calculation of second error";
  parameter Types.PerUnit KAct "OEL actual value scaling factor";
  parameter Types.PerUnit KdOel "OEL PID regulator differential gain";
  parameter Types.PerUnit KFb "OEL timer feedback gain";
  parameter Types.PerUnit KiOel "OEL PID regulator integral gain";
  parameter Types.PerUnit KpOel "OEL PID regulator proportional gain";
  parameter Types.PerUnit Krd "OEL reference ramp-down rate";
  parameter Types.PerUnit Kru "OEL reference ramp-up rate";
  parameter Types.PerUnit KScale "OEL input signal scaling factor";
  parameter Types.PerUnit Kzru "OEL thermal reference release threshold";
  parameter Boolean Sw1 "If true, ramp rate depends on field current error, if false, ramp rates are fixed";
  parameter Types.Time tAOel "OEL reference filter time constant in s";
  parameter Types.Time tB1Oel "OEL regulator first lag time constant in s";
  parameter Types.Time tB2Oel "OEL regulator second lag time constant in s";
  parameter Types.Time tC1Oel "OEL regulator first lead time constant in s";
  parameter Types.Time tC2Oel "OEL regulator second lead time constant in s";
  parameter Types.Time tDOel "OEL PID regulator differential time constant in s";
  parameter Types.Time tEn "OEL activation delay time in s";
  parameter Types.Time tFcl "OEL timer reference in s";
  parameter Types.Time tMax "OEL timer maximum level in s";
  parameter Types.Time tMin "OEL timer minimum level in s";
  parameter Types.Time tOff "OEL reset delay time in s";
  parameter Types.Time tROel "OEL input signal filter time constant in s";
  parameter Types.PerUnit VInvMaxPu "OEL maximum inverse time output";
  parameter Types.PerUnit VInvMinPu "OEL minimum inverse time output";
  parameter Types.VoltageModulePu VOel1MaxPu "Maximum OEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel1MinPu "Minimum OEL output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MaxPu "Maximum OEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel2MinPu "Minimum OEL lead-lag 1 output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel3MaxPu "Maximum OEL PID output limit in pu (base UNom)";
  parameter Types.VoltageModulePu VOel3MinPu "Minimum OEL PID output limit in pu (base UNom)";

  //Input variable
  Modelica.Blocks.Interfaces.RealInput inputPu(start = Input0Pu) "Input signal" annotation(
    Placement(visible = true, transformation(origin = {-220, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput UOelPu(start = 0) "Overexcitation limitation output voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tROel, k = KScale, y_start = I0Pu) annotation(
    Placement(visible = true, transformation(origin = {-170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tAOel, y_start = IRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag(YMax = VOel2MaxPu, YMin = VOel2MinPu, t1 = tC2Oel, t2 = tB2Oel) annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedLeadLag limitedLeadLag1(YMax = VOel1MaxPu, YMin = VOel1MinPu, t1 = tC1Oel, t2 = tB1Oel) annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = KAct) annotation(
    Placement(visible = true, transformation(origin = {-90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard.BaseClasses.OelActivation oelActivation(
    IInstPu = IInstPu,
    IRef0Pu = IRef0Pu,
    IResetPu = IResetPu,
    IThOffPu = IThOffPu,
    tEn = tEn,
    tErr0 = tErr0,
    tOff = tOff) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimPID pid(Nd = 1, Td = tDOel, Ti = 1 / KiOel, wd = KdOel / tDOel, wp = KpOel, yMax = VOel3MaxPu, yMin = VOel3MinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.OverExcitationLimiters.Standard.BaseClasses.OelReferenceCurrent oelReferenceCurrent(
    C1 = C1,
    C2 = C2,
    FixedRd = FixedRd,
    FixedRu = FixedRu,
    I0Pu = I0Pu,
    IInstPu = IInstPu,
    ILimPu = ILimPu,
    IRef0Pu = IRef0Pu,
    ITfPu = ITfPu,
    K1 = K1,
    K2 = K2,
    KFb = KFb,
    Krd = Krd,
    Kru = Kru,
    Kzru = Kzru,
    Sw1 = Sw1,
    VInvMaxPu = VInvMaxPu,
    VInvMinPu = VInvMinPu,
    tErr0 = tErr0,
    tFcl = tFcl,
    tInt0 = tInt0,
    tMax = tMax,
    tMin = tMin) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameter
  parameter Types.PerUnit Input0Pu "Initial input signal";

  final parameter Types.CurrentModulePu I0Pu = KScale * Input0Pu "Initial input current in pu";
  final parameter Types.CurrentModulePu IRef0Pu = KAct * I0Pu "Initial reference current in pu";
  final parameter Types.CurrentModulePu IScaled0Pu = I0Pu / ITfPu "Initial scaled current in pu";
  final parameter Types.Time tErr0 = tFcl - tInt0 "Initial OEL timer error in s";
  final parameter Types.Time tInt0 = (K2 * (IScaled0Pu ^ C2 - 1) + (if IScaled0Pu <= 1 then FixedRu else FixedRd)) / KFb "Initial OEL timer output in s";

equation
  pid.u_m = 0;

  connect(inputPu, firstOrder.u) annotation(
    Line(points = {{-220, 0}, {-182, 0}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add3.u3) annotation(
    Line(points = {{1, -60}, {20, -60}, {20, -8}, {38, -8}}, color = {0, 0, 127}));
  connect(firstOrder.y, gain4.u) annotation(
    Line(points = {{-159, 0}, {-140, 0}, {-140, 80}, {-102, 80}}, color = {0, 0, 127}));
  connect(gain4.y, add3.u1) annotation(
    Line(points = {{-79, 80}, {20, 80}, {20, 8}, {38, 8}}, color = {0, 0, 127}));
  connect(limitedLeadLag.y, limitedLeadLag1.u) annotation(
    Line(points = {{141, 0}, {158, 0}}, color = {0, 0, 127}));
  connect(limitedLeadLag1.y, UOelPu) annotation(
    Line(points = {{181, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(gain4.y, oelActivation.IActPu) annotation(
    Line(points = {{-79, 80}, {-60, 80}, {-60, 16}, {-44, 16}}, color = {0, 0, 127}));
  connect(oelActivation.IBiasPu, add3.u2) annotation(
    Line(points = {{2, 0}, {38, 0}}, color = {0, 0, 127}));
  connect(add3.y, pid.u_s) annotation(
    Line(points = {{61, 0}, {78, 0}}, color = {0, 0, 127}));
  connect(pid.y, limitedLeadLag.u) annotation(
    Line(points = {{101, 0}, {118, 0}}, color = {0, 0, 127}));
  connect(firstOrder.y, oelReferenceCurrent.IPu) annotation(
    Line(points = {{-158, 0}, {-124, 0}}, color = {0, 0, 127}));
  connect(oelReferenceCurrent.tErr, oelActivation.tErr) annotation(
    Line(points = {{-78, 0}, {-44, 0}}, color = {0, 0, 127}));
  connect(oelReferenceCurrent.IRefPu, oelActivation.IRefPu) annotation(
    Line(points = {{-78, -16}, {-44, -16}}, color = {0, 0, 127}));
  connect(oelReferenceCurrent.IRefPu, firstOrder1.u) annotation(
    Line(points = {{-78, -16}, {-60, -16}, {-60, -60}, {-22, -60}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})));
end Oel2c;
