within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

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

protected
  Real iq_boost_raw "Reactive current boost before limiting (pu)";
  Real iq_boost     "Reactive current boost after limiting (pu)";
  Real iq_eff       "Effective reactive current reference after boost (pu)";

equation
  // ── Step 1: compute raw boost (undervoltage + overvoltage) ───
  /*
     - Se U_meas_pu <  UboostLow  → inietto Q (iq_boost_raw > 0 se Kqv > 0)
     - Se U_meas_pu >  UboostHigh → assorbo Q (iq_boost_raw < 0 se Kqv > 0)
     - Fra UboostLow e UboostHigh → nessun boost (banda morta)
  */
  if noEvent(U_meas_pu < UboostLow) then
    // Sottotensione: iniezione di Q
    iq_boost_raw = Kqv * (UboostLow - U_meas_pu);
  elseif noEvent(U_meas_pu > UboostHigh) then
    // Sovratensione: assorbimento di Q
    iq_boost_raw = Kqv * (UboostHigh - U_meas_pu);
  else
    // Banda morta: nessun contributo di boost
    iq_boost_raw = 0;
  end if;

  // ── Step 2: limit the boost ──────────────────────────────────
  iq_boost = max(min(iq_boost_raw, IqBoostMax), IqBoostMin);

  // ── Step 3: effective iq reference ───────────────────────────
  iq_eff = iq_raw + iq_boost;

  // ── Step 4: current limiting with P/Q priority ───────────────
  /*
     Se PQFlag = true  (priorità P):
       - asse d prioritario
       - se |id_raw| >= Imax: tutta la corrente su d, iq_lim = 0
       - altrimenti: id_lim = id_raw, iq limitato dal cerchio

     Se PQFlag = false (priorità Q):
       - asse q (incluso boost) prioritario
       - se |iq_eff| >= Imax: tutta la corrente su q, id_lim = 0
       - altrimenti: iq_lim = iq_eff, id limitato dal cerchio
  */
  if PQFlag then
    // P priority (d-axis)
    if noEvent(abs(id_raw) >= Imax) then
      id_lim = sign(id_raw) * Imax;
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
      iq_lim = -sign(iq_eff) * Imax;
      id_lim = 0;
    else
      iq_lim = -iq_eff;
      id_lim = max(
                 min(id_raw,  sqrt(max(Imax^2 - iq_eff^2, 0))),
                -sqrt(max(Imax^2 - iq_eff^2, 0)));
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
             textString = "Limiter"),
        Text(origin = {0, -20}, extent = {{-80, 20}, {80, -20}},
             textString = "IqBoost ±")}),
    Diagram);

end current_limiter_reactive_boost;
