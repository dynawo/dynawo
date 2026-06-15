within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseFixedReactiveLimits "Base dynamic model for fixed reactive limits"
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef)";

  annotation(preferredView = "text");
end BaseFixedReactiveLimits;
