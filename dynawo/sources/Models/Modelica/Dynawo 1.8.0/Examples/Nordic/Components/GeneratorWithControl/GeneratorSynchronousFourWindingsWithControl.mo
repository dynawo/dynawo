within Dynawo.Examples.Nordic.Components.GeneratorWithControl;
model GeneratorSynchronousFourWindingsWithControl "Model of synchronous generator with four windings, a governor and a voltage regulator, for the Nordic 32 test system"
  extends GeneratorSynchronousThreeWindingsWithControl(
    redeclare Dynawo.Examples.BaseClasses.InitializedGeneratorSynchronousFourWindings generatorSynchronous
  );

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The controlled generator frame functions as the regulated synchronous generator of the Nordic 32 test system.<div>It consists of a 4 windings initialized synchronous generator, which models thermal plants. The regulating elements comprise automatic voltage regulation (AVR), exciter (EXC), overexcitation limitation (OEL), power system stabilizer (PSS) and speed control by a governor (GOV).</div><div>Parameters are automatically chosen according to a preset defined in the GeneratorParameters. Then, only initial values need to be supplied.</div><div>To add another configuration, append a new line to \"genFrameParamValues\", \"govParamValues\" and \"vrParamValues\"&nbsp;in GeneratorParameters and append a fitting name in the \"genFramePreset\" enumeration.</div></body></html>"));
end GeneratorSynchronousFourWindingsWithControl;
