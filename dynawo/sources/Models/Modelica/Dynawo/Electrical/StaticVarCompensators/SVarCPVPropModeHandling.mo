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

model SVarCPVPropModeHandling "PV static var compensator model with slope and mode handling"
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode;
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends AdditionalIcons.SVarC;
  extends SwitchOff.SwitchOffShunt;

  type BStatus = enumeration (Standard "Susceptance is between its maximal and minimal values",
                              SusceptanceMax "Susceptance is fixed to its maximal value",
                              SusceptanceMin "Susceptance is fixed to its minimal value");

  Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid";

  extends Parameters.Params_ModeHandling;
  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNom, SnRef)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNom, SnRef)";
  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in pu (base UNom, SnRef)";
  parameter Types.PerUnit BShuntPu "Fixed susceptance of the static var compensator in pu (for standby mode) (base UNom, SnRef)";
  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

  input Types.VoltageModule URef(start = URef0Pu * UNom) "Voltage reference for the regulation in kV";
  input Boolean selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration";
  input Integer setModeManual(start = setModeManual0) "Mode selected when in manual configuration";

  BStatus bStatus(start = BStatus.Standard) "Susceptance value status: standard, susceptancemax, susceptancemin";
  Types.PerUnit BVarRawPu(start = BVar0Pu) "Raw variable susceptance of the static var compensator in pu (base UNom, SnRef)";
  Types.PerUnit BVarPu(start = BVar0Pu) "Variable susceptance of the static var compensator in pu (base UNom, SnRef)";
  Types.PerUnit BPu(start = B0Pu) "Susceptance of the static var compensator in pu (base UNom, SnRef)";
  Types.VoltageModulePu UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNom)";
  Types.ReactivePowerPu QInjPu(start = B0Pu * U0Pu ^ 2) "Reactive power in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PInjPu(start = 0) "Active power in pu (base SnRef) (generator convention)";
  Types.VoltageModulePu URefPu(start = URef0Pu) = modeHandling.URefPu "Reference voltage amplitude in pu (base UNom)";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNom);

  parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base UNom, SnRef)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu (base UNom, SnRef)";
  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";
  final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

equation
  UPu = modeHandling.UPu;
  URef = modeHandling.URef;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  URefPu = UPu + LambdaPu * (BVarRawPu + BShuntPu) * UPu ^ 2;
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

  if modeHandling.mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
  elseif modeHandling.mode.value == Mode.STANDBY then
    BPu = BShuntPu;
  else
    BPu = 0;
  end if;

  if (running.value) then
    UPu = Modelica.ComplexMath.'abs'(terminal.V);
    terminal.i = terminal.V * Complex(0, BPu);
  else
    UPu = 0.;
    terminal.i = Complex(0);
  end if;

  PInjPu = 0;
  QInjPu = - ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

  annotation(preferredView = "text");
end SVarCPVPropModeHandling;
