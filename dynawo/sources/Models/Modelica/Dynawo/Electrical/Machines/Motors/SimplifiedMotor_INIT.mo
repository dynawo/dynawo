within Dynawo.Electrical.Machines.Motors;
model SimplifiedMotor_INIT "Initialization model for simplified induction motor"
  extends BaseClasses_INIT.BaseMotor_INIT;
  extends AdditionalIcons.Init;

  parameter Types.PerUnit RsPu "Stator resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit RrPu "Rotor resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XsPu "Stator leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XrPu "Rotor leakage reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit XmPu "Magnetizing reactance in pu (base UNom, SNom)";

protected
  final parameter Types.ComplexImpedancePu ZsPu = Complex(RsPu, XsPu) "Stator impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZrPu = Complex(RrPu, XrPu) "Rotor impedance in pu (base UNom, SNom)";
  final parameter Types.ComplexImpedancePu ZmPu = Complex(0, XmPu) "Magnetising impedance in pu (base UNom, SNom)";

public
  Types.ComplexCurrentPu is0Pu "Start value of the stator current in pu (base SNom, UNom)";
  Types.ComplexCurrentPu im0Pu "Start value of the magnetising current in pu (base SNom, UNom)";
  Types.ComplexCurrentPu ir0Pu "Start value of the rotor current in pu (base SNom, UNom)";
  Types.PerUnit ce0Pu "Start value of the electrical torque in pu (base SNom, omegaNom)";
  Real s0 "Start value of the slip of the motor";
  Types.AngularVelocityPu omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";

equation
  u0Pu = ZmPu * im0Pu + ZsPu * is0Pu;  // Kirchhoff’s voltage law in the first loop
  is0Pu = u0Pu / (ZsPu + 1 / (1 / ZmPu + s0 / Complex(RrPu, XrPu * s0)));  // Avoid numerical issues when s = 0
  is0Pu = im0Pu + ir0Pu;
  s0Pu = u0Pu * ComplexMath.conj(is0Pu) * (SNom / SystemBase.SnRef);

  s0 = (SystemBase.omegaRef0Pu - omegaR0Pu) / SystemBase.omegaRef0Pu;
  ce0Pu =RrPu*Modelica.ComplexMath.abs(ir0Pu^2)/(SystemBase.omegaRef0Pu*s0);

  annotation(preferredView = "text");
end SimplifiedMotor_INIT;
