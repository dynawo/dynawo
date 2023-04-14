within Dynawo.Electrical.StaticVarCompensators;

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

package BaseClasses
  extends Icons.BasesPackage;

  partial model BaseModeHandling "Base dynamic model for static var compensator mode handling"

    input Boolean selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration";
    input Integer setModeManual(start = setModeManual0) "Mode selected when in manual configuration";

    parameter BaseControls.Mode Mode0 "Start value for mode";
    parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";

    final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

    annotation(
      preferredView = "text");
  end BaseModeHandling;

  partial model BaseSVarC "Base dynamic model for static var compensator"
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


    parameter Types.PerUnit BMaxPu "Maximum value for the variable susceptance in pu (base UNom, SnRef)";
    parameter Types.PerUnit BMinPu "Minimum value for the variable susceptance in pu (base UNom, SnRef)";
    parameter Types.PerUnit BShuntPu "Fixed susceptance of the static var compensator in pu (for standby mode) (base UNom, SnRef)";

    Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the static var compensator to the grid";
    input Types.VoltageModule URefPu(start = URef0Pu) "Reference voltage amplitude in pu (base UNom)";

    Types.PerUnit BPu(start = B0Pu) "Susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
    BStatus bStatus(start = BStatus.Standard) "Susceptance value status: standard, susceptancemax, susceptancemin";
    Types.PerUnit BVarPu(start = BVar0Pu) "Variable susceptance of the static var compensator in pu (base UNomLocal, SnRef)";
    Types.ActivePowerPu PInjPu(start = 0) "Active power in pu (base SnRef) (generator convention)";
    Types.ReactivePowerPu QInjPu(start = B0Pu * U0Pu ^ 2) "Reactive power in pu (base SnRef) (generator convention)";
    Types.VoltageModulePu UPu(start = U0Pu) "Voltage amplitude at terminal in pu (base UNomLocal)";

    parameter Types.PerUnit B0Pu "Start value of the susceptance in pu (base UNom, SnRef)";
    parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at injector terminal in pu (base UNom, SnRef) (receptor convention)";
    parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage at injector terminal in pu (base UNom)";
    parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
    parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

    final parameter Types.PerUnit BVar0Pu = B0Pu - BShuntPu "Start value of variable susceptance in pu (base UNom, SnRef)";

  equation
    when bStatus == BStatus.SusceptanceMax and pre(bStatus) <> BStatus.SusceptanceMax then
      Timeline.logEvent1(TimelineKeys.SVarCMaxB);
    elsewhen bStatus == BStatus.SusceptanceMin and pre(bStatus) <> BStatus.SusceptanceMin then
      Timeline.logEvent1(TimelineKeys.SVarCMinB);
    elsewhen bStatus == BStatus.Standard and pre(bStatus) <> BStatus.Standard then
      Timeline.logEvent1(TimelineKeys.SVarCBackRegulation);
    end when;

    if (running.value) then
      UPu = Modelica.ComplexMath.'abs'(terminal.V);
      terminal.i = terminal.V * Complex(0, BPu);
    else
      UPu = 0.;
      terminal.i = Complex(0);
    end if;

    PInjPu = 0;
    QInjPu = - ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

    annotation(
      preferredView = "text");
  end BaseSVarC;

  annotation(preferredView = "text");
end BaseClasses;
