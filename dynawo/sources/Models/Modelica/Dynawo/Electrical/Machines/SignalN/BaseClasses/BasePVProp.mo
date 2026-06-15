within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BasePVProp "Base dynamic model for a proportional voltage regulation"
  extends BaseClasses.BasePV;

  parameter Types.PerUnit KVoltage "Parameter of the proportional voltage regulation";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";

  annotation(preferredView = "text");
end BasePVProp;
