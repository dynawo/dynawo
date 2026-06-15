within Dynawo.Electrical.Controls.Basics;
model Step_INIT "Initialization for the step model"
  extends AdditionalIcons.Init;

  parameter Real ValueIn = 0 "Start value of the step model given as a parameter";

  Real Value0(start = ValueIn) "Start value of the step model at the end of the initialization process";

  annotation(preferredView = "text");
end Step_INIT;
