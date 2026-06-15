within Dynawo.Electrical.Controls.Basics;
model Perturbation_INIT "Initialization for the perturbation model"
  extends AdditionalIcons.Init;

  parameter Real ValueIn = 0 "Start value of the output given as a parameter";

  Real Value0(start = ValueIn) "Start value of the output of the initialization process";

  annotation(preferredView = "text");
end Perturbation_INIT;
