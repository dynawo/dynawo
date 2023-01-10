within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model ActivePowerControlSide "Active Power Control Side of the HVDC link"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ActivePowerControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ACVoltageControl;
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";
  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom)";

  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -64}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-47, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -88}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-93, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -76}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {46, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = modeU0) "Boolean assessing the mode of the control: true if U mode, false if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-107, -100}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 80}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {93, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = P0Pu) "Reference active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 60}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.BooleanInput activateDeltaP(start = false) "Boolean that indicates whether DeltaP is activated or not" annotation(
    Placement(visible = true, transformation(origin = {-107, 100}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 86}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + Lambda * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -52}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqMod1Pu(start = 0) "Additional reactive current in case of fault or overvoltage in pu for the other HVDC terminal (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 12}, extent = {{7, -7}, {-7, 7}}, rotation = 0), iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqRef1Pu(start = Iq0Pu) "Reactive current reference in pu for the other HVDC terminal (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -12}, extent = {{7, -7}, {-7, 7}}, rotation = 0), iconTransformation(origin = {-110, -69}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -70}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = { -110, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput ipRefPPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 70}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = { -110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqModPu(start = 0) "Additional reactive current in case of fault or overvoltage in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -52}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput POutPu annotation(
    Placement(visible = true, transformation(origin = {107, 40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  HVDC.HvdcVSC.BaseControls.ActivePowerControl.ActivePowerControl activePowerControl(Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu, KiDeltaP = KiDeltaP, KiPControl = KiPControl, KpDeltaP = KpDeltaP, KpPControl = KpPControl, P0Pu = P0Pu, PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, SlopePRefPu = SlopePRefPu, SlopeRPFault = SlopeRPFault, Udc0Pu = Udc0Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu) "Active power control for HVDC link" annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction.LimitsCalculationFunction limitsCalculationFunction(InPu = InPu, Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu, Iq0Pu = Iq0Pu) "Reactive and active currents limits calculation function" annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ACVoltageControl.ACVoltageControl aCVoltageControl(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, KiACVoltageControl = KiACVoltageControl, KpACVoltageControl = KpACVoltageControl, Lambda = Lambda, P0Pu = P0Pu, Q0Pu = Q0Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U0Pu, modeU0 = modeU0, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod) "AC voltage control for HVDC" annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

  parameter Types.VoltageModulePu Udc0Pu "Start value of dc voltage in pu (base SNom, UNom)";
  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";
  parameter Boolean modeU0 "Start value of the boolean assessing the mode of the control: true if U mode, false if Q mode";

equation
  connect(blocked, activePowerControl.blocked) annotation(
    Line(points = {{-80, 0}, {-40, 0}, {-40, 37}}, color = {255, 0, 255}));
  connect(blocked, aCVoltageControl.blocked) annotation(
    Line(points = {{-80, 0}, {-40, 0}, {-40, -37}}, color = {255, 0, 255}));
  connect(limitsCalculationFunction.IpMaxPu, activePowerControl.IpMaxPu) annotation(
    Line(points = {{7, 21}, {-16, 21}, {-16, 37}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IpMinPu, activePowerControl.IpMinPu) annotation(
    Line(points = {{7, 9}, {-28, 9}, {-28, 37}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMinPu, aCVoltageControl.IqMinPu) annotation(
    Line(points = {{7, -9}, {-28, -9}, {-28, -37}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMaxPu, aCVoltageControl.IqMaxPu) annotation(
    Line(points = {{7, -21}, {-16, -21}, {-16, -37}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, iqRefPu) annotation(
    Line(points = {{-7, -70}, {107, -70}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqModPu, limitsCalculationFunction.iqModPu) annotation(
    Line(points = {{-7, -52}, {19, -52}, {19, -33}, {19, -33}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, limitsCalculationFunction.iqRefPu) annotation(
    Line(points = {{-7, -70}, {40, -70}, {40, -33}, {40, -33}}, color = {0, 0, 127}));
  connect(activePowerControl.ipRefPPu, limitsCalculationFunction.ipRefPu) annotation(
    Line(points = {{-7, 70}, {40, 70}, {40, 33}, {40, 33}}, color = {0, 0, 127}));
  connect(activePowerControl.ipRefPPu, ipRefPPu) annotation(
    Line(points = {{-7, 70}, {107, 70}}, color = {0, 0, 127}));
  connect(activateDeltaP, activePowerControl.activateDeltaP) annotation(
    Line(points = {{-107, 100}, {-73, 100}}, color = {255, 0, 255}));
  connect(UdcPu, activePowerControl.UdcPu) annotation(
    Line(points = {{-107, 80}, {-73, 80}}, color = {0, 0, 127}));
  connect(PRefPu, activePowerControl.PRefPu) annotation(
    Line(points = {{-107, 60}, {-73, 60}}, color = {0, 0, 127}));
  connect(QPu, aCVoltageControl.QPu) annotation(
    Line(points = {{-107, -88}, {-73, -88}}, color = {0, 0, 127}));
  connect(UPu, aCVoltageControl.UPu) annotation(
    Line(points = {{-107, -76}, {-73, -76}}, color = {0, 0, 127}));
  connect(QRefPu, aCVoltageControl.QRefPu) annotation(
    Line(points = {{-107, -64}, {-75, -64}, {-75, -64}, {-73, -64}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-107, -52}, {-75, -52}, {-75, -52}, {-73, -52}}, color = {0, 0, 127}));
  connect(PPu, activePowerControl.PPu) annotation(
    Line(points = {{-107, 40}, {-73, 40}}, color = {0, 0, 127}));
  connect(PPu, aCVoltageControl.PPu) annotation(
    Line(points = {{-107, 40}, {-94, 40}, {-94, -40}, {-73, -40}}, color = {0, 0, 127}));
  connect(modeU, aCVoltageControl.modeU) annotation(
    Line(points = {{-107, -100}, {-75, -100}, {-75, -100}, {-73, -100}}, color = {255, 0, 255}));
  connect(PPu, POutPu) annotation(
    Line(points = {{-107, 40}, {101, 40}, {101, 40}, {107, 40}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqModPu, iqModPu) annotation(
    Line(points = {{-7, -52}, {101, -52}, {101, -52}, {107, -52}}, color = {0, 0, 127}));
  connect(iqMod1Pu, limitsCalculationFunction.iqMod1Pu) annotation(
    Line(points = {{107, 12}, {76, 12}, {76, 12}, {73, 12}}, color = {0, 0, 127}));
  connect(iqRef1Pu, limitsCalculationFunction.iqRef1Pu) annotation(
    Line(points = {{107, -12}, {73, -12}, {73, -12}, {73, -12}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, initialScale = 0.1)),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-76, 113}, extent = {{-13, 8}, {13, -8}}, textString = "PRefPu"), Text(origin = {-10, 112}, extent = {{-13, 8}, {13, -8}}, textString = "QRefPu"), Text(origin = {55, 112}, extent = {{-13, 8}, {13, -8}}, textString = "URefPu"), Text(origin = {122, 111}, extent = {{-13, 8}, {13, -8}}, textString = "modeU"), Text(origin = {132, 73}, extent = {{-13, 8}, {39, -14}}, textString = "activateDeltaP"), Text(origin = {133, -9}, extent = {{-13, 8}, {1, -6}}, textString = "PPu"), Text(origin = {-114, 58}, extent = {{-13, 8}, {13, -8}}, textString = "ipRefPu"), Text(origin = {-113, -10}, extent = {{-13, 8}, {13, -8}}, textString = "iqRefPu"), Text(origin = {-70, -129}, extent = {{-13, 8}, {1, -6}}, textString = "QPu"), Text(origin = {-26, -129}, extent = {{-13, 8}, {1, -6}}, textString = "PPu"), Text(origin = {23, -128}, extent = {{-13, 8}, {1, -6}}, textString = "UPu"), Text(origin = {64, -128}, extent = {{-13, 8}, {13, -8}}, textString = "blocked"), Text(origin = {116, -125}, extent = {{-13, 8}, {8, -11}}, textString = "UdcPu"), Text(origin = {0, 51}, extent = {{-65, 27}, {65, -27}}, textString = "P Control"), Text(origin = {0, -53}, extent = {{-65, 27}, {65, -27}}, textString = "U/Q Control"), Text(origin = {147, -44}, extent = {{-28, 11}, {1, -6}}, textString = "iqMod1Pu"), Text(origin = {146, 46}, extent = {{-28, 11}, {1, -6}}, textString = "iqModPu"), Text(origin = {-113, -54}, extent = {{-13, 8}, {13, -8}}, textString = "iqRef1Pu")}));
end ActivePowerControlSide;
