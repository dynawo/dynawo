within Dynawo.Electrical.Controls.IEC.IEC63406.Measurement;

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

model GridMeasurement
  extends Dynawo.Electrical.Controls.IEC.BaseClasses.BaseMeasurements;

  //PLL parameters
  parameter Integer PLLFlag "0 for the case when the phase angle can be read from the calculation result of the simulation program, 1 for the case of adding a filter based on case 1, 2 for the case where the dynamics of the PLL need to be considered" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TpllFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time TfFilt "Time constant in PLL angle filter. Put 0 if no filter for the PLL (PLLFlag=2 in the norm)" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Time DeltaT "Integral time step" annotation(
    Dialog(tab = "PLL"));
  parameter Types.Frequency fref "Rated frequency (50/60 Hz)" annotation(
    Dialog(tab = "PLL"));
  parameter Real KPpll "Proportional gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Real KIpll "Integral gain in PI controller" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit UpllPu "Voltage below which the frequency of the voltage is filtered and the angle of the voltage is possibly frozen" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocity Wref = 2 * Modelica.Constants.pi * fref "Rated angular velocity" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMaxPu "Maximum PLL frequency deviation" annotation(
    Dialog(tab = "PLL"));
  parameter Types.PerUnit WMinPu "Minimum PLL frequency deviation" annotation(
    Dialog(tab = "PLL"));
  parameter Types.AngularVelocityPu DfMaxPu "Maximum angle rotation ramp rate in rad/s" annotation(
    Dialog(tab = "PLL"));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput thetaPLL(start=UPhase0) "Phase angle outputted by phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput fFiltPu(start=fInitPu) "Measured frequency outputted by the phase-locked loop" annotation(
    Placement(visible = true, transformation(origin = {150, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.PerUnit fInitPu "Initial frequency" annotation(
      Dialog(tab = "Operating point"));
  PLL pll(DeltaT = DeltaT, DfMaxPu = DfMaxPu, KIpll = KIpll, KPpll = KPpll, PLLFlag = PLLFlag, TfFilt = TfFilt, TpllFilt = TpllFilt, UPhase0 = UPhase0, UpllPu = UpllPu, WMaxPu = WMaxPu, WMinPu = WMinPu, fInitPu = fInitPu, fref = fref, tS = tS, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {3.55271e-15, -100}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
equation
  connect(uPu, pll.uPu) annotation(
    Line(points = {{-160, 0}, {-100, 0}, {-100, -100}, {-48, -100}}, color = {85, 170, 255}));
  connect(pll.thetaPLL, thetaPLL) annotation(
    Line(points = {{44, -80}, {150, -80}}, color = {0, 0, 127}));
  connect(pll.fMeasPu, fFiltPu) annotation(
    Line(points = {{44, -120}, {150, -120}}, color = {0, 0, 127}));
end GridMeasurement;
