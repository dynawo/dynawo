within Dynawo.Electrical.Controls.WECC.Mechanical;

model WTGPb " WECC Pitch Controller Type B"
extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGPB;
  Modelica.Blocks.Interfaces.RealInput Pord(start=PInj0Pu) annotation(
    Placement(transformation(origin = {-102, -42}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput Pref(start=PInj0Pu) annotation(
    Placement(transformation(origin = {-60, -88}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-61, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput wref(start=SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-102, 66}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput wt(start=SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-48, 108}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-61, 109}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput theta(start=thetaInit) annotation(
    Placement(transformation(origin = {142, 42}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum annotation(
    Placement(transformation(origin = {-60, -42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kcc(k = kcc) annotation(
    Placement(transformation(origin = {-48, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Sum sum1(nin = 3, each final k = {1, -1, 1}) annotation(
    Placement(transformation(origin = {-48, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kpc(k = kpc) annotation(
    Placement(transformation(origin = {-22, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add annotation(
    Placement(transformation(origin = {6, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain Kpw(k = kpw) annotation(
    Placement(transformation(origin = {-20, 48}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(transformation(origin = {4, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = thetawmax, uMin = thetawmin) annotation(
    Placement(transformation(origin = {32, 64}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax = thetacmax, uMin = thetacmin) annotation(
    Placement(transformation(origin = {34, -44}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(transformation(origin = {60, 42}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.AntiWindupIntegratorNoDerivative antiWindupIntegratorNoDerivative(tI = 1/kiw, YMax = thetawmax, YMin = thetawmin, Y0 = 0) annotation(
    Placement(transformation(origin = {-22, 86}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.AntiWindupIntegratorNoDerivative antiWindupIntegratorNoDerivative1(YMax = thetacmax, YMin = thetacmin, tI = 1/kic, Y0 = 0) annotation(
    Placement(transformation(origin = {-20, -26}, extent = {{-10, -10}, {10, 10}})));
 NonElectrical.Blocks.NonLinear.LimRateLimFirstOrder limRateLimFirstOrder(DuMax = thetarmax, DuMin = thetarmin, tS = ttheta, YMax = thetamax, YMin = thetamin, Y0 = thetaInit)  annotation(
    Placement(transformation(origin = {88, 42}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(Pord, sum.u1) annotation(
    Line(points = {{-102, -42}, {-68, -42}}, color = {0, 0, 127}));
  connect(Pref, sum.u2) annotation(
    Line(points = {{-60, -88}, {-60, -50}}, color = {0, 0, 127}));
  connect(sum.y, Kcc.u) annotation(
    Line(points = {{-50, -42}, {-48, -42}, {-48, -8}}, color = {0, 0, 127}));
  connect(wt, sum1.u[1]) annotation(
    Line(points = {{-48, 108}, {-60, 108}, {-60, 66}}, color = {0, 0, 127}));
  connect(wref, sum1.u[2]) annotation(
    Line(points = {{-102, 66}, {-60, 66}}, color = {0, 0, 127}));
  connect(Kcc.y, sum1.u[3]) annotation(
    Line(points = {{-48, 16}, {-60, 16}, {-60, 66}}, color = {0, 0, 127}));
  connect(sum.y, Kpc.u) annotation(
    Line(points = {{-50, -42}, {-34, -42}, {-34, -58}}, color = {0, 0, 127}));
  connect(Kpc.y, add.u2) annotation(
    Line(points = {{-11, -58}, {-6, -58}, {-6, -50}}, color = {0, 0, 127}));
  connect(Kpw.y, add1.u2) annotation(
    Line(points = {{-9, 48}, {-8, 48}, {-8, 58}}, color = {0, 0, 127}));
  connect(sum1.y, Kpw.u) annotation(
    Line(points = {{-36, 66}, {-32, 66}, {-32, 48}}, color = {0, 0, 127}));
  connect(add.y, limiter1.u) annotation(
    Line(points = {{17, -44}, {22, -44}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{15, 64}, {20, 64}}, color = {0, 0, 127}));
  connect(limiter.y, add2.u1) annotation(
    Line(points = {{44, 64}, {48, 64}, {48, 48}}, color = {0, 0, 127}));
  connect(limiter1.y, add2.u2) annotation(
    Line(points = {{46, -44}, {48, -44}, {48, 36}}, color = {0, 0, 127}));
  connect(sum1.y, antiWindupIntegratorNoDerivative.u) annotation(
    Line(points = {{-36, 66}, {-34, 66}, {-34, 86}}, color = {0, 0, 127}));
  connect(antiWindupIntegratorNoDerivative.y, add1.u1) annotation(
    Line(points = {{-10, 86}, {-8, 86}, {-8, 70}}, color = {0, 0, 127}));
  connect(antiWindupIntegratorNoDerivative1.y, add.u1) annotation(
    Line(points = {{-8, -26}, {-6, -26}, {-6, -38}}, color = {0, 0, 127}));
  connect(sum.y, antiWindupIntegratorNoDerivative1.u) annotation(
    Line(points = {{-50, -42}, {-32, -42}, {-32, -26}}, color = {0, 0, 127}));
  if abs(limRateLimFirstOrder.y-thetamax)<1e-6 then
    antiWindupIntegratorNoDerivative.fMax = true;
    antiWindupIntegratorNoDerivative.fMin = false;
    antiWindupIntegratorNoDerivative1.fMax = true;
    antiWindupIntegratorNoDerivative1.fMin = false;
  elseif abs(limRateLimFirstOrder.y-thetamin)<1e-6 then
    antiWindupIntegratorNoDerivative.fMax = false;
    antiWindupIntegratorNoDerivative.fMin = true;
    antiWindupIntegratorNoDerivative1.fMax = false;
    antiWindupIntegratorNoDerivative1.fMin = true;
  else
    antiWindupIntegratorNoDerivative.fMax = false;
    antiWindupIntegratorNoDerivative.fMin = false;
    antiWindupIntegratorNoDerivative1.fMax = false;
    antiWindupIntegratorNoDerivative1.fMin = false;
  end if annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Icon(graphics = {Text(origin = {116, 22}, extent = {{-18, 12}, {18, -12}}, textString = "theta"), Text(origin = {-34, 114}, extent = {{-28, 14}, {28, -14}}, textString = "wt"), Text(origin = {-127, 85}, extent = {{-21, 13}, {21, -13}}, textString = "wref"), Text(origin = {-124, -38}, extent = {{-20, 12}, {20, -12}}, textString = "Pord"), Text(origin = {-28, -110}, extent = {{-16, 14}, {16, -14}}, textString = "Pref"), Text(origin = {3, 5}, extent = {{-59, 41}, {59, -41}}, textString = "WTGP_B"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
 connect(add2.y, limRateLimFirstOrder.u) annotation(
    Line(points = {{72, 42}, {76, 42}}, color = {0, 0, 127}));
 connect(limRateLimFirstOrder.y, theta) annotation(
    Line(points = {{100, 42}, {142, 42}}, color = {0, 0, 127}));
  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This block contains the Pitch controller model Type B for a WindTurbineGenerator Type 3 based on &nbsp;<br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p data-start=\"358\" data-end=\"553\" class=\"\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">The Pitch Controller is designed to regulate blade pitch angle, ensuring optimal performance and protection under varying wind conditions. It serves the following primary functions:</p><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"></p><ol data-start=\"555\" data-end=\"1421\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li data-start=\"555\" data-end=\"758\" class=\"\"><p data-start=\"558\" data-end=\"758\" class=\"\"><strong data-start=\"558\" data-end=\"597\">Protection against High Wind Speeds</strong>: The controller adjusts the blade pitch to reduce aerodynamic loading during high wind conditions, preventing potential mechanical damage or structural failure.</p></li><li data-start=\"760\" data-end=\"975\" class=\"\"><p data-start=\"763\" data-end=\"975\" class=\"\"><strong data-start=\"763\" data-end=\"786\">Energy Optimization</strong>: Under moderate to low wind conditions, the pitch angle is adjusted to maximize the turbine's energy capture by optimizing the angle of attack of the blades relative to the wind direction.</p></li><li data-start=\"977\" data-end=\"1244\" class=\"\"><p data-start=\"980\" data-end=\"1244\" class=\"\"><strong data-start=\"980\" data-end=\"1004\">Power Output Control</strong>: The controller also regulates the turbine's power output, especially in higher wind speeds, by adjusting the blade pitch to prevent exceeding the turbine's rated power capacity. This helps ensure the generator operates within safe limits.</p></li><li data-start=\"1246\" data-end=\"1421\" class=\"\"><p data-start=\"1249\" data-end=\"1421\" class=\"\"><strong data-start=\"1249\" data-end=\"1271\">Low Wind Operation</strong>: In low wind conditions, the controller adjusts the blade pitch to ensure the turbine starts generating power efficiently, even at lower wind speeds.</p><p data-start=\"1249\" data-end=\"1421\" class=\"\"><!--StartFragment-->By tying together the limits of the controller’s various correctors, this model offers enhanced flexibility<!--EndFragment-->&nbsp;compared to the model A.&nbsp;</p></li></ol>
<p>
 </p><p></p></body></html>"),
    Icon(graphics = {Text(origin = {0, 4}, extent = {{-60, 46}, {60, -46}}, textString = "WTGP_B"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGPb;
