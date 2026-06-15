within Dynawo.Electrical.Controls.Basics;
model Step "Parametrable step model : applies a change of amplitude at a given time"

  Modelica.Blocks.Interfaces.RealOutput step(start = Value0);

  parameter Real Height "Amplitude of the step to be imposed by the model";
  parameter Types.Time tStep "Time instant when the step occurs";

  parameter Real Value0 "Start value of the step model";

equation
  step = Value0 + (if time < tStep then 0 else Height);

  annotation(preferredView = "text");
end Step;
