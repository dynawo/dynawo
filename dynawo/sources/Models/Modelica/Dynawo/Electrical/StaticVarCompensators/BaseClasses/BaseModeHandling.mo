within Dynawo.Electrical.StaticVarCompensators.BaseClasses;
partial model BaseModeHandling "Base dynamic model for static var compensator mode handling"

  input Boolean selectModeAuto(start = selectModeAuto0) "Whether the static var compensator is in automatic configuration";
  input Integer setModeManual(start = setModeManual0) "Mode selected when in manual configuration";

  parameter BaseControls.Mode Mode0 "Start value for mode";
  parameter Boolean selectModeAuto0 = true "Start value of the boolean indicating whether the SVarC is initially in automatic configuration";

  final parameter Integer setModeManual0 = Integer(Mode0) "Start value of the mode when in manual configuration";

  annotation(preferredView = "text");
end BaseModeHandling;
