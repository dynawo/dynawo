within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

record OmegaFlag "OmegaFlag parameter"
  parameter Integer OmegaFlag "GFM control type; 0=GFL, 1=droop, 2=VSM, 3=dVOC" annotation(
Dialog(tab = "General"));

  annotation(
  preferredView = "text");
end OmegaFlag;
