within Dynawo.Electrical.HVDC.BaseClasses;
partial model BasePQProp "Base dynamic model for proportional reactive power control"
  extends BaseClasses.BasePQPropDangling;

  parameter Real QPercent2 "Percentage of the coordinated reactive control that comes from converter 2";

  input Types.PerUnit NQ2 "Signal to change the reactive power of converter 2 depending on the centralized voltage regulation (generator convention)";

  Types.ReactivePowerPu QInj2RawModeUPu "Reactive power generation of converter 2 without taking limits into account in pu and for mode U activated (base SnRef) (generator convention)";
  Types.ReactivePowerPu QInj2RawPu "Reactive power generation of converter 2 without taking limits into account in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePQProp;
