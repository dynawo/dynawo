within Dynawo.Electrical.Controls.Basics;
model SetPoint "Fixed set-point throughout a simulation"

  Modelica.Blocks.Interfaces.RealOutput setPoint(start= Value0) "Set point value";

  parameter Real Value0 "Start value of the set-point model";

equation
  setPoint = Value0;

  annotation(preferredView = "text");
end SetPoint;
