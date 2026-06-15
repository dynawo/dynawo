within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified;
model VRDTRI8_INIT "Simple proportional voltage regulator initialization model for DTR I8 fiche"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  parameter Types.PerUnit Gain "Control gain";

  Types.VoltageModulePu UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  Efd0Pu = (UsRef0Pu - Us0Pu)*Gain;

  annotation(preferredView = "text");
end VRDTRI8_INIT;
