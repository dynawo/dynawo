within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseHvdcPDanglingFixedReactiveLimits "Base dynamic model for HVDC links with a regulation of the active power and with fixed reactive power limits"
  extends BaseHvdcPDangling;
  extends BaseFixedReactiveLimitsDangling;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end BaseHvdcPDanglingFixedReactiveLimits;
