within Dynawo.Electrical.Controls.Machines.Governors;

model IEEE_TGOV1_INIT


  parameter Types.PerUnit R = 0.05 "Controller Droop";


  Types.VoltageModulePu RefL0Pu "Initial control voltage";
  // p.u. = Unom
  Types.VoltageModulePu PMech0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";

equation

  RefL0Pu = PMech0Pu * R ;

end IEEE_TGOV1_INIT;
