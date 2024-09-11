within Dynawo.Electrical.Controls.Machines.Governors.Standard.Hydraulic;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

  // public parameters
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
  parameter Integer ModelInt "0=simple (proportional), 1=Pelton/Francis, 2=Kaplan, 3=custom table" annotation(
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
  // table parameters
  parameter Real CustomTable[7, 2] "Custom ModelInt look up table, e.g. [0.1, 0; 0.4, 0.42; 0.5, 0.56; 0.7, 0.8; 0.8, 0.9; 0.9, 0.97; 1, 1]" annotation(
    Dialog(tab = "Turbine type"));
  final parameter Real FrancisPeltonTable[7, 2] = [0.1, 0; 0.4, 0.42; 0.5, 0.56; 0.7, 0.8; 0.8, 0.9; 0.9, 0.97; 1, 1] "Francis/Pelton ModelInt look up table" annotation(
    Dialog(tab = "Turbine type"));
  final parameter Real KaplanTable[7, 2] = [0.1, 0; 0.4, 0.35; 0.5, 0.468; 0.7, 0.796; 0.8, 0.917; 0.9, 0.99; 1, 1] "Kaplan ModelInt look up table" annotation(
    Dialog(tab = "Turbine type"));
  final parameter Real SimpleTable[2, 2] = [0, 0; 1, 1] "Proportional table for simple ModelInt";
  final parameter Real Lookuptab[:, :] = if ModelInt == 0 then SimpleTable elseif ModelInt == 1 then FrancisPeltonTable elseif ModelInt == 2 then KaplanTable else CustomTable;
  final parameter Boolean Sel = if ModelInt == 3 then true else false;
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput omegaPu "Rotor speed in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 118}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, -141}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu "Rotor speed reference in pu (base SystemBase.omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 148}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, -1}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Reference power in pu (no constant base due to turbine characteristics" annotation(
    Placement(visible = true, transformation(origin = {-240, 184}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-257, 141}, extent = {{-37, -37}, {37, 37}}, rotation = 0)));
  //outputs
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power in pu (base PNomTurb)" annotation(
    Placement(visible = true, transformation(origin = {238, -50}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {260, 0}, extent = {{-39, -39}, {39, 39}}, rotation = 0)));
  
  // blocks
  Modelica.Blocks.Math.Add addDeltaOmega(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-196, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addDeltaP(k2 = -1, k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-124, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addFeedback annotation(
    Placement(visible = true, transformation(origin = {-146, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Add addHDam(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {-56, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPm(k1 = -1) annotation(
    Placement(visible = true, transformation(origin = {192, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQnl(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {54, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = HDam) annotation(
    Placement(visible = true, transformation(origin = {-98, -82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = QNl) annotation(
    Placement(visible = true, transformation(origin = {22, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DeadBand dbOmega(EpsMax = DeltaOmegaEpsPu, UMax = DeltaOmegaDbPu) annotation(
    Placement(visible = true, transformation(origin = {-158, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.BacklashHysteresis dbPower(H0 = false, U0 = InitSet, UHigh = DeltaPDbPu) annotation(
    Placement(visible = true, transformation(origin = {78, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression deltaomega(y = addDeltaOmega.y) annotation(
    Placement(visible = true, transformation(origin = {166, 77}, extent = {{-18, -13}, {18, 13}}, rotation = -90)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-144, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainATurb(k = ATurb) annotation(
    Placement(visible = true, transformation(origin = {144, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainDTurb(k = DTurb) annotation(
    Placement(visible = true, transformation(origin = {160, -4}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainRPerm(k = RPerm) annotation(
    Placement(visible = true, transformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Math.Gain gainTg(k = 1 / tG) annotation(
    Placement(visible = true, transformation(origin = {-40, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator intLimG(outMax = GMax, outMin = GMin, y_start = InitSet) annotation(
    Placement(visible = true, transformation(origin = {40, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator intTw(k = 1 / tW, y_start = Pm0Pu / ATurb + QNl) annotation(
    Placement(visible = true, transformation(origin = {-14, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder lagTp(T = tP, y(fixed = true), y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-78, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limitU(limitsAtInit = true, uMax = UO, uMin = UC) annotation(
    Placement(visible = true, transformation(origin = {-2, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodDTurb annotation(
    Placement(visible = true, transformation(origin = {160, 34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product prodH annotation(
    Placement(visible = true, transformation(origin = {108, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product prodSquare annotation(
    Placement(visible = true, transformation(origin = {-96, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds tableGvPgv(table = Lookuptab) annotation(
    Placement(visible = true, transformation(origin = {-188, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative tfRTemp(T = tR, initType = Modelica.Blocks.Types.Init.InitialState, k = RTemp * tR, x_start = InitSet) annotation(
    Placement(visible = true, transformation(origin = {8, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  // initial parameters
  parameter Types.PerUnit Pm0Pu "Initial value of mechanical power in pu (base: PNomTurb)";
  // final parameters
  final parameter Real InitSet = Modelica.Math.Vectors.interpolate(Lookuptab[:, 2], Lookuptab[:, 1], Pm0Pu / ATurb + QNl) "Interpolated initial value of look-up table input";
  final parameter Types.PerUnit PRef0Pu = InitSet * RPerm "Initial value of reference power in pu (no constant base due to turbine characteristics)";
  
equation
  connect(prodSquare.y, addHDam.u1) annotation(
    Line(points = {{-85, -50}, {-69, -50}}, color = {0, 0, 127}));
  connect(const.y, addHDam.u2) annotation(
    Line(points = {{-87, -82}, {-69, -82}, {-69, -62}}, color = {0, 0, 127}));
  connect(addQnl.y, prodH.u2) annotation(
    Line(points = {{65, -62}, {95, -62}}, color = {0, 0, 127}));
  connect(prodH.u1, prodSquare.y) annotation(
    Line(points = {{96, -50}, {82, -50}, {82, -16}, {-76, -16}, {-76, -50}, {-84, -50}}, color = {0, 0, 127}));
  connect(constant1.y, addQnl.u2) annotation(
    Line(points = {{33, -86}, {37, -86}, {37, -68}, {41, -68}}, color = {0, 0, 127}));
  connect(prodH.y, gainATurb.u) annotation(
    Line(points = {{119, -56}, {131, -56}}, color = {0, 0, 127}));
  connect(gainTg.y, limitU.u) annotation(
    Line(points = {{-29, 140}, {-14, 140}}, color = {0, 0, 127}));
  connect(limitU.y, intLimG.u) annotation(
    Line(points = {{9, 140}, {28, 140}}, color = {0, 0, 127}));
  connect(intLimG.y, dbPower.u) annotation(
    Line(points = {{51, 140}, {66, 140}}, color = {0, 0, 127}));
  connect(gainATurb.y, addPm.u2) annotation(
    Line(points = {{155, -56}, {179, -56}}, color = {0, 0, 127}));
  connect(addPm.y, PmPu) annotation(
    Line(points = {{203, -50}, {238, -50}}, color = {0, 0, 127}));
  connect(dbOmega.y, addDeltaP.u2) annotation(
    Line(points = {{-147, 140}, {-136, 140}}, color = {0, 0, 127}));
  connect(prodDTurb.y, gainDTurb.u) annotation(
    Line(points = {{160, 23}, {160, 8}}, color = {0, 0, 127}));
  connect(lagTp.y, gainTg.u) annotation(
    Line(points = {{-67, 140}, {-52, 140}}, color = {0, 0, 127}));
  connect(addDeltaP.y, lagTp.u) annotation(
    Line(points = {{-113, 140}, {-90, 140}}, color = {0, 0, 127}));
  connect(deltaomega.y, prodDTurb.u1) annotation(
    Line(points = {{166, 57}, {166, 46.2}}, color = {0, 0, 127}));
  connect(gainRPerm.y, addFeedback.u2) annotation(
    Line(points = {{-1, 90}, {-140, 90}, {-140, 98}}, color = {0, 0, 127}));
  connect(addFeedback.y, addDeltaP.u3) annotation(
    Line(points = {{-146, 121}, {-146, 131}, {-136, 131}}, color = {0, 0, 127}));
  connect(dbPower.y, prodDTurb.u2) annotation(
    Line(points = {{90, 140}, {112, 140}, {112, 56}, {154, 56}, {154, 46}}, color = {0, 0, 127}));
  connect(dbPower.y, gainRPerm.u) annotation(
    Line(points = {{89, 140}, {112, 140}, {112, 90}, {22, 90}}, color = {0, 0, 127}));
  connect(dbPower.y, tableGvPgv.u) annotation(
    Line(points = {{90, 140}, {112, 140}, {112, 20}, {-212, 20}, {-212, -48}, {-200, -48}}, color = {0, 0, 127}));
  connect(gainDTurb.y, addPm.u1) annotation(
    Line(points = {{160, -14}, {160, -44}, {180, -44}}, color = {0, 0, 127}));
  connect(addHDam.y, intTw.u) annotation(
    Line(points = {{-44, -56}, {-26, -56}}, color = {0, 0, 127}));
  connect(intTw.y, addQnl.u1) annotation(
    Line(points = {{-2, -56}, {42, -56}}, color = {0, 0, 127}));
  connect(addDeltaOmega.y, dbOmega.u) annotation(
    Line(points = {{-184, 140}, {-170, 140}}, color = {0, 0, 127}));
  connect(division.y, prodSquare.u2) annotation(
    Line(points = {{-132, -54}, {-120, -54}, {-120, -56}, {-108, -56}}, color = {0, 0, 127}));
  connect(division.y, prodSquare.u1) annotation(
    Line(points = {{-132, -54}, {-120, -54}, {-120, -44}, {-108, -44}}, color = {0, 0, 127}));
  connect(intTw.y, division.u1) annotation(
    Line(points = {{-2, -56}, {0, -56}, {0, -106}, {-170, -106}, {-170, -48}, {-156, -48}}, color = {0, 0, 127}));
  connect(tableGvPgv.y[1], division.u2) annotation(
    Line(points = {{-176, -48}, {-166, -48}, {-166, -60}, {-156, -60}}, color = {0, 0, 127}));
  connect(PRefPu, addDeltaP.u1) annotation(
    Line(points = {{-240, 184}, {-136, 184}, {-136, 148}}, color = {0, 0, 127}));
  connect(omegaRefPu, addDeltaOmega.u1) annotation(
    Line(points = {{-240, 148}, {-208, 148}, {-208, 146}}, color = {0, 0, 127}));
  connect(omegaPu, addDeltaOmega.u2) annotation(
    Line(points = {{-240, 118}, {-208, 118}, {-208, 134}}, color = {0, 0, 127}));
  connect(tfRTemp.u, dbPower.y) annotation(
    Line(points = {{20, 50}, {112, 50}, {112, 140}, {90, 140}}, color = {0, 0, 127}));
  connect(tfRTemp.y, addFeedback.u1) annotation(
    Line(points = {{-2, 50}, {-152, 50}, {-152, 98}}, color = {0, 0, 127}));
  
  annotation(
    uses(Dynawo(version = "1.0.1"), Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-220, -220}, {220, 220}})),
    Icon(coordinateSystem(extent = {{-220, -220}, {220, 220}}), graphics = {Rectangle(extent = {{-220, 220}, {220, -220}}), Text(origin = {7, 14}, extent = {{255, -48}, {-255, 48}}, textString = "govHydro4")}),
    version = "");
end GovHydro4;
