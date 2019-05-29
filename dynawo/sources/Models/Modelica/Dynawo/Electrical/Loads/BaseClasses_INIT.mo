within Dynawo.Electrical.Loads;

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

package BaseClasses_INIT

partial model BaseLoadInterfaceVariables_INIT "Base model for load initialization"

  protected
    Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in p.u (base UNom)";
    Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power in p.u (base SnRef) (receptor convention)";
    flow Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in p.u (base UNom, SnRef) (receptor convention)";

end BaseLoadInterfaceVariables_INIT;

partial model BaseLoadInterfaceParameters_INIT "Base model for load initialization from load flow"

  parameter Types.ActivePowerPu P0Pu  "Start value of active power in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";

  equation
    s0Pu = Complex(P0Pu, Q0Pu);

end BaseLoadInterfaceParameters_INIT;

end BaseClasses_INIT;
