within Dynawo.Electrical.HVDC.BaseClasses_INIT;
partial model BaseDiagramPQ_INIT "Base initialization model for PQ diagram"
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;

  parameter Types.ReactivePowerPu QInj2Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 2";
  parameter Types.ReactivePowerPu QInj2Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 2";

  annotation(preferredView = "text");
end BaseDiagramPQ_INIT;
