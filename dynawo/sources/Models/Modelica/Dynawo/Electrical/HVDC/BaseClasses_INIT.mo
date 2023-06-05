within Dynawo.Electrical.HVDC;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package BaseClasses_INIT
  extends Icons.BasesPackage;

partial model BasePV_INIT "Base initialization model for PV HVDC"

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePower Q1Nom "Nominal reactive power in Mvar at terminal 1";

  parameter Types.VoltageModulePu U1Ref0Pu "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

  Types.ReactivePowerPu QInj10PuQNom "Reactive power at terminal 1 in pu (base Q1Nom) (generator convention)";
  Types.VoltageModulePu U1Ref0PuVar "Start value of the voltage regulation set point in pu (base UNom) at terminal 1";

equation
  U1Ref0PuVar = U1Ref0Pu;

  annotation(preferredView = "text");
end BasePV_INIT;

partial model BaseDiagramPQDangling_INIT "Base initialization model for PQ diagram at terminal 1"

  parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
  parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";

  annotation(preferredView = "text");
end BaseDiagramPQDangling_INIT;

partial model BaseDiagramPQ_INIT "Base initialization model for PQ diagram"
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;

  parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
  parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";

  annotation(preferredView = "text");
end BaseDiagramPQ_INIT;

partial model BaseQStatusDangling_INIT "Base initialization model for QStatus at terminal 1"

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  Boolean limUQDown10 "Whether the minimum reactive power limits are reached or not at terminal 1, start value";
  Boolean limUQUp10 "Whether the maximum reactive power limits are reached or not at terminal 1, start value";
  QStatus q1Status0 "Start voltage regulation status of terminal 1: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown10 = q1Status0 == QStatus.AbsorptionMax;
  limUQUp10 = q1Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatusDangling_INIT;

partial model BaseQStatus_INIT "Base initialization model for QStatus"
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;

  Boolean limUQDown20 "Whether the minimum reactive power limits are reached or not at terminal 2, start value";
  Boolean limUQUp20 "Whether the maximum reactive power limits are reached or not at terminal 2, start value";
  QStatus q2Status0 "Start voltage regulation status of terminal 2: Standard, AbsorptionMax, GenerationMax";

equation
  limUQDown20 = q2Status0 == QStatus.AbsorptionMax;
  limUQUp20 = q2Status0 == QStatus.GenerationMax;

  annotation(preferredView = "text");
end BaseQStatus_INIT;

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
  Types.ActivePowerPu P1Ref0Pu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.Angle Theta10 "Start value of angle of the voltage at terminal 1 in rad";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";

  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.Angle Theta20 "Start value of angle of the voltage at terminal 2 in rad";
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

annotation(preferredView = "text");
end BaseClasses_INIT;
