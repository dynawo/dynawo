within Dynawo.Electrical.Switches;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model IdealSwitchGeneratorAux_INIT "Initialization model for ideal switch with auxiliary"
  extends AdditionalIcons.Init;

  // Start values at network side
  parameter Types.ActivePowerPu P10Pu "Start value of active power at network side in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at network side in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at network side in pu (base U1Nom)";
  parameter Types.Angle U1Phase0 "Start value of voltage angle at network side in rad";

  // Start values for LV auxiliary
  Dynawo.Connectors.ActivePowerPuConnector PAuxLV0Pu "Start value of LV auxiliary active power in pu (base SnRef) (receptor convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QAuxLV0Pu "Start value of LV auxiliary reactive power in pu (base SnRef) (receptor convention)";

  // Start values at network side
  Types.ActivePowerPu PSw10Pu "Start value of active power at transformer network side in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QSw10Pu "Start value of reactive power at transformer network side in pu (base SnRef) (receptor convention)";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at network side (base U1Nom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at transformer network side in pu (base SnRef) (receptor convention)";
  Types.ComplexCurrentPu i10Pu "Start value of complex current at transforer network side (base U1Nom, SnRef) (receptor convention)";

  // Start values at generator side
  Dynawo.Connectors.ComplexVoltagePuConnector u20Pu "Start value of complex voltage at generator side (base U2Nom)";
  Types.ComplexCurrentPu i20Pu "Start value of complex current at transformer generator side (base U2Nom, SnRef) (receptor convention)";
  Dynawo.Connectors.VoltageModulePuConnector U20Pu "Start value of voltage amplitude at generator side in pu (base U2Nom)";
  Dynawo.Connectors.ActivePowerPuConnector P20Pu "Start value of active power at generator side in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector Q20Pu "Start value of reactive power at generator side in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.AngleConnector U2Phase0 "Start value of voltage angle in rad";

equation
  // Variables at network side
  PSw10Pu = P10Pu;
  QSw10Pu = Q10Pu;
  s10Pu = Complex(PSw10Pu, QSw10Pu);
  u10Pu = ComplexMath.fromPolar(U10Pu, U1Phase0);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);

  // Variables at generator side (taking LV auxiliary into account)
  P20Pu = - ComplexMath.real(u20Pu * ComplexMath.conj(i20Pu)) - PAuxLV0Pu;
  Q20Pu = - ComplexMath.imag(u20Pu * ComplexMath.conj(i20Pu)) - QAuxLV0Pu;
  U20Pu = ComplexMath.'abs'(u20Pu);
  U2Phase0 = ComplexMath.arg(u20Pu);

  // Switch equations
  u10Pu = u20Pu;
  i10Pu = - i20Pu;

  annotation(preferredView = "text");
end IdealSwitchGeneratorAux_INIT;
