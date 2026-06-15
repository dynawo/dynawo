within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseHvdcPDanglingDiagramPQ "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus. The reactive power limits are given by a PQ diagram."
  extends BaseHvdcPDangling;
  extends BaseDiagramPQTerminal1;

equation
  PInj1Pu = tableQInj1Min.u[1];
  PInj1Pu = tableQInj1Max.u[1];

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus. This partial model also implements the PQ diagram at terminal1.</div></body></html>"));
end BaseHvdcPDanglingDiagramPQ;
