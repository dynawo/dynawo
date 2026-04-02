within Dynawo.Examples.GridCodeSimulations;

model BaseUnitModel
  /*
  * Copyright (c) 2026, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  extends BaseParameters;
  // ────────────────────────────────────────────────────────────
  // DyCoV output variables
  // ────────────────────────────────────────────────────────────
  Real BusPDR_BUS_Voltage;
  Real BusPDR_BUS_ActivePower;
  Real BusPDR_BUS_ReactivePower;
  Real BusPDR_BUS_ActiveCurrent;
  Real BusPDR_BUS_ReactiveCurrent;
  Real Wind_Turbine_GEN_MagnitudeControlledByAVRPu;
  Real Wind_Turbine_GEN_UPuInjTerminal;
  Real Wind_Turbine_GEN_IpInjTerminal;
  Real Wind_Turbine_GEN_IqInjTerminal;
  Real Measurements_BUS_Voltage;
  Real Measurements_BUS_ActivePower;
  Real Measurements_BUS_ReactivePower;
  Real StepUp_Xfmr_XFMR_Tap;
  Real Wind_Turbine_GEN_VoltageSetpointPu;
  Real Wind_Turbine_GEN_NetworkFrequencyPu;
  Real NetworkFrequencyPu;

  parameter Real OmegaCC          = 200  "Inner current loop bandwidth [rad/s]";
  parameter Real w_cc_outer       = 4.5   "Outer P/Q loop bandwidth [rad/s]";
  parameter Real w_cc_plant       = 1.3   "Plant (power) controller bandwidth [rad/s]";
  parameter Real OmegaPLL         = 4.5  "PLL bandwidth [rad/s]";
  parameter Real KsiPLL           = 0.5   "PLL damping ratio [-]";
  parameter Real OmegaLPF         = 300   "Measurement low‑pass filter cutoff [rad/s]";
  parameter Real delay_time_plant = 0.02  "Equivalent delay from plant to outer loop [s]";
  final parameter Real T_filter   = 1.0 / OmegaLPF "Measurement filter time constant [s]";
// ═══════════════════════════════════════════════════════════════
  // Impedenze effettive
  // ═══════════════════════════════════════════════════════════════
  final parameter Real Rf1 = Unit.RfPu  + Unit.RPuLV;
  final parameter Real Lf1 = Unit.LfPu  + Unit.LPuLV;


  // ═══════════════════════════════════════════════════════════════
  // Guadagni GFL1
  // ═══════════════════════════════════════════════════════════════
  final parameter Real kp_cc_1    = Lf1 * OmegaCC / SystemBase.omegaNom;
  final parameter Real ki_cc_1    = Rf1 * OmegaCC;
  final parameter Real kp_outer_1 = w_cc_outer / OmegaLPF;
  final parameter Real ki_outer_1 = w_cc_outer;
  final parameter Real kp_pll_1   = 2.0 * KsiPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real ki_pll_1   = OmegaPLL * OmegaPLL / SystemBase.omegaNom;
  final parameter Real kp_plant_1 = w_cc_plant / w_cc_outer;
  final parameter Real ki_plant_1 =  w_cc_plant;

  Modelica.Blocks.Sources.Constant PRefPu(k = -Unit.P0_pcc*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-70, 42}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Step URefPu(offset = Unit.URef0Pu, height = 0, startTime = 2) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, 10}, {10, -10}})));
Electrical.PEIR.Plants.Average.GFLmodel Unit (
  SNom = SNom, U0Pu = U0Pu, Uphase = UPhase0, P0_pcc = P0Pu, Q0_pcc = Q0Pu, Omega0Pu = 1.0, // ── VSC Pade delay ────────────────────────────────────────
  tVSC = 1e-3,
    RfPu = 0.003, LfPu = 0.1, CfPu = 1e-5,
    omegaNom = 2 * Modelica.Constants.pi * 50,
    RPuLV = 0.001, LPuLV = 0.025,
    RPuHV = 0.001, LPuHV = 0.025,
    k_filter = 1, T_filter = T_filter,
    k_p_d_current = kp_cc_1, k_i_d_current = ki_cc_1,
    k_p_q_current = kp_cc_1, k_i_q_current = ki_cc_1,
    k_p_d_outer = kp_outer_1, k_i_d_outer = ki_outer_1,
    k_p_q_outer = kp_outer_1, k_i_q_outer = ki_outer_1,
    UboostHigh = 1.1, UboostLow = 0.9, Kqv = 2,
    Imax = 2, PQFlag = false,
    IqBoostMax = 0.5, IqBoostMin = -0.5,
    K_p_q_plant = kp_plant_1, K_i_q_plant = ki_plant_1,
    K_p_p_plant = kp_plant_1, K_i_p_plant = ki_plant_1,
    Lambda = 0.417, Kdroop = 15,
    QMaxPu = 0.3, QMinPu = -0.3,
    PMaxPu = 2,   PMinPu = 0,
    FEMaxPu = 999, FEMinPu = -999,
    FDbd1Pu = 0.005, FDbd2Pu = 0.1,
    DbdPu = 0.0001,
    K_p_pll = kp_pll_1, K_i_pll = ki_pll_1,
    OmegaMaxPu = 1.1, OmegaMinPu = 0.9,
    DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0,
    DuMax_idref = 10.0,   DuMin_idref = -10.0,
    tS_idref = 1e-4,
    delay_time_plant = delay_time_plant,
    voltagefeedforwardflag_d = 1, voltagefeedforwardflag_q = 1)  annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-31, -31}, {31, 31}})));
equation
  Unit.switchOffSignal1=false;
  Unit.switchOffSignal2=false;
  Unit.switchOffSignal3=false;
  BusPDR_BUS_Voltage = Unit.measurementBlock.U_pcc_pu_abs;
  BusPDR_BUS_ActivePower = Unit.measurementBlock.P_plant;
  BusPDR_BUS_ReactivePower = Unit.measurementBlock.Q_plant;
  BusPDR_BUS_ActiveCurrent = Unit.measurementBlock.P_plant/Unit.measurementBlock.U_pcc_pu_abs;
  BusPDR_BUS_ReactiveCurrent = Unit.measurementBlock.Q_plant/Unit.measurementBlock.U_pcc_pu_abs;
  Wind_Turbine_GEN_MagnitudeControlledByAVRPu = Unit.plant_controller.uLambdaQ.y;
  Wind_Turbine_GEN_UPuInjTerminal = sqrt(Unit.lCDynFilter.uLeft_rePu^2 + Unit.lCDynFilter.uLeft_imPu^2);
  Wind_Turbine_GEN_IpInjTerminal = Unit.measurementBlock.P_plant/Unit.measurementBlock.U_pcc_pu_abs;
  Wind_Turbine_GEN_IqInjTerminal = Unit.measurementBlock.Q_plant/Unit.measurementBlock.U_pcc_pu_abs;
  Measurements_BUS_Voltage = Unit.measurementBlock.U_pcc_pu_abs;
  Measurements_BUS_ActivePower = Unit.measurementBlock.P_plant;
  Measurements_BUS_ReactivePower = Unit.measurementBlock.Q_plant;
  StepUp_Xfmr_XFMR_Tap = 1.0;
  Wind_Turbine_GEN_VoltageSetpointPu = Unit.UREfPu;
  Wind_Turbine_GEN_NetworkFrequencyPu = Unit.gFLControl.omega_pll_pu * Electrical.SystemBase.fNom;
  NetworkFrequencyPu = Unit.gFLControl.omega_pll_pu * Electrical.SystemBase.fNom;
 connect(Unit.PRefPu, PRefPu.y) annotation(
    Line(points = {{-28, 28}, {-42.5, 28}, {-42.5, 42}, {-59, 42}}, color = {0, 0, 127}));
 connect(Unit.UREfPu, URefPu.y) annotation(
    Line(points = {{-28, 6}, {-61, 6}}, color = {0, 0, 127}));
  annotation(
    Icon,
    Documentation(info = "<html>
<p><b>Rules to follow in order to prevent bug :</b></p>

<ul>
  <li>Before adding your plant model, you should delete the one available here.</li>
  <br/>

  <li>You should name your model \"Unit\" in the attributes (the connections in the test cases depend on this name).</li>
  <br/>

  <li>You should define the base apparent power of your plant model as \"SNom\", parameter that you will define in the \"BaseParameter\" file.</li>
  <br/>

  <li>You should define the 4 initialization parameters U0Pu, P0Pu, Q0Pu, UPhase0 with those exact names in your model. Those parameters are defined across the test cases model to respect the operating points required in the grid code simulations.</li>
  <br/>

  <li>You should define here the complete tuning of your model. This is where you define the tuning used across all simulations in this GridCodeSimulations package.</li>
  <br/>

  <li>You should make sure your model is initializing properly.</li>
  <br/>

  <li>The voltage order entry of your model should remain a step model with offset = Unit.URef0Pu, height = 0.</li>
</ul>

<p><b>If the entries of your model are in base SNom and in receptor convention :</b></p>

<ul>
  <li>The active power order entry of your model should be a constant = -Unit.P0Pu*Electrical.SystemBase.SnRef/SNom.</li>
  <br/>

  <li>The reactive power order entry of your model should be a constant = -Unit.Q0Pu*Electrical.SystemBase.SnRef/SNom.</li>
</ul>

</html>"),
  Diagram);
end BaseUnitModel;
