within Dynawo.Electrical.Machines.Motors.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

partial model BaseMotor "Base model for motors"
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffMotor;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the motor in MVA";

  input Types.ComplexVoltagePu V "Complex AC voltage in pu (base UNom)";
  Connectors.ImPin omegaRefPu(value(start = SystemBase.omegaRef0Pu)) "Network angular reference frequency in pu (base omegaNom)";

  Types.ActivePowerPu PPu(start = s0Pu.re) "Active power at load terminal in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QPu(start = s0Pu.im) "Reactive power at load terminal in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu SPu(re(start = s0Pu.re), im(start = s0Pu.im)) "Apparent power at load terminal in pu (base SnRef) (receptor convention)";

  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at load terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexApparentPowerPu s0Pu "Start value of apparent power at load terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at load terminal in pu (base UNom)";

equation
  SPu = Complex(PPu, QPu);

  annotation(preferredView = "text");
end BaseMotor;
