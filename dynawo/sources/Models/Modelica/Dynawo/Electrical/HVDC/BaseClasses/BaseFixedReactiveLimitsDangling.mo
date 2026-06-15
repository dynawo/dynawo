within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseFixedReactiveLimitsDangling "Base dynamic model for fixed reactive limits at terminal 1"

  parameter Types.ReactivePowerPu Q1MaxPu "Maximum reactive power in pu (base SnRef) at terminal 1 (generator convention)";
  parameter Types.ReactivePowerPu Q1MinPu "Minimum reactive power in pu (base SnRef) at terminal 1 (generator convention)";

  annotation(preferredView = "text");
end BaseFixedReactiveLimitsDangling;
