within Dynawo.Electrical.HVDC.BaseClasses;
partial model BasePQPropDangling "Base dynamic model for proportional reactive power control at terminal 1"

  parameter Real QPercent1 "Percentage of the coordinated reactive control that comes from converter 1";

  input Types.PerUnit NQ1 "Signal to change the reactive power of converter 1 depending on the centralized voltage regulation (generator convention)";

  Types.ReactivePowerPu QInj1RawModeUPu "Reactive power generation of converter 1 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj1RawPu "Reactive power generation of converter 1 without taking limits into account in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePQPropDangling;
