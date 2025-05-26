within Dynawo.Electrical.Controls.WECC.Parameters;

record ParamsWTGPA
parameter Types.Frequency kiw "Pitch controller integral gain" annotation(Dialog(tab="Pitch Control"));
parameter Real kpw "Pitch controller proportional gain" annotation(Dialog(tab="Pitch Control"));
parameter Types.Frequency kic "Pitch compensation integral gain" annotation(Dialog(tab="Pitch Control"));
parameter Real kpc "Pitch Compensation proportional gain" annotation(Dialog(tab="Pitch Control"));
parameter Real kcc "Proportionnal cross-compensation gain" annotation(Dialog(tab="Pitch Control"));
parameter Types.Time ttheta "Pitch time constant" annotation(Dialog(tab="Pitch Control"));
parameter Types.AngleDegree thetamax "Maximum pitch angle limit" annotation(Dialog(tab="Pitch Control"));
parameter Types.AngleDegree thetamin "Minimum pitch angle limit" annotation(Dialog(tab="Pitch Control"));
parameter Types.AngularVelocityDegree thetarmax "Maximun pitch angle rate limit" annotation(Dialog(tab="Pitch Control"));
parameter Types.AngularVelocityDegree thetarmin "Maximun pitch angle rate limit" annotation(Dialog(tab="Pitch Control"));
parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
parameter Types.AngleDegree thetaInit "Initial pitch angle" annotation (Dialog(tab="Aero-dynamic model"));


end ParamsWTGPA;
