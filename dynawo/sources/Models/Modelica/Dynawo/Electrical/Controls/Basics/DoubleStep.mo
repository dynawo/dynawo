within Dynawo.Electrical.Controls.Basics;
model DoubleStep "Parameterizable step model : applies two changes of amplitude at given times"

  Dynawo.Connectors.ImPin step(value(start = Value0));

  parameter Real Height1 "Amplitude of the first step to be imposed by the model";
  parameter Types.Time tStep1 "Time instant when the first step occurs";
  parameter Real Height2 "Amplitude of the second step to be imposed by the model";
  parameter Types.Time tStep2 "Time instant when the second step occurs";

  parameter Real Value0 "Start value of the step model";

equation
  if tStep1 < tStep2 then
    step.value = Value0 + (if time < tStep1 then 0 else (if time < tStep2 then Height1 else Height2));
  else
    step.value = Value0 + (if time < tStep2 then 0 else (if time < tStep1 then Height2 else Height1));
  end if;

  annotation(preferredView = "text");
end DoubleStep;
