within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;
record CurrentControl "Current control parameters"
  parameter Types.PerUnit KPi "Proportional gain of the current loop, example value = 0.5" annotation(
  Dialog(tab = "CurrentControl"));
  parameter Types.PerUnit KIi "Integral gain of the current loop, example value = 5" annotation(
  Dialog(tab = "CurrentControl"));
  parameter Types.Time tE "PT1 constant for voltage output in s, example value = 0.01" annotation(
  Dialog(tab = "CurrentControl"));

  annotation(
  preferredView = "text");
end CurrentControl;
