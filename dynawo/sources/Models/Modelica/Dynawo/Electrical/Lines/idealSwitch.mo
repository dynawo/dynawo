within Dynawo.Electrical.Lines;

model idealSwitch "ideal switch inspired by MSL idealOpeningSwitch"
  import Modelica.ComplexMath.real;
  import Modelica.ComplexMath.conj;

  parameter Modelica.SIunits.Resistance Ron(final min=0) = 1e-5 "Closed switch resistance";
  parameter Modelica.SIunits.Conductance Goff(final min=0) = 1e-5 "Opened switch conductance";
  Modelica.Blocks.Interfaces.BooleanInput control(start = false) "true => switch open, false => p--n connected"
                                                   annotation (Placement(
        transformation(
        origin={0,120},
        extent={{-20,-20},{20,20}},
        rotation=270)));
  Connectors.ACPower terminal1 annotation(
    Placement(transformation(origin = {-100, 4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-100, 34}, extent = {{-10, -10}, {10, 10}})));
  Connectors.ACPower terminal2 annotation(
    Placement(transformation(origin = {102, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {104, 30}, extent = {{-10, -10}, {10, 10}})));

  Modelica.SIunits.ComplexVoltage v "Complex voltage";
  Modelica.SIunits.ComplexCurrent i "Complex current";

protected
  Complex s(re(final unit="1"),im(final unit="1")) "Auxiliary variable";
  constant Modelica.SIunits.ComplexVoltage unitVoltage=Complex(1, 0)
    annotation (HideResult=true);
  constant Modelica.SIunits.ComplexCurrent unitCurrent=Complex(1, 0)
    annotation (HideResult=true);

equation
  terminal1.i + terminal2.i = Complex(0);
  v = terminal1.V - terminal2.V;
  i = terminal1.i;
  v = (s*unitCurrent)*(if control then 1 else Ron);
  i = (s*unitVoltage)*(if control then Goff else 1);

    annotation (
    Icon(coordinateSystem(preserveAspectRatio = true, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(extent = {{-44, 4}, {-36, -4}}, lineColor = {0, 0, 255}), Line(points = {{-90, 0}, {-44, 0}}, color = {0, 0, 255}), Line(points = {{-37, 2}, {40, 40}}, color = {0, 0, 255}), Line(points = {{40, 0}, {90, 0}}, color = {0, 0, 255}), Text(extent = {{-150, 90}, {150, 50}}, textString = "%name", lineColor = {0, 0, 255})}),
  Documentation(info = "<html><head></head><body><br></body></html>"));
end idealSwitch;
