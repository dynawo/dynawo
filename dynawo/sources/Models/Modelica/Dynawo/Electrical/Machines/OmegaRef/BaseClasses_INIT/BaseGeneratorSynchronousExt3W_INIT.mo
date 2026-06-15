within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;
partial model BaseGeneratorSynchronousExt3W_INIT "Base initialization model for synchronous machine from external parameters with three windings"
  extends BaseGeneratorSynchronousExt_INIT;

  parameter Types.PerUnit XppqPu "Quadrature axis sub-transient reactance in pu";
  parameter Types.Time Tppq0 "Open circuit quadrature axis sub-transient time constant";

  Types.Time Tppq;
  Types.PerUnit T3qPu;
  Types.PerUnit T6qPu;

equation
  Tppq = Tppq0 * XppqPu / XqPu;

  T3qPu = Tppq0 * SystemBase.omegaNom;
  T6qPu = Tppq  * SystemBase.omegaNom;

  LQ1Pu * (MqPu + LqPu) * (T3qPu - T6qPu) = (MqPu + LqPu) * MqPu * T6qPu - MqPu * LqPu * T3qPu;
  RQ1Pu * T3qPu = MqPu + LQ1Pu;

  RQ2Pu = 0;
  LQ2Pu = 100000;

  annotation(preferredView = "text");
end BaseGeneratorSynchronousExt3W_INIT;
