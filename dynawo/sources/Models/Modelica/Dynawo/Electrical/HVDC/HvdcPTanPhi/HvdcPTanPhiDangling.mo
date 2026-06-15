within Dynawo.Electrical.HVDC.HvdcPTanPhi;
model HvdcPTanPhiDangling "Model for P/tan(Phi) HVDC link with terminal2 connected to a switched-off bus"
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPDanglingFixedReactiveLimits;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePTanPhiDangling(QInj1RawPu(start = - s10Pu.im));

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  QInj1RawPu = tanPhi1Ref * PInj1Pu;

  if runningSide1 then
    if QInj1RawPu >= Q1MaxPu then
     QInj1Pu = Q1MaxPu;
    elseif QInj1RawPu <= Q1MinPu then
     QInj1Pu = Q1MinPu;
    else
     QInj1Pu = QInj1RawPu;
    end if;
  else
    terminal1.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at terminal1. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end HvdcPTanPhiDangling;
