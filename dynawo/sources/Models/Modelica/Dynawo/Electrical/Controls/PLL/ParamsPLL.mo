within Dynawo.Electrical.Controls.PLL;
record ParamsPLL
  parameter Types.PerUnit KiPLL "PLL integrator gain" annotation(
    Dialog(tab="PLL"));
  parameter Types.PerUnit KpPLL "PLL proportional gain" annotation(
    Dialog(tab="PLL"));
  parameter Types.AngularVelocityPu OmegaMaxPu "Upper frequency limit in pu (base omegaNom)" annotation(
    Dialog(tab="PLL"));
  parameter Types.AngularVelocityPu OmegaMinPu "Lower frequency limit in pu (base omegaNom)" annotation(
    Dialog(tab="PLL"));

  annotation(
    preferredView = "text");
end ParamsPLL;
