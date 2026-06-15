within Dynawo.Electrical.Loads;
model LoadAlphaBetaTwoMotorSimplified "Alpha-beta load in parallel with two simplified motor models"
  extends BaseClasses.BaseLoadMotorSimplified;
  redeclare parameter Integer NbMotors = 2;

  annotation(preferredView = "text");
end LoadAlphaBetaTwoMotorSimplified;
