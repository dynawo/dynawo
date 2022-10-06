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

package BaseClasses

  extends Icons.BasesPackage;

  partial model BaseGeneratorSimplified "Base model for simplified generator models"
    import Dynawo.Connectors;
    import Dynawo.Electrical.Controls.Basics.SwitchOff;
    extends SwitchOff.SwitchOffGenerator;

    Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the synchronous generator to the grid" annotation(
      Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

    parameter Types.VoltageModulePu U0Pu "Start value of voltage at terminal amplitude in pu (base UNom)";
    parameter Types.ActivePowerPu PGen0Pu "Start value of active power at terminal in pu (base SnRef) (generator convention)";
    parameter Types.ReactivePowerPu QGen0Pu "Start value of reactive power at terminal in pu (base SnRef) (generator convention)";
    parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at terminal in pu (base UNom)";
    parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base UNom, SnRef) (receptor convention)";

    Types.ComplexApparentPowerPu SGenPu(re(start = PGen0Pu), im(start = QGen0Pu)) "Complex apparent power at terminal in pu (base SnRef) (generator convention)";
    Types.ActivePowerPu PGenPu(start = PGen0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QGenPu(start = QGen0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";
    Types.VoltageModulePu UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNom)";

  equation
    SGenPu = Complex(PGenPu, QGenPu);
    SGenPu = -terminal.V * ComplexMath.conj(terminal.i);
    if running.value then
      UPu = ComplexMath.'abs'(terminal.V);
    else
      UPu = 0;
    end if;

    annotation(preferredView = "text");
  end BaseGeneratorSimplified;

annotation(preferredView = "text");
end BaseClasses;
