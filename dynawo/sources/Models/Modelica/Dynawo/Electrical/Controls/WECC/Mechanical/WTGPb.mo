within Dynawo.Electrical.Controls.WECC.Mechanical;

model WTGPb " WECC Pitch Controller Type B"
extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsWTGPB;
extends Dynawo.Electrical.Controls.WECC.Mechanical.BaseClasses.BaseWTGP;
NonElectrical.Blocks.Continuous.AntiWindupIntegratorNoDerivative antiWindupIntegratorNoDerivative(tI = 1/kiw, YMax = thetawmax, YMin = thetawmin, Y0 = 0) annotation(
    Placement(transformation(origin = {-22, 86}, extent = {{-10, -10}, {10, 10}})));
  NonElectrical.Blocks.Continuous.AntiWindupIntegratorNoDerivative antiWindupIntegratorNoDerivative1(YMax = thetacmax, YMin = thetacmin, tI = 1/kic, Y0 = 0) annotation(
    Placement(transformation(origin = {-20, -26}, extent = {{-10, -10}, {10, 10}})));
 equation
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
  annotation(preferredView = "diagram",
    Documentation(info = "<html><head></head><body><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">This block contains the Pitch controller model Type B for a WindTurbineGenerator Type 3 based on &nbsp;<br><a href=\"3002027129_Model%20User%20Guide%20for%20Generic%20Renewable%20Energy%20Systems.pdf\">https://www.wecc.org/Reliability/WECC-Second-Generation-Wind-Turbine-Models-012314.pdf</a></p><p data-start=\"358\" data-end=\"553\" class=\"\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\">The Pitch Controller is designed to regulate blade pitch angle, ensuring optimal performance and protection under varying wind conditions. It serves the following primary functions:</p><p style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"></p><ol data-start=\"555\" data-end=\"1421\" style=\"font-family: 'MS Shell Dlg 2'; font-size: 12px;\"><li data-start=\"555\" data-end=\"758\" class=\"\"><p data-start=\"558\" data-end=\"758\" class=\"\"><strong data-start=\"558\" data-end=\"597\">Protection against High Wind Speeds</strong>: The controller adjusts the blade pitch to reduce aerodynamic loading during high wind conditions, preventing potential mechanical damage or structural failure.</p></li><li data-start=\"760\" data-end=\"975\" class=\"\"><p data-start=\"763\" data-end=\"975\" class=\"\"><strong data-start=\"763\" data-end=\"786\">Energy Optimization</strong>: Under moderate to low wind conditions, the pitch angle is adjusted to maximize the turbine's energy capture by optimizing the angle of attack of the blades relative to the wind direction.</p></li><li data-start=\"977\" data-end=\"1244\" class=\"\"><p data-start=\"980\" data-end=\"1244\" class=\"\"><strong data-start=\"980\" data-end=\"1004\">Power Output Control</strong>: The controller also regulates the turbine's power output, especially in higher wind speeds, by adjusting the blade pitch to prevent exceeding the turbine's rated power capacity. This helps ensure the generator operates within safe limits.</p></li><li data-start=\"1246\" data-end=\"1421\" class=\"\"><p data-start=\"1249\" data-end=\"1421\" class=\"\"><strong data-start=\"1249\" data-end=\"1271\">Low Wind Operation</strong>: In low wind conditions, the controller adjusts the blade pitch to ensure the turbine starts generating power efficiently, even at lower wind speeds.</p><p data-start=\"1249\" data-end=\"1421\" class=\"\"><!--StartFragment-->By tying together the limits of the controller’s various correctors, this model offers enhanced flexibility<!--EndFragment-->&nbsp;compared to the model A.&nbsp;</p></li></ol>
<p>
 </p><p></p></body></html>"),
    Icon(graphics = {Text(origin = {0, 4}, extent = {{-60, 46}, {60, -46}}, textString = "WTGP_B"), Rectangle(extent = {{-100, 100}, {100, -100}})}));
end WTGPb;
