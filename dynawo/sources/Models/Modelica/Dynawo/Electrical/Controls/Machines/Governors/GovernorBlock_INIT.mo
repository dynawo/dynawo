within Dynawo.Electrical.Controls.Machines.Governors;

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

model GovernorBlock_INIT "Initialisation model for governor"
  // only retrieves initial mechanical torque from whole generator model
  // In steady-state, omegaPu is supposed = 1
  
  public
    SIunits.PerUnit Pm0Pu (start = 1) "Initial mechanical power";
    
end GovernorBlock_INIT;
