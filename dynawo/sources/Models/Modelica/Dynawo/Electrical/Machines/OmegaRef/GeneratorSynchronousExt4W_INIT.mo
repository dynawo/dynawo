within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorSynchronousExt4W_INIT "Synchronous machine with 4 windings - Initialization model from external parameters"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends BaseClasses_INIT.BaseGeneratorSynchronousExt4W_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text");
end GeneratorSynchronousExt4W_INIT;
