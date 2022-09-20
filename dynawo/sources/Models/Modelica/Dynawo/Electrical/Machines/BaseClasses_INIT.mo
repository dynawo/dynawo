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

package BaseClasses_INIT
  extends Icons.BasesPackage;

  partial model BaseGeneratorParameters_INIT "Base initialization model for simplified generator models"

    parameter Types.ActivePowerPu P0Pu = -19.98/2 "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
    parameter Types.ReactivePowerPu Q0Pu = -9.68/2 "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
    parameter Types.VoltageModulePu U0Pu = 1 "Start value of voltage amplitude at terminal in pu (base UNom)";
    parameter Types.Angle UPhase0 = 0.49 "Start value of voltage angle at terminal in rad";

    Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

    Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
    Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  equation
    u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
    s0Pu = Complex(P0Pu, Q0Pu);
    s0Pu = u0Pu * ComplexMath.conj(i0Pu);

    // Convention change
    PGen0Pu = -P0Pu;
    QGen0Pu = -Q0Pu;

    annotation(preferredView = "text");
  end BaseGeneratorParameters_INIT;

  partial model BaseGeneratorVariables_INIT "Base initialization model for simplified generator models"

    Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
    Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
    Types.VoltageModulePu U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
    Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";

    Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";

    Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
    Types.ComplexApparentPowerPu s0Pu "Start value of complex apparent power at terminal in pu (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

  equation
    u0Pu = ComplexMath.fromPolar(U0Pu, UPhase0);
    s0Pu = Complex(P0Pu, Q0Pu);
    s0Pu = u0Pu * ComplexMath.conj(i0Pu);

    // Convention change
    PGen0Pu = -P0Pu;
    QGen0Pu = -Q0Pu;

    annotation(preferredView = "text");
  end BaseGeneratorVariables_INIT;

annotation(preferredView = "text");
end BaseClasses_INIT;
