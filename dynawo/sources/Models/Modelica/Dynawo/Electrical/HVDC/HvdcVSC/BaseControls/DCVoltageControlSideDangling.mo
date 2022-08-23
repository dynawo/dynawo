within Dynawo.Electrical.HVDC.HvdcVSC.BaseControls;

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

model DCVoltageControlSideDangling "DC Voltage Control Side for the HVDC VSC model with terminal2 connected to a switched-off bus (Udc control on terminal 1)"
  import Modelica;
  import Dynawo.Electrical.HVDC;
  import Dynawo.Types;

  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_BaseDCVoltageControl;
  extends HVDC.HvdcVSC.BaseControls.Parameters.Params_ACVoltageControl;
  parameter Types.PerUnit RdcPu "DC line resistance in pu (base UdcNom, SnRef)";
  parameter Types.PerUnit IpMaxCstPu "Maximum value of the active current in pu (base SNom, UNom)";
  parameter Types.CurrentModulePu InPu "Nominal current in pu (base SNom, UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = UdcRef0Pu) "Reference DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 75}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcPu(start = Udc0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, 57}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-93,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput blocked(start = false) "Boolean assessing the state of the HVDC link: true if blocked, false if not blocked" annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -76}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {0,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.BooleanInput modeU(start = modeU0) "Boolean assessing the mode of the control: true if U mode, false if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-107, -100}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-99, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = U0Pu + Lambda * Q0Pu) "Reference voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -52}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = Q0Pu) "Reference reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -64}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {33, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QPu(start = Q0Pu) "Reactive power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -88}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {94,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PPu(start = P0Pu) "Active power in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-107, -40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput ipRefUdcPu(start = Ip0Pu) "Active current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, 58}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {107, -70}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {110, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput POutPu annotation(
    Placement(visible = true, transformation(origin = {107, -40}, extent = {{-7, -7}, {7, 7}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  HVDC.HvdcVSC.BaseControls.DCVoltageControl.DCVoltageControlDangling dCVoltageControl(Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu, Kidc = Kidc, Kpdc = Kpdc, RdcPu = RdcPu, SNom = SNom, U0Pu = U0Pu, Udc0Pu = Udc0Pu, UdcRef0Pu = UdcRef0Pu, UdcRefMaxPu = UdcRefMaxPu, UdcRefMinPu = UdcRefMinPu) "DC Voltage Control for HVDC"  annotation(
    Placement(visible = true, transformation(origin = {-40, 70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.ACVoltageControl.ACVoltageControl aCVoltageControl(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip0Pu, Iq0Pu = Iq0Pu, KiACVoltageControl = KiACVoltageControl, KpACVoltageControl = KpACVoltageControl, Lambda = Lambda, P0Pu = P0Pu, Q0Pu = Q0Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U0Pu, modeU0 = modeU0, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod) "AC voltage control for HVDC"  annotation(
    Placement(visible = true, transformation(origin = {-40, -70}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));
  HVDC.HvdcVSC.BaseControls.LimitsCalculationFunction.LimitsCalculationFunctionDangling limitsCalculationFunction(InPu = InPu, Ip0Pu = Ip0Pu, IpMaxCstPu = IpMaxCstPu, Iq0Pu = Iq0Pu) "Reactive and active currents limits calculation function" annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

  parameter Types.VoltageModulePu Udc0Pu "Start value of dc voltage in pu (base SNom, UNom)";
  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power in pu (base SNom) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power in pu (base SNom) (generator convention)";
  parameter Boolean modeU0 "Start value of the boolean assessing the mode of the control: true if U mode, false if Q mode";
  parameter Types.VoltageModulePu UdcRef0Pu "Start value of dc voltage reference in pu (base UdcNom)";

equation
  connect(UdcRefPu, dCVoltageControl.UdcRefPu) annotation(
    Line(points = {{-107, 75}, {-73, 75}}, color = {0, 0, 127}));
  connect(UdcPu, dCVoltageControl.UdcPu) annotation(
    Line(points = {{-107, 57}, {-73, 57}}, color = {0, 0, 127}));
  connect(blocked, aCVoltageControl.blocked) annotation(
    Line(points = {{-80, 0}, {-40, 0}, {-40, -37}, {-40, -37}}, color = {255, 0, 255}));
  connect(limitsCalculationFunction.IqMaxPu, aCVoltageControl.IqMaxPu) annotation(
    Line(points = {{17, -21}, {-16, -21}, {-16, -37}, {-16, -37}}, color = {0, 0, 127}));
  connect(limitsCalculationFunction.IqMinPu, aCVoltageControl.IqMinPu) annotation(
    Line(points = {{17, -9}, {-28, -9}, {-28, -37}, {-28, -37}}, color = {0, 0, 127}));
  connect(dCVoltageControl.ipRefUdcPu, limitsCalculationFunction.ipRefPu) annotation(
    Line(points = {{-7, 58}, {50, 58}, {50, 33}, {50, 33}}, color = {0, 0, 127}));
  connect(dCVoltageControl.ipRefUdcPu, ipRefUdcPu) annotation(
    Line(points = {{-7, 58}, {107, 58}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, iqRefPu) annotation(
    Line(points = {{-7, -70}, {107, -70}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqModPu, limitsCalculationFunction.iqModPu) annotation(
    Line(points = {{-7, -52}, {29, -52}, {29, -33}, {29, -33}}, color = {0, 0, 127}));
  connect(aCVoltageControl.iqRefPu, limitsCalculationFunction.iqRefPu) annotation(
    Line(points = {{-7, -70}, {50, -70}, {50, -33}, {50, -33}}, color = {0, 0, 127}));
  connect(modeU, aCVoltageControl.modeU) annotation(
    Line(points = {{-107, -100}, {-75, -100}, {-75, -100}, {-73, -100}}, color = {255, 0, 255}));
  connect(QPu, aCVoltageControl.QPu) annotation(
    Line(points = {{-107, -88}, {-73, -88}}, color = {0, 0, 127}));
  connect(UPu, aCVoltageControl.UPu) annotation(
    Line(points = {{-107, -76}, {-74, -76}, {-74, -76}, {-73, -76}}, color = {0, 0, 127}));
  connect(QRefPu, aCVoltageControl.QRefPu) annotation(
    Line(points = {{-107, -64}, {-76, -64}, {-76, -64}, {-73, -64}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-107, -52}, {-73, -52}, {-73, -52}, {-73, -52}}, color = {0, 0, 127}));
  connect(URefPu, aCVoltageControl.URefPu) annotation(
    Line(points = {{-107, -52}, {-76, -52}, {-76, -52}, {-73, -52}}, color = {0, 0, 127}));
  connect(PPu, aCVoltageControl.PPu) annotation(
    Line(points = {{-107, -40}, {-75, -40}, {-75, -40}, {-73, -40}}, color = {0, 0, 127}));
  connect(PPu, POutPu) annotation(
    Line(points = {{-107, -40}, {103, -40}, {103, -40}, {107, -40}}, color = {0, 0, 127}));
  connect(UPu, dCVoltageControl.UPu) annotation(
    Line(points = {{-107, -76}, {-80, -76}, {-80, 92}, {-73, 92}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {122, 112}, extent = {{-13, 8}, {20, -12}}, textString = "UdcRefPu"), Text(origin = {54, 111}, extent = {{-13, 8}, {13, -8}}, textString = "QRefPu"), Text(origin = {-10, 111}, extent = {{-13, 8}, {13, -8}}, textString = "URefPu"), Text(origin = {-77, 112}, extent = {{-13, 8}, {13, -8}}, textString = "modeU"), Text(origin = {-110, 11}, extent = {{-13, 8}, {1, -6}}, textString = "PPu"), Text(origin = {124, 53}, extent = {{-13, 8}, {13, -8}}, textString = "ipRefPu"), Text(origin = {123, -13}, extent = {{-13, 8}, {13, -8}}, textString = "iqRefPu"), Text(origin = {116, -126}, extent = {{-13, 8}, {1, -6}}, textString = "QPu"), Text(origin = {68, -128}, extent = {{-13, 8}, {1, -6}}, textString = "PPu"), Text(origin = {23, -128}, extent = {{-13, 8}, {1, -6}}, textString = "UPu"), Text(origin = {-24, -128}, extent = {{-13, 8}, {13, -8}}, textString = "blocked"), Text(origin = {-71, -125}, extent = {{-13, 8}, {8, -11}}, textString = "UdcPu"), Text(origin = {0, 51}, extent = {{-65, 27}, {65, -27}}, textString = "Udc Control"), Text(origin = {0, -53}, extent = {{-65, 27}, {65, -27}}, textString = "U/Q Control")}));
end DCVoltageControlSideDangling;
