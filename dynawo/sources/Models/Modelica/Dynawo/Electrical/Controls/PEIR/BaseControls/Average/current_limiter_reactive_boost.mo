within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model current_limiter_reactive_boost

  "Limit sqrt(id^2 + iq^2) to Imax with P/Q priority and optional Iq boost (WECC-like)"

  parameter Real Imax "Maximum current amplitude (pu)";
  parameter Boolean PQFlag
    "Q/P priority: Q (false=0) or P (true=1) priority, as in WECC";

  // Voltage-dependent reactive current boost parameters
  parameter Real UboostStart 
    "Voltage threshold where Iq boost starts (pu)";
  parameter Real Kqv         
    "Gain for voltage-dependent reactive boost (pu Iq / pu U). Set 0 to disable boost";
  parameter Real IqBoostMax  = Imax
    "Maximum additional reactive current boost (pu)";
  parameter Real IqBoostMin  = -Imax
    "Minimum additional reactive current boost (pu)";

  // Inputs: raw references from PI controllers (d/q axes)
  Modelica.Blocks.Interfaces.RealInput id_raw
    "d-axis (P-like) raw current reference"
    annotation(
      Placement(
        transformation(origin = {-80, 30}, extent = {{-20, -20},{20, 20}}),
        iconTransformation(origin = {-110, 40}, extent = {{-10, -10},{10, 10}})));

  Modelica.Blocks.Interfaces.RealInput iq_raw
    "q-axis (Q-like) raw current reference"
    annotation(
      Placement(
        transformation(origin = {-80, -30}, extent = {{-20, -20},{20, 20}}),
        iconTransformation(origin = {-110, -10}, extent = {{-10, -10},{10, 10}})));

  // Input: measured voltage magnitude for Iq boost
  Modelica.Blocks.Interfaces.RealInput U_meas_pu
    "Measured voltage magnitude at PCC/filter (pu)"
    annotation(
      Placement(
        transformation(origin = {-80, 0}, extent = {{-20, -20},{20, 20}}),
        iconTransformation(origin = {-110, -50}, extent = {{-10, -10},{10, 10}})));

  // Outputs: limited references
  Modelica.Blocks.Interfaces.RealOutput id_lim
    "d-axis limited current reference"
    annotation(
      Placement(
        transformation(origin = {80, 30}, extent = {{-20, -20},{20, 20}}),
        iconTransformation(origin = {110, 40}, extent = {{-10, -10},{10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput iq_lim
    "q-axis limited current reference"
    annotation(
      Placement(
        transformation(origin = {80, -30}, extent = {{-20, -20},{20, 20}}),
        iconTransformation(origin = {110, -40}, extent = {{-10, -10},{10, 10}})));

protected
  Real iq_boost "Reactive current boost under undervoltage (pu)";
  Real iq_eff   "Effective reactive current reference after boost (pu)";

equation
  // ── Voltage-dependent Iq boost (WECC-like) ──────────────────
  // If U_meas falls below UboostStart, increase Iq by Kqv*(UboostStart - U_meas)
  if noEvent(U_meas_pu < UboostStart) then
    iq_boost = Kqv * (UboostStart - U_meas_pu);
  else
    iq_boost = 0;
  end if;

  // Limit the boost
  iq_boost = max(min(iq_boost, IqBoostMax), IqBoostMin);

  // Effective reactive current reference including boost
  iq_eff = iq_raw + iq_boost;

  // ── Current limiting with P/Q priority (like before, but on iq_eff) ─
  /*
     Logic analogous to CurrentLimitsCalculationB:

     - If PQFlag = true  (P priority):
         * d-axis (id_raw) has priority.
         * If |id_raw| >= Imax: put all current on d-axis, iq_lim = 0.
         * Else:  id_lim = id_raw;
                 iq is limited so that id^2 + iq^2 <= Imax^2.

     - If PQFlag = false (Q priority):
         * q-axis (iq_eff) has priority.
         * If |iq_eff| >= Imax: put all current on q-axis, id_lim = 0.
         * Else:  iq_lim = iq_eff;
                 id is limited so that id^2 + iq^2 <= Imax^2.
  */

  if PQFlag then
    // ---- P priority (d-axis) ----
    if noEvent(abs(id_raw) >= Imax) then
      // d-axis alone reaches the limit
      id_lim = sign(id_raw)*Imax;
      iq_lim = 0;
    else
      // d-axis as requested; limit q-axis accordingly
      id_lim = id_raw;
      iq_lim = max(
                 min(iq_eff,  sqrt(Imax^2 - id_raw^2)),
                -sqrt(Imax^2 - id_raw^2));
    end if;
  else
    // ---- Q priority (q-axis, including boost) ----
    if noEvent(abs(iq_eff) >= Imax) then
      // q-axis (with boost) alone reaches the limit
      iq_lim = sign(iq_eff)*Imax;
      id_lim = 0;
    else
      // q-axis as requested; limit d-axis accordingly
      iq_lim = iq_eff;
      id_lim = max(
                 min(id_raw,  sqrt(Imax^2 - iq_eff^2)),
                -sqrt(Imax^2 - iq_eff^2));
    end if;
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
             textString = "Limiter+IqBoost")
      }),
    Diagram);

end current_limiter_reactive_boost;