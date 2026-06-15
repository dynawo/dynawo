within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorSynchronousInt_INIT "Synchronous machine - Initialization model from internal parameters"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends BaseClasses_INIT.BaseGeneratorSynchronousInt_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text");
end GeneratorSynchronousInt_INIT;
