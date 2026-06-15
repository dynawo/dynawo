within Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard;
model Ac7b_INIT "IEEE excitation system type AC7B initialization model"
  extends Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard.Ac168_INIT;

  //Regulation parameter
  parameter Types.PerUnit Kp "Potential source gain";

  //Input parameters
  Dynawo.Connectors.ComplexCurrentPuConnector it0Pu "Initial complex stator current in pu (base SNom, UNom)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex voltage in pu (base UNom)";

  //Output parameter
  Types.VoltageModulePu Vb0Pu "Initial available exciter field voltage in pu (base UNom)";

equation
  Vb0Pu =Kp*Modelica.ComplexMath.abs(ut0Pu);

  annotation(preferredView = "text");
end Ac7b_INIT;
