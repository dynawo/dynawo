within Dynawo.Electrical.Controls.WECC.Mechanical;

model WTGQa "WECC Torque Controller Type A"
extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGQA;
//Input Variables
  Modelica.Blocks.Interfaces.RealInput Pe(start=PInj0Pu) annotation(
    Placement(transformation(origin = {-140, 28}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput wg(start=SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-140, 88}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Pref0(start=PInj0Pu) annotation(
    Placement(transformation(origin = {-140, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
    Modelica.Blocks.Interfaces.BooleanInput freeze annotation(
    Placement(transformation(origin = {94, 134}, extent = {{-14, -14}, {14, 14}}, rotation = -90), iconTransformation(origin = {20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
//Output Variables
 Modelica.Blocks.Interfaces.RealOutput Pref(start=PInj0Pu) annotation(
    Placement(transformation(origin = {290, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput wref(start=SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {290, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));
    
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = [p1, spd1; p2, spd2; p3, spd3; p4, spd4], smoothness = Modelica.Blocks.Types.Smoothness.ContinuousDerivative, extrapolation = Modelica.Blocks.Types.Extrapolation.LastTwoPoints)  annotation(
    Placement(transformation(origin = {-32, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(k = 1, T = tp, y_start = PInj0Pu)  annotation(
    Placement(transformation(origin = {-62, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(k = 1, T = twref)  annotation(
    Placement(transformation(origin = {-2, 28}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = -1)  annotation(
    Placement(transformation(origin = {30, 34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1(k1 = -1)  annotation(
    Placement(transformation(origin = {-32, -18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {42, -12}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {74, 14}, extent = {{-10, 10}, {10, -10}}, rotation = -0)));
  Modelica.Blocks.Sources.BooleanConstant Tflag(k = tflag)  annotation(
    Placement(transformation(origin = {36, 14}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gain(k = kpp)  annotation(
    Placement(transformation(origin = {104, 4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {154, 16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product annotation(
    Placement(transformation(origin = {226, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = temax, uMin = temin)  annotation(
    Placement(transformation(origin = {184, 16}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedIntegratorFreeze limitedIntegratorFreeze(K = kip, YMax = temax, YMin = temin, Y0 = PInj0Pu/SystemBase.omegaRef0Pu)  annotation(
    Placement(transformation(origin = {102, 26}, extent = {{-10, -10}, {10, 10}})));
  
  equation
  connect(wg, add.u1) annotation(
    Line(points = {{-140, 88}, {16, 88}, {16, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(firstOrder1.y, add.u2) annotation(
    Line(points = {{10, 28}, {18, 28}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-51, 28}, {-51, -12}, {-44, -12}}, color = {0, 0, 127}));
  connect(Pref0, add1.u2) annotation(
    Line(points = {{-140, -20}, {-46, -20}, {-46, -24}, {-44, -24}}, color = {0, 0, 127}));
  connect(Tflag.y, switch1.u2) annotation(
    Line(points = {{40, 14}, {62, 14}}, color = {255, 0, 255}));
  connect(division.y, switch1.u1) annotation(
    Line(points = {{53, -12}, {63, -12}, {63, 6}, {62, 6}}, color = {0, 0, 127}));
  connect(add.y, switch1.u3) annotation(
    Line(points = {{41, 34}, {45, 34}, {45, 22}, {62, 22}}, color = {0, 0, 127}));
  connect(add2.y, limiter.u) annotation(
    Line(points = {{165, 16}, {171, 16}}, color = {0, 0, 127}));
  connect(wg, product.u1) annotation(
    Line(points = {{-140, 88}, {204, 88}, {204, 28}, {214, 28}}, color = {0, 0, 127}));
  connect(limitedIntegratorFreeze.y, add2.u1) annotation(
    Line(points = {{113, 26}, {142, 26}, {142, 22}}, color = {0, 0, 127}));
  connect(switch1.y, limitedIntegratorFreeze.u) annotation(
    Line(points = {{85, 14}, {85, 27}, {90, 27}, {90, 26}}, color = {0, 0, 127}));
  connect(switch1.y, gain.u) annotation(
    Line(points = {{85, 14}, {85, 5.5}, {92, 5.5}, {92, 4}}, color = {0, 0, 127}));
  connect(gain.y, add2.u2) annotation(
    Line(points = {{115, 4}, {115, 3}, {142, 3}, {142, 10}}, color = {0, 0, 127}));
  connect(limiter.y, product.u2) annotation(
    Line(points = {{196, 16}, {214, 16}}, color = {0, 0, 127}));
  connect(product.y, Pref) annotation(
    Line(points = {{238, 22}, {290, 22}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], firstOrder1.u) annotation(
    Line(points = {{-20, 28}, {-14, 28}}, color = {0, 0, 127}));
  connect(Pe, firstOrder.u) annotation(
    Line(points = {{-140, 28}, {-74, 28}}, color = {0, 0, 127}));
  connect(firstOrder.y, combiTable1D.u[1]) annotation(
    Line(points = {{-50, 28}, {-44, 28}}, color = {0, 0, 127}));
  connect(freeze, limitedIntegratorFreeze.freeze) annotation(
    Line(points = {{94, 134}, {94, 38}}, color = {255, 0, 255}));
  connect(add1.y, division.u1) annotation(
    Line(points = {{-20, -18}, {30, -18}}, color = {0, 0, 127}));
  connect(wg, division.u2) annotation(
    Line(points = {{-140, 88}, {12, 88}, {12, -6}, {30, -6}}, color = {0, 0, 127}));
  connect(firstOrder1.y, wref) annotation(
    Line(points = {{10, 28}, {14, 28}, {14, -34}, {274, -34}, {274, -16}, {290, -16}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p> This block contains the Torque controller model TypeA for a WindTurbineGenerator Type 3 according to <br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a> </p><p>&nbsp;It is a simplified generic 
model. The model is relatively simple. It takes in the speed of the generator (ωg), the electrical 
power developed by the generator (Pe), and the power reference coming from the power plant 
controller (Prefo), and thus determines the electrical-torque needed.<!--EndFragment-->&nbsp;</p><p>&nbsp;The flag, Tflag, allows the user to determine whether the torque is changed based on 
the speed reference and change in generator speed, or the power reference.</p><!--StartFragment--><!--EndFragment-->


<p>
 </p><p></p></body></html>"),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram(coordinateSystem(extent = {{-120, 120}, {280, -40}})),
    version = "",
  Icon(graphics = {Text(origin = {-117, 94}, extent = {{-19, 12}, {19, -12}}, textString = "wg"), Text(origin = {-127, 32}, extent = {{-15, 12}, {15, -12}}, textString = "Pe"), Text(origin = {-126, -38}, extent = {{-22, 16}, {22, -16}}, textString = "Pref0"), Text(origin = {-1, 2}, extent = {{-59, 42}, {59, -42}}, textString = "WTGQ_A"), Text(origin = {119, 84}, extent = {{-19, 12}, {19, -12}}, textString = "Pref"), Text(origin = {121, -37}, extent = {{-23, 11}, {23, -11}}, textString = "wref"), Text(origin = {52, -108}, extent = {{14, 20}, {-14, -20}}, textString = "Freeze"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGQa;
