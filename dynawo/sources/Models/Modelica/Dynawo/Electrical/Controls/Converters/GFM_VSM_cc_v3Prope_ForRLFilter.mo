within Dynawo.Electrical.Controls.Converters;

model GFM_VSM_cc_v3Prope_ForRLFilter "Grid Forming converters test case"

  import Modelica.Constants.pi;
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  extends SwitchOff.SwitchOffGenerator;

  //Nominal Values of the converter
  final parameter Types.Frequency fNom = 50 "System AC frequency Hz";
  final parameter Types.AngularVelocity Wn  = 2 * pi * fNom  "nominal angular frequency rad/s";
  parameter Types.ApparentPowerModule SNom = 1000 "Nominal apparent power for the converter";



    //Parameters of the Transformer between the converter and the PCC Base 1
    // parameter Real LFilterTotal = 0.3 "Transformer inductance in pu (base UNom, SNom)";
    //Parameters of the RLC Filter
   parameter Real LFilter  "RLC filter inductor in pu";
   final parameter Real RFilter = LFilter/10 "RLC filter resistance in pu";
   parameter Real CFilter "RLC filter capacitance in pu";


  //Parameters of the Transformer between the converter and the PCC
  parameter Real LTransformer =0.15 "Transformer inductance in pu (base UNom, SNom)";
  final parameter Real RTransformer = LTransformer/10*0"Transformer resistance in pu (base UNom, SNom)";

  // Parameter of the VSC
  parameter Real Fsw = 5000 "Switching frequency of the VSC (hz)";
  final parameter Real Wvsc = 2 * Fsw "angular frequency cut-off of the VSC";
  final parameter Real TrVSC = 1 / Wvsc *4 "Time response of the VSC";

    //Parameters for the Tunning of the Current Loop
  final parameter Real EpsilonCurrent = 0.7 "damping of the close current loop";
  parameter Real Gffv = 1 "sensitivity to the voltage variation at the RLC filter capacitance";
 // final parameter Real TrCurrent = 10 * TrVSC "settling time of the current loop";
  parameter Real Wnc  "Bandwidth of the current control loop in rad/s, = Wvsc/10";
  final parameter Real TrCurrent = 4 / (EpsilonCurrent * Wnc) "settling time of the current loop";
 // final parameter Real Wnc = 4 / (EpsilonCurrent * TrCurrent) "angular frequency cut-off of the current control loop in rad/s";
  final parameter Real Kpc = (LFilter )*Wnc/Wn "proportional gain in pu of the current loop";
  final parameter Real Kic = RFilter*Wnc  "integral gain in rad/s of the current loop";

  //Parameters for the Tunning of the Voltage Loop
  parameter Real Wqsem  "Bandwidth of the QSEM in rad/sec";
  parameter Real Lv_QSEM "virtual impedance added to the QSEM bloc directly";
  //Parameters of the Power synchronisation block to find the frequency of the Grid
 parameter Real H "inertie parameter of the VSM Power Synchro block ";

    parameter Boolean Wref_FromPLL = false "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Real WPLL = 10 "Cut off angular frequency of a first order filter at the output of the PLL (rad/sec)";
  parameter Real omegaSetPu = 1 "Fixe angular frequency as a reference  in pu (base omegaNom)";

  final parameter Real Leq = LTransformer+LFilter+1/10 "impedance equivalente estimated , considering SCR=10";
  parameter Real AmortisementVSM = 0.7 "amortisement pour la bocle de synchronisation" ;
  final parameter Real Kp_GFo = AmortisementVSM*sqrt(2/(H*Wn*1/Leq)) "parameter in between Kd";
  final parameter Real Kd =2*H*Kp_GFo*Wn/Leq "";

  //Parameters for the Direct Voltage Control
  parameter Real FDampingLC "cut-off pulsation frequency of the high pass first order filter (Hz)";
  parameter Real R_LCL "LC damping resistance added to damp oscilations idue to the LC Filter ";

  //Parameters of the Virtual Resistance Block
  parameter Real Rv = 0.09 "Gain of the active damping";
  parameter Real Wff = 60 "Cutoff pulsation of the high-pass first order filter of the Transient Virtual Resistor (in Hz)";

  //Reactive Power block
  parameter Real Mq = 0.05 "Reactive power droop control coefficient";
  parameter Real Wf = Wn / 10 "Cutoff pulsation of the low-pass first order filter to read the reactive power (in rad/s)";

  //PLL block
  parameter Real KiPLL = 795 "integral coefficient of the PI-PLL";
  parameter Real KpPLL = 3 "proportional coefficient of the PI-PLL";


    //Current Saturation
  parameter Real Imax = 1.2 "max value for the current reference in the saturation block";
  parameter Real Imin = 0 "min value for the current reference in the saturation block";

  //Virtual Impedance
  parameter Real Imax_XVI = 1.2 "maximum current allowed, this should be more than Imax from current saturation";
  parameter Real SigmaXR = 10 "constant to calculate XVI";
  parameter Real Ith_XVI = 1 "thershold value that activates the XVI block, from this value we start inserting XVI";










  /*RLConnection*/
  parameter Real idPcc0Pu "Start value of the d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real iqPcc0Pu "Start value of the q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real omega0Pu "Start value of the angular reference frequency for the VSC system(omega) ";
  parameter Real udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Real uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)" ;
  parameter Real udPcc0Pu "Start value of the q-axis voltage at the grid connection point in pu (base UNom, SNom)";
  parameter Real uqPcc0Pu "Start value of the d-axis voltage at the grid connection point in pu (base UNom, SNom)";

  /*Measurement Pcc*/
  parameter Real PGen0Pu "Start value of active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real QGen0Pu "Start value of reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real UPolar0Pu "Start value of voltage angle at ACPower PCC connection in rad";
  parameter Real UPolarPhase0 "Start value of voltage module at ACPower PCC connection in pu (base UNom)";
  parameter Complex i0Pu "Start value of the complex current at ACPower PCC connection in pu (base UNom,SNom)";
  parameter Real theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Complex u0Pu "Start value of the complex voltage at ACPower PCC connection in pu (base UNom)";


  /*VSC*/

  parameter Real PFilter0Pu "Active Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real QFilter0Pu "Reactive Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real idConv0Pu "d-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Real iqConv0Pu "q-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Real udConv0Pu "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  parameter Real uqConv0Pu "The q-axis voltage at the inverter bridge output in pu (base UNom, SNom)";


 /*VoltageFilterControl*/
   parameter Real idConvRef0Pu "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
   parameter Real iqConvRef0Pu "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
   parameter  Real udFilterRef0Pu "Start value of the d-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
   parameter Real uqFilterRef0Pu "Start value of the q-axis voltage reference after the RLC filter in pu (base UNom, SNom)";

/*VoltageFilterReference*/
   parameter Real DeltaVVId0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
   parameter Real DeltaVVIq0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
   parameter Real QMesure0Pu "start-value of the reactive power mesured (base UNom, SNom) (generator convention)";
   parameter Real   QRef0Pu "start-value of the reactive power reference  input (base UNom, SNom) (generator convention) " ;
   parameter Real   UFilterRef0Pu "start-value of the module voltage reference to be reached after the RLC filter connection point (base UNom, SNom)";


  //VirtualImpedance
   parameter Real  RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
   parameter Real  XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
   parameter Real XVInduct "Start value of virtual reactance in pu (base UNom, SNom)-to improve damping";

  //CurrentSaturation
   parameter Real  CurrentModule0 "start value of the Module of the current in dq representation idConvPu,iqConvPu";
   parameter Real  CurrentAngle0 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
   parameter Real idConvSatRef0Pu "start value of the satured-value of id";
   parameter Real iqConvSatRef0Pu "start value of the satured-value of iq";
   parameter Real W_CurrentLimit "Bandwidth of the current saturation block rad/sec";
  /*CurrentFilterLoop*/

   parameter Real udConvRef0Pu "d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
   parameter  Real uqConvRef0Pu "q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";


 //Droop Controls
   parameter Real omegaPLL0Pu "start value of PLL Frequency  in pu (base omegaNom)";
   parameter Real omegaRef0Pu "start value of frequency system reference in pu (base omegaNom)";
   parameter Real PMesure0Pu "start value of the active power mesured, base (SRef, UNom) ";
   parameter Real PRef0Pu "start value of the reference active power (SRef, UNom)";
   parameter Real omegaSetSelected0Pu "start value of the angular frequency selected";

   //Bloc Angles
   parameter Boolean ActiveAngleBloc "Active a Fonction to hold internal angle of the converter when the voltage magnitud is less than a value";


  Dynawo.Electrical.Controls.Converters.BaseControls.RLConnection RLConnection(LTransformer = LTransformer, RTransformer = RTransformer, idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, omega0Pu = omega0Pu, udFilter0Pu = udFilter0Pu, udPcc0Pu = udPcc0Pu, uqFilter0Pu = uqFilter0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {25109, -73}, extent = {{-812, -812}, {812, 812}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.MeasurementPcc measurementPcc(PGen0Pu = PGen0Pu, QGen0Pu = QGen0Pu, SNom = SNom, UPolar0Pu = UPolar0Pu, UPolarPhase0 = UPolarPhase0, i0Pu = Complex(i0Pu.re, i0Pu.im), idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, theta0 = theta0, u0Pu = Complex(u0Pu.re, u0Pu.im), udPcc0Pu = udPcc0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {29987, 66}, extent = {{-1084, -1084}, {1084, 1084}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = KiPLL, Kp = KpPLL, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1669.5, 3271.5}, extent = {{-518.5, -518.5}, {518.5, 518.5}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.BridgeInverterRLC VSC(CFilter = CFilter, LFilter = LFilter, PFilter0Pu = PFilter0Pu, QFilter0Pu = QFilter0Pu, RFilter = RFilter, TrVSC = TrVSC, idConv0Pu = idConv0Pu, idPcc0Pu = idPcc0Pu, iqConv0Pu = iqConv0Pu, iqPcc0Pu = iqPcc0Pu, omega0Pu = omega0Pu, udConv0Pu = udConv0Pu,  udConvRef0Pu = udConvRef0Pu, udFilter0Pu = udFilter0Pu, uqConv0Pu = uqConv0Pu, uqConvRef0Pu = uqConvRef0Pu,   uqFilter0Pu = uqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {19626.9, -513.699}, extent = {{-932.056, -1677.7}, {932.056, 1677.7}}, rotation = 0)));
   Dynawo.Electrical.Controls.Converters.InnerControls.VC_QSEM VoltageFilterControl(   LFilter = LTransformer, Lv_QSEM = Lv_QSEM, RFilter = RTransformer,Wn = Wn, Wqsem = Wqsem, idConvRef0Pu = idConvRef0Pu,  iqConvRef0Pu = iqConvRef0Pu, udFilter0Pu = udFilter0Pu, udFilterRef0Pu = udFilterRef0Pu, uqFilter0Pu = uqFilter0Pu, uqFilterRef0Pu = uqFilterRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-2212.89, -548.999}, extent = {{-930.556, -1675}, {930.556, 1675}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.OuterControls.VoltageFilterReference VoltageFilterReference(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0,Mq = Mq, QMesure0Pu = QMesure0Pu, QRef0Pu = QRef0Pu, Rv = Rv, UFilterRef0Pu = UFilterRef0Pu, Wf = Wf, Wff = Wff, idPcc0Pu = idPcc0Pu, iqPcc0Pu = iqPcc0Pu, udFilterRef0Pu = udFilterRef0Pu, uqFilterRef0Pu = uqFilterRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-9019.22, -348.8}, extent = {{-1226.78, -2208.2}, {1226.78, 2208.2}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.InnerControls.VirtualImpedance  VirtualImpedance(DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0,Imax_XVI = Imax_XVI, RVI0 = RVI0, SigmaXR = SigmaXR, XVI0 = XVI0, XVInduct = XVInduct, idConv0Pu = idConv0Pu, iqConv0Pu = iqConv0Pu, Ith_XVI = Ith_XVI) annotation(
    Placement(visible = true, transformation(origin = {-15453.6, -2000.2}, extent = {{-926.556, -833.9}, {926.556, 833.9}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentSaturation currentSaturation(CurrentAngle0 = CurrentAngle0, CurrentModule0 = CurrentModule0,Imax = Imax, Imin = Imin, W_CurrentLimit = W_CurrentLimit, idConvRef0Pu = idConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, iqConvRef0Pu = iqConvRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {2134, -225}, extent = {{-1033, -1033}, {1033, 1033}}, rotation = 0)));
  Dynawo.Connectors.ACPower PCC annotation(
    Placement(visible = true, transformation(origin = {33436, -2184}, extent = {{-180, -180}, {180, 180}}, rotation = 0), iconTransformation(origin = {120, 8}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu annotation(
    Placement(visible = true, transformation(origin = {-5192.5, 2089.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-114, -50}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput PrefPu annotation(
    Placement(visible = true, transformation(origin = {-3336.5, 5909.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-114, -2}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput UFilterRefPu annotation(
    Placement(visible = true, transformation(origin = {-15544.5, 2092.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-116, 42}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput QrefPu annotation(
    Placement(visible = true, transformation(origin = {-15513.5, 837.5}, extent = {{-328.5, -328.5}, {328.5, 328.5}}, rotation = 0), iconTransformation(origin = {-116, 84}, extent = {{15, -15}, {-15, 15}}, rotation = 180)));
  Dynawo.Electrical.Controls.Converters.InnerControls.CurrentFilterLoopQSEM currentFilterLoop(EpsilonCurrent = EpsilonCurrent, Fsw = Fsw, Gffv = Gffv, Kic = Kic, Kpc = Kpc, LFilter =  LFilter,  Wn = Wn, Wnc = Wnc, idConv0Pu = idConv0Pu,  idConvSatRef0Pu = idConvSatRef0Pu, iqConv0Pu = iqConv0Pu,  iqConvSatRef0Pu = iqConvSatRef0Pu, omega0Pu = omega0Pu, udConvRef0Pu = udConvRef0Pu, udFilter0Pu = udFilter0Pu, uqConvRef0Pu = uqConvRef0Pu, uqFilter0Pu = uqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {9402.42, -273.297}, extent = {{-1174.42, -1409.3}, {1174.42, 1409.3}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {20852.5, 4618.5}, extent = {{-504.5, -504.5}, {504.5, 504.5}}, rotation = 0), iconTransformation(origin = {118, 76}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
 Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization.VirtualSynchroMachine virtualSynchroMachine(H = H, K_VSM =Kd, PMesure0Pu = PMesure0Pu, PRef0Pu = PRef0Pu, WPLL = WPLL, Wref_FromPLL = Wref_FromPLL, omega0Pu = omega0Pu, omegaPLL0Pu = omegaPLL0Pu, omegaRef0Pu = omegaRef0Pu, omegaSetSelected0Pu = omegaSetSelected0Pu, theta0 = theta0)  annotation(
    Placement(visible = true, transformation(origin = {2342.5, 3540.5}, extent = {{-956.5, -956.5}, {956.5, 956.5}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-28456.5, 3316.5}, extent = {{-852.5, -852.5}, {852.5, 852.5}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-24886.5, 3322.5}, extent = {{-627.5, -627.5}, {627.5, 627.5}}, rotation = 0)));
 Modelica.Blocks.Continuous.Integrator integrator(k = 0.1, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-24815, 575}, extent = {{-707, -707}, {707, 707}}, rotation = 0)));
 Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-21396.5, 2375.5}, extent = {{-680.5, -680.5}, {680.5, 680.5}}, rotation = 0)));
 Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-16067.5, 4976.5}, extent = {{-680.5, -680.5}, {680.5, 680.5}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-18503.5, 5479.5}, extent = {{-627.5, -627.5}, {627.5, 627.5}}, rotation = 0)));
 Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold = 0.95)  annotation(
    Placement(visible = true, transformation(origin = {31556.5, 7098.5}, extent = {{-544.5, -544.5}, {544.5, 544.5}}, rotation = 0)));
 Modelica.Blocks.Logical.And and1 annotation(
    Placement(visible = true, transformation(origin = {37842.5, 6776.5}, extent = {{-660.5, -660.5}, {660.5, 660.5}}, rotation = 0)));
 Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {45897.5, 8023.5}, extent = {{-775.5, -775.5}, {775.5, 775.5}}, rotation = 0)));
 Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {46643.5, 4631.5}, extent = {{637.5, 637.5}, {-637.5, -637.5}}, rotation = 180)));
 Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = ActiveAngleBloc)  annotation(
    Placement(visible = true, transformation(origin = {34241, 5486}, extent = {{-762, -762}, {762, 762}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput theta annotation(
    Placement(visible = true, transformation(origin = {17945.5, 7070.5}, extent = {{-504.5, -504.5}, {504.5, 504.5}}, rotation = 0), iconTransformation(origin = {118, -66}, extent = {{-18, -18}, {18, 18}}, rotation = 0)));
equation
  connect(OmegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-5192, 2090}, {-3723, 2090}, {-3723, 2960}, {-2240, 2960}}, color = {0, 0, 127}));
  connect(virtualSynchroMachine.theta, measurementPcc.theta) annotation(
    Line(points = {{3395, 3961}, {29987, 3961}, {29987, 1222}}, color = {0, 0, 127}));
  connect(measurementPcc.terminal, PCC) annotation(
    Line(points = {{29228, -1066}, {29284, -1066}, {29284, -2184}, {33436, -2184}}, color = {0, 0, 255}));
  connect(measurementPcc.uComplexPu, pll.uPu) annotation(
    Line(points = {{30941, -1078}, {30865, -1078}, {30865, -1766}, {33545, -1766}, {33545, 3128}, {4226, 3128}, {4226, 4639}, {-2741, 4639}, {-2741, 3583}, {-2240, 3583}}, color = {85, 170, 255}));
  connect(VoltageFilterReference.uqFilterRefPu, VoltageFilterControl.uqFilterRefPu) annotation(
    Line(points = {{-7670, -582}, {-5764, -582}, {-5764, 428}, {-3227, 428}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.idConvRefPu, currentSaturation.idConvRefPu) annotation(
    Line(points = {{-1189, -65}, {998, -65}, {998, 147}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.iqConvRefPu, currentSaturation.iqConvRefPu) annotation(
    Line(points = {{-1189, -754}, {79, -754}, {79, -246}, {998, -246}}, color = {0, 0, 127}));
  connect(RLConnection.idPccPu, measurementPcc.idPccPu) annotation(
    Line(points = {{26002, 135}, {28795, 135}, {28795, 126}}, color = {0, 0, 127}));
  connect(RLConnection.iqPccPu, measurementPcc.iqPccPu) annotation(
    Line(points = {{26002, -136}, {28795, -136}, {28795, -199}}, color = {0, 0, 127}));
  connect(VSC.udFilterPu, RLConnection.udFilterPu) annotation(
    Line(points = {{20652, -420}, {22519, -420}, {22519, -524}, {24216, -524}}, color = {0, 0, 127}));
  connect(VSC.uqFilterPu, RLConnection.uqFilterPu) annotation(
    Line(points = {{20652, -793}, {22448, -793}, {22448, -705}, {24216, -705}}, color = {0, 0, 127}));
  connect(RLConnection.udPccPu, measurementPcc.udPccPu) annotation(
    Line(points = {{24216, 595}, {23854, 595}, {23854, 1757}, {32403, 1757}, {32403, 536}, {31179, 536}}, color = {0, 0, 127}));
  connect(RLConnection.uqPccPu, measurementPcc.uqPccPu) annotation(
    Line(points = {{24216, 441}, {23590, 441}, {23590, 1871}, {32675, 1871}, {32675, 295}, {31179, 295}}, color = {0, 0, 127}));
  connect(OmegaRefPu, virtualSynchroMachine.omegaRefPu) annotation(
    Line(points = {{-5192, 2090}, {-4560, 2090}, {-4560, 4344}, {1290, 4344}}, color = {0, 0, 127}));
  connect(virtualSynchroMachine.omegaPu, omegaPu) annotation(
    Line(points = {{3395, 3196}, {9647, 3196}, {9647, 4619}, {20853, 4619}}, color = {0, 0, 127}));
  connect(RLConnection.omegaPu, VSC.omegaPu) annotation(
    Line(points = {{25109, 784}, {25128, 784}, {25128, 3189}, {19627, 3189}, {19627, 1257}}, color = {0, 0, 127}));
  connect(virtualSynchroMachine.omegaPu, VSC.omegaPu) annotation(
    Line(points = {{3395, 3196}, {19627, 3196}, {19627, 1257}}, color = {0, 0, 127}));
  connect(currentSaturation.idConvSatRefPu, currentFilterLoop.idConvSatRefPu) annotation(
    Line(points = {{3270, 188}, {4085, 188}, {4085, 901}, {8150, 901}}, color = {0, 0, 127}));
  connect(currentSaturation.iqConvSatRefPu, currentFilterLoop.iqConvSatRefPu) annotation(
    Line(points = {{3270, -432}, {8150, -432}, {8150, -493}}, color = {0, 0, 127}));
  connect(VoltageFilterReference.iqPccPu, RLConnection.iqPccPu) annotation(
    Line(points = {{-10369, -1085}, {-11896, -1085}, {-11896, -3778}, {28185, -3778}, {28185, -136}, {26002, -136}}, color = {0, 0, 127}));
  connect(currentFilterLoop.idConvPu, VSC.idConvPu) annotation(
    Line(points = {{8142, 564}, {4737, 564}, {4737, -2564}, {22688, -2564}, {22688, 884}, {20652, 884}}, color = {0, 0, 127}));
  connect(currentFilterLoop.iqConvPu, VSC.iqConvPu) annotation(
    Line(points = {{8150, -915}, {4488, -915}, {4488, -2885}, {23044, -2885}, {23044, 400}, {20652, 400}}, color = {0, 0, 127}));
  connect(VSC.idPccPu, RLConnection.idPccPu) annotation(
    Line(points = {{18602, -700}, {17055, -700}, {17055, -3954}, {26856, -3954}, {26856, 135}, {26002, 135}}, color = {0, 0, 127}));
  connect(VSC.iqPccPu, RLConnection.iqPccPu) annotation(
    Line(points = {{18602, -1222}, {17208, -1222}, {17208, -4065}, {27177, -4065}, {27177, -136}, {26002, -136}}, color = {0, 0, 127}));
  connect(VoltageFilterReference.idPccPu, RLConnection.idPccPu) annotation(
    Line(points = {{-10369, -594}, {-12475, -594}, {-12475, -3536}, {27622, -3536}, {27622, 135}, {26002, 135}}, color = {0, 0, 127}));
  connect(currentFilterLoop.udFilterPu, VSC.udFilterPu) annotation(
    Line(points = {{8150, 40}, {5364, 40}, {5364, 2015}, {21922, 2015}, {21922, -420}, {20652, -420}}, color = {0, 0, 127}));
  connect(currentFilterLoop.uqFilterPu, VSC.uqFilterPu) annotation(
    Line(points = {{8150, -1416}, {5084, -1416}, {5084, 2148}, {22202, 2148}, {22202, -793}, {20652, -793}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.udPccPu, measurementPcc.udPccPu) annotation(
    Line(points = {{-3237, -1405}, {-5381, -1405}, {-5381, -6304}, {34099, -6304}, {34099, 536}, {31179, 536}}, color = {0, 0, 127}));
  connect(measurementPcc.uqPccPu, VoltageFilterControl.uqPccPu) annotation(
    Line(points = {{31179, 295}, {34691, 295}, {34691, -6687}, {-4841, -6687}, {-4841, -1703}, {-3237, -1703}}, color = {0, 0, 127}));
  connect(VoltageFilterReference.udFilterRefPu, VoltageFilterControl.udFilterRefPu) annotation(
    Line(points = {{-7670, 68}, {-5957, 68}, {-5957, 791}, {-3218, 791}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.omegaPu, currentFilterLoop.omegaPu) annotation(
    Line(points = {{-2120, 1219}, {-2159, 1219}, {-2159, 1654}, {9402, 1654}, {9402, 1214}}, color = {0, 0, 127}));
  connect(virtualSynchroMachine.omegaPu, VoltageFilterControl.omegaPu) annotation(
    Line(points = {{3395, 3196}, {3675, 3196}, {3675, 2177}, {-2120, 2177}, {-2120, 1219}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-27689, 3317}, {-25639.5, 3317}, {-25639.5, 3322.5}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{-24196, 3322.5}, {-23046, 3322.5}, {-23046, 2784}, {-22213, 2784}}, color = {0, 0, 127}));
  connect(integrator.u, feedback.y) annotation(
    Line(points = {{-25663, 575}, {-27689, 575}, {-27689, 3317}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-24037, 575}, {-23099, 575}, {-23099, 1967}, {-22213, 1967}}, color = {0, 0, 127}));
  connect(QrefPu, feedback.u1) annotation(
    Line(points = {{-15513, 838}, {-13748, 838}, {-13748, 6702}, {-29801, 6702}, {-29801, 3317}, {-29138, 3317}}, color = {0, 0, 127}));
  connect(UFilterRefPu, add1.u2) annotation(
    Line(points = {{-15544, 2093}, {-14278, 2093}, {-14278, 3682}, {-17377, 3682}, {-17377, 4568}, {-16884, 4568}}, color = {0, 0, 127}));
  connect(gain1.y, add1.u1) annotation(
    Line(points = {{-17813, 5480}, {-16884, 5480}, {-16884, 5385}}, color = {0, 0, 127}));
  connect(gain1.u, add.y) annotation(
    Line(points = {{-19256, 5480}, {-19894, 5480}, {-19894, 2376}, {-20648, 2376}}, color = {0, 0, 127}));
  connect(lessThreshold.y, and1.u1) annotation(
    Line(points = {{32155.5, 7098.5}, {33156.4, 7098.5}, {33156.4, 6776.5}, {37050, 6776.5}}, color = {255, 0, 255}));
  connect(switch1.u2, and1.y) annotation(
    Line(points = {{44967, 8024}, {42356, 8024}, {42356, 6777}, {38569, 6777}}, color = {255, 0, 255}));
  connect(switch1.y, virtualSynchroMachine.PRefPu) annotation(
    Line(points = {{46751, 8024}, {47368, 8024}, {47368, 9484}, {-514, 9484}, {-514, 4038}, {1290, 4038}}, color = {0, 0, 127}));
  connect(lessThreshold.u, product.u2) annotation(
    Line(points = {{30903, 7099}, {30636, 7099}, {30636, 4249}, {45879, 4249}}, color = {0, 0, 127}));
  connect(measurementPcc.UModule, lessThreshold.u) annotation(
    Line(points = {{31179, 1042}, {33975, 1042}, {33975, 3882}, {30218, 3882}, {30218, 7099}, {30903, 7099}}, color = {0, 0, 127}));
  connect(booleanConstant.y, and1.u2) annotation(
    Line(points = {{35079, 5486}, {35972, 5486}, {35972, 6248}, {37050, 6248}}, color = {255, 0, 255}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{47345, 4632}, {47909.5, 4632}, {47909.5, 4618}, {47858, 4618}, {47858, 6331}, {44163, 6331}, {44163, 8644}, {44967, 8644}}, color = {0, 0, 127}));
  connect(switch1.u3, product.u1) annotation(
    Line(points = {{44967, 7403}, {43240, 7403}, {43240, 5014}, {45879, 5014}}, color = {0, 0, 127}));
  connect(switch1.u3, PrefPu) annotation(
    Line(points = {{44967, 7403}, {43220, 7403}, {43220, 8967}, {-1924, 8967}, {-1924, 5910}, {-3336, 5910}}, color = {0, 0, 127}));
  connect(currentSaturation.idPcc, VSC.idConvPu) annotation(
    Line(points = {{1783, -1361}, {1777, -1361}, {1777, -5704}, {21352, -5704}, {21352, 884}, {20652, 884}}, color = {0, 0, 127}));
  connect(currentSaturation.iqPcc, VSC.iqConvPu) annotation(
    Line(points = {{2712, -1361}, {2805, -1361}, {2805, -5829}, {21571, -5829}, {21571, 400}, {20652, 400}}, color = {0, 0, 127}));
  connect(virtualSynchroMachine.theta, theta) annotation(
    Line(points = {{3395, 3961}, {6979, 3961}, {6979, 7071}, {17946, 7071}}, color = {0, 0, 127}));
  connect(add1.y, VoltageFilterReference.UFilterRefPu) annotation(
    Line(points = {{-15319, 4976.5}, {-12874, 4976.5}, {-12874, 1369}, {-10369, 1369}}, color = {0, 0, 127}));
  connect(QrefPu, VoltageFilterReference.QRefPu) annotation(
    Line(points = {{-15513, 838}, {-12546, 838}, {-12546, 853}, {-10369, 853}}, color = {0, 0, 127}));
  connect(feedback.u2, measurementPcc.QGenPu) annotation(
    Line(points = {{-28456, 2635}, {-28356, 2635}, {-28356, -8375}, {32106, -8375}, {32106, -729}, {31179, -729}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, virtualSynchroMachine.omegaPLLPu) annotation(
    Line(points = {{-1099, 3531}, {-395, 3531}, {-395, 3024}, {1290, 3024}}, color = {0, 0, 127}));
  connect(measurementPcc.QGenPu, VoltageFilterReference.QMesurePu) annotation(
    Line(points = {{31179, -729}, {32640, -729}, {32640, -7624}, {-13283, -7624}, {-13283, 216}, {-10369, 216}}, color = {0, 0, 127}));
  connect(VirtualImpedance.DeltaVVIq, VoltageFilterReference.DeltaVVIq) annotation(
    Line(points = {{-14434, -2241}, {-12634, -2241}, {-12634, -2410}, {-10369, -2410}}, color = {0, 0, 127}));
  connect(VirtualImpedance.DeltaVVId, VoltageFilterReference.DeltaVVId) annotation(
    Line(points = {{-14434, -1537}, {-12016, -1537}, {-12016, -1968}, {-10369, -1968}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.idConvRefPu, VirtualImpedance.idConvPu) annotation(
    Line(points = {{-1189, -65}, {-1305, -65}, {-1305, -6484}, {-18718, -6484}, {-18718, -2000}, {-16491, -2000}}, color = {0, 0, 127}));
  connect(VoltageFilterControl.iqConvRefPu, VirtualImpedance.iqConvPu) annotation(
    Line(points = {{-1189, -754}, {-449, -754}, {-449, -7340}, {-17535, -7340}, {-17535, -2406}, {-16482, -2406}, {-16482, -2399}}, color = {0, 0, 127}));
 connect(currentFilterLoop.udConvRefPu, VSC.udConvRefPu) annotation(
    Line(points = {{10655, 651}, {16312, 651}, {16312, 605}, {18602, 605}}, color = {0, 0, 127}));
 connect(currentFilterLoop.uqConvRefPu, VSC.uqConvRefPu) annotation(
    Line(points = {{10655, -649}, {13131, -649}, {13131, 46}, {18602, 46}}, color = {0, 0, 127}));
 connect(virtualSynchroMachine.PMesurePu, measurementPcc.PGenPu) annotation(
    Line(points = {{1290, 3636}, {241, 3636}, {241, -4378}, {32952, -4378}, {32952, -416}, {31179, -416}}, color = {0, 0, 127}));
protected
 annotation(
    Diagram(coordinateSystem(extent = {{-29800, 9480}, {47920, -8380}})));

end GFM_VSM_cc_v3Prope_ForRLFilter;
