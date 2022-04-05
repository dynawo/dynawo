within Dynawo.Electrical.Lines;

model dynamicLine "AC power line - PI model considerating the transistent mode "


  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)) , i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  parameter Types.PerUnit RPu "Resistance in pu (base SnRef)";
  parameter Types.PerUnit XPu "Reactance in pu (base SnRef)";
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef)";
  parameter Types.PerUnit BPu "Half-susceptance in pu (base SnRef)";
  parameter Types.PerUnit U20Re "Start value of the real voltage on side 2 in pu (base Unom)";
  parameter Types.PerUnit U20Im "Start value of the imaginary voltage on side 2 in pu (base Unom)";
  parameter Types.PerUnit U10Re "Start value of the real voltage on side 1 in pu (base Unom)";
  parameter Types.PerUnit U10Im "Start value of the imaginary voltage on side 1 in pu (base Unom)";



protected

    parameter Types.ComplexImpedancePu ZPu (re = RPu, im = XPu) "Line impedance";
    parameter Types.ComplexAdmittancePu YPu (re = GPu, im = BPu) "Line half-admittance";


    parameter Types.ComplexVoltagePu u20Pu=Complex(U20Re,U20Im) "Start value of the voltage on side 2 ";
    parameter Types.ComplexCurrentPu Ia0Pu=Complex((GPu*u10Pu.re-BPu*u10Pu.im ), (GPu*u10Pu.im+BPu*u10Pu.re  )) "Start value of current through the equivalent impedance G+jB on side 1 ";
    parameter Types.ComplexCurrentPu Iz0Pu=Complex((XPu*RPu/(XPu^2+RPu^2)*((u10Pu.re-u20Pu.re)/XPu + (u10Pu.im-u20Pu.im)/RPu) ),-(XPu*RPu/(XPu^2+RPu^2)*((u10Pu.re-u20Pu.re)/RPu-(u10Pu.im-u20Pu.im)/XPu) )) "Start value of current through the equivalent impedance R+jX in pu ( base Unom, Snref )";
    parameter Types.ComplexCurrentPu Ib0Pu=Complex((GPu*u20Pu.re-BPu*u20Pu.im ), (GPu*u20Pu.im+BPu*u20Pu.re ))"Start value of current through the equivalent impedance G+jB on side 1 in pu ( base Unom, Snref) ";
    parameter Types.ComplexApparentPowerPu s20Pu=u20Pu*ComplexMath.conj(i20Pu) "Start value of the apparent power on side 2";
    parameter Types.ComplexCurrentPu i20Pu=Ib0Pu-Iz0Pu "Start value of the current on side 2 in pu (base Unom, Snref)";

    parameter Types.ComplexVoltagePu u10Pu=Complex(U10Re,U10Im) "Start value of the voltage on side 1" ;
    parameter Types.ComplexApparentPowerPu s10Pu=u10Pu*ComplexMath.conj(i10Pu) "Start value of the apparent power on side 1 in pu (base Snref)";
    parameter Types.ComplexCurrentPu i10Pu=Ia0Pu+Iz0Pu  "Start value of the current on side 1 in pu (base Unom, Snref)";


    Types.ComplexCurrentPu IzPu(re(start=Iz0Pu.re),im(start=Iz0Pu.im))" Current through the equivalent impedance R+jX in pu (base UNom, SnRef)";
    Types.ComplexCurrentPu IaPu(re(start=Ia0Pu.re),im(start=Ia0Pu.im)) " Current through the equivalent impedance G+jB on side 1 in pu (base UNom, SnRef) ";
    Types.ComplexCurrentPu IbPu(re(start=Ib0Pu.re),im(start=Ib0Pu.im)) " Current through the equivalent impedance G+jB on side 2 in pu (base UNom, SnRef) ";

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
