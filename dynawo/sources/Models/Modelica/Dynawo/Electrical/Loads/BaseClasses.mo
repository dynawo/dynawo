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

package BaseClasses
  extends Icons.BasesPackage;

partial model BaseLoad "Base model for loads"

  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.Electrical.SystemBase;

  extends SwitchOff.SwitchOffLoad;

  public

    Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the load to the grid";

    Connectors.ImPin UPu(value (start = ComplexMath.'abs'(u0Pu))) "Voltage amplitude at load terminal in p.u (base UNom)";

    Types.ActivePowerPu PPu(start = s0Pu.re) "Active power at load terminal in p.u (base SnRef) (receptior convention)";
    Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at load terminal in p.u (base SnRef) (receptor convention)";
    Types.ComplexApparentPowerPu SPu(re (start = s0Pu.re), im (start = s0Pu.im)) "Apparent power at load terminal in p.u (base SnRef) (receptor convention)";

  protected
    parameter Types.ComplexVoltagePu u0Pu  "Start value of complex voltage at load terminal in p.u (base UNom)";
    parameter Types.ComplexApparentPowerPu s0Pu  "Start value of apparent power at load terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.ComplexCurrentPu i0Pu  "Start value of complex current at load terminal in p.u (base UNom, SnRef) (receptor convention)";

  equation

    SPu = Complex(PPu, QPu);
    SPu = terminal.V * ComplexMath.conj(terminal.i);

    if (running.value) then
        UPu.value = ComplexMath.'abs'(terminal.V);
    else
        UPu.value = 0;
    end if;

annotation(preferredView = "text");
end BaseLoad;



end BaseClasses;
