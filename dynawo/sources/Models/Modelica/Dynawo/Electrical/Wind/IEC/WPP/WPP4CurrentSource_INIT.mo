within Dynawo.Electrical.Wind.IEC.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model WPP4CurrentSource_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT(
    BesPu = if ConverterLVControl then 0 else BLvTrPu,
    GesPu = if ConverterLVControl then 0 else GLvTrPu,
    ResPu = if ConverterLVControl then 0 else RLvTrPu,
    XesPu = if ConverterLVControl then 0 else XLvTrPu);

  //QControl parameter
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";

  //Electrical parameters for internal MV network + MV/HV transformer
  parameter Types.PerUnit BMvHvPu = 0 "Shunt susceptance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit GMvHvPu = 0 "Shunt conductance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit RMvHvPu = 0 "Serial resistance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));
  parameter Types.PerUnit XMvHvPu = 0 "Serial reactance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer", enable = PPCLocal));

  //Parameters for LV transformer
  parameter Types.PerUnit BLvTrPu "Shunt susceptance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit GLvTrPu "Shunt conductance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));

  //Configuration parameters to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl  "If true, the converter is controlling at its output (LV side of its transformer), if false, after its transformer (MV side)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Boolean PPCLocal "If true, the Power Park Control is controlling at model's output terminal, if false, at a remote terminal using external measurements" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));

  // In every case (RPcsPu + j*XPcsPu) and (GPcsPu + j*BPcsPu) are respectively the serial impedance and shunt admittance between WT terminal and model's output terminal
  //Depending on the 4 possible combinations of (ConverterLVControl ; PPCLocal) we are correctly defining these parameters
  final parameter Types.PerUnit BPcsPu = if PPCLocal and ConverterLVControl then BLvTrPu + BMvHvPu elseif PPCLocal and not ConverterLVControl then BMvHvPu
   elseif not PPCLocal and ConverterLVControl then BLvTrPu else 0 "Shunt susceptance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit GPcsPu = if PPCLocal and ConverterLVControl then GLvTrPu + GMvHvPu elseif PPCLocal and not ConverterLVControl then GMvHvPu
   elseif not PPCLocal and ConverterLVControl then GLvTrPu else 0 "Shunt conductance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit RPcsPu = if PPCLocal and ConverterLVControl then RLvTrPu + RMvHvPu elseif PPCLocal and not ConverterLVControl then RMvHvPu
   elseif not PPCLocal and ConverterLVControl then RLvTrPu else 0 "Serial resistance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPcsPu = if PPCLocal and ConverterLVControl then XLvTrPu + XMvHvPu elseif PPCLocal and not ConverterLVControl then XMvHvPu
   elseif not PPCLocal and ConverterLVControl then XLvTrPu else 0 "Serial reactance between WT terminal and model's output terminal in pu (base UNom, SNom)";

  parameter Types.ActivePowerPu PPcc0Pu = 0 "Initial active power at the external bus controlled by the PPC (used when PPCLocal = False) in pu (base SnRef) (receptor convention) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.ReactivePowerPu QPcc0Pu = 0 "Initial reactive power at the external bus controlled by the PPC (used when PPCLocal = False) in pu (base SnRef) (receptor convention) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.VoltageModulePu UPcc0Pu = 1 "Initial voltage module at the external bus controlled by the PPC (used when PPCLocal = False) in pu (base UNom) (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));
  parameter Types.Angle UPccPhase0 = 0 "Initial voltage angle at the external bus controlled by the PPC (used when PPCLocal = False) in rad (only if the PCS is defined outside of the model)" annotation(
    Dialog(tab = "Operating point", enable = not PPCLocal));

  Types.ComplexCurrentPu iControl0Pu "Initial complex current to be controlled by the PPC coming either from the external bus or from the model's output terminal (receptor convention, base UNom, SnRef)";
  Types.ComplexCurrentPu iWt0Pu "Initial complex current at WT terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ActivePowerPu PControl0Pu "Initial active power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convetion)";
  Types.ReactivePowerPu QControl0Pu "Initial reactive power at the point controlled by the PPC (either model's output terminal or external PCC) (base SNom, generator convention)";
  Types.ComplexVoltagePu uControl0Pu "Initial complex voltage to be controlled by the PPC coming either from the external bus or from the model's output terminal (base UNom)";
  Types.ComplexVoltagePu uWt0Pu "Initial complex voltage at WT terminal in pu (base UNom)";

equation
  if PPCLocal then
    iControl0Pu = i0Pu;
    PControl0Pu = -P0Pu * SystemBase.SnRef / SNom;
    QControl0Pu = -Q0Pu * SystemBase.SnRef / SNom;
    uControl0Pu = u0Pu;
  else
    iControl0Pu * Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0) = Modelica.ComplexMath.conj(Complex(PPcc0Pu, QPcc0Pu));
    PControl0Pu = -PPcc0Pu * SystemBase.SnRef / SNom;
    QControl0Pu = -QPcc0Pu * SystemBase.SnRef / SNom;
    uControl0Pu = Modelica.ComplexMath.fromPolar(UPcc0Pu, UPccPhase0);
  end if;

  iWt0Pu = i0Pu - Complex(GPcsPu, BPcsPu) * (u0Pu * SNom / SystemBase.SnRef - Complex(RPcsPu, XPcsPu) * i0Pu);
  uWt0Pu = u0Pu - Complex(RPcsPu, XPcsPu) * i0Pu * SystemBase.SnRef / SNom;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP4CurrentSource_INIT;
