within Dynawo.Electrical.Lines;

model dynamicLine_INIT "Initialization for dynamic line"
  extends AdditionalIcons.Init;
  import Dynawo.Types;

  public

    parameter Types.PerUnit RPu=0.00375/2 "Resistance in pu (base SnRef)";
    parameter Types.PerUnit XPu=0.0375/2 "Reactance in pu (base SnRef)";
    parameter Types.PerUnit GPu=0 "Half-conductance i=u20Pu*ComplexMath.conj(i20Pu)n pu (base SnRef)";
    parameter Types.PerUnit BPu=0.0000375/2 "Half-susceptance in pu (base SnRef)";


    parameter Types.VoltageModulePu U10Pu=0.882565  "Start value of voltage amplitude at line terminal 1 in pu (base UNom)";
    parameter Types.Angle UPhase10=0.131795  "Start value of voltage angle at line terminal 1 (in rad)";
    parameter Types.VoltageModulePu U20Pu=0.944307   "Start value of voltage amplitude at line terminal 2 in pu (base UNom)";
    parameter Types.Angle UPhase20=0.351159 "Start value of voltage angle at line terminal 2 (in rad)";




    Types.ComplexVoltagePu u20Pu "Start value of the voltage on side 2 ";
    Types.ComplexCurrentPu ia0Pu "Start value of current through the equivalent impedance G+jB on side 1 ";
    Types.ComplexCurrentPu iz0Pu "Start value of current through the equivalent impedance R+jX in pu ( base Unom, Snref )";
    Types.ComplexCurrentPu ib0Pu "Start value of current through the equivalent impedance G+jB on side 1 in pu ( base Unom, Snref) ";
    Types.ComplexApparentPowerPu s20Pu "Start value of the apparent power on side 2";
    Types.ComplexCurrentPu i20Pu "Start value of the current on side 2 in pu (base Unom, Snref)";
    Types.ComplexVoltagePu u10Pu "Start value of the voltage on side 1" ;
    Types.ComplexApparentPowerPu s10Pu "Start value of the apparent power on side 1 in pu (base Snref)";
    Types.ComplexCurrentPu i10Pu  "Start value of the current on side 1 in pu (base Unom, Snref)";




equation


  u10Pu=ComplexMath.fromPolar(U10Pu,UPhase10);
  u20Pu=ComplexMath.fromPolar(U20Pu,UPhase20);
  s10Pu=u10Pu*ComplexMath.conj(i10Pu);
  s20Pu=u20Pu*ComplexMath.conj(i20Pu);
  i10Pu=ia0Pu+iz0Pu;
  i20Pu=ib0Pu-iz0Pu;
  ia0Pu=Complex((GPu*u10Pu.re-BPu*u10Pu.im ), (GPu*u10Pu.im+BPu*u10Pu.re));
  iz0Pu=Complex((XPu*RPu/(XPu^2+RPu^2)*((u10Pu.re-u20Pu.re)/XPu + (u10Pu.im-u20Pu.im)/RPu) ),-(XPu*RPu/(XPu^2+RPu^2)*((u10Pu.re-u20Pu.re)/RPu-(u10Pu.im-u20Pu.im)/XPu) ));
  ib0Pu=Complex((GPu*u20Pu.re-BPu*u20Pu.im ), (GPu*u20Pu.im+BPu*u20Pu.re ));

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end dynamicLine_INIT;
