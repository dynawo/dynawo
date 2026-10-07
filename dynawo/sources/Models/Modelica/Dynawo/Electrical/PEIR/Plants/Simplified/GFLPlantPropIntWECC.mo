within Dynawo.Electrical.PEIR.Plants.Simplified;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GFLPlantPropIntWECC "Simplified grid following model with plant control"
extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
parameter Types.PerUnit RPu "Serial resistance between injector output and LvTfo in pu (base UNom, SNom). Including source resistance for voltage source.";
  parameter Types.PerUnit XPu "Serial reactance between injector output and LvTfo in pu (base UNom, SNom). Including source resistance for voltage source.";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional active power reference in pu (base PNom)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Network angular reference frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage amplitude at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  // Output variables
  Connectors.ACPower terminal(V(im(start = u0Pu.im), re(start = u0Pu.re)), i(im(start = i0Pu.im), re(start = i0Pu.re))) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 2}, extent = {{-10, -10}, {10, 10}})));
  Types.ActivePowerPu PGenPu(start = -P0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGenPu(start = -Q0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";
  Dynawo.Electrical.Controls.WECC.REPC.REPCa plantControllerPropInt(DDn = DDn, DUp = DUp, DbdPu = DbdPu, EMaxPu = EMaxPu, EMinPu = EMinPu, FDbd1Pu = FDbd1Pu, FDbd2Pu = FDbd2Pu, FEMaxPu = FEMaxPu, FEMinPu = FEMinPu, FreqFlag = FreqFlag, Kc = Kc, Ki = Ki, Kig = Kig, Kp = Kp, Kpg = Kpg, PControl0Pu = PControl0Pu, PConv0Pu = PConv0Pu, PMaxREPCPu = PMaxREPCPu, PMinREPCPu = PMinREPCPu, QControl0Pu = QControl0Pu, QConv0Pu = QConv0Pu, QMaxREPCPu = QMaxREPCPu, QMinREPCPu = QMinREPCPu, RcPu = RPu, RefFlag = RefFlag, SNom = SNom, VCompFlag = VCompFlag, VFrz = VFrz, XcPu = XPu, iControl0Pu = iControl0Pu, tFilterPC = tFilterPC, tFt = tFt, tFv = tFv, tLag = tLag, tpREPC = tpREPC, uControl0Pu = uControl0Pu) annotation(
    Placement(transformation(origin = {10, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.PEIR.Plants.Simplified.BaseControls.InjectorInterface injector(SNom = SNom, i0Pu = i0Pu, U0Pu = U0Pu, u0Pu = u0Pu, PInj0Pu = -P0Pu*SystemBase.SnRef/SNom, QInj0Pu = -Q0Pu*SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}})));

 parameter Types.ComplexCurrentPu iControl0Pu "Initial complex current to be controlled by the PPC coming either from the external bus or from the model's output terminal (receptor convention, base UNom, SnRef)";

equation
  Complex(PGenPu, QGenPu) = -terminal.V*Modelica.ComplexMath.conj(terminal.i);
  connect(URefPu, plantControllerPropInt.URefPu) annotation(
    Line(points = {{-110, -40}, {-110, -39.5}, {10, -39.5}, {10, -11}}, color = {0, 0, 127}));
  connect(plantControllerPropInt.PInjPu, injector.PInjPu) annotation(
    Line(points = {{21, 4}, {30, 4}, {30, 6}, {39, 6}}, color = {0, 0, 127}));
  connect(plantControllerPropInt.QInjPu, injector.QInjPu) annotation(
    Line(points = {{21, -4}, {30, -4}, {30, -6}, {39, -6}}, color = {0, 0, 127}));
  connect(injector.terminal, terminal) annotation(
    Line(points = {{60, 0}, {100, 0}}, color = {0, 0, 255}));
  connect(QRegPu, plantControllerPropInt.QRegPu) annotation(
    Line(points = {{-110, 60}, {-110, 61}, {10, 61}, {10, 11}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, plantControllerPropInt.deltaPmRefPu) annotation(
    Line(points = {{-110, 40}, {-20, 40}, {-20, 7}, {-1, 7}}, color = {0, 0, 127}));
  connect(URegPu, plantControllerPropInt.URegPu) annotation(
    Line(points = {{-110, 20}, {-40, 20}, {-40, 3}, {-1, 3}}, color = {0, 0, 127}));
  connect(omegaRefPu, plantControllerPropInt.omegaRefPu) annotation(
    Line(points = {{-110, -20}, {-20, -20}, {-20, -2}, {0, -2}}, color = {0, 0, 127}));
  annotation(
    Diagram,
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-1, 2}, extent = {{-83, 38}, {83, -38}}, textString = "Grid Following Plant PI Controller")}));
end GFLPlantPropIntWECC;
