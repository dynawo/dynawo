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

record ParamsLvTfo

  //Parameters for LV transformer
  parameter Types.PerUnit RLvTrPu "Serial resistance of LV transformer in pu (base UNom, SNom). Including source resistance for voltage source." annotation(
    Dialog(tab = "LV transformer"));
  parameter Types.PerUnit XLvTrPu "Serial reactance of LV transformer in pu (base UNom, SNom). Including source reactance for voltage source." annotation(
    Dialog(tab = "LV transformer"));

  //Configuration parameter to define how the user wants to represent the internal network
  parameter Boolean ConverterLVControl "If true, the converter is controlling at its output (LV side of its transformer), if false, after its transformer (MV side)" annotation(
    Dialog(tab = "LV transformer"));

  // In every case (RPu + j*XPu) is the serial impedance between converter's output and injector terminal
  //Depending on the value of ConverterLVControl we are correctly defining these parameters
  final parameter Types.PerUnit RPu = if ConverterLVControl then 1e-5 else RLvTrPu "Serial resistance between injector output and LvTfo in pu (base UNom, SNom). Including source resistance for voltage source.";
  final parameter Types.PerUnit XPu = if ConverterLVControl then 1e-5 else XLvTrPu "Serial reactance between injector output and LvTfo in pu (base UNom, SNom). Including source resistance for voltage source.";

  annotation(preferredView = "text");
end ParamsLvTfo;
