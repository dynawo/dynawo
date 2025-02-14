within Dynawo;

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

package Types "Standard types for electrical variables"
  extends Icons.TypesPackage;

  // Voltage
  record Voltage = Complex(redeclare VoltageComponent re "Real part of complex voltage",
                           redeclare VoltageComponent im "Imaginary part of complex voltage") "Complex voltage";
  type VoltageComponent = Real(final unit="kV") "Real or imaginary part of complex voltage";
  type VoltageModule = Real(final unit="kV") "Voltage module";

  // Current
  record Current = Complex(redeclare CurrentComponent re "Real part of complex current",
                           redeclare CurrentComponent im "Imaginary part of complex current") "Complex current";
  type CurrentComponent = Real(final unit = "kA") "Real or imaginary part of complex current";
  type CurrentModule = Real(final unit = "kA") "Current module";

  // Power
  record ApparentPower = Complex(redeclare ActivePower re "Real part of complex apparent power",
                                 redeclare ReactivePower im "Imaginary part of complex apparent power") "Complex apparent power";
  type ApparentPowerModule = Real(final unit = "MVA") "Apparent power module";
  type ActivePower = Real(final unit = "MW") "Active power";
  type ReactivePower = Real(final unit = "Mvar") "Reactive power";

  // Angle
  type Angle = Real(final unit = "rad") "Angle";
  connector AngleConnector = Real(final unit = "rad") "Angle";
  type AngularVelocity = Real(final unit = "rad/s") "Angular velocity";
  type AngularAcceleration = Real(final unit = "rad/s2") "Angular acceleration";

  // Frequency
  type Frequency = Real(final unit = "Hz") "Frequency";

  // Time
  type Time = Real(final unit = "s") "Time";

  // PerUnit
  record ComplexPerUnit = Complex(redeclare PerUnit re "Real part of complex per unit quantity",
                                  redeclare PerUnit im "Imaginary part of complex per unit quantity") "Complex per unit";
  record ComplexVoltagePu = ComplexPerUnit;
  record ComplexCurrentPu = ComplexPerUnit;
  record ComplexApparentPowerPu = ComplexPerUnit;
  record ComplexImpedancePu = ComplexPerUnit;
  record ComplexAdmittancePu = ComplexPerUnit;

  type PerUnit = Real(unit = "1") "Per unit quantity";
  type VoltageModulePu = PerUnit;
  type CurrentModulePu = PerUnit;
  type ApparentPowerModulePu = PerUnit;
  type ActivePowerPu = PerUnit;
  type ReactivePowerPu = PerUnit;
  type ApparentPowerPu = PerUnit;
  type AngularVelocityPu = PerUnit;
  type AngularAccelerationPu = PerUnit;

  connector ComplexPerUnitConnector = Complex(redeclare PerUnit re "Real part of complex per unit quantity",
                                  redeclare PerUnit im "Imaginary part of complex per unit quantity") "Complex per unit";
  connector ComplexVoltagePuConnector = ComplexPerUnitConnector;
  connector ComplexCurrentPuConnector = ComplexPerUnitConnector;


  connector PerUnitConnector = Real(unit = "1") "Per unit quantity";
  connector VoltageModulePuConnector = PerUnitConnector;
  connector CurrentModulePuConnector = PerUnitConnector;
  connector ActivePowerPuConnector = PerUnitConnector;
  connector ReactivePowerPuConnector = PerUnitConnector;

  // Percent
  type Percent = Real(unit = "100") "Percent quantity";

  annotation(preferredView = "text");
end Types;
