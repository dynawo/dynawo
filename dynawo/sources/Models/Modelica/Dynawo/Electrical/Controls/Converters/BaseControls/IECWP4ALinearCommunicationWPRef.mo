within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWP4ALinearCommunicationWPRef

  import Modelica;
  import Dynawo;
  import Dynawo.Types;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Linear Communication Parameters*/
  parameter Types.PerUnit Tlead "Communication lead time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));
  parameter Types.PerUnit Tlag "Communication lag time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));

  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit X0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";

  Modelica.Blocks.Interfaces.RealInput pWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "WP reference active power" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "WP reference reactive power" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput pWPRefComPu(start = -P0Pu * SystemBase.SnRef / SNom) "WP reference active power communicated" annotation(
    Placement(visible = true, transformation(origin = {120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput xWPRefComPu(start = X0Pu) "WP reference reactive power" annotation(
    Placement(visible = true, transformation(origin = {120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.TransferFunction leadLag(a = {Tlag, 1}, b = {Tlead, 1}, x_scaled(start = {-P0Pu * SystemBase.SnRef / SNom}), x_start = {-P0Pu * SystemBase.SnRef / SNom}, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {4.44089e-16, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction leadLag1(a = {Tlag, 1}, b = {Tlead, 1}, x_scaled(start = {X0Pu}), x_start = {X0Pu}, y_start = X0Pu) annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation

  connect(pWPRefPu, leadLag.u) annotation(
    Line(points = {{-120, 40}, {-24, 40}}, color = {0, 0, 127}));
  connect(leadLag.y, pWPRefComPu) annotation(
    Line(points = {{22, 40}, {120, 40}}, color = {0, 0, 127}));
  connect(xWPRefPu, leadLag1.u) annotation(
    Line(points = {{-120, -40}, {-24, -40}}, color = {0, 0, 127}));
  connect(leadLag1.y, xWPRefComPu) annotation(
    Line(points = {{22, -40}, {120, -40}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 80}, {100, -80}}), Text(origin = {72, -114}, extent = {{-112, 184}, {-32, 46}}, textString = "module"), Text(origin = {-30, -100}, extent = {{-66, 144}, {126, -10}}, textString = "(for WP references)"), Text(origin = {28, -26}, extent = {{-112, 184}, {56, -66}}, textString = "Communication")}, coordinateSystem(extent = {{-100, -80}, {100, 80}})),
    Diagram(coordinateSystem(extent = {{-100, -80}, {100, 80}})));

end IECWP4ALinearCommunicationWPRef;
