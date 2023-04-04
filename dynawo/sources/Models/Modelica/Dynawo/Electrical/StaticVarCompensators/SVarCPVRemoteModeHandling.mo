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

model SVarCPVRemoteModeHandling "PV static var compensator model with remote voltage regulation, slope and mode handling"
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
  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

  extends Parameters.Params_ModeHandling;
  parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.PerUnit BShuntPu "Fixed susceptance of the static var compensator in pu (for standby mode) (base UNomLocal, SnRef)";
  parameter Types.VoltageModule UNomRemote "Static var compensator remote nominal voltage in kV";
  parameter Types.VoltageModule URef0Pu "Start value of voltage reference in kV";

  input Types.VoltageModule URef(start = URef0Pu * UNomRemote) "Voltage reference for the regulation in kV";
  input Boolean selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration";
  input Integer setModeManual(start = setModeManual0) "Mode selected when in manual configuration";

  BStatus bStatus(start = BStatus.Standard) "Susceptance value status: standard, susceptancemax, susceptancemin";
  Types.PerUnit BVarPu(start = BVar0Pu) "Variable susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
  Types.PerUnit BPu(start = B0Pu) "Susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
  Types.ReactivePowerPu QInjPu(start = B0Pu * U0Pu ^ 2) "Reactive power in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PInjPu(start = 0) "Active power in pu (base SnRef) (generator convention)";
  Types.VoltageModulePu URefPu(start = URef0Pu) = modeHandling.URefPu "Reference voltage amplitude in pu (base UNomRemote)";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNomRemote, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNomRemote);

  parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base UNomLocal, SnRef)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNomLocal)";
  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNomLocal)";
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNomLocal, SnRef) (receptor convention)";
  final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu (base UNomLocal, SnRef)";
  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";
  final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

equation
  URegulatedPu = modeHandling.UPu;
  URef = modeHandling.URef;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  when bStatus == BStatus.SusceptanceMax and pre(bStatus) <> BStatus.SusceptanceMax then
    Timeline.logEvent1(TimelineKeys.SVarCMaxB);
  elsewhen bStatus == BStatus.SusceptanceMin and pre(bStatus) <> BStatus.SusceptanceMin then
    Timeline.logEvent1(TimelineKeys.SVarCMinB);
  elsewhen bStatus == BStatus.Standard and pre(bStatus) <> BStatus.Standard then
    Timeline.logEvent1(TimelineKeys.SVarCBackRegulation);
  end when;

  when BVarPu >= BMaxPu and URegulatedPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and URegulatedPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or URegulatedPu > URefPu) and (BVarPu > BMinPu or URegulatedPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if modeHandling.mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
  elseif modeHandling.mode.value == Mode.STANDBY then
    BPu = BShuntPu;
  else
    BPu = 0;
  end if;

  if (running.value) then
    terminal.i = terminal.V * Complex(0, BPu);
    if modeHandling.mode.value == Mode.RUNNING_V then
      if bStatus == BStatus.Standard then
        URegulatedPu = URefPu;
      elseif bStatus == BStatus.SusceptanceMax then
        BVarPu = BMaxPu;
      else
        BVarPu = BMinPu;
      end if;
    else
      BVarPu = 0;
    end if;
  else
    terminal.i = Complex(0);
    BVarPu = 0.;
  end if;

  PInjPu = 0;
  QInjPu = - ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

  annotation(preferredView = "text");
end SVarCPVRemoteModeHandling;
