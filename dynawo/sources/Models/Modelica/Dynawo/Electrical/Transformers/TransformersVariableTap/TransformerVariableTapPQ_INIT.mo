within Dynawo.Electrical.Transformers.TransformersVariableTap;
model TransformerVariableTapPQ_INIT "Initialization for transformer based on the network voltage, active and reactive power"
  extends BaseClasses_INIT.BaseTransformerVariableTap_INIT;
  extends BaseClasses_INIT.BaseTransformerParameters_INIT;
  extends AdditionalIcons.Init;

equation
  // Initial tap estimation
  Tap0 = BaseClasses_INIT.TapEstimation(ZPu, rTfoMinPu, rTfoMaxPu, NbTap, u10Pu, i10Pu, Uc20Pu);

  // Transformer equations
  i10Pu = rTfo0Pu * (YPu * u20Pu - i20Pu);
  rTfo0Pu * rTfo0Pu * u10Pu = rTfo0Pu * u20Pu + ZPu * i10Pu;

  annotation(preferredView = "text");
end TransformerVariableTapPQ_INIT;
