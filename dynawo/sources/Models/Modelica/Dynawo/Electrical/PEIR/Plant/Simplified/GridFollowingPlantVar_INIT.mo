within Dynawo.Electrical.PEIR.Plant.Simplified;

model GridFollowingPlantVar_INIT
  extends AdditionalIcons.Init;

  Modelica.Blocks.Interfaces.RealInput P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealInput Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  Modelica.Blocks.Interfaces.RealInput U0Pu "Start value of voltage amplitude at terminal in pu (base UNom)";
  Modelica.Blocks.Interfaces.RealInput UPhase0 "Start value of voltage angle at terminal in rad";

  Modelica.Blocks.Interfaces.RealInput QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  Modelica.Blocks.Interfaces.RealInput UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

end GridFollowingPlantVar_INIT;
