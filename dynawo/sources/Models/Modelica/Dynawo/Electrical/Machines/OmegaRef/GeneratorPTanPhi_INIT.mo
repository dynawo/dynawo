within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorPTanPhi_INIT "Initialisation model for generator PV when linked to reactive power control loop"
  extends Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  annotation(
    preferredView = "text");
end GeneratorPTanPhi_INIT;
