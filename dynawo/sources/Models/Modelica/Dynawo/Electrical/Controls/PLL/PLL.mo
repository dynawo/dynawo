within Dynawo.Electrical.Controls.PLL;

model PLL "Phase-Locked Loop"

  import Modelica.Blocks;
  import Modelica.ComplexBlocks;
  import Modelica.Constants;
  import Modelica.SIunits;  
    
  import Dynawo.Connectors;

  parameter SIunits.PerUnit Kp "PLL voltage calculation proportional gain";
  parameter SIunits.PerUnit Ki "PLL voltage calculation integrator";
  parameter SIunits.PerUnit fmin "Lower frequency limit (only positive values!)";
  parameter SIunits.PerUnit fmax "Upper frequency limit";
  parameter SIunits.PerUnit fref "Frequency refence value";

  // Inputs:
  ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at PCC (pu base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-116, 29}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {-101, 51}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Blocks.Interfaces.RealInput OmegaRefPu(start = Omega0Pu) "Reference frequency of the system. Either connected to the reference machine or the center of inertia frequency or set be constant 1." annotation(
    Placement(visible = true, transformation(origin = {-117, -70}, extent = {{-18, -18}, {18, 18}}, rotation = 0), iconTransformation(origin = {-101, -47}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  
  // Outputs:
  Blocks.Interfaces.RealOutput fmeas "Measured Frequency, PLL (pu)" annotation(
    Placement(visible = true, transformation(origin = {160, -63}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {106, 50}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput sinphi "sin(phi) aligned with terminal voltage phasor" annotation(
    Placement(visible = true, transformation(origin = {160, 53}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {106, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Blocks.Interfaces.RealOutput cosphi "cos(phi) aligned with terminal voltage phasor" annotation(
    Placement(visible = true, transformation(origin = {160, 5}, extent = {{-17, -17}, {17, 17}}, rotation = 0), iconTransformation(origin = {106, -46}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  
  // Blocks:
  Blocks.Math.Product ur_x_sinPhi annotation(
    Placement(visible = true, transformation(origin = {-72, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Product ui_x_cosPhi annotation(
    Placement(visible = true, transformation(origin = {-72, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add uq(k1 = -1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {-42, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain K(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {0, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.LimIntegrator I(initType = Modelica.Blocks.Types.Init.SteadyState, k = Ki, outMax = (fmax-fref)*2*Constants.pi, outMin =(fref-fmin)*2*Constants.pi) annotation(
    Placement(visible = true, transformation(origin = {0, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add dOmega(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {40, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.Integrator Phi(initType = Modelica.Blocks.Types.Init.SteadyState, k = 1) annotation(
    Placement(visible = true, transformation(origin = {76, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Sin sinPhi annotation(
    Placement(visible = true, transformation(origin = {116, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Cos cosPhi annotation(
    Placement(visible = true, transformation(origin = {116, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add OmegaRad(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {78, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain fPu(k = 1 / (2 * Constants.pi)) annotation(
    Placement(visible = true, transformation(origin = {122, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Gain OmegaRefRad(k = 2 * Constants.pi) annotation(
    Placement(visible = true, transformation(origin = {-2, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected

  parameter Types.ComplexVoltagePu u0Pu "Start value of complex voltage in p.u (base UNom)";
  parameter Types.PerUnit Omega0Pu "Start value of angular speed";

equation
  connect(dOmega.y, OmegaRad.u1) annotation(
    Line(points = {{52, 28}, {54, 28}, {54, -58}, {66, -58}}, color = {0, 0, 127}));
  connect(OmegaRad.y, fPu.u) annotation(
    Line(points = {{89, -64}, {110, -64}}, color = {0, 0, 127}));
  connect(OmegaRefRad.y, OmegaRad.u2) annotation(
    Line(points = {{10, -70}, {66, -70}}, color = {0, 0, 127}));
  connect(OmegaRefPu, OmegaRefRad.u) annotation(
    Line(points = {{-116, -70}, {-16, -70}, {-16, -70}, {-14, -70}}, color = {0, 0, 127}));
  connect(uPu.re, ur_x_sinPhi.u2) annotation(
    Line(points = {{-116, 29}, {-94, 29}, {-94, 62}, {-84, 62}}, color = {85, 170, 255}));
  connect(uPu.im, ui_x_cosPhi.u1) annotation(
    Line(points = {{-116, 29}, {-94, 29}, {-94, -12}, {-84, -12}, {-84, -10}}, color = {85, 170, 255}));
  connect(uq.y, K.u) annotation(
    Line(points = {{-31, 28}, {-22, 28}, {-22, 52}, {-12, 52}}, color = {0, 0, 127}));
  connect(K.y, dOmega.u1) annotation(
    Line(points = {{11, 52}, {18, 52}, {18, 34}, {28, 34}}, color = {0, 0, 127}));
  connect(sinPhi.y, ur_x_sinPhi.u1) annotation(
    Line(points = {{128, 52}, {132, 52}, {132, 92}, {-94, 92}, {-94, 74}, {-84, 74}}, color = {0, 0, 127}));
  connect(cosPhi.y, ui_x_cosPhi.u2) annotation(
    Line(points = {{128, 4}, {132, 4}, {132, -36}, {-94, -36}, {-94, -22}, {-84, -22}}, color = {0, 0, 127}));
  connect(fPu.y, fmeas) annotation(
    Line(points = {{133, -64}, {150, -64}, {150, -62}, {160, -62}}, color = {0, 0, 127}));
  connect(uq.y, I.u) annotation(
    Line(points = {{-31, 28}, {-22, 28}, {-22, 8}, {-12, 8}}, color = {0, 0, 127}));
  connect(I.y, dOmega.u2) annotation(
    Line(points = {{11, 8}, {18, 8}, {18, 22}, {28, 22}}, color = {0, 0, 127}));
  connect(ui_x_cosPhi.y, uq.u2) annotation(
    Line(points = {{-61, -16}, {-56, -16}, {-56, 21}, {-54, 21}, {-54, 22}}, color = {0, 0, 127}));
  connect(ur_x_sinPhi.y, uq.u1) annotation(
    Line(points = {{-61, 68}, {-56, 68}, {-56, 35}, {-54, 35}, {-54, 34}}, color = {0, 0, 127}));
  connect(cosPhi.y, cosphi) annotation(
    Line(points = {{128, 4}, {150, 4}, {150, 6}, {160, 6}}, color = {0, 0, 127}));
  connect(sinPhi.y, sinphi) annotation(
    Line(points = {{128, 52}, {148, 52}, {148, 54}, {160, 54}}, color = {0, 0, 127}));
  connect(Phi.y, cosPhi.u) annotation(
    Line(points = {{88, 28}, {92, 28}, {92, 4}, {104, 4}, {104, 4}}, color = {0, 0, 127}));
  connect(Phi.y, sinPhi.u) annotation(
    Line(points = {{88, 28}, {92, 28}, {92, 52}, {104, 52}, {104, 52}}, color = {0, 0, 127}));
  connect(Phi.y, cosPhi.u) annotation(
    Line(points = {{88, 28}, {92, 28}, {92, 4}, {104, 4}, {104, 4}, {104, 4}}, color = {0, 0, 127}));
  connect(Phi.y, sinPhi.u) annotation(
    Line(points = {{88, 28}, {92, 28}, {92, 52}, {104, 52}, {104, 52}}, color = {0, 0, 127}));
  connect(dOmega.y, Phi.u) annotation(
    Line(points = {{52, 28}, {64, 28}, {64, 28}, {64, 28}}, color = {0, 0, 127}));
  
annotation(
    Documentation(info = "<html> 
<p> The PLL calculates the frequency of the grid voltage by synchronizing the internal phase angle with measured voltage phasor. q-component of internal voltage phasor is therefore controlled to be zero. </p>

<p> Following relationship is used to calculate internal voltage phasor q-component: </p>
<pre>
   uq = ui*cos(phi)-ur*sin(phi);
</pre>

<p> If uq is zero, the internal phasor is locked with the measured phasor and rotates with the same frequency.</p>

</html>"),
    Icon(graphics = {Rectangle(origin = {-1, 0}, extent = {{-99, 100}, {101, -100}}), Text(origin = {-48, 33}, extent = {{148, -85}, {-44, 19}}, textString = "PLL")}, coordinateSystem(extent = {{-100, -100}, {150, 100}})),
    Diagram(coordinateSystem(extent = {{-100, -100}, {150, 100}})),
    __OpenModelica_commandLineOptions = "");

end PLL;
