within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorSynchronousIntTfo_INIT "Synchronous machine - Initialization model from internal parameters"

/*This model is similar to GeneratorSynchronousInt_INIT but U0Pu, P0Pu, Q0Pu and UPhase0 are variables because they are calculated from the generator transformer initialization model and should be passed to the generator through an initConnect in a preassembled model or in the dyd file*/
  extends Machines.BaseClasses_INIT.BaseGeneratorVariables_INIT;
  extends BaseClasses_INIT.BaseGeneratorSynchronousInt_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text");
end GeneratorSynchronousIntTfo_INIT;
