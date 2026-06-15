within Dynawo.Electrical.Loads;
model LoadAlphaBetaTwoMotorFifthOrder "Alpha-beta load in parallel with two fifth-order motor models"
  extends BaseClasses.BaseLoadMotorFifthOrder;
  redeclare parameter Integer NbMotors = 2;

  annotation(preferredView = "text");
end LoadAlphaBetaTwoMotorFifthOrder;
