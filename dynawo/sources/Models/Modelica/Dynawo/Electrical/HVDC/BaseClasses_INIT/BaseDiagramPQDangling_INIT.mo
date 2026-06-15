within Dynawo.Electrical.HVDC.BaseClasses_INIT;
partial model BaseDiagramPQDangling_INIT "Base initialization model for PQ diagram at terminal 1"

  parameter Types.ReactivePowerPu QInj1Max0Pu "Start value of the maximum reactive power in pu (base SnRef) (generator convention) at terminal 1";
  parameter Types.ReactivePowerPu QInj1Min0Pu "Start value of the minimum reactive power in pu (base SnRef) (generator convention) at terminal 1";

  annotation(preferredView = "text");
end BaseDiagramPQDangling_INIT;
