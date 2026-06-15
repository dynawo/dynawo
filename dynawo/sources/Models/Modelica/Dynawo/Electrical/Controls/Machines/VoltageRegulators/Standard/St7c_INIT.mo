within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model St7c_INIT "IEEE excitation system type ST7C initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Exciter_INIT;

  //Regulation parameters
  parameter Types.PerUnit Kia "Voltage regulator feedback gain";
  parameter Types.PerUnit Kpa "Voltage regulator proportional gain";

  Dynawo.Connectors.VoltageModulePuConnector UsRef0Pu "Initial reference stator voltage in pu (base UNom)";

equation
  UsRef0Pu = (1 + Kia) * Efd0Pu / Kpa + Us0Pu;

  annotation(preferredView = "text");
end St7c_INIT;
