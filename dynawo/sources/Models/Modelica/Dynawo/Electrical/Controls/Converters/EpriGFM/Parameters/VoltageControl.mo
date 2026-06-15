within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;
record VoltageControl "Voltage control parameters"
  parameter Types.PerUnit IMaxPu "Max current in pu (base UNom, SNom), example value = 1.05" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KIp "Integral gain of the power loop, example value = 10" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KIv "Integral gain of the voltage loop, example value = 150 if OmegaFlag=0 else 10" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KPp "Proportional gain of the power loop, example value = 2" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit KPv "Proportional gain of the voltage loop, example value = 0.5 if OmegaFlag=0 else 2.0" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit OmegaDroopPu "Frequency droop in pu, example value = 0.05" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Boolean PQFlag "Active or active power priority flag: false = P priority, true = Q priority" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit QDroopPu "Voltage droop in pu, example value = 0.2" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Types.PerUnit UDipPu "Freeze voltage in pu (base UNom), example value = 0.85" annotation(
  Dialog(tab = "VoltageControl"));

  annotation(
  preferredView = "text");
end VoltageControl;
