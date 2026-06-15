within Dynawo.Electrical.Controls.Basics;
model Perturbation "Parameterizable perturbation model : adds a constant signal at a given time"

  Modelica.Blocks.Interfaces.RealInput signal(start = Value0);
  Modelica.Blocks.Interfaces.RealOutput perturbatedSignal(start = Value0);

  parameter Real Height "Amplitude of the perturbation to be added";
  parameter Types.Time tStep "Time instant when the perturbation occurs";

  parameter Real Value0 "Start value of the output";

equation
  perturbatedSignal = signal + (if time < tStep then 0 else Height);

  annotation(preferredView = "text");
end Perturbation;
