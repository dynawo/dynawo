within Dynawo.Electrical.Lines;

model dynamicLine_INIT "Initialization for dynamic line"
  extends AdditionalIcons.Init;
  import Dynawo.Types;

  public
    parameter Types.VoltageModulePu U10Pu=1  "Start value of voltage amplitude at line terminal 1 in pu (base UNom)";
    parameter Types.Angle UPhase10=0.05  "Start value of voltage angle at line terminal 1 (in rad)";
    parameter Types.ReactivePowerPu Q10Pu  "Start value of reactive power in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePower P10Pu " Start value of active power in pu (base SnRef) ";
    parameter Types.VoltageModulePu U20Pu=0.8  "Start value of voltage amplitude at line terminal 2 in pu (base UNom)";
    parameter Types.Angle UPhase20=0  "Start value of voltage angle at line terminal 2 (in rad)";
    parameter Types.ReactivePowerPu Q20Pu  "Start value of reactive power in pu (base SnRef) (receptor convention)";
    parameter Types.ActivePower P20Pu " Start value of active power in pu (base SnRef) ";

    Types.ComplexVoltagePu u10Pu "Start value of complex voltage at line terminal 1 in pu (base UNom)";
    Types.ComplexApparentPowerPu s10Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i10Pu "Start value of complex current at line terminal 1 in pu (base UNom, SnRef) (receptor convention)";
    Types.ComplexVoltagePu u20Pu "Start value of complex voltage at line terminal 2 in pu (base UNom)";
    Types.ComplexApparentPowerPu s20Pu "Start value of complex apparent power in pu (base SnRef) (receptor convention)";
    Types.ComplexCurrentPu i20Pu "Start value of complex current at line terminal 2 in pu (base UNom, SnRef) (receptor convention)";

  protected


equation
  u10Pu = ComplexMath.fromPolar(U10Pu, UPhase10);
  s10Pu = Complex( 0, Q10Pu);
  i10Pu.re = 0.2;
  i10Pu.im = -0.2;
  u20Pu = ComplexMath.fromPolar(U20Pu, UPhase20);
  i20Pu.re = 0.2;
  i20Pu.im = -0.2;
  s20Pu = Complex( 0, Q20Pu);

end dynamicLine_INIT;
