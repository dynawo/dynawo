within Dynawo.Electrical.Loads;
model LoadAlphaBetaThreeMotorFifthOrder "Alpha-beta load in parallel with three fifth-order motor models"
  extends BaseClasses.BaseLoadMotorFifthOrder;
  redeclare parameter Integer NbMotors = 3;

  annotation(preferredView = "text");
end LoadAlphaBetaThreeMotorFifthOrder;
