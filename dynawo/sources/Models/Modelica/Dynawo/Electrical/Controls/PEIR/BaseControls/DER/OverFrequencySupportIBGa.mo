within Dynawo.Electrical.Controls.PEIR.BaseControls.DER;
model OverFrequencySupportIBGa "Active current injection model for aggregated IBG"
  parameter Types.AngularVelocityPu OmegaDeadBandPu "Deadband of the overfrequency contribution in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";
  parameter Types.PerUnit s(min = 0, max = 1) "Share of units that trip at OmegaDeadBandPu";

  Modelica.Blocks.Interfaces.RealInput omegaPu "Angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PextPu "Active power setpoint in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput deltaP "Active power reduction in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if omegaPu < OmegaDeadBandPu then
    deltaP = 0;
  elseif omegaPu < OmegaMaxPu then
    deltaP = PextPu * (s + (1-s) * (omegaPu - OmegaDeadBandPu)/(OmegaMaxPu - OmegaDeadBandPu));
  else
    deltaP = PextPu;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>When frequency is greater than OmegaDeadBandPu, the IBG unit is requested to decrease its active power injection. The unit participate in over-frequency control with full capacity when frequency reaches OmegaMaxPu. This model takes into account partial tripping. &nbsp;</body></html>"));
end OverFrequencySupportIBGa;
