within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

model IEEE_AC4A_INIT_WithoutPSS


  parameter Types.PerUnit Ka = 200 "Overall equivalent gain";


  Types.VoltageModulePu Vref0Pu "Initial control voltage";
  // p.u. = Unom
  Types.VoltageModulePu Vs0Pu "Initial stator voltage";
  // p.u. = Unom
  Types.VoltageModulePu Vc0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";

  Types.VoltageModulePu efd0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";

equation

  Vref0Pu = Vc0Pu - Vs0Pu + efd0Pu / Ka ;
  Vs0Pu = 0;

end IEEE_AC4A_INIT_WithoutPSS;
