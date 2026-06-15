within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseHvdcPFixedReactiveLimits "Base dynamic model for HVDC links with a regulation of the active power and with fixed reactive power limits"
  extends BaseHvdcP;
  extends BaseFixedReactiveLimits;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation.</div></body></html>"));
end BaseHvdcPFixedReactiveLimits;
