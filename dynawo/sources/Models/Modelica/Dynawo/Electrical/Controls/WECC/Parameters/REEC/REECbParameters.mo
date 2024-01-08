within Dynawo.Electrical.Controls.WECC.Parameters.REEC;

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

record REECbParameters "Parameters for REECb"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REEC.BaseREECParameters;

  //REECb parameters
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive output limit in pu (base SNom) (typical: 0..1, set to 9999 to disable, strictly positive)" annotation(
    Dialog(tab = "Electrical Control", group = "REECb"));
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive output limit in pu (base SNom) (typical: -1..0, set to -9999 to disable)" annotation(
    Dialog(tab = "Electrical Control", group = "REECb"));

  annotation(
    preferredView = "text");
end REECbParameters;
