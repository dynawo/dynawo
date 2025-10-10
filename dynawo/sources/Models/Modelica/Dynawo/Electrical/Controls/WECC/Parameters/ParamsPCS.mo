within Dynawo.Electrical.Controls.WECC.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsPCS

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Electrical parameters for internal MV network + MV/HV transformer
  parameter Types.PerUnit BMvHvPu = 0 "Shunt susceptance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));
  parameter Types.PerUnit GMvHvPu = 0 "Shunt conductance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));
  parameter Types.PerUnit RMvHvPu = 0 "Serial resistance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));
  parameter Types.PerUnit XMvHvPu = 0 "Serial reactance of internal MV network + MV/HV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));
  parameter Types.PerUnit rTfoPu = 1 "Transformation ratio in pu: UWT_terminal/UWTG_terminal in no load conditions" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));

  //Parameters for LV transformer
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom)" annotation(
    Dialog(tab = "LV transformer"));

  //Configuration parameters to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl = true "Boolean parameter to choose whether the converter is controlling at its output (LV side of its transformer) : True ; or after its transformer (MV side): False" annotation(
    Dialog(tab = "LV transformer"));
  parameter Boolean PPCLocal = true "Boolean parameter to choose whether the Power Park Control is controlling at model's output terminal (True) or at a remote terminal using external measurements (False)" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));

  // In every cases (RPcsPu + j*XPcsPu) and (GPcsPu + j*BPcsPu) are respectively the serial impedance and shunt admittance between WT terminal and model's output terminal
  //Depending on the 4 possible combinations of (ConverterLVControl ; PPCLocal) we are correctly defining these parameters
  final parameter Types.PerUnit BPcsPu = if PPCLocal then BMvHvPu else 1e-5 "Shunt susceptance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit GPcsPu = if PPCLocal then GMvHvPu else 1e-5 "Shunt conductance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit RPcsPu = if PPCLocal and ConverterLVControl then RLvTrPu + RMvHvPu elseif PPCLocal and not ConverterLVControl then RMvHvPu
   elseif not PPCLocal and ConverterLVControl then RLvTrPu else 1e-5 "Serial resistance between WT terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPcsPu = if PPCLocal and ConverterLVControl then XLvTrPu + XMvHvPu elseif PPCLocal and not ConverterLVControl then XMvHvPu
   elseif not PPCLocal and ConverterLVControl then XLvTrPu else 1e-5 "Serial reactance between WT terminal and model's output terminal in pu (base UNom, SNom)";

  // In every cases (RPu + j*XPu) is the serial impedance between converter's output and WT terminal
  //Depending on the value of ConverterLVControl we are correctly defining these parameters
  final parameter Types.PerUnit RPu = if ConverterLVControl then 1e-5 else RLvTrPu "Serial resistance between converter output and WT terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPu = if ConverterLVControl then 1e-5 else XLvTrPu "Serial reactance between converter output and WT terminal in pu (base UNom, SNom)";

  annotation(preferredView = "text");
end ParamsPCS;
