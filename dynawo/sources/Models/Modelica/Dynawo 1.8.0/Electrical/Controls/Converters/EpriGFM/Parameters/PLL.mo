within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

record PLL
  parameter Types.PerUnit KIPll "PLL integrator gain, example value = 700" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit KPPll "PLL proportional gain, example value = 20" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMaxPu "PLL Upper frequency limit in pu (base OmegaNom), example value = 1.5" annotation(Dialog(tab = "Pll"));
  parameter Types.PerUnit OmegaMinPu "PLL Lower frequency limit in pu (base OmegaNom), example value = 0.5" annotation(Dialog(tab = "Pll"));

  annotation(
  preferredView = "text");
end PLL;
