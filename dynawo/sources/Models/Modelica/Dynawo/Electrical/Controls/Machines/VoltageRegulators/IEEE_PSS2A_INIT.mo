within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

model IEEE_PSS2A_INIT


  // Types.VoltageModulePu Vsi10Pu "Initial control voltage";
  // p.u. = Unom
  Types.VoltageModulePu Vsi20Pu "Initial stator voltage";
  // p.u. = Unom
  Types.VoltageModulePu Vst0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";

equation

  Vst0Pu = 0;

end IEEE_PSS2A_INIT;
