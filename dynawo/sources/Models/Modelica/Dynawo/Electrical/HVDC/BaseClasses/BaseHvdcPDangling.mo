within Dynawo.Electrical.HVDC.BaseClasses;
partial model BaseHvdcPDangling "Base dynamic model for HVDC links with a regulation of the active power and with terminal2 connected to a switched-off bus"
  extends BaseHvdc;

/*
  Equivalent circuit and conventions:

               I1                  I2 = 0
   (terminal1) -->-------HVDC-------<-- (switched-off terminal2)

*/

equation
  //Connected side
  if runningSide1 then
    P1Pu = if P1RefPu > PMaxPu then PMaxPu elseif P1RefPu < -PMaxPu then -PMaxPu else P1RefPu;
    if ((terminal1.V.re == 0) and (terminal1.V.im == 0)) then
      U1Pu = 0;
    else
      U1Pu =Modelica.ComplexMath.abs(terminal1.V);
    end if;
  else
    P1Pu = 0;
    U1Pu = 0;
  end if;

  //Disconnected side
  P2Pu = 0;
  Q2Pu = 0;
  terminal2.i.re = 0;
  terminal2.i.im = 0;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. The active power reference is given as an input and can be changed during the simulation. The terminal2 is connected to a switched-off bus.</div></body></html>"));
end BaseHvdcPDangling;
