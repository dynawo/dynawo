within Dynawo.Electrical.HVDC.HvdcVsc;

/*
* Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcVscDanglingP_INIT "Initialisation model for the HVDC VSC model with terminal2 connected to a switched-off bus (P control on terminal 1)"
  extends AdditionalIcons.Init;

  parameter Types.PerUnit LambdaPu "Lambda coefficient for the QRefUPu calculation in pu (base SNom, UNom)";
  parameter Boolean ModeU1Set "Set mode of control on side 1 : if true, U mode, if false, Q mode";
  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";

  parameter Types.ActivePowerPu P10Pu "Start value of active power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.ReactivePowerPu Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (AC to DC)";
  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at terminal 1 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at terminal 1 in rad";

  Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in pu (base SnRef, UNom) (AC to DC)";
  Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  Boolean ModeU10 "Initial mode of control on side 1 : if true, U mode, if false, Q mode";
  Types.ActivePowerPu PRef0Pu "Start value of active power reference in pu (base SNom) (DC to AC)";
  Types.ReactivePowerPu QRef10Pu "Start value of reactive power reference at terminal 1 in pu (base SNom) (DC to AC)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in pu (base SnRef) (AC to DC)";
  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  Dynawo.Connectors.VoltageModulePuConnector URef10Pu "Start value of the voltage reference for the side 1 of the HVDC link in pu (base UNom)";

equation
  u10Pu = ComplexMath.fromPolar(U10Pu, UPhase10);
  s10Pu = Complex(P10Pu, Q10Pu);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);
  P10Pu = - U10Pu * Ip10Pu * (SNom / SystemBase.SnRef);
  Q10Pu = U10Pu * Iq10Pu * (SNom / SystemBase.SnRef);
  QRef10Pu = - Q10Pu * (SystemBase.SnRef / SNom);
  PRef0Pu = - P10Pu * (SystemBase.SnRef / SNom);
  URef10Pu = U10Pu - LambdaPu * Q10Pu * (SystemBase.SnRef / SNom);
  ModeU10 = ModeU1Set;

  annotation(preferredView = "text");
end HvdcVscDanglingP_INIT;
