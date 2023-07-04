within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model DcVoltageControlSideDangling "DC voltage control side for the HVDC VSC model with terminal2 connected to a switched-off bus (UDc control on terminal 1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsAcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsDcVoltageControl;
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsLimitsCalculation;

  parameter Types.PerUnit RDcPu "DC line resistance in pu (base UDcNom, SnRef)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "If true, converter is blocked" annotation(
    Placement(visible = true, transformation(origin = {-107, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = ModeU0) "Mode of control : if true, U mode, if false, Q mode" annotation(
    Placement(visible = true, transformation(origin = {-107, -100}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-107, -40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-107, -88}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {94,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-107, -64}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UDcPu(start = UDc0Pu) "DC voltage in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 57}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-110,0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UDcRefPu(start = UDcRef0Pu) "Reference DC voltage in pu (base UDcNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 75}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -76}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {0,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + LambdaPu * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -52}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipRefPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {107, 70}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = { 110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base UNom, SNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {107, -70}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.DcVoltageControl.DcVoltageControlDangling dCVoltageControl(Ip0Pu = Ip0Pu, IpMaxPu = IpMaxPu, KiDc = KiDc, KpDc = KpDc, RDcPu = RDcPu, SNom = SNom, tMeasureU = tMeasureU, U0Pu = U0Pu, UDc0Pu = UDc0Pu, UDcRef0Pu = UDcRef0Pu, UDcRefMaxPu = UDcRefMaxPu, UDcRefMinPu = UDcRefMinPu) "DC voltage control for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-30, 70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.AcVoltageControl.AcVoltageControl aCVoltageControl(InPu = InPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, IqModTableName = IqModTableName, KiAc = KiAc, KpAc = KpAc, LambdaPu = LambdaPu, P0Pu = P0Pu, Q0Pu = Q0Pu, QOpMaxPu = QOpMaxPu, QOpMinPu = QOpMinPu, QPMaxTableName = QPMaxTableName, QPMinTableName = QPMinTableName, QUMaxTableName = QUMaxTableName, QUMinTableName = QUMinTableName, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TablesFile = TablesFile, tMeasure = tMeasure, tQ = tQ, U0Pu = U0Pu, ModeU0 = ModeU0) "AC voltage control for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-30, -70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation.LimitsCalculationUDcDangling limitsCalculationUDc(InPu = InPu, Ip0Pu = Ip0Pu, IpMaxPu = IpMaxPu, Iq0Pu = Iq0Pu) "Reactive and active currents limits calculation function" annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom) (DC to AC)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom) (DC to AC)";
  parameter Boolean ModeU0 "Initial mode of control : if true, U mode, if false, Q mode";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (DC to AC)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (DC to AC)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.VoltageModulePu UDc0Pu "Start value of DC voltage in pu (base SNom, UNom)";
  parameter Types.VoltageModulePu UDcRef0Pu "Start value of DC voltage reference in pu (base UDcNom)";

equation
  connect(UDcRefPu, dCVoltageControl.UDcRefPu) annotation(
    Line(points = {{-107, 75}, {-63, 75}}, color = {0, 0, 127}));
  connect(UDcPu, dCVoltageControl.UDcPu) annotation(
    Line(points = {{-107, 57}, {-63, 57}}, color = {0, 0, 127}));
  connect(dCVoltageControl.ipRefPu, limitsCalculationUDc.ipRefPu) annotation(
    Line(points = {{3, 70}, {50, 70}, {50, 33}}, color = {0, 0, 127}));
  connect(dCVoltageControl.ipRefPu, ipRefPu) annotation(
    Line(points = {{3, 70}, {107, 70}}, color = {0, 0, 127}));
  connect(dCVoltageControl.UPu, UPu) annotation(
    Line(points = {{-63, 92}, {-80, 92}, {-80, -76}, {-107, -76}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-107, -52}, {-63, -52}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-107, -52}, {-73, -52}, {-73, -52}, {-73, -52}}, color = {0, 0, 127}));
  connect(QRefPu, aCVoltageControl.QRefPu) annotation(
    Line(points = {{-107, -64}, {-63, -64}}, color = {0, 0, 127}));
  connect(UPu, aCVoltageControl.UPu) annotation(
    Line(points = {{-107, -76}, {-63, -76}}, color = {0, 0, 127}));
  connect(QPu, aCVoltageControl.QPu) annotation(
    Line(points = {{-107, -88}, {-63, -88}}, color = {0, 0, 127}));
  connect(modeU, aCVoltageControl.modeU) annotation(
    Line(points = {{-107, -100}, {-63, -100}}, color = {255, 0, 255}));
  connect(aCVoltageControl.iqRefPu, limitsCalculationUDc.iqRefPu) annotation(
    Line(points = {{3, -70}, {50, -70}, {50, -33}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqModPu, limitsCalculationUDc.iqModPu) annotation(
    Line(points = {{3, -52}, {29, -52}, {29, -33}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, iqRefPu) annotation(
    Line(points = {{3, -70}, {107, -70}}, color = {0, 0, 127}));
  connect(limitsCalculationUDc.iqMinPu, aCVoltageControl.iqMinPu) annotation(
    Line(points = {{17, -12}, {-18, -12}, {-18, -37}}, color = {0, 0, 127}));
  connect(limitsCalculationUDc.iqMaxPu, aCVoltageControl.iqMaxPu) annotation(
    Line(points = {{17, -24}, {-6, -24}, {-6, -37}}, color = {0, 0, 127}));
  connect(blocked, aCVoltageControl.blocked) annotation(
    Line(points = {{-107, 0}, {-30, 0}, {-30, -37}}, color = {255, 0, 255}));
  connect(limitsCalculationUDc.ipMaxPu, dCVoltageControl.ipMaxPu) annotation(
    Line(points = {{17, 24}, {-6, 24}, {-6, 37}}, color = {0, 0, 127}));
  connect(limitsCalculationUDc.ipMinPu, dCVoltageControl.ipMinPu) annotation(
    Line(points = {{17, 12}, {-18, 12}, {-18, 37}}, color = {0, 0, 127}));
  connect(PPu, aCVoltageControl.PPu) annotation(
    Line(points = {{-106, -40}, {-62, -40}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {122, 112}, extent = {{-13, 8}, {20, -12}}, textString = "UDcRefPu"), Text(origin = {54, 111}, extent = {{-13, 8}, {13, -8}}, textString = "QRefPu"), Text(origin = {-10, 111}, extent = {{-13, 8}, {13, -8}}, textString = "URefPu"), Text(origin = {-77, 112}, extent = {{-13, 8}, {13, -8}}, textString = "modeU"), Text(origin = {124, 53}, extent = {{-13, 8}, {13, -8}}, textString = "ipRefPu"), Text(origin = {123, -13}, extent = {{-13, 8}, {13, -8}}, textString = "iqRefPu"), Text(origin = {116, -126}, extent = {{-13, 8}, {1, -6}}, textString = "QPu"), Text(origin = {23, -128}, extent = {{-13, 8}, {1, -6}}, textString = "UPu"), Text(origin = {-24, -128}, extent = {{-13, 8}, {13, -8}}, textString = "blocked"), Text(origin = {-111, -19}, extent = {{-13, 8}, {8, -11}}, textString = "UDcPu"), Text(origin = {0, 51}, extent = {{-65, 27}, {65, -27}}, textString = "UDc Control"), Text(origin = {0, -53}, extent = {{-65, 27}, {65, -27}}, textString = "U/Q Control")}));
end DcVoltageControlSideDangling;
