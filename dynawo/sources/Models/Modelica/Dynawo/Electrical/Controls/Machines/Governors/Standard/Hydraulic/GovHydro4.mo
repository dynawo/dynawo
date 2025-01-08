within Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at
* SPDX-License-Identifier:
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GovHydro4 "Governor type GovHydro4"

  // Public parameters
  parameter Types.PerUnit ATurb "Turbine gain in pu, typical: 1.2" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.AngularVelocityPu DeltaOmegaDbPu "Frequency Intentional dead-band width in pu of base SystemBase.omegaNom, typical: 0" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.AngularVelocityPu DeltaOmegaEpsPu "Frequency Intentional dead-band hysteresis in pu of base SystemBase.omegaNom, typical: 0" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit DeltaPDbPu "Unintentional dead-band in pu of base PNomTurb, typical: 0" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit DTurb "Turbine damping factor in pu, typical: 0.5 (simple turbine) or 1.1 (real turbine) (if ModelInt == 0 then 0.5 else 1.1)" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit GMax "Maximum gate opening in pu of PNomTurb, typical: 1" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit GMin "Minimum gate opening in pu of PNomTurb, typical: 0" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit HDam "Head available at dam in pu, typical: 1" annotation(
    Dialog(tab = "General parameters"));
  parameter Integer ModelInt = 1 "0=simple (proportional), 1=Pelton/Francis, 2=Kaplan, 3=custom table" annotation(
    Dialog(tab = "Turbine type"));
  parameter Types.PerUnit QNl "No-load flow at nominal head in pu, typical: 0.08 (simple turbine) or 0 (real turbine) (if ModelInt == 0 then 0.08 else 0)" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time RPerm "Permanent droop in pu, typical: 0.05" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time RTemp "Temporary droop in seconds, typical: 0.3" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time tG "Gate servo time constant in seconds, typical: 0.5" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time tP "Pilot servo time constant in seconds, typical: 0.1" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time tR "Dashpot time constan in seconds, typical: 5" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.Time tW "Water inertia time constant in seconds, typical: 1" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit UC "Max gate closing velocity in pu/s, typical: -0.2" annotation(
    Dialog(tab = "General parameters"));
  parameter Types.PerUnit UO "Max gate opening velocity in pu/s, typical: 0.2" annotation(
    Dialog(tab = "General parameters"));

  // Table parameters
  parameter Real CustomTable[7, 2] = [0.1, 0; 0.4, 0.42; 0.5, 0.56; 0.7, 0.8; 0.8, 0.9; 0.9, 0.97; 1, 1] "Custom ModelInt look up table, e.g. [0.1, 0; 0.4, 0.42; 0.5, 0.56; 0.7, 0.8; 0.8, 0.9; 0.9, 0.97; 1, 1]" annotation(
    Dialog(tab = "Turbine type"));

  // Inputs
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omega0Pu) "Rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, -141}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Rotor speed reference in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 160}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, -1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Reference power in pu (no constant base due to turbine characteristics" annotation(
    Placement(visible = true, transformation(origin = {-240, 200}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, 141}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {238, -40}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {260, 0}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));

  // Blocks
  Modelica.Blocks.Math.Add addDeltaOmega(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addDeltaP(k2 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-110, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addFeedback annotation(
    Placement(visible = true, transformation(origin = {-130, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Add addHDam(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-48, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPm(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQnl(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = HDam) annotation(
    Placement(visible = true, transformation(origin = {-90, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = QNl) annotation(
    Placement(visible = true, transformation(origin = {10, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DeadBand dbOmega(EpsMax = DeltaOmegaEpsPu, UMax = DeltaOmegaDbPu) annotation(
    Placement(visible = true, transformation(origin = {-150, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.BacklashHysteresis dbPower(H0 = false, U0 = InitSet, UHigh = DeltaPDbPu) annotation(
    Placement(visible = true, transformation(origin = {90, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression deltaomega(y = addDeltaOmega.y) annotation(
    Placement(visible = true, transformation(origin = {166, 157}, extent = {{-18, -13}, {18, 13}}, rotation = -90)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainATurb(k = ATurb) annotation(
    Placement(visible = true, transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainDTurb(k = DTurb) annotation(
    Placement(visible = true, transformation(origin = {160, -10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainRPerm(k = RPerm) annotation(
    Placement(visible = true, transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gainTg(k = 1 / tG) annotation(
    Placement(visible = true, transformation(origin = {-30, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator intLimG(outMax = GMax, outMin = GMin, y_start = InitSet) annotation(
    Placement(visible = true, transformation(origin = {50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator intTw(k = 1 / tW, y_start = Pm0Pu / (ATurb * HDam) + QNl) annotation(
    Placement(visible = true, transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTp(T = tP, y(fixed = true), y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitU(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = UO, uMin = UC) annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodDTurb annotation(
    Placement(visible = true, transformation(origin = {160, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product prodH annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodSquare annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds tableGvPgv(table = Lookuptab) annotation(
    Placement(visible = true, transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative tfRTemp(T = tR, initType = Modelica.Blocks.Types.Init.InitialState, k = RTemp * tR, x_start = InitSet, y(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {10, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit Pm0Pu "Initial value of mechanical power in pu (base: PNomTurb)";

  // Final parameters
  final parameter Real InitSet = Modelica.Math.Vectors.interpolate(Lookuptab[:, 2], Lookuptab[:, 1], Pm0Pu / ATurb + QNl) "Interpolated initial value of look-up table input";
  final parameter Types.PerUnit PRef0Pu = InitSet * RPerm "Initial value of reference power in pu (no constant base due to turbine characteristics)";

  // Table characteristics
  final parameter Real FrancisPeltonTable[7, 2] = [0.1, 0; 0.4, 0.42; 0.5, 0.56; 0.7, 0.8; 0.8, 0.9; 0.9, 0.97; 1, 1] "Francis/Pelton ModelInt look up table" annotation(
    Dialog(tab = "Turbine type"));
  final parameter Real KaplanTable[7, 2] = [0.1, 0; 0.4, 0.35; 0.5, 0.468; 0.7, 0.796; 0.8, 0.917; 0.9, 0.99; 1, 1] "Kaplan ModelInt look up table" annotation(
    Dialog(tab = "Turbine type"));
  final parameter Real SimpleTable[2, 2] = [0, 0; 1, 1] "Proportional table for simple ModelInt";
  final parameter Real Lookuptab[:, :] = if ModelInt == 0 then SimpleTable elseif ModelInt == 1 then FrancisPeltonTable elseif ModelInt == 2 then KaplanTable else CustomTable;
  final parameter Boolean Sel = if ModelInt == 3 then true else false;

equation
  connect(const.y, addHDam.u2) annotation(
    Line(points = {{-79, -80}, {-66, -80}, {-66, -46}, {-60, -46}, {-60, -46}}, color = {0, 0, 127}));
  connect(addQnl.y, prodH.u2) annotation(
    Line(points = {{61, -60}, {80, -60}, {80, -66}, {98, -66}}, color = {0, 0, 127}));
  connect(prodH.u1, prodSquare.y) annotation(
    Line(points = {{98, -54}, {80, -54}, {80, 0}, {-89.5, 0}, {-89.5, -40}, {-99, -40}}, color = {0, 0, 127}));
  connect(constant1.y, addQnl.u2) annotation(
    Line(points = {{21, -130}, {29, -130}, {29, -66}, {38, -66}}, color = {0, 0, 127}));
  connect(prodH.y, gainATurb.u) annotation(
    Line(points = {{121, -60}, {138, -60}}, color = {0, 0, 127}));
  connect(gainTg.y, limitU.u) annotation(
    Line(points = {{-19, 140}, {-2, 140}}, color = {0, 0, 127}));
  connect(limitU.y, intLimG.u) annotation(
    Line(points = {{21, 140}, {38, 140}}, color = {0, 0, 127}));
  connect(intLimG.y, dbPower.u) annotation(
    Line(points = {{61, 140}, {78, 140}}, color = {0, 0, 127}));
  connect(gainATurb.y, addPm.u2) annotation(
    Line(points = {{161, -60}, {169.5, -60}, {169.5, -46}, {178, -46}}, color = {0, 0, 127}));
  connect(addPm.y, PmPu) annotation(
    Line(points = {{201, -40}, {238, -40}}, color = {0, 0, 127}));
  connect(dbOmega.y, addDeltaP.u2) annotation(
    Line(points = {{-139, 140}, {-122, 140}}, color = {0, 0, 127}));
  connect(prodDTurb.y, gainDTurb.u) annotation(
    Line(points = {{160, 19}, {160, 2}}, color = {0, 0, 127}));
  connect(lagTp.y, gainTg.u) annotation(
    Line(points = {{-59, 140}, {-42, 140}}, color = {0, 0, 127}));
  connect(addDeltaP.y, lagTp.u) annotation(
    Line(points = {{-99, 140}, {-82, 140}}, color = {0, 0, 127}));
  connect(deltaomega.y, prodDTurb.u1) annotation(
    Line(points = {{166, 137}, {166, 42}}, color = {0, 0, 127}));
  connect(gainRPerm.y, addFeedback.u2) annotation(
    Line(points = {{-1, 80}, {-123.75, 80}, {-123.75, 98}, {-124, 98}}, color = {0, 0, 127}));
  connect(addFeedback.y, addDeltaP.u3) annotation(
    Line(points = {{-130, 121}, {-130, 132}, {-122, 132}}, color = {0, 0, 127}));
  connect(dbPower.y, prodDTurb.u2) annotation(
    Line(points = {{101, 140}, {154, 140}, {154, 42}}, color = {0, 0, 127}));
  connect(dbPower.y, gainRPerm.u) annotation(
    Line(points = {{101, 140}, {112, 140}, {112, 80}, {22, 80}}, color = {0, 0, 127}));
  connect(dbPower.y, tableGvPgv.u) annotation(
    Line(points = {{101, 140}, {112, 140}, {112, 20}, {-212, 20}, {-212, -40}, {-202, -40}}, color = {0, 0, 127}));
  connect(gainDTurb.y, addPm.u1) annotation(
    Line(points = {{160, -21}, {160, -34}, {178, -34}}, color = {0, 0, 127}));
  connect(addHDam.y, intTw.u) annotation(
    Line(points = {{-37, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(intTw.y, addQnl.u1) annotation(
    Line(points = {{1, -40}, {28, -40}, {28, -54}, {38, -54}}, color = {0, 0, 127}));
  connect(addDeltaOmega.y, dbOmega.u) annotation(
    Line(points = {{-179, 140}, {-162, 140}}, color = {0, 0, 127}));
  connect(division.y, prodSquare.u2) annotation(
    Line(points = {{-139, -40}, {-133.5, -40}, {-133.5, -46}, {-122, -46}}, color = {0, 0, 127}));
  connect(division.y, prodSquare.u1) annotation(
    Line(points = {{-139, -40}, {-133.125, -40}, {-133.125, -34}, {-122, -34}}, color = {0, 0, 127}));
  connect(intTw.y, division.u1) annotation(
    Line(points = {{1, -40}, {10, -40}, {10, -100}, {-170, -100}, {-170, -34}, {-162, -34}}, color = {0, 0, 127}));
  connect(tableGvPgv.y[1], division.u2) annotation(
    Line(points = {{-179, -40}, {-171.5, -40}, {-171.5, -46}, {-162, -46}}, color = {0, 0, 127}));
  connect(PRefPu, addDeltaP.u1) annotation(
    Line(points = {{-240, 200}, {-132, 200}, {-132, 148}, {-122, 148}, {-122, 148}}, color = {0, 0, 127}));
  connect(omegaRefPu, addDeltaOmega.u1) annotation(
    Line(points = {{-240, 160}, {-209.5, 160}, {-209.5, 146}, {-202, 146}}, color = {0, 0, 127}));
  connect(omegaPu, addDeltaOmega.u2) annotation(
    Line(points = {{-240, 120}, {-210, 120}, {-210, 134}, {-202, 134}}, color = {0, 0, 127}));
  connect(tfRTemp.u, dbPower.y) annotation(
    Line(points = {{22, 40}, {112, 40}, {112, 140}, {101, 140}}, color = {0, 0, 127}));
  connect(tfRTemp.y, addFeedback.u1) annotation(
    Line(points = {{-1, 40}, {-136, 40}, {-136, 98}}, color = {0, 0, 127}));
  connect(prodSquare.y, addHDam.u1) annotation(
    Line(points = {{-98, -40}, {-80, -40}, {-80, -34}, {-60, -34}}, color = {0, 0, 127}));

  annotation(
    uses(Dynawo(version = "1.0.1"), Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-220, -220}, {220, 220}})),
    Icon(coordinateSystem(extent = {{-220, -220}, {220, 220}}), graphics = {Rectangle(extent = {{-220, 220}, {220, -220}}), Text(origin = {7, 14}, extent = {{255, -48}, {-255, 48}}, textString = "govHydro4")}),
    version = "");
end GovHydro4;
