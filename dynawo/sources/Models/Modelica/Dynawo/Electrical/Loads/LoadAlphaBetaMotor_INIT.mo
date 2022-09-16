within Dynawo.Electrical.Loads;

model LoadAlphaBetaMotor_INIT
  extends Load_INIT;
  import Modelica;

  parameter Types.ApparentPowerModule PNom "Nominal active power consumed by a single motor (Unom base)";
  parameter Types.PerUnit ActiveMotorShare "Share of active power consumed by motors in pu";
  parameter Types.PerUnit RsPu "Stator resistance in pu (PNom base, it is assumed that when PRef increases, proportionaly more motors are connected to keep the ActiveMotorShare constant)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (PNom base)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (PNom base)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (PNom base)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (PNom base)";

  Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (Unom, PNom base)";
  Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (Unom, PNom base)";
  Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (Unom, PNom base)";

  Types.PerUnit ce0Pu "Start value of the electrical torque in pu (PNom base)";
  Types.PerUnit cl0Pu "Start value of the load torque in pu (PNom base)";
  Real s0 "Start value of the slip of the motor";
  Types.AngularVelocity omegaR0Pu "Start value of the angular velocity of the motor";

  Types.ReactivePowerPu QMotor0Pu "Start value of the reactive power consumed by the motor in pu (PNom base)";

  Types.ActivePowerPu PLoad0Pu "Start value of the active power consumed by the load in pu (SnRef base)";
  Types.ReactivePowerPu QLoad0Pu "Start value of the reactive power consumed by the load in pu (SnRef base)";
  Types.ComplexCurrentPu iLoad0Pu "Start value of the complex current consumed by the load in pu (SnRef base)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu,XsPu) "Stator impedance in pu";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu,XrPu) "Rotor impedance in pu";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0,XmPu) "Magnetising impedance in pu";

equation

  // PQ load
  PLoad0Pu = (1-ActiveMotorShare) * s0Pu.re;
  // QLoad0Pu = s0Pu.im - QMotor0Pu;
  Complex(PLoad0Pu,QLoad0Pu) = u0Pu*ComplexMath.conj(iLoad0Pu);

  // Asynchronous motor
  u0Pu = ZmPu*im0Pu + ZsPu*is0Pu; // Kirchhoff’s voltage law in the first loop
  // ZmPu*im0Pu = (ZrPu + RrPu*(1-s0)/s0)*ir0Pu; // Kirchhoff’s voltage law in the second loop
  is0Pu = u0Pu/(ZsPu + 1/(1/ZmPu + s0/Complex(RrPu,XrPu*s0))); // Avoid numerical issues when s = 0
  is0Pu = im0Pu + ir0Pu;

  s0 = (SystemBase.omega0Pu - omegaR0Pu)/SystemBase.omega0Pu;
  ce0Pu = RrPu*ComplexMath.'abs'(ir0Pu^2)/(SystemBase.omega0Pu*s0);
  cl0Pu = ce0Pu;

  QMotor0Pu = ComplexMath.imag(u0Pu*ComplexMath.conj(is0Pu));

  // Total load
  i0Pu = iLoad0Pu + (PNom/SystemBase.SnRef)*is0Pu;

annotation(preferredView = "text");
end LoadAlphaBetaMotor_INIT;
