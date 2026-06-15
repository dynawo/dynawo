within Dynawo.Electrical.Controls.WECC.Parameters.Mechanical;
record ParamsWTGPb
  parameter Types.AngleDegree ThetaWMax "Maximum pitch PI controller angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaWMin "Minimum pitch angle PI controller limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaCMax "Maximum pitch compensation PI controller angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));
  parameter Types.AngleDegree ThetaCMin "Minimum pitch compensation PI controller angle limit in degree" annotation(
  Dialog(tab="Pitch Control"));

  annotation(
  preferredView = "text");
end ParamsWTGPb;
