within Dynawo.Examples.GridFollowing.SMIB;

model SMIBdynGFL "Grid following converter with an infinite bus"
  parameter Real Ur = 1.0047*cos(0.033);
  parameter Real Ui = 1.0047*sin(0.033);
  parameter Real Uphase = 0.033;

  Dynawo.Electrical.PEIR.Plants.General.Average.GridFollowing.DynGFLPlantQCtrl gFLmodelnodyn(
  // Initial conditions — PCC node
  SNom = 100,
  U0Pu = 1.0047,
  UPhase0 = Uphase,
  P0Pu = -0.6,
  Q0Pu = -0.0016854,
  Omega0Pu = 1.0,
  // VSC Pade delay
  tVSC = 1e-5,
  // LC filter
  RFilterPu = 0.00001,
  LFilterPu = 0.001,
  CFilterPu = 1e-4,
  omegaNom = 2*Modelica.Constants.pi*50,
  // LV transformer (filter → LV node)
  RTransformerLVPu = 0.00005,
  LTransformerLVPu = 0.00008,
  // HV transformer (LV node → PCC)
  RTransformerHVPu = 0.00001,
  LTransformerHVPu = 0.00005,
  // Measurement filter
  KFilter = 1,
  tFilter = 1e-4,
  // Inner current loop
  Kpc = 2.7,
  Kic = 81.0,
  // Voltage feedforward
  Kfd = 1,
  Kfq = 1,
  // Outer loop
  KpdOuter = 0.3,
  KidOuter = 1.0,
  KpqOuter = 0.3,
  KiqOuter = 1.0,
  PControlFlag = false,
  QControlFlag = false,
  tBoost = 1e-5,
  // Current limiter
  UBoostHighPu = 1.1,
  UBoostLowPu = 0.9,
  Kqv = 0.3,
  IMaxPu = 8,
  PQFlag = false,
  IqBoostMaxPu = 0.5,
  IqBoostMinPu = -0.5,
  // Plant controller
  KpqPlant = 0.05,
  KiqPlant = 0.5,
  KppPlant = 0.05,
  KipPlant = 0.5,
  LambdaPu = 0.28,
  KDroop = 0.03,
  QMaxPu = 0.5,
  QMinPu = -0.5,
  PMaxPu = 23,
  PMinPu = 0,
  FEMaxPu = 0.05,
  FEMinPu = -0.05,
  FDbd1Pu = 0.005,
  FDbd2Pu = 0.01,
  DbdPu = 0.005,
  // PLL
  KpPLL = 10.0,
  KiPLL = 25.0,
  OmegaMaxPu = 1.05,
  OmegaMinPu = 0.95,
  // Rate limiters and delays
  DidMax = 10.0,
  DidMin = -10.0,
  tSid = 1e-4,
  tPlant = 1e-3) annotation(
    Placement(transformation(extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Constant URefPu(k = gFLmodelnodyn.URef0Pu) annotation(
    Placement(transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omegaRef(k = 1.0) annotation(
    Placement(transformation(origin = {-70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Step PRefPu(height = 0.1, offset = 0.6, startTime = 1000) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPu = 1.0047, UPhase = 0.033) annotation(
    Placement(transformation(origin = {100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));

equation
  gFLmodelnodyn.switchOffSignal1 = false;
  gFLmodelnodyn.switchOffSignal2 = false;
  gFLmodelnodyn.switchOffSignal3 = false;

  connect(omegaRef.y, gFLmodelnodyn.omegaRefPu) annotation(
    Line(points = {{-59, -40}, {-39, -40}, {-39, -12}, {-22, -12}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.terminal, infiniteBus.terminal) annotation(
    Line(points = {{20, 0}, {20, -0.5}, {100, -0.5}, {100, 0}}, color = {0, 0, 255}));
  connect(gFLmodelnodyn.PRefPu, PRefPu.y) annotation(
    Line(points = {{-22, 12}, {-41.5, 12}, {-41.5,  40}, {-59, 40}}, color = {0, 0, 127}));
  connect(gFLmodelnodyn.URefPu, URefPu.y) annotation(
    Line(points = {{-22, 0}, {-59, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    experiment(StartTime = 0, StopTime = 20, Tolerance = 1e-6, Interval = 0.0005),
    Icon(graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Ellipse(lineColor = {75, 138, 73}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Polygon(lineColor = {0, 0, 255}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-36, 60}, {64, 0}, {-36, -60}, {-36, 60}})}),
        Documentation(info = "<html><head></head><body>
<h4>SMIB test: grid-following converter connected directly to an infinite bus</h4>

<p>One grid-following converter with plant control (<code>DynGFLPlantQCtrl</code>) is connected directly to an infinite
bus, with no line in between. The PCC voltage is therefore imposed by the infinite bus (infinitely strong grid).</p>

<p>This case checks the initialization: no event occurs within the simulation window, so all variables should stay at
their initial values. Any drift or transient at t = 0 shows that the start values do not match the steady state.</p>

<h4>Network</h4>
<pre>
  gFLmodelnodyn (PCC) ---- infiniteBus (U = 1.0047 pu, UPhase = 0.033 rad)
</pre>

<h4>Initial operating point (PCC)</h4>
<ul>
  <li><code>SNom = 100 MVA</code>, equal to SnRef, so the machine base and the system base are the same;</li>
  <li><code>P0Pu = -0.6</code>, <code>Q0Pu = -0.0016854</code> (receptor convention): the converter injects
      P = 0.6 pu and Q = 0.0017 pu;</li>
  <li><code>U0Pu = 1.0047 pu</code>, <code>UPhase0 = 0.033 rad</code>, equal to the infinite bus voltage.</li>
</ul>

<h4>References</h4>
<ul>
  <li><code>omegaRef</code>: constant, 1 pu;</li>
  <li><code>URefPu</code>: constant, equal to the initial voltage reference of the plant controller,
      <code>gFLmodelnodyn.URef0Pu = U0Pu + LambdaPu*QPcc0Pu &asymp; 1.00517 pu</code>, so the U + lambda*Q control starts
      with no error;</li>
  <li><code>PRefPu</code> (active power reference): starts at 0.6 pu, equal to <code>PPcc0Pu</code>, with a step of
      +0.1 pu at t = 1000 s, outside the 20 s window (inactive). Set <code>startTime</code> below <code>StopTime</code>
      to test an active power step.</li>
</ul>
</body></html>"),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --allowNonStandardModelica ");
end SMIBdynGFL;
