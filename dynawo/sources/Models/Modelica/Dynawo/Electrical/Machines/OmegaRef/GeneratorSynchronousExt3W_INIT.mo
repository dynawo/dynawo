within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorSynchronousExt3W_INIT "Synchronous machine with 3 windings - Initialization model from external parameters"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends BaseClasses_INIT.BaseGeneratorSynchronousExt3W_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text");
end GeneratorSynchronousExt3W_INIT;
