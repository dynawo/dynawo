within Dynawo.Electrical.Controls.Basics;
model SetPoint_INIT "Initialization for the set-point model"
  extends AdditionalIcons.Init;

  parameter Real ValueIn "Start value of the set-point model given as a parameter";

  Real Value0(start = ValueIn) "Start value of the set-point model at the end of the initialization process";

  annotation(preferredView = "text");
end SetPoint_INIT;
