within Dynawo.Electrical.Machines;

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

model GeneratorSynchronousInt_INIT "Synchronous machine - Initialization model from internal parameters"

  extends BaseClasses_INIT.BaseGeneratorSynchronous_INIT;

  public

    // Internal parameters of the synchronous machine given as parameters
    parameter SIunits.PerUnit RaPu "Armature resistance in p.u.";
    parameter SIunits.PerUnit LdPu "Direct axis stator leakage in p.u.";
    parameter SIunits.PerUnit MdPu "Direct axis mutual inductance in p.u.";
    parameter SIunits.PerUnit LDPu "Direct axis damper leakage in p.u.";
    parameter SIunits.PerUnit RDPu "Direct axis damper resistance in p.u.";
    parameter SIunits.PerUnit MrcPu "Canay's mutual inductance in p.u.";
    parameter SIunits.PerUnit LfPu "Excitation winding leakage in p.u.";
    parameter SIunits.PerUnit RfPu "Excitation windings resistance in p.u.";
    parameter SIunits.PerUnit LqPu "Quadrature axis stator leakage in p.u.";
    parameter SIunits.PerUnit MqPu "Quadrature axis mutual inductance in p.u.";
    parameter SIunits.PerUnit LQ1Pu "Quadrature axis 1st damper leakage in p.u.";
    parameter SIunits.PerUnit RQ1Pu "Quadrature axis 1st damper resistance in p.u.";
    parameter SIunits.PerUnit LQ2Pu "Quadrature axis 2nd damper leakage in p.u.";
    parameter SIunits.PerUnit RQ2Pu "Quadrature axis 2nd damper resistance in p.u.";

end GeneratorSynchronousInt_INIT;
