within Dynawo.Electrical.Controls.WECC.Parameters.REPC;

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

record REPCaParameters "Parameters for REPCa"
  extends Dynawo.Electrical.Controls.WECC.Parameters.REPC.BaseREPCParameters;

  parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom) (generator convention) (typical: 0..0.43)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCa"));
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom) (generator convention) (typical: -0.43..0)" annotation(
    Dialog(tab = "Plant Controller", group = "REPCa"));

  annotation(
    preferredView = "text");
end REPCaParameters;
