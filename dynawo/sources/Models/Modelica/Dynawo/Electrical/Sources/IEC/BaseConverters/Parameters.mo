within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package Parameters "Parameters for IEC Wind Turbine converter classes"
  extends Icons.Package;

record Circuit "Circuit parameters for injector"
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
end Circuit;


record GenSystem3 "Do not use. Use 3a or 3b instead."
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit XEqv "Transient reactance (should be calculated from the transient inductance as defined in 'New Generic Model of DFG-Based Wind Turbines for RMS-Type Simulation', Fortmann et al., 2014 (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
end GenSystem3;

record GenSystem3a "Control parameters for generator system of WT, specific to Type 3A"
  extends GenSystem3;
  parameter Types.PerUnit KPc "Current PI controller proportional gain" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time TIc "Current PI controller integration time constant" annotation(
    Dialog(tab = "Control"));
end GenSystem3a;

record GenSystem3b "Control parameters for generator system of WT, specific to Type 3B"
  extends GenSystem3;
  parameter Real tCrb[:,:] = [-99,0.1; -1,0.1; -0.1,0; 0,0] "Crowbar duration versus voltage variation look-up table, for example [-99,0.1; -1,0.1; -0.1,0; 0,0]" annotation(
    Dialog(tab = "Control"));
    parameter Types.Time tWo "Time constant for crowbar washout filter" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant" annotation(
    Dialog(tab = "Control"));
  parameter Boolean MCrb "Crowbar control mode (true=disable only iq control, false=disable iq and ip control)" annotation(
    Dialog(tab = "Control"));
end GenSystem3b;

record GenSystem4 "Control parameters for generator system of WT Type 4"
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMinPu "Minimum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kipaw "Anti-windup gain for active current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kiqaw "Anti-windup gain for reactive current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant in s" annotation(
    Dialog(tab = "Control"));
end GenSystem4;

record InitialComplexUGrid "Initial voltage and current for grid side"
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(Dialog(tab = "Initialization"));
end InitialComplexUGrid;

record InitialComplexUiGrid "Initial voltage and current for grid side"
  extends InitialComplexUGrid;
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(Dialog(tab = "Initialization"));
end InitialComplexUiGrid;

record InitialUGrid "Initial voltage module and phase for grid side"
  extends InitialUModuleGrid;
  extends InitialUPhaseGrid;
end InitialUGrid;

record InitialUModuleGrid
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(Dialog(tab = "Operating point"));
end InitialUModuleGrid;

record InitialUPhaseGrid
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(Dialog(tab = "Operating point"));
end InitialUPhaseGrid;

record InitialIGs "Initial current for generator system (GS) side"
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
end InitialIGs;

record InitialUGs "Initial voltage for generator system (GS) side"
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(Dialog(tab = "Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(tab = "Initialization"));
end InitialUGs;

record InitialPqGrid "Initial P and Q for grid side"
  extends InitialQGrid;
  extends InitialPGrid;
end InitialPqGrid;

record InitialQGrid "Initial Q for grid side"
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(Dialog(tab = "Operating point"));
end InitialQGrid;

record InitialPGrid "Initial P for grid side"
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
end InitialPGrid;

record InitialGenSystem "Initial parameters for Generator System"
  extends InitialGenSystemP;
  extends InitialGenSystemQ;
  extends InitialPAg;
end InitialGenSystem;

record InitialGenSystemP "Initial IpMax"
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
end InitialGenSystemP;

record InitialGenSystemQ "Initial IqMin, IqMax"
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
end InitialGenSystemQ;

record InitialPAg "Initial PAg"
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(Dialog(tab = "Initialization"));
end InitialPAg;

record IntegrationTimeStep
  parameter Types.Time tS "Integration time step in s";
end IntegrationTimeStep;

record SNom "Nominal parameters for generator system"
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
end SNom;

end Parameters;
