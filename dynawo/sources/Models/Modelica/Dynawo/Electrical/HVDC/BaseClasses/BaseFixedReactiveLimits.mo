within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseFixedReactiveLimits "Base dynamic model for fixed reactive limits"
  extends BaseClasses.BaseFixedReactiveLimitsDangling;

  parameter Types.ReactivePowerPu Q2MaxPu "Maximum reactive power in pu (base SnRef) at terminal 2 (generator convention)";
  parameter Types.ReactivePowerPu Q2MinPu "Minimum reactive power in pu (base SnRef) at terminal 2 (generator convention)";

  annotation(preferredView = "text");
end BaseFixedReactiveLimits;
