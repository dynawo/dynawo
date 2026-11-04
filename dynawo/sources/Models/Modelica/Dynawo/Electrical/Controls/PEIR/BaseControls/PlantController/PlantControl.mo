within Dynawo.Electrical.Controls.PEIR.BaseControls.PlantController;

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

model PlantControl "Generic plant controller"
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter in MVA";
  // Parameters -- gains
  parameter Types.PerUnit LambdaPu "Reactive power compensation gain, URegPu + LambdaPu*QReg is controlled (in pu (base UNom) per pu (base SNom), generator convention)";
  parameter Types.PerUnit Kdroop "Frequency droop gain (in pu (base SNom) per pu (base omegaNom), generator convention)";
  // Parameters -- time constants
  parameter Types.Time tQFilt "Time constant for the reactive power filter in s";
  parameter Types.Time tPFilt "Time constant for the active power filter in s";
  parameter Types.Time tUFilt "Time constant for the voltage filter in s";
  // Parameters -- PI gains
  parameter Types.PerUnit Kpq "PI proportional gain - voltage/Q loop";
  parameter Real Kiq(unit = "1/s") "PI integral gain - voltage/Q loop";
  parameter Types.PerUnit Kpp "PI proportional gain - active power loop";
  parameter Real Kip(unit = "1/s") "PI integral gain - active power loop";
  // Parameters -- output limits
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power reference sent to the converter in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power reference sent to the converter in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power reference sent to the converter in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power reference sent to the converter in pu (base SNom) (generator convention)";
  // Parameters -- deadbands and frequency droop limiter
  parameter Types.ActivePowerPu FEMaxPu "Maximum active power contribution of the frequency droop in pu (base SNom) (generator convention)";
  parameter Types.ActivePowerPu FEMinPu "Minimum active power contribution of the frequency droop in pu (base SNom) (generator convention)";
  parameter Types.PerUnit FDbd1Pu "Frequency deadband on the over-frequency side in pu (base omegaNom) (positive value)";
  parameter Types.PerUnit FDbd2Pu "Frequency deadband on the under-frequency side in pu (base omegaNom) (positive value)";
  parameter Types.PerUnit DbdPu "Voltage error deadband half-width in pu (base UNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage module at the regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-114, -80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-112, -88}, extent = {{-12, -12}, {12, 12}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage reference at the regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-114, -20}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -21}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-114, -50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, -53}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PRegPu(start = PReg0Pu) "Active power at the regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-114, 80}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 79}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRegGen0Pu) "Active power setpoint at the regulated bus in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-114, 50}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 49}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = Omega0Pu) "Converter angular frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-114, 6}, extent = {{-14, -14}, {14, 14}}), iconTransformation(origin = {-111, 19}, extent = {{-11, -11}, {11, 11}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu "Reactive power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu "Active power reference sent to the converter in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 64}, extent = {{-10, -10}, {10, 10}})));

  // Change of base and convention of the measurements: from base SnRef and receptor convention to base SNom and generator convention
  Modelica.Blocks.Math.Gain gainPReg(k = -SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-95, 80}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gainQReg(k = -SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-95, -50}, extent = {{-4, -4}, {4, 4}})));
  // Reactive power / voltage path
  Modelica.Blocks.Continuous.FirstOrder firstOrderQ(T = tQFilt, y_start = QRegGen0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {-76, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrderU(T = tUFilt, y_start = UReg0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {-76, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain lambdaGain(k = LambdaPu) annotation(
    Placement(visible = true, transformation(origin = {-42, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-12, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {6, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone voltDeadband(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Q PI controller (LimPID: native anti-windup, saturation on total output)
  Modelica.Blocks.Continuous.LimPID piQ(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kpq, Ti = Kpq/Kiq, yMax = QMaxPu, yMin = QMinPu, initType = Modelica.Blocks.Types.InitPID.InitialState, xi_start = QRef0Pu/Kpq, y_start = QRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant zeroQ(k = 0) annotation(
    Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // Active power / frequency droop path
  Modelica.Blocks.Continuous.FirstOrder firstOrderP(T = tPFilt, y_start = PRegGen0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
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
  Modelica.Blocks.Math.Add activePowerErr(k1 = -1, k2 = +1) annotation(
    Placement(transformation(origin = {18, 69}, extent = {{-6, -6}, {6, 6}})));
  // P PI controller (LimPID: native anti-windup, saturation on total output)
  Modelica.Blocks.Continuous.LimPID piP(controllerType = Modelica.Blocks.Types.SimpleController.PI, k = Kpp, Ti = Kpp/Kip, yMax = PMaxPu, yMin = PMinPu, initType = Modelica.Blocks.Types.InitPID.InitialState, xi_start = PRef0Pu/Kpp, y_start = PRef0Pu) annotation(
    Placement(transformation(origin = {60, 69}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant zeroP(k = 0) annotation(
    Placement(transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Initial parameters
  parameter Types.ReactivePowerPu QReg0Pu "Start value of reactive power at the regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.AngularVelocityPu Omega0Pu "Start value of the converter angular frequency (omegaPu input) in pu (base omegaNom)";
  parameter Types.VoltageModulePu UReg0Pu "Start value of voltage module at the regulated bus in pu (base UNom)";
  parameter Types.ActivePowerPu PReg0Pu "Start value of active power at the regulated bus in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Pinj0Pu "Start value of active power injected by the converter in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu Qinj0Pu "Start value of reactive power injected by the converter in pu (base SNom) (generator convention)";
  final parameter Types.ActivePowerPu PRegGen0Pu = -PReg0Pu*SystemBase.SnRef/SNom "Start value of active power at the regulated bus in pu (base SNom) (generator convention)";
  final parameter Types.ReactivePowerPu QRegGen0Pu = -QReg0Pu*SystemBase.SnRef/SNom "Start value of reactive power at the regulated bus in pu (base SNom) (generator convention)";
  final parameter Types.ActivePowerPu PRef0Pu = Pinj0Pu "Start value of the active power reference sent to the converter in pu (base SNom) (generator convention)";
  final parameter Types.ReactivePowerPu QRef0Pu = Qinj0Pu "Start value of the reactive power reference sent to the converter in pu (base SNom) (generator convention)";
  final parameter Types.VoltageModulePu URef0Pu = UReg0Pu + LambdaPu*QRegGen0Pu "Start value of the voltage reference at the regulated bus in pu (base UNom)";

equation
  // Reactive power / voltage path
  connect(QRegPu, gainQReg.u) annotation(
    Line(points = {{-114, -50}, {-100, -50}}, color = {0, 0, 127}));
  connect(gainQReg.y, firstOrderQ.u) annotation(
    Line(points = {{-91, -50}, {-88, -50}}, color = {0, 0, 127}));
  connect(firstOrderQ.y, lambdaGain.u) annotation(
    Line(points = {{-64, -50}, {-54, -50}}, color = {0, 0, 127}));
  connect(URegPu, firstOrderU.u) annotation(
    Line(points = {{-114, -80}, {-88, -80}}, color = {0, 0, 127}));
  connect(firstOrderU.y, add.u2) annotation(
    Line(points = {{-64, -80}, {-26, -80}, {-26, -68}, {-24, -68}}, color = {0, 0, 127}));
  connect(lambdaGain.y, add.u1) annotation(
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
  // Active power / frequency droop path
  connect(PRegPu, gainPReg.u) annotation(
    Line(points = {{-114, 80}, {-100, 80}}, color = {0, 0, 127}));
  connect(gainPReg.y, firstOrderP.u) annotation(
    Line(points = {{-91, 80}, {-88, 80}}, color = {0, 0, 127}));
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
  connect(PRefEff.y, activePowerErr.u2) annotation(
    Line(points = {{2, 38}, {10, 38}, {10, 66}}, color = {0, 0, 127}));
  connect(firstOrderP.y, activePowerErr.u1) annotation(
    Line(points = {{-64, 80}, {10, 80}, {10, 72}}, color = {0, 0, 127}));
  connect(activePowerErr.y, piP.u_s) annotation(
    Line(points = {{24, 70}, {48, 69}}, color = {0, 0, 127}));
  connect(zeroP.y, piP.u_m) annotation(
    Line(points = {{60, 51}, {60, 58}}, color = {0, 0, 127}));
  connect(piP.y, PInjRefPu) annotation(
    Line(points = {{71, 69}, {90, 69}, {90, 70}, {110, 70}}, color = {0, 0, 127}));
  connect(piQ.y, QInjRefPu) annotation(
    Line(points = {{71, -20}, {110, -20}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>Generic plant controller regulating the voltage and the active power at a regulated bus, and sending active and reactive power references to the converter.<br><br>The measurements at the regulated bus (PRegPu, QRegPu) are in pu (base SnRef) in receptor convention: they are first converted to pu (base SNom) in generator convention. All the setpoints, gains, limits and outputs are then in pu (base SNom) in generator convention.<br><br><b>Voltage / reactive power path.</b> The filtered voltage is compensated by the filtered reactive power: UComp = UFilt + LambdaPu*QGenFilt. The error URefPu - UComp goes through a deadband of half-width DbdPu and a PI controller (Kpq, Kiq) limited between QMinPu and QMaxPu, which gives the reactive power reference QInjRefPu. In steady state (outside the deadband and the limits), UReg = URef - LambdaPu*QGen: LambdaPu &gt; 0 gives a U-Q droop characteristic, LambdaPu = 0 gives a pure voltage regulation.<br><br><b>Active power / frequency path.</b> The frequency error is 1 - omegaPu (positive in under-frequency). It goes through an asymmetric deadband: FDbd1Pu on the over-frequency side (negative error) and FDbd2Pu on the under-frequency side (positive error), as the fdbd1/fdbd2 parameters of the WECC plant controllers. It is then multiplied by Kdroop and the resulting active power contribution is limited between FEMinPu and FEMaxPu, in pu (base SNom). This contribution is added to PRefPu and the error with the filtered active power goes through a PI controller (Kpp, Kip) limited between PMinPu and PMaxPu, which gives the active power reference PInjRefPu.<br><br>The integral gains Kiq and Kip must be strictly positive (the PI time constants are Kpq/Kiq and Kpp/Kip).</body></html>"));
end PlantControl;
