within Dynawo.Electrical.PEIR.Plant.Simplified;

model GridFollowingPlantVar_INIT
  extends AdditionalIcons.Init;

  Modelica.Blocks.Interfaces.RealInput QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  Modelica.Blocks.Interfaces.RealInput UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

end GridFollowingPlantVar_INIT;
