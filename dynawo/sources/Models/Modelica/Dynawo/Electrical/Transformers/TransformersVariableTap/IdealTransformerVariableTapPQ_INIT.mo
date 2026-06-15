within Dynawo.Electrical.Transformers.TransformersVariableTap;
model IdealTransformerVariableTapPQ_INIT "Initialization for ideal transformer based on the network voltage, active and reactive power"
  extends BaseClasses_INIT.BaseTransformerVariableTapCommon_INIT;
  extends BaseClasses_INIT.BaseTransformerParameters_INIT;
  extends AdditionalIcons.Init;

equation
  // Initial tap estimation
  Tap0 = BaseClasses_INIT.IdealTransformerTapEstimation(rTfoMinPu, rTfoMaxPu, NbTap, u10Pu, Uc20Pu);

  // Transformer equations
  i10Pu = - rTfo0Pu * i20Pu;
  rTfo0Pu * u10Pu = u20Pu;

  annotation(preferredView = "text");
end IdealTransformerVariableTapPQ_INIT;
