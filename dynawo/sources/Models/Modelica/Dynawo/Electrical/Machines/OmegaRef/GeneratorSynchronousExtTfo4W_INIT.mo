within Dynawo.Electrical.Machines.OmegaRef;
model GeneratorSynchronousExtTfo4W_INIT "Synchronous machine with 4 windings - Initialization model from external parameters"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorVariables_INIT;
  extends BaseClasses_INIT.BaseGeneratorSynchronousExt4W_INIT;
  extends AdditionalIcons.Init;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
<p><span>This model is similar to GeneratorSynchronousExt4W_INIT but U0Pu, P0Pu, Q0Pu and UPhase0 are variables because they are calculated from the generator transformer initialization model and should be passed to the generator through an initConnect in a preassembled model or in the dyd file.</span></p></body></html>"));
end GeneratorSynchronousExtTfo4W_INIT;
