within Dynawo.Electrical.Loads;
model LoadAlphaBetaMotorSimplified "Alpha-beta load in parallel with a simple motor model"
  extends BaseClasses.BaseLoadMotorSimplified;
  redeclare parameter Integer NbMotors = 1;

  annotation(preferredView = "text");
end LoadAlphaBetaMotorSimplified;
