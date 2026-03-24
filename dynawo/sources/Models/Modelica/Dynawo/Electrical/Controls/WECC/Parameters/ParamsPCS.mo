within Dynawo.Electrical.Controls.WECC.Parameters;

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

record ParamsPCS
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsLvTfo;

  //Nominal parameter
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

  //Configuration parameter to define how the user wants to represent the internal network
  parameter Boolean PPCLocal = true "If true, the Power Park Control is controlling at model's output terminal, if false, at a remote terminal using external measurements" annotation(
    Dialog(tab = "MV network + MV/HV transformer"));

  // In every case (RPcsPu + j*XPcsPu) and (GPcsPu + j*BPcsPu) are respectively the serial impedance and shunt admittance between converter terminal and model's output terminal
  //Depending on the 4 possible combinations of (ConverterLVControl ; PPCLocal) we are correctly defining these parameters
  final parameter Types.PerUnit BPcsPu = if PPCLocal then BMvHvPu else 1e-5 "Shunt susceptance between converter terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit GPcsPu = if PPCLocal then GMvHvPu else 1e-5 "Shunt conductance between converter terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit RPcsPu = if PPCLocal and ConverterLVControl then RLvTrPu + RMvHvPu elseif PPCLocal and not ConverterLVControl then RMvHvPu
   elseif not PPCLocal and ConverterLVControl then RLvTrPu else 1e-5 "Serial resistance between converter terminal and model's output terminal in pu (base UNom, SNom)";
  final parameter Types.PerUnit XPcsPu = if PPCLocal and ConverterLVControl then XLvTrPu + XMvHvPu elseif PPCLocal and not ConverterLVControl then XMvHvPu
   elseif not PPCLocal and ConverterLVControl then XLvTrPu else 1e-5 "Serial reactance between converter terminal and model's output terminal in pu (base UNom, SNom)";

  annotation(preferredView = "text");
end ParamsPCS;
