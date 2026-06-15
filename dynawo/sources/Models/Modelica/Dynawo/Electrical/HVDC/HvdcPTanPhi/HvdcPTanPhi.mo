within Dynawo.Electrical.HVDC.HvdcPTanPhi;
model HvdcPTanPhi "Model for P/tan(Phi) HVDC link"
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPFixedReactiveLimits;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePTanPhi(QInj1RawPu(start = - s10Pu.im), QInj2RawPu(start = - s20Pu.im));

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

equation
  QInj1RawPu = tanPhi1Ref * PInj1Pu;
  QInj2RawPu = tanPhi2Ref * PInj2Pu;

  if running then
    if QInj1RawPu >= Q1MaxPu then
     QInj1Pu = Q1MaxPu;
    elseif QInj1RawPu <= Q1MinPu then
     QInj1Pu = Q1MinPu;
    else
     QInj1Pu = QInj1RawPu;
    end if;
    if QInj2RawPu >= Q2MaxPu then
     QInj2Pu = Q2MaxPu;
    elseif QInj2RawPu <= Q2MinPu then
     QInj2Pu = Q2MinPu;
    else
     QInj2Pu = QInj2RawPu;
    end if;
  else
    Q1Pu = 0;
    Q2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself and the reactive power at each of its terminal. The power factor setpoint is given as an input and can be modified during the simulation, as well as the active power setpoint.</div></body></html>"));
end HvdcPTanPhi;
