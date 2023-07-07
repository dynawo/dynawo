within Dynawo.Electrical.Controls.WECC.Parameters.REGC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

record REGCcParameters "Parameters for REGCc"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REGC.BaseREGCParameters;

  //REGCc parameters
  parameter Types.CurrentModulePu IMaxGCPu "Maximum current rating of the converter in pu (base SNom, UNom) (typical: 1.1..1.4)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kii "Integral gain of the inner-current control loop in pu/pu/s (base SNom, UNom) (typical: 20..100)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit Kip "Proportional gain of the inner-current control loop in pu/pu (base SNom, UNom) (typical: 1..10)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit KiPll "Integral gain of the PLL in rad/s/pu/s (base SNom, UNom) (typical: 500..3000)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit KpPll "Proportional gain of the PLL in rad/s/pu (base SNom, UNom) (typical: 1..10)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.AngularVelocity OmegaMax "Upper limit of the PLL in rad/s (typical: 1..10)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.AngularVelocity OmegaMin "Lower limit of the PLL in rad/s (typical: -10..-1)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit RSourcePu = 0 "Source resistance in pu (base SNom, UNom) (typical: 0..0.01)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit UPllFrz "If measured terminal voltage is below UPllFrz, then PLL state is frozen; in pu (base UNom) (typical: 0.1..0.5)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.Time tE "Emulated delay in converter controls in s (typical: 0..0.02)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base SNom, UNom) (typical: 0.05..0.2)" annotation(
    Dialog(tab = "Generator Converter", group = "REGCc"));

  annotation(
    preferredView = "text");
end REGCcParameters;
