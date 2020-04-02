within Dynawo.Electrical.HVDC.Standard;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model HVDCStandard_INIT "Initialisation model for the HVDC Standard model"
  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";
  parameter Types.PerUnit Lambda "Lambda coefficient for the QRefUPu calculation";
  parameter Types.PerUnit RdcPu "DC line resistance in p.u (base UNom, SNom)";

  parameter Types.VoltageModulePu U10Pu  "Start value of voltage amplitude at terminal 1 in p.u (base UNom)";
  parameter Types.Angle UPhase10  "Start value of voltage angle at terminal 1 (in rad)";
  parameter Types.ActivePowerPu P10Pu  "Start value of active power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power at terminal 1 in p.u (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U20Pu  "Start value of voltage amplitude at terminal 2 in p.u (base UNom)";
  parameter Types.Angle UPhase20  "Start value of voltage angle at terminal 2 (in rad)";
  parameter Types.ActivePowerPu P20Pu  "Start value of active power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power at terminal 2 in p.u (base SnRef) (receptor convention)";
  parameter Real modeU1Set "Set value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  parameter Real modeU2Set "Set value of the real assessing the mode of the control at terminal 2: 1 if U mode, 0 if Q mode";

protected

  Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in p.u (base UNom)";
  Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power at terminal 1 in p.u (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i10Pu "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu u20Pu "Start value of complex voltage at terminal 2 in p.u (base UNom)";
  Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power at terminal 2 in p.u (base SnRef) (receptor convention)";
  flow Types.ComplexCurrentPu i20Pu "Start value of complex current at terminal 2 in p.u (base UNom, SnRef) (receptor convention)";
  Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in p.u (base SNom)";
  Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in p.u (base SNom)";
  Types.PerUnit Ip20Pu "Start value of active current at terminal 2 in p.u (base SNom)";
  Types.PerUnit Iq20Pu "Start value of reactive current at terminal 2 in p.u (base SNom)";
  Types.PerUnit Udc10Pu "Start value of dc voltage at terminal 1 in p.u (base UdcNom)";
  Types.PerUnit Udc20Pu "Start value of dc voltage at terminal 2 in p.u (base UdcNom)";
  Types.VoltageModulePu URef10Pu "Start value of the voltage reference for the side 1 of the HVDC link in p.u (base UNom)";
  Types.VoltageModulePu URef20Pu "Start value of the voltage reference for the side 1 of the HVDC link in p.u (base UNom)";
  Types.ReactivePowerPu QRef10Pu "Start value of reactive power reference at terminal 1 in p.u (base SNom) (generator convention)";
  Types.ReactivePowerPu QRef20Pu "Start value of reactive power reference at terminal 2 in p.u (base SNom) (generator convention)";
  Types.ReactivePowerPu PRef0Pu "Start value of reactive power reference in p.u (base SNom) (generator convention)";
  Real modeU10 "Start value of the real assessing the mode of the control at terminal 1: 1 if U mode, 0 if Q mode";
  Real modeU20 "Start value of the real assessing the mode of the control at terminal 2: 1 if U mode, 0 if Q mode";

equation

  s10Pu = Complex(P10Pu, Q10Pu);
  u10Pu = ComplexMath.fromPolar(U10Pu, UPhase10);
  s10Pu = u10Pu * ComplexMath.conj(i10Pu);
  s20Pu = Complex(P20Pu, Q20Pu);
  u20Pu = ComplexMath.fromPolar(U20Pu, UPhase20);
  s20Pu = u20Pu * ComplexMath.conj(i20Pu);
  P10Pu = - U10Pu * Ip10Pu * (SNom/SystemBase.SnRef);
  Q10Pu = U10Pu * Iq10Pu * (SNom/SystemBase.SnRef);
  P20Pu = - U20Pu * Ip20Pu * (SNom/SystemBase.SnRef);
  Q20Pu = U20Pu * Iq20Pu * (SNom/SystemBase.SnRef);
  Udc10Pu = 1 + RdcPu * P10Pu;
  Udc20Pu = 1;
  QRef10Pu = - Q10Pu * (SystemBase.SnRef/SNom);
  QRef20Pu = - Q20Pu * (SystemBase.SnRef/SNom);
  PRef0Pu = - P10Pu * (SystemBase.SnRef/SNom);
  URef10Pu = U10Pu - Lambda * Q10Pu * (SystemBase.SnRef/SNom);
  URef20Pu = U20Pu - Lambda * Q20Pu * (SystemBase.SnRef/SNom);
  modeU10 = modeU1Set;
  modeU20 = modeU2Set;

annotation(preferredView = "text");
end HVDCStandard_INIT;
