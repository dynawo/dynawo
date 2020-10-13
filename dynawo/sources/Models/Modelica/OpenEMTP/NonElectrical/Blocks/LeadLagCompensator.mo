within OpenEMTP.NonElectrical.Blocks;

block LeadLagCompensator
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real K "Gain";
  parameter Modelica.SIunits.Time T1 "Lead time constant";
  parameter Modelica.SIunits.Time T2 "Lag time constant";
  parameter Real y_start "Output start value"
    annotation (Dialog(group="Initialization"));
  parameter Real x_start=0 "Start value of state variable"
    annotation (Dialog(group="Initialization"));
  Modelica.Blocks.Sources.RealExpression par1(y=T1)
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Modelica.Blocks.Sources.RealExpression par2(y=T2)
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica.Blocks.Continuous.TransferFunction TF(
    b={K*T1,K},
    a={T2_dummy,1},
    y_start=y_start,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    x_start={x_start})
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
protected
  parameter Modelica.SIunits.Time T2_dummy=if abs(T1 - T2) < Modelica.Constants.eps
       then 1000 else T2 "Lead time constant";
equation
  if abs(par1.y - par2.y) < Modelica.Constants.eps then
    y = K*u;
  else
    y = TF.y;
  end if;
  connect(TF.u, u)
    annotation (Line(points={{-10,0},{-120,0}}, color={0,0,127}));
  annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 12px; orphans: 2; text-align: justify; widows: 2; background-color: rgb(255, 255, 255);\">Lead and lag compensators are used quite extensively in control. A lead compensator can increase the stability or speed of reponse of a system; a lag compensator can reduce (but not eliminate) the steady-state error. Depending on the effect desired, one or more lead and lag compensators may be used in various combinations.</span><!--EndFragment--><div><span style=\"font-family: Arial, Helvetica, sans-serif; font-size: 12px; orphans: 2; text-align: justify; widows: 2; background-color: rgb(255, 255, 255);\"><br></span></div><div><!--StartFragment--><p style=\"margin: 0px 0px 10px; padding: 0px; border: 0px; clear: both; font-family: Arial, Helvetica, sans-serif; font-size: 12px; orphans: 2; text-align: justify; widows: 2; background-color: rgb(255, 255, 255);\">A first-order lead compensator&nbsp;<i style=\"margin: 0px; padding: 0px; border: 0px;\">C</i>(<i style=\"margin: 0px; padding: 0px; border: 0px;\">s</i>) can be designed using the root locus. A lead compensator in root locus form is given by</p><p style=\"margin: 0px 0px 10px; padding: 0px; border: 0px; clear: both; font-family: Arial, Helvetica, sans-serif; font-size: 12px; orphans: 2; text-align: justify; widows: 2; background-color: rgb(255, 255, 255);\"><span class=\"eqn_num\" style=\"margin: 0px; padding: 0px; border: 0px; float: right;\">(1)</span><img class=\"display_eqn\" src=\"http://ctms.engin.umich.edu/CTMS/Content/Extras/html/Extras_Leadlag_eq18077883220293986268.png\" alt=\"$$ C(s)=K_{c}rac{(s-z_{0})}{(s-p_{0})} $$\" style=\"margin: 1.5em auto; padding: 0px; border: 0px; display: block; max-width: 100%;\"></p><p style=\"margin: 0px 0px 10px; padding: 0px; border: 0px; clear: both; font-family: Arial, Helvetica, sans-serif; font-size: 12px; orphans: 2; text-align: justify; widows: 2; background-color: rgb(255, 255, 255);\">where the magnitude of&nbsp;<i style=\"margin: 0px; padding: 0px; border: 0px;\">z0</i>&nbsp;is less than the magnitude of&nbsp;<i style=\"margin: 0px; padding: 0px; border: 0px;\">p0</i>. A phase-lead compensator tends to shift the root locus toward to the left in the complex&nbsp;<i style=\"margin: 0px; padding: 0px; border: 0px;\">s</i>-plane. This results in an improvement in the system's stability and an increase in its response speed.</p><!--EndFragment--></div></body></html>", revisions = "<html><head></head><body>Alireza Masoom Feb 03 2020</body></html>"),
    Icon(graphics = {Text(lineColor = {0, 0, 255}, extent = {{-44, 82}, {76, 22}}, textString = "1+sT"), Line(points = {{-46, 0}, {82, 0}}, color = {0, 0, 255}, thickness = 0.5, smooth = Smooth.Bezier), Text(lineColor = {0, 0, 255}, extent = {{-44, -20}, {76, -80}}, textString = "1+sT"), Text(lineColor = {0, 0, 255}, extent = {{-100, 28}, {-40, -32}}, textString = "K"), Text(lineColor = {0, 0, 255}, extent = {{62, 44}, {82, 24}}, textString = "1"), Text(lineColor = {0, 0, 255}, extent = {{64, -58}, {84, -78}}, textString = "2")}, coordinateSystem(initialScale = 0.1)));
end LeadLagCompensator;
