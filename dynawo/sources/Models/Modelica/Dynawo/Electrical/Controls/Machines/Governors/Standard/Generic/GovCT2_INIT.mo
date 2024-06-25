within Dynawo.Electrical.Controls.Machines.Governors.Standard.Generic;

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

model GovCT2_INIT "Initialisation model for GovCT2 generic governor"
  extends AdditionalIcons.Init;

  //Parameters (use the same names as in the simulation model)
    parameter Types.PerUnit RPu "Permanent droop in pu";

  //Input parameter (use the same name as the corresponding **parameter** in the simulation model)
  Modelica.Blocks.Interfaces.RealInput Pm0Pu "Initial mechanical power in pu (base PNom)";

  //Output parameter (use the same name as the corresponding **parameter** in the simulation model)
  Modelica.Blocks.Interfaces.RealOutput PRef0Pu "Initial reference mechanical power in pu (base PNom)";
  
  
equation
  
  PRef0Pu = Pm0Pu * RPu;
  
  annotation(preferredView = "text");
end GovCT2_INIT;
