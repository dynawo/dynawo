within Dynawo.Examples.GridForming;

model synchronisation
  parameter Types.PerUnit WLP "60 Cutoff pulsation of the active and reactive filters (in rad/s)";
  parameter Types.PerUnit Mp "Active power droop control coefficient, equal to 0.05Wn";
  parameter Types.PerUnit Theta0=0 "";
  parameter Types.PerUnit WPLL "Dynamic of the PLL";
  parameter Boolean Wref_FromPLL "TRUE if the reference for Wref is coming from PLL";
  parameter Real PLL_W_init "Start feequency for the PLL";
  parameter Real omegaSetPu_ "WSet as input for the droop Control ";
  
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {70, 94}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1/ WLP, k = 1, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {100, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {20, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaSetPu(k = omegaSetPu_) annotation(
    Placement(visible = true, transformation(origin = {-120, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Mp) annotation(
    Placement(visible = true, transformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PFilterPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -57}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0) annotation(
    Placement(visible = true, transformation(origin = {130, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPLLSetPu(start = 0) annotation(
    Placement(visible = true, transformation(origin = {-130, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-22, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = WPLL, k = 1, y_start = PLL_W_init) annotation(
    Placement(visible = true, transformation(origin = {-72, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = Wref_FromPLL)  annotation(
    Placement(visible = true, transformation(origin = {-108, -10}, extent = {{-18, -10}, {18, 10}}, rotation = 0)));
equation
  connect(feedback1.u1, PRefPu) annotation(
    Line(points = {{-88, 100}, {-130, 100}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{31, 94}, {40, 94}, {40, 40}, {130, 40}}, color = {0, 0, 127}));
  connect(add1.y, feedback2.u1) annotation(
    Line(points = {{31, 94}, {62, 94}}, color = {0, 0, 127}));
  connect(PFilterPu, feedback1.u2) annotation(
    Line(points = {{-130, 52}, {-80, 52}, {-80, 92}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{88, 94}, {79, 94}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-9, 100}, {8, 100}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{111, 94}, {130, 94}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-130, 120}, {70, 120}, {70, 102}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-71, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-39, 100}, {-32, 100}}, color = {0, 0, 127}));
  connect(switch1.y, add1.u2) annotation(
    Line(points = {{-11, 10}, {-2, 10}, {-2, 88}, {8, 88}}, color = {0, 0, 127}));
  connect(omegaPLLSetPu, firstOrder1.u) annotation(
    Line(points = {{-130, 28}, {-84, 28}}, color = {0, 0, 127}));
  connect(firstOrder1.y, switch1.u1) annotation(
    Line(points = {{-60, 28}, {-48, 28}, {-48, 18}, {-34, 18}}, color = {0, 0, 127}));
  connect(booleanExpression.y, switch1.u2) annotation(
    Line(points = {{-88, -10}, {-78, -10}, {-78, 10}, {-34, 10}}, color = {255, 0, 255}));
  connect(omegaSetPu.y, switch1.u3) annotation(
    Line(points = {{-108, -42}, {-66, -42}, {-66, 2}, {-34, 2}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 140}, {140, -60}})),
    Icon(graphics = {Text(origin = {159, 62}, extent = {{-37, 24}, {37, -24}}, textString = "Theta"), Text(origin = {169, -40}, extent = {{-43, 24}, {43, -24}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, -1}, extent = {{-99, 99}, {99, -99}}, textString = "PowerSynchro"), Text(origin = {-173, 5}, extent = {{-51, 23}, {51, -23}}, textString = "PFilterPu"), Text(origin = {-160, 78}, extent = {{-38, 14}, {38, -14}}, textString = "PRefPu"), Text(origin = {-178, -52}, extent = {{-60, 16}, {60, -16}}, textString = "omegaRefPu"), Text(origin = {63, 129}, extent = {{-51, 23}, {51, -23}}, textString = "omegaRefPLLPu")}));
end synchronisation;