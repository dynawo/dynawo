within Dynawo.Electrical.Loads;

model LoadAlphaBetaMotor "AlphaBeta load in parallel with an induction motor. The load torque is supposed constant (does not change with rotor speed)."
/*
                  isPu          umPu  irPu
    terminal --.--->----Rs+jXs---.----->--Rr+jXr------.
               |                 |                    |
            PQ load             jXm                Rr(1-s)/s
               |                 |                    |
               ----------------------------------------

imPu goes downwards through jXm
*/
  import Modelica;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  Connectors.ImPin omegaPu(value(start = SystemBase.omega0Pu)) "Network angular reference frequency in p.u (base OmegaNom)";

  parameter Types.ApparentPowerModule PNom "Nominal active power consumed by a single motor (Unom base)";
  parameter Types.PerUnit ActiveMotorShare "Share of active power consumed by motors in pu";
  parameter Types.PerUnit RsPu "Stator resistance in pu (PNom base)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (PNom base)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (PNom base)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (PNom base)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (PNom base)";
  parameter Real H "Inertia constant (s, PNom base)";

  parameter Real alpha "Active load sensitivity to voltage";
  parameter Real beta "Reactive load sensitivity to voltage";

  Types.ComplexCurrentPu isPu(re(start = is0Pu.re), im(start = is0Pu.im)) "Stator current in pu (Unom, PNom base)";
  Types.ComplexCurrentPu imPu(re(start = im0Pu.re), im(start = im0Pu.im)) "Magnetising current in pu (Unom, PNom base)";
  Types.ComplexCurrentPu irPu(re(start = ir0Pu.re), im(start = ir0Pu.im)) "Rotor current in pu (Unom, PNom base)";

  Types.PerUnit cePu(start = ce0Pu) "Electrical torque in pu (PNom base)";
  Types.PerUnit clPu(start = ce0Pu) "Load torque in pu (PNom base)";
  Real s(start = s0) "Slip of the motor";
  Types.AngularVelocity omegaRPu(start = omegaR0Pu) "Angular velocity of the motor in pu";

  Types.ActivePowerPu PLoadPu (start = PLoad0Pu) "Active power consumed by the load in pu (SnRef base)";
  Types.ReactivePowerPu QLoadPu (start = QLoad0Pu) "Reactive power consumed by the load in pu (SnRef base)";
  Complex iLoadPu(re(start = iLoad0Pu.re), im(start = iLoad0Pu.im)) "Complex current consumed by the load in pu (SnRef base)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu,XsPu) "Stator impedance in pu";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu,XrPu) "Rotor impedance in pu";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0,XmPu) "Magnetising impedance in pu";

  // Motor initial values
  parameter Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (Unom, PNom base)";
  parameter Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (Unom, PNom base)";
  parameter Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (Unom, PNom base)";

  parameter Types.PerUnit ce0Pu "Start value of the electrical torque in pu (PNom base)";
  parameter Types.PerUnit cl0Pu "Start value of the load torque in pu (PNom base)";
  parameter Real s0 "Start value of the slip of the motor";
  parameter Types.AngularVelocity omegaR0Pu "Start value of the angular velocity of the motor";

  parameter Types.ReactivePowerPu QMotor0Pu "Start value of the reactive power consumed by the motor";

  // Load initial values
  parameter Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (SnRef base)";
  parameter Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (SnRef base)";
  parameter Types.ComplexCurrentPu iLoad0Pu "Start value of the complex current consumed by the load in pu (SnRef base)";

equation
  assert(0 < ActiveMotorShare and ActiveMotorShare < 1, "ActiveMotorShare should be between 0 and 1");

  if (running.value) then
    // PQ load
    PLoadPu = (1-ActiveMotorShare) * PRefPu  * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ alpha);
    QLoadPu = QRefPu - QMotor0Pu * (PNom/SystemBase.SnRef) * (PRefPu/s0Pu.re) * ((ComplexMath.'abs' (terminal.V) / ComplexMath.'abs' (u0Pu)) ^ beta); // s0Pu.re = PRef0Pu (if PRefPu increases but QRefPu stays constant, the reactive power consumed by the motor increases, so the reactive power of the load is reduced to keep the total constant).
    Complex(PLoadPu,QLoadPu) = terminal.V*ComplexMath.conj(iLoadPu);

    // Asynchronous motor
    terminal.V = ZmPu*imPu + ZsPu*isPu; // Kirchhoff’s voltage law in the first loop
    // ZmPu*imPu = (ZrPu + RrPu*(1-s)/s)*irPu; // Kirchhoff’s voltage law in the second loop
    isPu = terminal.V/(ZsPu + 1/(1/ZmPu + s/Complex(RrPu,XrPu*s))); // Avoid numerical issues when s = 0
    isPu = imPu + irPu;

    s = (omegaPu.value - omegaRPu)/omegaPu.value;
    cePu = RrPu*ComplexMath.'abs'(irPu^2)/(omegaPu.value*s);
    clPu = ce0Pu; // Constant load torque
    2*H*der(omegaRPu) = cePu - clPu;

    // Total load
    terminal.i = iLoadPu + (PNom/SystemBase.SnRef)*isPu * (PRefPu/s0Pu.re);
  else
    omegaRPu = 0;
    PLoadPu = 0;
    QLoadPu = 0;
    iLoadPu = Complex(0);
    isPu = Complex(0);
    imPu = Complex(0);
    irPu = Complex(0);
    cePu = 0;
    clPu = 0;
    s = 0;
    terminal.i = Complex(0);
  end if;

annotation(preferredView = "text");
end LoadAlphaBetaMotor;
