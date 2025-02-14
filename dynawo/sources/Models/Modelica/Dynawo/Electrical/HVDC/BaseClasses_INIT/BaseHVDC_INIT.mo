within Dynawo.Electrical.HVDC.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

partial model BaseHVDC_INIT "Base initialization model for HVDC link"
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 in rad";

  parameter Types.ActivePowerPu P20Pu "Start value of active power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu "Start value of reactive power at terminal 2 in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U20Pu "Start value of voltage amplitude at terminal 2 in pu (base UNom)";
  parameter Types.Angle UPhase20 "Start value of voltage angle at terminal 2 in rad";

  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base UNom, SnRef) (receptor convention)";
  Types.ActivePowerPuConnector P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.AngleConnector Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";

  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.AngleConnector Theta20 "Start value of angle of the voltage at terminal 2 in rad";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in pu (base UNom)";

equation
  u10Pu = ComplexMath.fromPolar(U10Pu, UPhase10);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);
  Theta10 = UPhase10;

  u20Pu = ComplexMath.fromPolar(U20Pu, UPhase20);
  s20Pu = Complex(P20Pu, Q20Pu);
  s20Pu = u20Pu * ComplexMath.conj(i20Pu);
  Theta20 = UPhase20;

  annotation(preferredView = "text");
end BaseHVDC_INIT;
