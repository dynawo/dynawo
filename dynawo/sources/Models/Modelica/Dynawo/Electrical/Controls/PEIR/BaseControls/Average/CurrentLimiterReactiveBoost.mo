within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model CurrentLimiterReactiveBoost "Limit sqrt(id^2 + iq^2) to IMaxPu with P/Q priority and bidirectional Iq boost (undervoltage + overvoltage)"

  // Parameters
  parameter Types.CurrentModulePu IMaxPu "Maximum current amplitude in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit IqBoostMaxPu = IMaxPu "Maximum additional reactive current boost in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit IqBoostMinPu = -IMaxPu "Minimum additional reactive current boost in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit Kqv "Gain for voltage-dependent reactive boost (pu Iq / pu U). Set 0 to disable boost";
  parameter Boolean PQFlag "Q/P priority: Q (false=0) or P (true=1) priority, as in WECC";
  parameter Types.Time tBoost "Time constant of first-order filter on iqBoostPu in s to delay the reactive boost response. Set 0 to disable";
  parameter Types.VoltageModulePu UBoostLowPu "Lower voltage threshold: below this, inject more Q in pu (base UNom)";
  parameter Types.VoltageModulePu UBoostHighPu "Upper voltage threshold: above this, absorb more Q in pu (base UNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idRawPu "d-axis (P-like) raw current reference in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqRawPu "q-axis (Q-like) raw current reference in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu "Measured voltage magnitude at PCC/filter (pu)" annotation(
    Placement(
      transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput idLimPu "d-axis limited current reference in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {120, 32}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqLimPu "q-axis limited current reference in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(
      transformation(origin = {120, -30}, extent = {{-20, -20}, {20, 20}}),
      iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  // Internal variables
  Types.PerUnit iqBoostPu "Reactive current boost after limiting and filtering in pu (base SNom, UNom) (generator convention)";
  Types.PerUnit iqBoostRawPu "Reactive current boost before limiting in pu (base SNom, UNom) (generator convention)";
  Types.PerUnit iqBoostUnfilteredPu "Reactive current boost after limiting, before filter in pu (base SNom, UNom) (generator convention)";
  Types.PerUnit iqEffPu "Effective reactive current reference after boost in pu (base SNom, UNom) (generator convention)";

  // Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage magnitude at PCC in pu (base UNom), used to initialise iqBoostPu";

initial equation
  // ── Initialise filter state at steady-state boost value ──────
  if tBoost > 0 then
    iqBoostPu = max(
                 min(
                   if U0Pu < UBoostLowPu then Kqv * (1 - U0Pu)
                   elseif U0Pu > UBoostHighPu then Kqv * (1 - U0Pu)
                   else 0,
                   IqBoostMaxPu),
                 IqBoostMinPu);
  end if;

equation
  // ── Step 1: compute raw boost (undervoltage + overvoltage) ───
  if noEvent(ULVPu < UBoostLowPu) then
    iqBoostRawPu = Kqv * (UBoostLowPu- ULVPu);
  elseif noEvent(ULVPu > UBoostHighPu) then
    iqBoostRawPu = Kqv * (UBoostHighPu - ULVPu);
  else
    iqBoostRawPu = 0;
  end if;

  // ── Step 2: limit the boost ──────────────────────────────────
  iqBoostUnfilteredPu = max(min(iqBoostRawPu, IqBoostMaxPu), IqBoostMinPu);

  // ── Step 2b: first-order filter on boost ─────────────────────
  if noEvent(tBoost > 0) then
    tBoost * der(iqBoostPu) = iqBoostUnfilteredPu - iqBoostPu;
  else
    iqBoostPu = iqBoostUnfilteredPu;
  end if;

  // ── Step 3: effective iq reference ───────────────────────────
  iqEffPu = iqRawPu + iqBoostPu;

  // ── Step 4: current limiting with P/Q priority ───────────────
  if PQFlag then
    // P priority (d-axis)
    if noEvent(abs(idRawPu) >= IMaxPu) then
      idLimPu = if (idRawPu)>0 then  IMaxPu else -  IMaxPu;
      iqLimPu = 0;
    else
      idLimPu = idRawPu;
      iqLimPu = -max(
                 min(iqEffPu,  sqrt(max(IMaxPu^2 - idRawPu^2, 0))),
                -sqrt(max(IMaxPu^2 - idRawPu^2, 0)));
    end if;
  else
    // Q priority (q-axis including boost)
    if noEvent(abs(iqEffPu) >= IMaxPu) then
      iqLimPu =  if iqEffPu>0 then  -IMaxPu else IMaxPu;
      idLimPu = 0;
    else
      iqLimPu = -iqEffPu;
      idLimPu = max(
                 min(idRawPu,  sqrt(max(IMaxPu^2 - iqEffPu^2, 0))),
                -sqrt(max(IMaxPu^2 - iqEffPu^2, 0)));
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
             textString = "IqBoost ±"),
        Text(origin = {0, -60}, extent = {{-80, 20}, {80, -20}},
             textString = "tBoost filter")}),
    Diagram,
  Documentation(info = "<html><head></head><body>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> Current limiter with reactive boost </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">for</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> a GFL converter </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">outer</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">loop</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> This </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">block</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> enforces the current amplitude constraint </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#0000ff;\">sqrt</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">(id² + iq²) ≤ IMaxPu</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">and</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> applies a voltage-dependent reactive current boost (Iq boost) to support</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> grid voltage during under- </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">and</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> overvoltage events.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">── Reactive boost logic ─────────────────────────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   U &lt; UBoostLowPu  → undervoltage: inject reactive current (iqBoostPu &gt; </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b008b;\">0</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   U &gt; UBoostHighPu → overvoltage:  absorb reactive current (iqBoostPu &lt; </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b008b;\">0</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   UBoostLowPu ≤ U ≤ UBoostHighPu → deadband: no boost</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   The boost magnitude is proportional to the voltage deviation via gain Kqv.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   It is </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">then</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> saturated between IqBoostMinPu </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">and</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> IqBoostMaxPu.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   The boost signal is filtered by a first-order low-pass with time </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">constant</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   tBoost to avoid discontinuous jumps </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">in</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> the current reference.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> ── Current limiting ─────────────────────────────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   Priority is selected via PQFlag (consistent with WECC convention):</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   PQFlag = </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">true</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">  → P priority: idRawPu respected first, iq clipped to circle</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   PQFlag = </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">false</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> → Q priority: iqEffPu respected first, id clipped to circle</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   In both cases the total current never exceeds IMaxPu.</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> ── Sign convention ──────────────────────────────────────────────────────────</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   Inputs idRawPu </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">and</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> iqRawPu follow generator convention (injection positive).</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   iqLimPu is </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">output</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> with a sign flip (−iqEffPu) to match the </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">inner</span><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> </span><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#8b0000;\">loop</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">   current reference convention used downstream.</span><!--EndFragment--></pre></body></html>"));
end CurrentLimiterReactiveBoost;
