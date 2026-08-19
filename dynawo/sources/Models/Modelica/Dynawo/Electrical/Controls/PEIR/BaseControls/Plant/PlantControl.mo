within Dynawo.Electrical.Controls.PEIR.BaseControls.Plant;

model PlantControl "Generic plant controller"
  /*
      * Copyright (c) 2026, RTE (http://www.rte-france.com)
      * See AUTHORS.txt
      * All rights reserved.
      * This Source Code Form is subject to the terms of the Mozilla Public
      * License, v. 2.0. If a copy of the MPL was not distributed with this
      * file, you can obtain one at http://mozilla.org/MPL/2.0/.
      * SPDX-License-Identifier: MPL-2.0
      *
      * This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
      */
  //Parameters -- SNom
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  //Parameters -- gains
  parameter Types.PerUnit Lambd "Gain for voltage/reactive power regulation";
  parameter Types.PerUnit Kdroop "Gain for frequency/active power regulation";
  //Parameters -- time constants
  parameter Real tQFilt "Time constant for the reactive power filter (in s)";
  parameter Real tPFilt "Time constant for the active power filter (in s)";
  parameter Real tUFilt "Time constant for the voltage filter (in s)";
  //Parameters -- PI gains
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop";
  parameter Types.PerUnit Kiq "PI integral gain - voltage/Q loop";
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop";
  parameter Types.PerUnit Kip "PI integral gain - active power loop";
  //Parameters -- output limits (base SNref, receptor convention, i.e. same base as PI internal signals before final conversion)
  parameter Real QMaxPu "Maximum reactive power reference before base/sign conversion (pu, base SNref)";
  parameter Real QMinPu "Minimum reactive power reference before base/sign conversion (pu, base SNref)";
  parameter Real PMaxPu "Maximum active power reference before base/sign conversion (pu, base SNref)";
  parameter Real PMinPu "Minimum active power reference before base/sign conversion (pu, base SNref)";
  //Parameters -- deadbands and frequency droop limiter
  parameter Real FEMaxPu "Maximum frequency error after droop limiter (pu)";
  parameter Real FEMinPu "Minimum frequency error after droop limiter (pu)";
  parameter Real FDbd1Pu "Frequency deadband lower threshold (pu, positive value)";
  parameter Real FDbd2Pu "Frequency deadband upper threshold (pu, positive value)";
  parameter Real DbdPu "Voltage error deadband half-width (pu)";
  //Initial Parameters
  parameter Types.PerUnit QPcc0Pu "Initial value of reactive power measured at the PCC (receptor convention, base SNref)";
  parameter Types.PerUnit Omega0Pu "Initial reference frequency of the grid (base omegaNom)";
  parameter Types.PerUnit UPcc0Pu "Initial value of the voltage measured at the PCC (base UNom)";
  parameter Types.PerUnit PPcc0Pu "Initial value of active power measured at the PCC (receptor convention, base SNref)";
  final parameter Types.PerUnit PRef0Pu = PPcc0Pu "Initial reference value of active power from the plant controller (receptor convention, base SNref)";
  final parameter Types.PerUnit QRef0Pu = QPcc0Pu "Initial reference value of reactive power from the plant controller (receptor convention, base SNref)";
  final parameter Types.PerUnit URef0Pu = UPcc0Pu + Lambd*QPcc0Pu;
  //Inputs
  Modelica.Blocks.Interfaces.RealInput UPccPu(start = UPcc0Pu) "Voltage at the PCC in p.u. (base UNom)" annotation(
    Placement(transformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-112, -88}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Reference voltage at the PCC in p.u. (base UNom)" annotation(
    Placement(transformation(origin = {-114, -20}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -21}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput QPccPu(start = QPcc0Pu) "Reactive power at the PCC in p.u. (receptor convention, base SNref)" annotation(
    Placement(transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -53}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PPccPu(start = PPcc0Pu) "Active power at the PCC in p.u. (receptor convention, base SNref)" annotation(
    Placement(transformation(origin = {-114, 80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 79}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) annotation(
    Placement(transformation(origin = {-114, 50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 49}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) annotation(
    Placement(transformation(origin = {-114, 6}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 19}, extent = {{-11, -11}, {11, 11}})));
  //Outputs
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu annotation(
    Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu annotation(
    Placement(transformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}})));

  //--- Reactive/voltage path
  Modelica.Blocks.Continuous.FirstOrder firstOrderQ(T = tQFilt, y_start = QPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderU(T = tUFilt, y_start = UPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Lambda(k = Lambd) annotation(
    Placement(visible = true, transformation(origin = {-42, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-12, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {6, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone voltDeadband(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Q PI controller (LimPID: native anti-windup, saturation on total output)
  Modelica.Blocks.Continuous.LimPID piQ(controllerType = Modelica.Blocks.Types.SimpleController.PI,
  k = Kpq, Ti = Kpq/Kiq, yMax = QMaxPu, yMin = QMinPu,
  y_start = QRef0Pu,
  initType = Modelica.Blocks.Types.InitPID.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zeroQ(k = 0) annotation(
    Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //--- Active power / frequency droop path
  Modelica.Blocks.Continuous.FirstOrder firstOrderP(T = tPFilt, y_start = PPcc0Pu) annotation(
    Placement(transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = 1) annotation(
    Placement(transformation(origin = {-107, 31}, extent = {{-7, -7}, {7, 7}})));
  Modelica.Blocks.Math.Add freqErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {-85, 20}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Nonlinear.DeadZone freqDeadband(uMax = FDbd2Pu, uMin = -FDbd1Pu) annotation(
    Placement(transformation(origin = {-64, 20}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Math.Gain droopGain(k = Kdroop) annotation(
    Placement(transformation(origin = {-45, 20}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Nonlinear.Limiter freqErrLim(uMax = FEMaxPu, uMin = FEMinPu) annotation(
    Placement(transformation(origin = {-28, 19}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Add PRefEff(k1 = +1, k2 = +1) annotation(
    Placement(transformation(origin = {-3, 38}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Math.Add activePowerErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {18, 69}, extent = {{-6, -6}, {6, 6}})));
  //P PI controller (LimPID)
  Modelica.Blocks.Continuous.LimPID piP(controllerType = Modelica.Blocks.Types.SimpleController.PI,
  k = Kpp, Ti = Kpp/Kip, yMax = PMaxPu, yMin = PMinPu,
  y_start = PRef0Pu,
  initType = Modelica.Blocks.Types.InitPID.InitialOutput) annotation(
    Placement(transformation(origin = {60, 69}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant zeroP(k = 0) annotation(
    Placement(transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  //--- Reactive power /voltage path ---
  connect(QPccPu, firstOrderQ.u) annotation(
    Line(points = {{-114, -50}, {-88, -50}}, color = {0, 0, 127}));
  connect(firstOrderQ.y, Lambda.u) annotation(
    Line(points = {{-64, -50}, {-54, -50}}, color = {0, 0, 127}));
  connect(UPccPu, firstOrderU.u) annotation(
    Line(points = {{-114, -80}, {-88, -80}}, color = {0, 0, 127}));
  connect(firstOrderU.y, add.u2) annotation(
    Line(points = {{-64, -80}, {-26, -80}, {-26, -68}, {-24, -68}}, color = {0, 0, 127}));
  connect(Lambda.y, add.u1) annotation(
    Line(points = {{-30, -50}, {-24, -50}, {-24, -56}}, color = {0, 0, 127}));
  connect(add.y, feedback1.u2) annotation(
    Line(points = {{0, -62}, {6, -62}, {6, -28}}, color = {0, 0, 127}));
  connect(URefPu, feedback1.u1) annotation(
    Line(points = {{-114, -20}, {-2, -20}}, color = {0, 0, 127}));
  connect(feedback1.y, voltDeadband.u) annotation(
    Line(points = {{16, -20}, {20, -20}}, color = {0, 0, 127}));
  connect(voltDeadband.y, piQ.u_s) annotation(
    Line(points = {{40, -20}, {48, -20}}, color = {0, 0, 127}));
  connect(zeroQ.y, piQ.u_m) annotation(
    Line(points = {{60, -39}, {60, -32}}, color = {0, 0, 127}));

  //--- Active power / frequency droop path ---
  connect(PPccPu, firstOrderP.u) annotation(
    Line(points = {{-114, 80}, {-88, 80}}, color = {0, 0, 127}));
  connect(const.y, freqErr.u1) annotation(
    Line(points = {{-100, 32}, {-90, 32}, {-90, 24}}, color = {0, 0, 127}));
  connect(omegaPu, freqErr.u2) annotation(
    Line(points = {{-114, 6}, {-90, 6}, {-90, 18}}, color = {0, 0, 127}));
  connect(freqErr.y, freqDeadband.u) annotation(
    Line(points = {{-80, 20}, {-70, 20}}, color = {0, 0, 127}));
  connect(freqDeadband.y, droopGain.u) annotation(
    Line(points = {{-58, 20}, {-50, 20}}, color = {0, 0, 127}));
  connect(droopGain.y, freqErrLim.u) annotation(
    Line(points = {{-40, 20}, {-36, 20}}, color = {0, 0, 127}));
  connect(freqErrLim.y, PRefEff.u2) annotation(
    Line(points = {{-22, 20}, {-8, 20}, {-8, 36}}, color = {0, 0, 127}));
  connect(PRefPu, PRefEff.u1) annotation(
    Line(points = {{-114, 50}, {-8, 50}, {-8, 42}}, color = {0, 0, 127}));
  connect(PRefEff.y, activePowerErr.u1) annotation(
    Line(points = {{2, 38}, {10, 38}, {10, 66}}, color = {0, 0, 127}));
  connect(firstOrderP.y, activePowerErr.u2) annotation(
    Line(points = {{-64, 80}, {10, 80}, {10, 72}}, color = {0, 0, 127}));
  connect(activePowerErr.y, piP.u_s) annotation(
    Line(points = {{24, 70}, {48, 69}}, color = {0, 0, 127}));
  connect(zeroP.y, piP.u_m) annotation(
    Line(points = {{60, 51}, {60, 58}}, color = {0, 0, 127}));

  //--- Final outputs: base change (SnRef -> SNom)
  QInjRefPu = -piQ.y * SystemBase.SnRef/SNom;
  PInjRefPu = -piP.y * SystemBase.SnRef/SNom;

end PlantControl;
