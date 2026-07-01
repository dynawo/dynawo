within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

// =============================================================================
// Author  : Gaia Bergamaschi
//
// Current limiter with reactive boost for a GFL converter outer loop.
//
// This block enforces the current amplitude constraint sqrt(id² + iq²) ≤ Imax
// and applies a voltage-dependent reactive current boost (Iq boost) to support
// grid voltage during under- and overvoltage events.
//
// ── Reactive boost logic ─────────────────────────────────────────────────────
//   U < UboostLow  → undervoltage: inject reactive current (iq_boost > 0)
//   U > UboostHigh → overvoltage:  absorb reactive current (iq_boost < 0)
//   UboostLow ≤ U ≤ UboostHigh → deadband: no boost
//   The boost magnitude is proportional to the voltage deviation via gain Kqv.
//   It is then saturated between IqBoostMin and IqBoostMax.
//   The boost signal is filtered by a first-order low-pass with time constant
//   T_boost to avoid discontinuous jumps in the current reference.
//
// ── Current limiting ─────────────────────────────────────────────────────────
//   Priority is selected via PQFlag (consistent with WECC convention):
//   PQFlag = true  → P priority: id_raw respected first, iq clipped to circle
//   PQFlag = false → Q priority: iq_eff respected first, id clipped to circle
//   In both cases the total current never exceeds Imax.
//
// ── Sign convention ──────────────────────────────────────────────────────────
//   Inputs id_raw and iq_raw follow generator convention (injection positive).
//   iq_lim is output with a sign flip (−iq_eff) to match the inner loop
//   current reference convention used downstream.
// =============================================================================

model current_limiter_reactive_boost
  "Limit sqrt(id^2 + iq^2) to Imax with P/Q priority and bidirectional Iq boost (undervoltage + overvoltage)"

  // ── Parameters ───────────────────────────────────────────────
  parameter Real Imax
    "Maximum current amplitude (pu)";
  parameter Boolean PQFlag
    "Q/P priority: Q (false=0) or P (true=1) priority, as in WECC";

  parameter Real UboostLow
    "Lower voltage threshold: below this, inject more Q (pu)";
  parameter Real UboostHigh
    "Upper voltage threshold: above this, absorb more Q (pu)";

  parameter Real Kqv
    "Gain for voltage-dependent reactive boost (pu Iq / pu U). Set 0 to disable boost";
  parameter Real IqBoostMax = Imax
    "Maximum additional reactive current boost (pu)";
  parameter Real IqBoostMin = -Imax
    "Minimum additional reactive current boost (pu)";
  parameter Real T_boost =1e-4
    "Time constant of first-order filter on iq_boost (s). Set 0 to disable";
  parameter Real U0Pu
    "Initial voltage magnitude at PCC (pu), used to initialise iq_boost";

  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput id_raw
    "d-axis (P-like) raw current reference (pu)" annotation(
    Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput iq_raw
    "q-axis (Q-like) raw current reference (pu)" annotation(
    Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput U_meas_pu
    "Measured voltage magnitude at PCC/filter (pu)" annotation(
    Placement(
      transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}})));

  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput id_lim
    "d-axis limited current reference (pu)" annotation(
    Placement(
      transformation(origin = {120, 32}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput iq_lim
    "q-axis limited current reference (pu)" annotation(
    Placement(
      transformation(origin = {120, -30}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  // ── Internal variables ───────────────────────────────────────
  Real iq_boost_raw        "Reactive current boost before limiting (pu)";
  Real iq_boost_unfiltered "Reactive current boost after limiting, before filter (pu)";
  Real iq_boost            "Reactive current boost after limiting and filtering (pu)";
  Real iq_eff              "Effective reactive current reference after boost (pu)";

equation
  // ── Step 1: compute raw boost (undervoltage + overvoltage) ───
  if noEvent(U_meas_pu < UboostLow) then
    iq_boost_raw = Kqv * (UboostLow- U_meas_pu);
  elseif noEvent(U_meas_pu > UboostHigh) then
    iq_boost_raw = Kqv * (UboostHigh - U_meas_pu);
  else
    iq_boost_raw = 0;
  end if;

  // ── Step 2: limit the boost ──────────────────────────────────
  iq_boost_unfiltered = max(min(iq_boost_raw, IqBoostMax), IqBoostMin);

  // ── Step 2b: first-order filter on boost ─────────────────────
  if noEvent(T_boost > 0) then
    T_boost * der(iq_boost) = iq_boost_unfiltered - iq_boost;
  else
    iq_boost = iq_boost_unfiltered;
  end if;

  // ── Step 3: effective iq reference ───────────────────────────
  iq_eff = iq_raw + iq_boost;

  // ── Step 4: current limiting with P/Q priority ───────────────
  if PQFlag then
    // P priority (d-axis)
    if noEvent(abs(id_raw) >= Imax) then
      id_lim = if (id_raw)>0 then  Imax else -  Imax;
      iq_lim = 0;
    else
      id_lim = id_raw;
      iq_lim = -max(
                 min(iq_eff,  sqrt(max(Imax^2 - id_raw^2, 0))),
                -sqrt(max(Imax^2 - id_raw^2, 0)));
    end if;
  else
    // Q priority (q-axis including boost)
    if noEvent(abs(iq_eff) >= Imax) then
      iq_lim =  if iq_eff>0 then  -Imax else Imax;
      id_lim = 0;
    else
      iq_lim = -iq_eff;
      id_lim = max(
                 min(id_raw,  sqrt(max(Imax^2 - iq_eff^2, 0))),
                -sqrt(max(Imax^2 - iq_eff^2, 0)));
    end if;
  end if;

initial equation
  // ── Initialise filter state at steady-state boost value ──────
  if T_boost > 0 then
    iq_boost = max(
                 min(
                   if U0Pu < UboostLow then Kqv * (1 - U0Pu)
                   elseif U0Pu > UboostHigh then Kqv * (1 - U0Pu)
                   else 0,
                   IqBoostMax),
                 IqBoostMin);
  end if;

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(
      coordinateSystem(extent = {{-100, -100}, {100, 100}}),
      graphics = {
        Rectangle(extent = {{-100, 100}, {100, -100}}),
        Text(origin = {0, 60}, extent = {{-80, 20}, {80, -20}},
             textString = "Current"),
        Text(origin = {0, 20}, extent = {{-80, 20}, {80, -20}},
             textString = "Limiter"),
        Text(origin = {0, -20}, extent = {{-80, 20}, {80, -20}},
             textString = "IqBoost ±"),
        Text(origin = {0, -60}, extent = {{-80, 20}, {80, -20}},
             textString = "T_boost filter")}),
    Diagram);

end current_limiter_reactive_boost;
