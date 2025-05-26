within Dynawo.Electrical.Controls.WECC.Parameters;

record ParamsDriveTrainb
extends ParamsDriveTrain;
parameter Types.Time tP "Lag Time constant" annotation(
  Dialog(tab="Mechanical"));
end ParamsDriveTrainb;
