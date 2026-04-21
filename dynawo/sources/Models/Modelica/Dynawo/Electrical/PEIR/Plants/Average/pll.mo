within Dynawo.Electrical.PEIR.Plants.Average;

model pll "Phase-Locked Loop"
  // Parameters
  parameter Types.PerUnit Ki "PLL integrator gain";
  parameter Types.PerUnit Kp "PLL proportional gain";
  parameter Types.PerUnit OmegaMaxPu "Upper frequency limit in pu (base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu "Lower frequency limit in pu (base OmegaNom)";
  // Initial parameter
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Real Omega0Pu "initial frequency in pu";
  parameter Real uqgrid0PU "initial voltage on q axis";
  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu) "Reference frequency of the system in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqgridPu(start =uqgrid0PU) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Output variables
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = Omega0Pu) "Measured frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) "Voltage phase at PCC in rad" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  // Internal blocks
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Theta0, k = SystemBase.omegaNom, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Ki, outMax = OmegaMaxPu - Omega0Pu, outMin = OmegaMinPu - Omega0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{121, -60}, {150, -60}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-150, -80}, {80, -80}, {80, -66}, {98, -66}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{121, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{11, -20}, {20, -20}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{61, 0}, {80, 0}, {80, -54}, {98, -54}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{11, 20}, {20, 20}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(uqgridPu, gain.u) annotation(
    Line(points = {{-150, 0}, {-60, 0}, {-60, 20}, {-12, 20}}, color = {0, 0, 127}));
  connect(limIntegrator.u, uqgridPu) annotation(
    Line(points = {{-12, -20}, {-60, -20}, {-60, 0}, {-150, 0}}, color = {0, 0, 127}));
  annotation(
    preferredView = "diagram",
    Documentation(info = "<html><head></head><body>
<p>The PLL calculates the frequency of the grid voltage by synchronizing the internal phase angle with the measured voltage phasor. The q-component of the internal voltage phasor is controlled to be zero.</p>
<p>Following relationship is used to calculate the internal voltage phasor q-component:</p>
<pre>uqPu = uiPu * cos(phi) - urPu * sin(phi);</pre>
<p>If uqPu is zero, the internal phasor is locked with the measured phasor and rotates with the same frequency.</p>
</body></html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLL")}));
end pll;