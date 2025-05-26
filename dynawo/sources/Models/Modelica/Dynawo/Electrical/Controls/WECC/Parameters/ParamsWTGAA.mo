within Dynawo.Electrical.Controls.WECC.Parameters;

record ParamsWTGAA
parameter Types.AngleDegree theta0 "Reference pitch angle" annotation (Dialog(tab="Aero-dynamic model"));
parameter Types.AngleDegree thetaInit "Initial pitch angle" annotation (Dialog(tab="Aero-dynamic model"));
parameter Real Ka " Aero-dynamic gain factor" annotation (Dialog(tab="Aero-dynamic model"));
 parameter Types.PerUnit PmRef0 annotation(Dialog(group = "Initialization"));
end ParamsWTGAA;
