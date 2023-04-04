within Dynawo.Electrical.StaticVarCompensators;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPVPropRemote "PV static var compensator model with remote voltage regulation, slope and without mode handling"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends AdditionalIcons.SVarC;
  extends SwitchOff.SwitchOffShunt;

  type BStatus = enumeration (Standard "Susceptance is between its maximal and minimal values",
                              SusceptanceMax "Susceptance is fixed to its maximal value",
                              SusceptanceMin "Susceptance is fixed to its minimal value");

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid";
  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in pu (base UNomRemote, SnRef)";
  parameter Types.PerUnit BShuntPu "Fixed susceptance of the static var compensator in pu (for standby mode) (base UNomLocal, SnRef)";
  parameter Types.VoltageModule UNomRemote "Static var compensator remote nominal voltage in kV";
  parameter Types.VoltageModule URef0Pu "Start value of voltage reference in kV";

  input Types.VoltageModule URefPu(start = URef0Pu) "Voltage reference for the regulation in kV";

  BStatus bStatus(start = BStatus.Standard) "Susceptance value status: standard, susceptancemax, susceptancemin";
  Types.PerUnit BVarRawPu(start = BVar0Pu) "Raw variable susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
  Types.PerUnit BVarPu(start = BVar0Pu) "Variable susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
  Types.PerUnit BPu(start = B0Pu) "Susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
  Types.VoltageModulePu UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNomLocal)";
  Types.ReactivePowerPu QInjPu(start = B0Pu * U0Pu ^ 2) "Reactive power in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PInjPu(start = 0) "Active power in pu (base SnRef) (generator convention)";

  parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNomLocal)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNomLocal)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNomLocal, SnRef) (receptor convention)";
  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu (base UNomLocal, SnRef)";

equation
  URefPu = URegulatedPu + LambdaPu * (BVarRawPu + BShuntPu) * UPu ^ 2;
  BVarPu = if BVarRawPu > BMaxPu then BMaxPu elseif BVarRawPu < BMinPu then BMinPu else BVarRawPu;

  when BVarRawPu >= BMaxPu and pre(bStatus) <> BStatus.SusceptanceMax then
    bStatus = BStatus.SusceptanceMax;
    Timeline.logEvent1(TimelineKeys.SVarCMaxB);
  elsewhen BVarRawPu <= BMinPu and pre(bStatus) <> BStatus.SusceptanceMin then
    bStatus = BStatus.SusceptanceMin;
    Timeline.logEvent1(TimelineKeys.SVarCMinB);
  elsewhen (BVarRawPu < BMaxPu and BVarRawPu > BMinPu) and pre(bStatus) <> BStatus.Standard then
    bStatus = BStatus.Standard;
    Timeline.logEvent1(TimelineKeys.SVarCBackRegulation);
  end when;

  if (running.value) then
    UPu = Modelica.ComplexMath.'abs'(terminal.V);
    terminal.i = terminal.V * Complex(0, BPu);
    BPu = BVarPu + BShuntPu;
  else
    UPu = 0.;
    terminal.i = Complex(0);
    BPu = 0.;
  end if;

  PInjPu = 0;
  QInjPu = - ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

  annotation(preferredView = "text");
end SVarCPVPropRemote;
