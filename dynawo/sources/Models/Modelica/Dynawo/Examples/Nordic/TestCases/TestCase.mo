within Dynawo.Examples.Nordic.TestCases;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
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

model TestCase "Nordic test system case with variable reference frequency"
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types;

  extends Dynawo.Examples.Nordic.Grid.FullDynamicModel;
  extends Icons.Example;

  Types.AngularVelocityPu omegaCOI(start = SystemBase.omega0Pu) "Weighted average of the frequencies of all generators in pu (base omegaNom)";

  Types.VoltageModulePu check_UPu_bus_1041;
  Types.VoltageModulePu check_UPu_bus_1042;
  Types.VoltageModulePu check_UPu_bus_4012;
  Types.VoltageModulePu check_UPu_bus_4062;
  Types.VoltageModulePu check_UtPu_g06;
  Types.VoltageModulePu check_UtPu_g07;
  Types.CurrentModulePu check_ifPu_g06;
  Types.CurrentModulePu check_ifPu_g07;
  Types.CurrentModulePu check_ifPu_g08;
  Types.CurrentModulePu check_ifPu_g09;
  Types.CurrentModulePu check_ifPu_g11;
  Types.CurrentModulePu check_ifPu_g12;
  Types.CurrentModulePu check_ifPu_g14;
  Types.CurrentModulePu check_ifPu_g15;
  Types.CurrentModulePu check_ifPu_g16;
  Types.CurrentModulePu check_ifPu_g18;
  Types.AngularVelocityPu check_f_g06;
  Types.AngularVelocityPu check_f_g07;
  Types.AngularVelocityPu check_f_g17;

  Dynawo.Electrical.Events.NodeFault nodeFault(RPu =  40 / 400 ^ 2 * SystemBase.SnRef, XPu =  40 / 400 ^ 2 * SystemBase.SnRef, tBegin = 1, tEnd = 1.1);
  Dynawo.Electrical.Events.Event.SingleBooleanEvent disconnection(stateEvent1 = true, tEvent = 1.1);

equation
  check_UPu_bus_1041 = ComplexMath.'abs'(bus_1041.terminal.V);
  check_UPu_bus_1042 = ComplexMath.'abs'(bus_1042.terminal.V);
  check_UPu_bus_4012 = ComplexMath.'abs'(bus_4012.terminal.V);
  check_UPu_bus_4062 = ComplexMath.'abs'(bus_4062.terminal.V);
  check_ifPu_g06 = g06.vrNordic.ifPu;
  check_ifPu_g07 = g07.vrNordic.ifPu;
  check_ifPu_g08 = g08.vrNordic.ifPu;
  check_ifPu_g09 = g09.vrNordic.ifPu;
  check_ifPu_g11 = g11.vrNordic.ifPu;
  check_ifPu_g12 = g12.vrNordic.ifPu;
  check_ifPu_g14 = g14.vrNordic.ifPu;
  check_ifPu_g15 = g15.vrNordic.ifPu;
  check_ifPu_g16 = g16.vrNordic.ifPu;
  check_ifPu_g18 = g18.vrNordic.ifPu;
  check_f_g06 = g06.generatorSynchronous.omegaPu.value;
  check_f_g07 = g07.generatorSynchronous.omegaPu.value;
  check_f_g17 = g17.generatorSynchronous.omegaPu.value;
  check_UtPu_g06 = g06.generatorSynchronous.UPu;
  check_UtPu_g07 = g07.generatorSynchronous.UPu;

  omegaCOI = (g01.generatorSynchronous.omegaPu.value * g01.generatorSynchronous.H * g01.generatorSynchronous.SNom +
              g02.generatorSynchronous.omegaPu.value * g02.generatorSynchronous.H * g02.generatorSynchronous.SNom +
              g03.generatorSynchronous.omegaPu.value * g03.generatorSynchronous.H * g03.generatorSynchronous.SNom +
              g04.generatorSynchronous.omegaPu.value * g04.generatorSynchronous.H * g04.generatorSynchronous.SNom +
              g05.generatorSynchronous.omegaPu.value * g05.generatorSynchronous.H * g05.generatorSynchronous.SNom +
              g06.generatorSynchronous.omegaPu.value * g06.generatorSynchronous.H * g06.generatorSynchronous.SNom +
              g07.generatorSynchronous.omegaPu.value * g07.generatorSynchronous.H * g07.generatorSynchronous.SNom +
              g08.generatorSynchronous.omegaPu.value * g08.generatorSynchronous.H * g08.generatorSynchronous.SNom +
              g09.generatorSynchronous.omegaPu.value * g09.generatorSynchronous.H * g09.generatorSynchronous.SNom +
              g10.generatorSynchronous.omegaPu.value * g10.generatorSynchronous.H * g10.generatorSynchronous.SNom +
              g11.generatorSynchronous.omegaPu.value * g11.generatorSynchronous.H * g11.generatorSynchronous.SNom +
              g12.generatorSynchronous.omegaPu.value * g12.generatorSynchronous.H * g12.generatorSynchronous.SNom +
              g13.generatorSynchronous.omegaPu.value * g13.generatorSynchronous.H * g13.generatorSynchronous.SNom +
              g14.generatorSynchronous.omegaPu.value * g14.generatorSynchronous.H * g14.generatorSynchronous.SNom +
              g15.generatorSynchronous.omegaPu.value * g15.generatorSynchronous.H * g15.generatorSynchronous.SNom +
              g16.generatorSynchronous.omegaPu.value * g16.generatorSynchronous.H * g16.generatorSynchronous.SNom +
              g17.generatorSynchronous.omegaPu.value * g17.generatorSynchronous.H * g17.generatorSynchronous.SNom +
              g18.generatorSynchronous.omegaPu.value * g18.generatorSynchronous.H * g18.generatorSynchronous.SNom +
              g19.generatorSynchronous.omegaPu.value * g19.generatorSynchronous.H * g19.generatorSynchronous.SNom +
              g20.generatorSynchronous.omegaPu.value * g20.generatorSynchronous.H * g20.generatorSynchronous.SNom
              ) / (
              g01.generatorSynchronous.SNom * g01.generatorSynchronous.H +
              g02.generatorSynchronous.SNom * g02.generatorSynchronous.H +
              g03.generatorSynchronous.SNom * g03.generatorSynchronous.H +
              g04.generatorSynchronous.SNom * g04.generatorSynchronous.H +
              g05.generatorSynchronous.SNom * g05.generatorSynchronous.H +
              g06.generatorSynchronous.SNom * g06.generatorSynchronous.H +
              g07.generatorSynchronous.SNom * g07.generatorSynchronous.H +
              g08.generatorSynchronous.SNom * g08.generatorSynchronous.H +
              g09.generatorSynchronous.SNom * g09.generatorSynchronous.H +
              g10.generatorSynchronous.SNom * g10.generatorSynchronous.H +
              g11.generatorSynchronous.SNom * g11.generatorSynchronous.H +
              g12.generatorSynchronous.SNom * g12.generatorSynchronous.H +
              g13.generatorSynchronous.SNom * g13.generatorSynchronous.H +
              g14.generatorSynchronous.SNom * g14.generatorSynchronous.H +
              g15.generatorSynchronous.SNom * g15.generatorSynchronous.H +
              g16.generatorSynchronous.SNom * g16.generatorSynchronous.H +
              g17.generatorSynchronous.SNom * g17.generatorSynchronous.H +
              g18.generatorSynchronous.SNom * g18.generatorSynchronous.H +
              g19.generatorSynchronous.SNom * g19.generatorSynchronous.H +
              g20.generatorSynchronous.SNom * g20.generatorSynchronous.H);

  g01.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g02.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g03.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g04.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g05.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g06.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g07.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g08.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g09.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g10.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g11.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g12.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g13.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g14.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g15.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g16.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g17.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g18.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g19.generatorSynchronous.omegaRefPu.value = omegaCOI;
  g20.generatorSynchronous.omegaRefPu.value = omegaCOI;

  connect(nodeFault.terminal, bus_4032.terminal);
  connect(disconnection.state1, line_4032_4044.switchOffSignal1);

  annotation(preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 166.8, Tolerance = 0.005, Interval = 0.01),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,nonewInst -d=initialization, -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 -d=nonewInst -d= -d=aliasConflicts, --maxSizeLinearTearing=1040, --maxSizeNonlinearTearing=1040 --daemode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "euler", lssMaxDensity = "0.1"),
    Documentation(info = "<html><head></head><body><span style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This test case is meant to investigate the long term dynamic response of the Nordic 32 test system, operating point A, regarding a contingency. This particular test case corresponds to the setup presented in Chapter 3.1 of the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.</span><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">OmegaRef of the generators is set to the center of inertia of the whole system.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font></div><div><font face=\"MS Shell Dlg 2\">The simulation runs in DAEmode, starts at t = 0 s, ends at t = 166.8 s (just before crashing) and uses the euler solver with a step size of 0.01 and a tolerance of 0.005.</font></div><div><font face=\"MS Shell Dlg 2\"><br></font><div><font face=\"MS Shell Dlg 2\">At t = 1 s, a node fault occurs at bus 4032, which is cleared by tripping line 4032-4044&nbsp;</font><span style=\"font-family: 'MS Shell Dlg 2';\">after 0.1 s</span>.</div><div><br></div><div><div style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">While voltage remains more or less stable at bus 4012 and 4062, voltage keeps dropping at bus 1041 and 1042, until the voltage collapses ~160 s later.</div></div></div></div></body></html>"));
end TestCase;
