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

  Modelica.Blocks.Sources.Constant PRefPu(k = Unit.P0Pu*Electrical.SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {-70, 42}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Sources.Step URefPu(offset = Unit.URef0Pu, height = 0, startTime = 2) annotation(
    Placement(transformation(origin = {-72, 6}, extent = {{-10, 10}, {10, -10}})));
  Electrical.PEIR.Plants.Average.GFLmodel Unit ( // ── Initial conditions — PCC node ────────────────────────
  SNom = SNom, U0Pu = U0Pu, Uphase = UPhase0, P0_pcc = P0Pu, Q0_pcc = Q0Pu, Omega0Pu = 1.0,  // ── VSC Pade delay ────────────────────────────────────────
  tVSC = 1e-100,  // ── LC filter — realistic values, fr ≈ 712 Hz ─────────────
  RfPu = 0.003,  // realistic conduction losses ~0.3 %
  LfPu = 0.1,  // 5 % filter reactance
  CfPu = 1e-4,  // 1 % filter susceptance  →  fr ≈ 712 Hz
  omegaNom = 2*Modelica.Constants.pi*50,  // ── LV transformer (filter → LV node) ────────────────────
  RPuLV = 0.005, LPuLV = 0.08,  // ── HV transformer (LV node → PCC) ───────────────────────
  RPuHV = 0.002, LPuHV = 0.05,  // ── Measurement filter ────────────────────────────────────
  k_filter = 1, T_filter = 1e-2,  // ── Inner current loop — ω_c = 2000 rad/s ────────────────
  k_p_d_current = 100.0, k_i_d_current = 100000.0, k_p_q_current = 100.0, k_i_q_current = 100000.0,  // ── Outer loop — ω_c = 200 rad/s ─────────────────────────
  k_p_d_outer = 0.1, k_i_d_outer = 20.0, k_p_q_outer = 0.1, k_i_q_outer = 20.0,  // ── Current limiter ───────────────────────────────────────
  UboostHigh = 1.1, UboostLow = 0.9, Kqv = 0.3, Imax = 1.2, PQFlag = true, IqBoostMax = 0.5, IqBoostMin = -0.5,  // ── Plant controller — ω_c = 2 rad/s ─────────────────────
  K_p_q_plant = 0.1, K_i_q_plant = 1.0, K_p_p_plant = 0.8, K_i_p_plant = 5.0, Lambda = 0.286, Kdroop = 15, QMaxPu = 0.5, QMinPu = -0.5, PMaxPu = 2, PMinPu = 0, FEMaxPu = 999, FEMinPu = -999, FDbd1Pu = 0.005, FDbd2Pu = 0.1, DbdPu = 0.0001,  // ── PLL — ω_c = 20 rad/s (weak-grid tuning) ──────────────
  K_p_pll = 0.13, K_i_pll = 1.27, OmegaMaxPu = 1.5,  // tight clamp — prevents runaway
  OmegaMinPu = 0.5,   // ── Rate limiters and delays ──────────────────────────────
  DyMax_pi_d = 10000.0, DyMax_pi_q = 100000.0, DuMax_idref = 10.0, DuMin_idref = -10.0, tS_idref = 1e-4, delay_time_plant = 1e-3,  // ── Voltage feedforward ───────────────────────────────────
  voltagefeedforwardflag = 1)  annotation(
    Placement(transformation(origin = {9, 5}, extent = {{-31, -31}, {31, 31}})));
equation
Unit.switchOffSignal1.value=false; 
Unit.switchOffSignal2.value=false; 
Unit.switchOffSignal3.value=false; 
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