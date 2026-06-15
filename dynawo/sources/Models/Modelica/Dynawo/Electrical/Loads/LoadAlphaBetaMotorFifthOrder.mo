within Dynawo.Electrical.Loads;
model LoadAlphaBetaMotorFifthOrder "Alpha-beta load in parallel with a fifth-order motor model"
  extends BaseClasses.BaseLoadMotorFifthOrder;
  redeclare parameter Integer NbMotors = 1;

  annotation(preferredView = "text");
end LoadAlphaBetaMotorFifthOrder;
