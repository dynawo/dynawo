within Dynawo.Electrical.HVDC.Standard;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HVDCStandard "HVDC Standard model"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  Dynawo.Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {-80, -50}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {80, -50}, extent = {{-40, -40}, {40, 40}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu UdcRefMaxPu "Maximum value of the DC voltage reference in p.u (base UNom)";
  parameter Types.VoltageModulePu UdcRefMinPu "Minimum value of the DC voltage reference in p.u (base UNom)";
  parameter Types.PerUnit Kpdc "Proportional coefficient of the PI controller for the dc voltage control";
  parameter Types.PerUnit Kidc "Integral coefficient of the PI controller for the dc voltage control";
  parameter Types.PerUnit IpMaxcstPu "Maximum value of the active current in p.u (base SNom, UNom)";
  parameter Types.CurrentModulePu DUDC "Deadband for the activate DeltaP function";
  parameter Real tableQMaxPPu[:,:]=[-1,2;-0.5,2;0,2;0.5,2;1,2] "PQ diagram for Q>0";
  parameter Real tableQMaxUPu[:,:]=[0,2;0.25,2;0.5,2;0.75,2;1,2] "UQ diagram for Q>0";
  parameter Real tableQMinPPu[:,:]=[-1,-2;-0.5,-2;0,-2;0.5,-2;1,-2] "PQ diagram for Q<0";
  parameter Real tableQMinUPu[:,:]=[0,-2;0.25,-2;0.5,-2;0.75,-2;1,-2] "UQ diagram for Q<0";
  parameter Real tableiqMod[:,:]=[0,0;1,0;2,0;3,0] "iqMod diagram";
  parameter Types.PerUnit SlopeURefPu "Slope of the ramp of URefPu";
  parameter Types.PerUnit SlopeQRefPu "Slope of the ramp of QRefPu";
  parameter Types.PerUnit Lambda "Lambda coefficient for the QRefUPu calculation";
  parameter Types.PerUnit Kiacvoltagecontrol "Integral coefficient of the PI controller for the ac voltage control";
  parameter Types.PerUnit Kpacvoltagecontrol "Proportional coefficient of the PI controller for the ac voltage control";
  parameter Types.ReactivePowerPu QMinCombPu "Minimum combined reactive power in p.u (base SNom)";
  parameter Types.ReactivePowerPu QMaxCombPu "Maximum combined reactive power in p.u (base SNom)";
  parameter Types.PerUnit DeadBandU "Deadband for the QRefUPu calculation";
  parameter Types.ReactivePowerPu QMinOPPu "Minimum operator value of the reactive power in p.u (base SNom)";
  parameter Types.ReactivePowerPu QMaxOPPu "Maximum operator value of the reactive power in p.u (base SNom)";
  parameter Types.Time TQ "Time constant of the first order filter for the ac voltage control";
  parameter Types.CurrentModulePu InPu "Nominal current in p.u (base SNom, UNom)";
  parameter Types.PerUnit Kppcontrol "Proportional coefficient of the PI controller for the active power control";
  parameter Types.PerUnit Kipcontrol "Integral coefficient of the PI controller for the active power control";
  parameter Types.ActivePowerPu PMaxOPPu "Maximum operator value of the active power in p.u (base SNom)";
  parameter Types.ActivePowerPu PMinOPPu "Minimum operator value of the active power in p.u (base SNom)";
  parameter Types.Time SlopePRefPu "Slope of the ramp of PRefPu";
  parameter Types.VoltageModulePu UdcMinPu "Minimum value of the DC voltage in p.u (base UNom)";
  parameter Types.VoltageModulePu UdcMaxPu "Maximum value of the DC voltage in p.u (base UNom)";
  parameter Types.PerUnit Kpdeltap "Proportional coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.PerUnit Kideltap "Integral coefficient of the PI controller for the calculation of DeltaP";
  parameter Types.PerUnit SlopeRPFault "Slope of the recovery of rpfault after a fault in p.u/s";
  parameter Types.PerUnit RdcPu "DC line resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit CdcPu "DC line capacitance in p.u (base UNom, SNom)";
  parameter Types.VoltageModulePu UBlockUVPu "Minimum voltage that triggers the blocking function in p.u (base UNom)";
  parameter Types.Time TBlockUV "If UPu < UBlockUVPu during TBlockUV then the blocking is activated";
  parameter Types.Time TBlock "The blocking is activated during at least TBlock";
  parameter Types.Time TDeblockU "When UPu goes back between UMindbPu and UMaxdbPu for TDeblockU then the blocking is deactivated";
  parameter Types.VoltageModulePu UMindbPu "Minimum voltage that deactivate the blocking function in p.u (base UNom)";
  parameter Types.VoltageModulePu UMaxdbPu "Maximum voltage that deactivate the blocking function in p.u (base UNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  Modelica.Blocks.Interfaces.RealInput QRef1Pu(start = - Q10Pu) "Reactive power reference for the side 1 of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = - P10Pu) "Active power reference of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef1Pu(start = U10Pu) "Voltage reference for the side 1 of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput modeU1(start = 1) "Real assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput QRef2Pu(start = - Q20Pu) "Reactive power reference for the side 2 of the HVDC link in p.u (base SNom) and in generator convention" annotation(
    Placement(visible = true, transformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput URef2Pu(start = U20Pu) "Voltage reference for the side 2 of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UdcRefPu(start = Udc20Pu) "DC voltage reference of the HVDC link in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput modeU2(start = 1) "Boolean assessing the mode of the control: 1 if U mode, 0 if Q mode" annotation(
    Placement(visible = true, transformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {90, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Dynawo.Electrical.HVDC.Standard.DCVoltageControlSide UdcPu_Side(DUDC = DUDC, DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip20Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq20Pu, Kiacvoltagecontrol = Kiacvoltagecontrol, Kidc = Kidc, Kpacvoltagecontrol = Kpacvoltagecontrol, Kpdc = Kpdc, Lambda = Lambda, P0Pu = - P20Pu, Q0Pu = - Q20Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopeQRefPu = SlopeQRefPu, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U20Pu, Udc0Pu = Udc20Pu, UdcRefMaxPu = UdcRefMaxPu, UdcRefMinPu = UdcRefMinPu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.ActivePowerControlSide PPu_Side(DeadBandU = DeadBandU, InPu = InPu, Ip0Pu = Ip10Pu, IpMaxcstPu = IpMaxcstPu, Iq0Pu = Iq10Pu, Kiacvoltagecontrol = Kiacvoltagecontrol, Kideltap = Kideltap, Kipcontrol = Kipcontrol, Kpacvoltagecontrol = Kpacvoltagecontrol, Kpdeltap = Kpdeltap, Kppcontrol = Kppcontrol, Lambda = Lambda, P0Pu = - P10Pu, PMaxOPPu = PMaxOPPu, PMinOPPu = PMinOPPu, Q0Pu = - Q10Pu, QMaxCombPu = QMaxCombPu, QMaxOPPu = QMaxOPPu, QMinCombPu = QMinCombPu, QMinOPPu = QMinOPPu, SlopePRefPu = SlopePRefPu, SlopeQRefPu = SlopeQRefPu, SlopeRPFault = SlopeRPFault, SlopeURefPu = SlopeURefPu, TQ = TQ, U0Pu = U10Pu, Udc0Pu = Udc10Pu, UdcMaxPu = UdcMaxPu, UdcMinPu = UdcMinPu, tableQMaxPPu = tableQMaxPPu, tableQMaxUPu = tableQMaxUPu, tableQMinPPu = tableQMinPPu, tableQMinUPu = tableQMinUPu, tableiqMod = tableiqMod)  annotation(
    Placement(visible = true, transformation(origin = {-80, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.HVDC.Standard.BlockingFunction.GeneralBlockingFunction Blocking(TBlock = TBlock, TBlockUV = TBlockUV, TDeblockU = TDeblockU, UBlockUVPu = UBlockUVPu, UMaxdbPu = UMaxdbPu, UMindbPu = UMindbPu, U10Pu = U10Pu, U20Pu = U20Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.HVDC.Standard.DCLine.DCLine dCLine(CdcPu = CdcPu, P10Pu = - P10Pu, P20Pu = - P20Pu, RdcPu = RdcPu, U1dc0Pu = Udc10Pu, U2dc0Pu = Udc20Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv1(Id0Pu = Ip10Pu, Iq0Pu = Iq10Pu, P0Pu = - P10Pu, Q0Pu = - Q10Pu, SNom = SNom, U0Pu = U10Pu, UPhase0 = UPhase10, i0Pu = i10Pu, s0Pu = s10Pu, u0Pu = u10Pu)  annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorIDQ Conv2(Id0Pu = Ip20Pu, Iq0Pu = Iq20Pu, P0Pu = - P20Pu, Q0Pu = - Q20Pu, SNom = SNom, U0Pu = U20Pu, UPhase0 = UPhase20, i0Pu = i20Pu, s0Pu = s20Pu, u0Pu = u20Pu)  annotation(
    Placement(visible = true, transformation(origin = {50, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean annotation(
    Placement(visible = true, transformation(origin = {-30, 88}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Math.RealToBoolean realToBoolean1 annotation(
    Placement(visible = true, transformation(origin = {90, 88}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

protected

  parameter Types.VoltageModulePu U10Pu;
  parameter Types.Angle UPhase10;
  parameter Types.ActivePowerPu P10Pu;
  parameter Types.ReactivePowerPu Q10Pu;
  parameter Types.ComplexVoltagePu u10Pu;
  parameter Types.ComplexCurrentPu i10Pu;
  parameter Types.ComplexApparentPowerPu s10Pu;
  parameter Types.VoltageModulePu Udc10Pu;
  parameter Types.PerUnit Ip10Pu;
  parameter Types.PerUnit Iq10Pu;

  parameter Types.VoltageModulePu U20Pu;
  parameter Types.Angle UPhase20;
  parameter Types.ActivePowerPu P20Pu;
  parameter Types.ReactivePowerPu Q20Pu;
  parameter Types.ComplexVoltagePu u20Pu;
  parameter Types.ComplexCurrentPu i20Pu;
  parameter Types.ComplexApparentPowerPu s20Pu;
  parameter Types.VoltageModulePu Udc20Pu;
  parameter Types.PerUnit Ip20Pu;
  parameter Types.PerUnit Iq20Pu;

equation

  connect(PPu_Side.iqRefPu, Conv1.iqPu) annotation(
    Line(points = {{-73, 9}, {-73, 9}, {-73, -24}, {-62, -24}, {-62, -24}}, color = {0, 0, 127}));
  connect(PPu_Side.ipRefPPu, Conv1.idPu) annotation(
    Line(points = {{-87, 9}, {-87, 9}, {-87, -14}, {-62, -14}, {-62, -14}}, color = {0, 0, 127}));
  connect(UdcPu_Side.ipRefUdcPu, Conv2.idPu) annotation(
    Line(points = {{73, 9}, {73, 9}, {73, -14}, {62, -14}, {62, -14}}, color = {0, 0, 127}));
  connect(UdcPu_Side.iqRefPu, Conv2.iqPu) annotation(
    Line(points = {{87, 9}, {87, 9}, {87, -24}, {62, -24}, {62, -24}}, color = {0, 0, 127}));
  connect(Conv1.UPu, Blocking.U1Pu) annotation(
    Line(points = {{-38, -12}, {-3, -12}, {-3, 48}, {-3, 48}}, color = {0, 0, 127}));
  connect(Conv2.UPu, Blocking.U2Pu) annotation(
    Line(points = {{38, -12}, {3, -12}, {3, 48}, {3, 48}}, color = {0, 0, 127}));
  connect(UdcPu_Side.activateDeltaP, PPu_Side.activateDeltaP) annotation(
    Line(points = {{69, 20}, {-68, 20}, {-68, 20}, {-69, 20}}, color = {255, 0, 255}));
  connect(Blocking.blocked, PPu_Side.blocked) annotation(
    Line(points = {{0, 71}, {0, 80}, {-95, 80}, {-95, 20}, {-91, 20}}, color = {255, 0, 255}));
  connect(Blocking.blocked, UdcPu_Side.blocked) annotation(
    Line(points = {{0, 71}, {0, 80}, {95, 80}, {95, 20}, {91, 20}}, color = {255, 0, 255}));
  connect(Conv1.UPu, PPu_Side.UPu) annotation(
    Line(points = {{-38, -12}, {-3, -12}, {-3, 23}, {-69, 23}, {-69, 23}}, color = {0, 0, 127}));
  connect(Conv2.UPu, UdcPu_Side.UPu) annotation(
    Line(points = {{38, -12}, {3, -12}, {3, 23}, {69, 23}, {69, 23}}, color = {0, 0, 127}));
  connect(Conv1.PInjPu, PPu_Side.PPu) annotation(
    Line(points = {{-38, -16}, {-20, -16}, {-20, 17}, {-69, 17}, {-69, 17}}, color = {0, 0, 127}));
  connect(Conv2.PInjPu, UdcPu_Side.PPu) annotation(
    Line(points = {{38, -16}, {20, -16}, {20, 17}, {69, 17}, {69, 17}}, color = {0, 0, 127}));
  connect(Conv1.QInjPu, PPu_Side.QPu) annotation(
    Line(points = {{-38, -19}, {-10, -19}, {-10, 27}, {-69, 27}, {-69, 27}}, color = {0, 0, 127}));
  connect(Conv2.QInjPu, UdcPu_Side.QPu) annotation(
    Line(points = {{39, -19}, {10, -19}, {10, 27}, {69, 27}, {69, 27}}, color = {0, 0, 127}));
  connect(dCLine.U2dcPu, UdcPu_Side.UdcPu) annotation(
    Line(points = {{6, -29}, {6, -29}, {6, 13}, {69, 13}, {69, 13}}, color = {0, 0, 127}));
  connect(dCLine.U1dcPu, PPu_Side.UdcPu) annotation(
    Line(points = {{-6, -29}, {-6, -29}, {-6, 13}, {-69, 13}, {-69, 13}}, color = {0, 0, 127}));
  connect(Conv1.PInjPu, dCLine.P1Pu) annotation(
    Line(points = {{-38, -16}, {-20, -16}, {-20, -60}, {-3, -60}, {-3, -51}, {-3, -51}}, color = {0, 0, 127}));
  connect(Conv2.PInjPu, dCLine.P2Pu) annotation(
    Line(points = {{39, -16}, {20, -16}, {20, -60}, {3, -60}, {3, -51}, {3, -51}}, color = {0, 0, 127}));
  connect(QRef1Pu, PPu_Side.QRefPu) annotation(
    Line(points = {{-90, 110}, {-90, 110}, {-90, 60}, {-89, 60}, {-89, 31}, {-89, 31}}, color = {0, 0, 127}));
  connect(URef1Pu, PPu_Side.URefPu) annotation(
    Line(points = {{-70, 110}, {-70, 110}, {-70, 60}, {-83, 60}, {-83, 31}, {-83, 31}}, color = {0, 0, 127}));
  connect(PRefPu, PPu_Side.PRefPu) annotation(
    Line(points = {{-50, 110}, {-50, 110}, {-50, 50}, {-77, 50}, {-77, 31}, {-77, 31}}, color = {0, 0, 127}));
  connect(UdcRefPu, UdcPu_Side.UdcRefPu) annotation(
    Line(points = {{70, 110}, {70, 110}, {70, 60}, {83, 60}, {83, 31}, {83, 31}}, color = {0, 0, 127}));
  connect(URef2Pu, UdcPu_Side.URefPu) annotation(
    Line(points = {{50, 110}, {50, 110}, {50, 50}, {77, 50}, {77, 31}, {77, 31}}, color = {0, 0, 127}));
  connect(QRef2Pu, UdcPu_Side.QRefPu) annotation(
    Line(points = {{30, 110}, {30, 110}, {30, 40}, {71, 40}, {71, 31}, {71, 31}}, color = {0, 0, 127}));
  connect(Conv1.terminal, terminal1) annotation(
    Line(points = {{-38, -28}, {-30, -28}, {-30, -50}, {-80, -50}, {-80, -50}}, color = {0, 0, 255}));
  connect(Conv2.terminal, terminal2) annotation(
    Line(points = {{39, -28}, {30, -28}, {30, -50}, {80, -50}, {80, -50}}, color = {0, 0, 255}));
 connect(modeU1, realToBoolean.u) annotation(
    Line(points = {{-30, 110}, {-30, 110}, {-30, 94}, {-30, 94}}, color = {0, 0, 127}));
 connect(realToBoolean.y, PPu_Side.modeU) annotation(
    Line(points = {{-30, 83}, {-30, 83}, {-30, 40}, {-71, 40}, {-71, 31}, {-71, 31}}, color = {255, 0, 255}));
 connect(modeU2, realToBoolean1.u) annotation(
    Line(points = {{90, 110}, {90, 110}, {90, 94}, {90, 94}}, color = {0, 0, 127}));
 connect(realToBoolean1.y, UdcPu_Side.modeU) annotation(
    Line(points = {{90, 83}, {90, 83}, {90, 40}, {89, 40}, {89, 31}, {89, 31}}, color = {255, 0, 255}));
  annotation(preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1})),
    Icon(coordinateSystem(grid = {1, 1})));
end HVDCStandard;
