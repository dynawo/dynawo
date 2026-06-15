within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BasePQProp "Base dynamic model for a proportional reactive power regulation"
  parameter Real QPercent "Percentage of the coordinated reactive control that comes from this machine";

  input Types.PerUnit NQ "Signal to change the reactive power generation of the generator depending on the centralized distant voltage regulation (generator convention)";

  parameter Types.ReactivePowerPu QRef0Pu "Start value of the reactive power set point in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu QDeadBandPu(min = 0) "Reactive power deadband around the target in pu (base SnRef)";

protected
  Types.ReactivePowerPu QGenRawPu "Reactive power generation without taking limits into account in pu (base SnRef) (generator convention)";

equation
  QGenRawPu = - QRef0Pu + abs(QPercent) * NQ;

  annotation(preferredView = "text");
end BasePQProp;
