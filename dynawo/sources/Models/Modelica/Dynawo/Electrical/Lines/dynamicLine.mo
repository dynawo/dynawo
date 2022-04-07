within Dynawo.Electrical.Lines;
model dynamicLine "AC power line - PI model considerating the transistent mode "

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));



  parameter Types.PerUnit RPu=0.00375 "Resistance in pu Current through the equivalent impedance G+jB on side 1 in pu (base UNom, SnRef) (base SnRef)";
  parameter Types.PerUnit XPu=0.0375 "Reactance in pu (base SnRef)";
  parameter Types.PerUnit GPu=0 "Half-conductance i=u20Pu*ComplexMath.conj(i20Pu)n pu (base SnRef)";
  parameter Types.PerUnit BPu=0.0000375 "Half-susceptance in pu (base SnRef)";

  parameter Types.PerUnit Iz0Pu=-11.1008 "Start value of the current through the equivalent impedance R+jX in pu (base UNom, SnRef)";
  parameter Types.Angle Iz0Phase=0.0433 "Start value of the angle of the current through the equivalent impedance R+jX in rad";

  parameter Types.PerUnit Ia0Pu=0 "Start value of the current through the equivalent impedance G+jB on side 1 in pu (base UNom, SnRef) ";
  parameter Types.Angle Ia0Phase=0 "Start value of the angle of the current through the equivalent impedance G+jB on side 1 in rad";

  parameter Types.PerUnit Ib0Pu=0 "Start value of the current through the equivalent impedance G+jB on side 2 in pu (base UNom, SnRef) ";
  parameter Types.Angle Ib0Phase=0 "Start value of the angle of the current through the equivalent impedance G+jB on side 2 in rad";

  parameter Types.PerUnit I10Pu=-11.1008 "Start value of the current on side 1 in pu (base UNom, SnRef) ";
  parameter Types.Angle I10Phase= 0.0433"Start value of the angle of the current on side 1 in rad";

  parameter Types.PerUnit I20Pu=11.1008 "Start value of the current on side 2 in pu (base UNom, SnRef) ";
  parameter Types.Angle I20Phase= 0.0433"Start value of the angle of the current on side 12in rad";

  parameter Types.PerUnit U10Pu=0.868122  "Start value of the voltage on side 1 base UNom ";
  parameter Types.Angle U10Phase =-0.107179 "Start value of the angle of the voltage on side 1 in rad";

  parameter Types.PerUnit U20Pu = 0.944307 "Start value of the voltage on side 2 base Unom " ;
  parameter Types.Angle U20Phase = 0.351159 "Start value of the angle of the voltage on side 2 in rad";


  parameter Types.ComplexVoltagePu u10Pu=ComplexMath.fromPolar(U10Pu,U10Phase);
  parameter Types.ComplexVoltagePu u20Pu=ComplexMath.fromPolar(U20Pu,U20Phase);
  parameter Types.ComplexCurrentPu i10Pu=ComplexMath.fromPolar(I10Pu,I10Phase);
  parameter Types.ComplexCurrentPu i20Pu=ComplexMath.fromPolar(I20Pu,I20Phase);

  parameter Types.ComplexCurrentPu iz0Pu=ComplexMath.fromPolar(Iz0Pu,Iz0Phase);
  parameter Types.ComplexCurrentPu ia0Pu=ComplexMath.fromPolar(Ia0Pu,Ia0Phase);
  parameter Types.ComplexCurrentPu ib0Pu=ComplexMath.fromPolar(Ib0Pu,Ib0Phase);


protected

    Types.ComplexCurrentPu IzPu(re(start=iz0Pu.re),im(start=iz0Pu.im))" Current through the equivalent impedance R+jX in pu (base UNom, SnRef)";
    Types.ComplexCurrentPu IaPu(re(start=ia0Pu.re),im(start=ia0Pu.im)) " Current through the equivalent impedance G+jB on side 1 in pu (base UNom, SnRef) ";
    Types.ComplexCurrentPu IbPu(re(start=ib0Pu.re),im(start=ib0Pu.im))" Current through the equivalent impedance G+jB on side 2 in pu (base UNom, SnRef) ";
    Types.ActivePowerPu P1Pu(start=0) "Active power on side 1 in pu (base SnRef)";
    Types.ReactivePowerPu Q1Pu(start=0) "Reactive power on side 1 in pu (base SnRef)";
    Types.ActivePowerPu P2Pu(start=0) "Active power on side 2 in pu (base SnRef)";
    Types.ReactivePowerPu Q2Pu(start=0) "Reactive power on side 2 in pu (base SnRef)";

equation
  if (running.value) then
ComplexMath.real(IaPu)=GPu*ComplexMath.real(terminal1.V)+(BPu*der(ComplexMath.real(terminal1.V))/SystemBase.omegaNom)-BPu*ComplexMath.imag(terminal1.V);
    ComplexMath.imag(IaPu)=GPu*ComplexMath.imag(terminal1.V)+(BPu*der(ComplexMath.imag(terminal1.V))/SystemBase.omegaNom)+BPu*ComplexMath.real(terminal1.V);
    ComplexMath.real(IbPu)=GPu*ComplexMath.real(terminal2.V)+(BPu*der(ComplexMath.real(terminal2.V))/SystemBase.omegaNom)-BPu*ComplexMath.imag(terminal2.V);
    ComplexMath.imag(IbPu)=GPu*ComplexMath.imag(terminal2.V)+BPu*der(ComplexMath.imag(terminal2.V))/SystemBase.omegaNom+BPu*ComplexMath.real(terminal2.V);
    RPu*ComplexMath.real(IzPu)+XPu*der(ComplexMath.real(IzPu))/SystemBase.omegaNom-XPu*ComplexMath.imag(IzPu)= ComplexMath.real(terminal1.V) - ComplexMath.real(terminal2.V);
    RPu*ComplexMath.imag(IzPu)+XPu*der(ComplexMath.imag(IzPu))/SystemBase.omegaNom+XPu*ComplexMath.real(IzPu) = ComplexMath.imag(terminal1.V) - ComplexMath.imag(terminal2.V);
    terminal1.i = IaPu+IzPu ;
    terminal2.i = IbPu-IzPu ;
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
    IzPu=Complex (0);
    IaPu=Complex (0);
    IbPu=Complex (0);
  end if;
  P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
  Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
  P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
  Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

end dynamicLine;
