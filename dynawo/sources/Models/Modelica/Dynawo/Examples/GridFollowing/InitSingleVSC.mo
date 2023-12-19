within Dynawo.Examples.GridFollowing;

model InitSingleVSC
  import Modelica;
  import Modelica.Constants;
  import Dynawo;
  /* Network parameters */
  parameter Types.ApparentPowerModule SnRef = 100 "base apparent power in MVA";
  parameter Types.VoltageModule UNom = 400 "base voltage in kV";
  parameter Types.Frequency fNom = 50 "Nominal System frequency";
  parameter Types.AngularVelocity omegaNom = 2*Constants.pi*fNom "Nominal System angular frequency";
  /* Converter Parameters */
  parameter Types.ApparentPowerModule SNom = 1200 "base apparent power in MVA";
  parameter Types.PerUnit ratioTr = 1.02 "Connection transformer ratio in p.u";
  parameter Types.PerUnit R = 0.005 "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit L = 0.15 "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rc = 0.005 "resistance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit Xc = 0.15 "reactance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit InomPu = 1 "Converter nominal current in pu";
  parameter Types.PerUnit ImaxPu = 1 "Converter maximum current in pu";
  parameter Types.PerUnit IqmaxPu = 99 "For cases with limited capability of voltage control the minimum between Iqmax and Iq1max is considered";
  /* Controller Parameters */
  parameter Types.PerUnit Kpc = 0.5730 "Proportional gain of the current loop";
  parameter Types.PerUnit Kic = 6 "Integral gain of the current loop";
  parameter Types.Time Tlpf = 0.0033 "Time constant of low pass filter";
  parameter Types.PerUnit Kpp = 0.0333 "Proportional gain of the active power loop";
  parameter Types.PerUnit Kip = 10 "Integral gain of the active power loop";
  parameter Types.Time T = 0.002 "Time constant in the active power control loop (Trlim in the stepss config file)";
  parameter Types.Frequency didt_min = -999 "Minimum of ramp rate limiter in active power loop in [pu/s]";
  parameter Types.Frequency didt_max = 10 "Maximum of ramp rate limiter in active power loop in [pu/s]";
  parameter Types.PerUnit Kpv = 0.1667 "Proportional gain of the reactive power loop";
  parameter Types.PerUnit Kiv = 50 "Integral gain of the reactive power loop";
  parameter Types.Time Tpll = 0.1 "Time constant of PLL to calculate KpPLL and kiPLL (Tau)";
  parameter Types.PerUnit KpPLL = 10/(omegaNom*Tpll);
  parameter Types.PerUnit OmegaMaxPu = 1.5;
  parameter Types.PerUnit OmegaMinPu = 0.5;
  parameter Types.PerUnit KiPLL = 25/(omegaNom*(Tpll^2));
  parameter Types.PerUnit Vpllb = 0.4 "vpll1 in the block diagrams: Hysteresis lower limit";
  parameter Types.PerUnit Vpllu = 0.5 "vpll2 in the block diagrams : Hysteresis upper limit";
  parameter Types.PerUnit Vs1 = 0.01 "For dynamic voltage support (not used because DVS not modeled)";
  parameter Types.PerUnit Vs2 = 0.005 "For dynamic voltage support (not used because DVS not modeled)";
  parameter Boolean VQControlFlag = true "control strategy: voltage (=true) and reactive power (=false)";
  /* Line Parameters */
  parameter Types.PerUnit RLinePu = 0 "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XLinePu = 0.1125 "Reactance in pu (base UNom, SNom)";
  parameter Types.PerUnit BLinePu = 0 "Half-conductance in pu";
  parameter Types.PerUnit GLinePu = 0 "Half-susceptance in pu";
  /* InfiniteBus Parameters */
  parameter Types.PerUnit RInfPu = 0 "Resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XInfPu = 0.12 "Reactance in pu (base UNom, SNom)";
  /* Powerflow data */
  /* Converter Bus
             Bus A: V= 1pu , theta = 0.093887 rad, P= 1000 MW, Q= 47 Mvar */
  parameter Types.ComplexVoltagePu uPcc0Pu = ComplexMath.fromPolar(1, 0.093887) "Start value of complex voltage at converter PCC in pu (base UNom)";
  parameter Types.ActivePowerPu PGen0Pu = 1000/SNom "Start value of converter generated active power in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu = 47/SNom "Start value of converter generated reactive power in pu (base SNom) (generator convention)";
  /* Infinite Bus
             Bus B: V= 1pu , theta = 0 rad, P=-1000 MW, Q= +47 Mvar */
  parameter Types.ComplexVoltagePu uInf0Pu = ComplexMath.fromPolar(1, 0) "Start value of complex voltage at Infinite Bus in pu (base UNom)";
  parameter Types.ActivePowerPu PInf0Pu = -1000/SNom "Start value of infinite bus injected active power in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInf0Pu = 47/SNom "Start value of infinite bus injected reactive power in pu (base SNom) (generator convention)";
  /* Initial quantities calculated from Powerflow data*/
  /* Converter */
  parameter Types.ComplexCurrentPu iPcc0Pu = ComplexMath.conj(Complex(PGen0Pu, QGen0Pu)/uPcc0Pu) "(generator convention)";
  parameter Types.PerUnit IP0Pu = iPcc0Pu.re*ratioTr;
  parameter Types.ComplexVoltagePu uConv0Pu = (uPcc0Pu/ratioTr) + iPcc0Pu*ratioTr*Complex(R, Xc);
  parameter Types.ComplexCurrentPu iConv0Pu = iPcc0Pu*ratioTr;
  parameter Types.PerUnit UConv0Pu = ComplexMath.'abs'(uConv0Pu);
  //    parameter Types.PerUnit UConv0Pu =sqrt(udConv0Pu*udConv0Pu + uqConv0Pu*uqConv0Pu);
  parameter Types.PerUnit omegaPLL0Pu = 1;
  parameter Types.PerUnit thetaPLL0Pu = ComplexMath.arg(uPcc0Pu);
  parameter Types.PerUnit udPcc0Pu = cos(thetaPLL0Pu)*uPcc0Pu.re + sin(thetaPLL0Pu)*uPcc0Pu.im;
  parameter Types.PerUnit uqPcc0Pu = -sin(thetaPLL0Pu)*uPcc0Pu.re + cos(thetaPLL0Pu)*uPcc0Pu.im;
  parameter Types.PerUnit idPcc0Pu = cos(thetaPLL0Pu)*iPcc0Pu.re + sin(thetaPLL0Pu)*iPcc0Pu.im;
  parameter Types.PerUnit iqPcc0Pu = -sin(thetaPLL0Pu)*iPcc0Pu.re + cos(thetaPLL0Pu)*iPcc0Pu.im;
  parameter Types.PerUnit udConv0Pu = cos(thetaPLL0Pu)*uConv0Pu.re + sin(thetaPLL0Pu)*uConv0Pu.im;
  parameter Types.PerUnit uqConv0Pu = -sin(thetaPLL0Pu)*uConv0Pu.re + cos(thetaPLL0Pu)*uConv0Pu.im;
  parameter Types.PerUnit idConv0Pu = ratioTr*cos(thetaPLL0Pu)*iPcc0Pu.re + ratioTr*sin(thetaPLL0Pu)*iPcc0Pu.im;
  parameter Types.PerUnit iqConv0Pu = -ratioTr*sin(thetaPLL0Pu)*iPcc0Pu.re + ratioTr*cos(thetaPLL0Pu)*iPcc0Pu.im;
  //  parameter Types.PerUnit udConvRef0Pu = udConv0Pu;
  //  parameter Types.PerUnit uqConvRef0Pu = uqConv0Pu;
  parameter Types.PerUnit udConvRef0Pu = udPcc0Pu/ratioTr + R*idPcc0Pu*ratioTr - omegaPLL0Pu*L*iqPcc0Pu*ratioTr;
  parameter Types.PerUnit uqConvRef0Pu = uqPcc0Pu/ratioTr + R*iqPcc0Pu*ratioTr + omegaPLL0Pu*L*idPcc0Pu*ratioTr;
  /* Infinite bus */
  parameter Types.ComplexCurrentPu iTerminal0Pu = ComplexMath.conj(Complex(PInf0Pu, QInf0Pu)/uInf0Pu) "(generator convention)";
  parameter Types.ComplexVoltagePu uTerminal0Pu = Complex(1, 0) "Infinite bus constant voltage module in pu (base UNom)";
  parameter Types.PerUnit UBus0Pu = ComplexMath.'abs'(Complex(RInfPu, XInfPu)*iTerminal0Pu + uTerminal0Pu) "Initial complex voltage at terminal in pu (base UNom)";
  parameter Types.PerUnit UPhaseBus0 = ComplexMath.arg(Complex(RInfPu, XInfPu)*iTerminal0Pu + uTerminal0Pu) "Infinite bus constant voltage angle in rad";
  parameter Types.PerUnit omegaRef0Pu = 1;
  parameter Types.PerUnit PGenRef0Pu = PGen0Pu;
  parameter Types.PerUnit QGenRef0Pu = QGen0Pu;
  parameter Types.PerUnit UConvRef0Pu = UConv0Pu;
  annotation(
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
end InitSingleVSC;
