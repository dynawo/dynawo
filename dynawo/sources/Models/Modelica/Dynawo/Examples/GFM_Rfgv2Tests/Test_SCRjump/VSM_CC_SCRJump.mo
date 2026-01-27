within Dynawo.Examples.GFM_Rfgv2Tests.Test_SCRjump;

model VSM_CC_SCRJump
  import Modelica.Constants.pi;
  //Nominal Values of the converter
  parameter Types.ApparentPowerModule Sbase1 = 1000 "Base apparent power of VSC MVA";
  //Values of the line connection
 // parameter Types.PerUnit SCR = 2 "SCR of the grid connection";

  parameter Real tEvtAnalysis = tOmegaEvtEnd "time to analyse the curves";
  parameter Real IdSteadyState = 0.7488 + 0.24 "Current at the DUT point in steady state after the event in SNom base";
  // Setting parameters for the Infinite Bus
  parameter Types.Time tOmegaEvtStart = 100;
  parameter Types.Time tOmegaEvtEnd = 100.0001;
  parameter Types.Time tMagnitudeEvtstart = 250;
  parameter Types.Time tMagnitudeEvtEnd = 250 + 3;
  //Bloc the Angle of the Power Synhcronisation
  parameter Boolean ActiveAngleHold = false;
  //Fault Values
  parameter Real XFault = 0.0482;
  final parameter Real RFault = XFault / 20;
  parameter Real SNom = Sbase1;
  parameter Real DeltaAngleDUTTest = 0.90 "Mesured Angle at DUT side used for the test in degrees";
  parameter Real DeltaAngleGridTest = 3.7 " 1.58 Applied Step Angle at Grid side used for the test in degrees";
  // /*====== GFM INIT =======*/


  Types.PerUnit Ufilter "Tension at the DUT output ";
  Types.PerUnit Uconv "Tension at the converter output ";
  Types.PerUnit UconvRe;
  Types.PerUnit UconvIm;
  Types.PerUnit UfilterRe;
  Types.PerUnit UfilterIm;
  Types.PerUnit Upcc;
  Types.PerUnit Ugrid;
  //Variables Setting -- Angle calculation
  Types.Angle AnglePcc;
  Types.Angle AngleGrid;
  Types.Angle AngleConv "Angle at the converter output";
  Types.Angle AngleFilter "Angle at the DUT points";
  Types.Angle AngleDroop "Angle at the output of the droop used for the dq Transf";
  //Variables Setting -- Delta Angle calculation
  Types.Angle DeltaAngleConv_Filter "Angle difference between the DUt and the converter output";
  Types.Angle DeltaAnglePcc_Grid;
  Types.Angle DeltaAngleFilter_Grid;
  Types.Angle DeltaAngleConv_Pcc;
  Types.Angle DeltaAngleConv_Grid "Angle Between the conv and the GRid in Degres";
  Types.Angle DeltaAngleFilter_Pcc "Angle Between the filter and the PCC in Degres";



  // Define a discrete variable to store the previous value
  //Real previousValue(start=0);
  Modelica.Blocks.Sources.Step Qref(height = 0, offset = 0, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-134, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step Uref(height = 0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-134, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step Pref(height = 0, offset = 0.5, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-134, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line Z1_line(BPu = 0, GPu = 0, RPu = Rconnection1, XPu = Lconnection1) annotation(
    Placement(visible = true, transformation(origin = {84, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step omegaRef(height = 0, offset = 1, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-134, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.GFM_VSM_cc_v3Prope_ForRLFilter gFM_VSM_cc(ActiveAngleBloc = false, AmortisementVSM = 0.52, CFilter = 0.00001, CurrentAngle0 = CurrentAngle0, CurrentModule0 = CurrentModule0, DeltaVVId0 = DeltaVVId0, DeltaVVIq0 = DeltaVVIq0, FDampingLC = 60, Fsw = 5000, Gffv = 0.8, H = 3, Imax = 1.4, Imax_XVI = 1.5, Ith_XVI = 1.2, LFilter = 0.15, LTransformer = 0.06, Lv_QSEM = 0, Mq = 0, PFilter0Pu = PFilter0Pu, PGen0Pu = PGen0Pu, PMesure0Pu = PMesure0Pu, PRef0Pu = PRef0Pu, QFilter0Pu = QFilter0Pu, QGen0Pu = QGen0Pu, QMesure0Pu = QMesure0Pu, QRef0Pu = QRef0Pu, RVI0 = RVI0, R_LCL = 0, Rv = 0, SNom = Sbase1, SigmaXR = 5, SwitchOffSignal10 = false, UFilterRef0Pu = UFilterRef0Pu, UPolar0Pu = UPolar0Pu, UPolarPhase0 = UPolarPhase0, WPLL = 0.01, W_CurrentLimit = 10000, Wnc = 1000, Wqsem = 100, Wref_FromPLL = false, XVI0 = XVI0, XVInduct = 0.19, i0Pu = i0Pu, idConv0Pu = idConv0Pu, idConvRef0Pu = idConvRef0Pu, idConvSatRef0Pu = idConvSatRef0Pu, idPcc0Pu = idPcc0Pu, iqConv0Pu = iqConv0Pu, iqConvRef0Pu = iqConvRef0Pu, iqConvSatRef0Pu = iqConvSatRef0Pu, iqPcc0Pu = iqPcc0Pu, omega0Pu = omega0Pu, omegaPLL0Pu = omegaPLL0Pu, omegaRef0Pu = omegaRef0Pu, omegaSetSelected0Pu = omegaSetSelected0Pu, theta0 = theta0, u0Pu = u0Pu, udConv0Pu = udConv0Pu, udConvRef0Pu = udConvRef0Pu, udFilter0Pu = udFilter0Pu, udFilterRef0Pu = udFilterRef0Pu, udPcc0Pu = udPcc0Pu, uqConv0Pu = uqConv0Pu, uqConvRef0Pu = uqConvRef0Pu, uqFilter0Pu = uqFilter0Pu, uqFilterRef0Pu = uqFilterRef0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-2, 36}, extent = {{-36, -36}, {36, 36}}, rotation = 0)));
  //Initial Parameters
  parameter Complex i0Pu = Complex(0, 0) "Start value of the complex current at ACPower PCC connection in pu (base UNom,SNom)";
  parameter Complex u0Pu = Complex(0.99, 0) "Start value of the complex voltage at ACPower PCC connection in pu (base UNom)";
  parameter Real PRef0Pu = 0 "start value of the reference active power (SRef, UNom)";
  parameter Real QRef0Pu = 0 "start-value of the reactive power reference  input (base UNom, SNom) (generator convention) ";
  parameter Real UFilterRef0Pu = 1 "start-value of the module voltage reference to be reached after the RLC filter connection point (base UNom, SNom)";
  /*RLConnection*/
  parameter Real idPcc0Pu = 0 "Start value of the d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real iqPcc0Pu = 0 "Start value of the q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Real omega0Pu = 1 "Start value of the angular reference frequency for the VSC system(omega) ";
  parameter Real udFilter0Pu = 0.99 "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Real uqFilter0Pu = 0 "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Real udPcc0Pu = 0.99 "Start value of the q-axis voltage at the grid connection point in pu (base UNom, SNom)";
  parameter Real uqPcc0Pu = 0 "Start value of the d-axis voltage at the grid connection point in pu (base UNom, SNom)";
  /*Measurement Pcc*/
  parameter Real PGen0Pu = 0 "Start value of active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real QGen0Pu = 0 "Start value of reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Real UPolar0Pu = 0.99 "Start value of voltage angle at ACPower PCC connection in rad";
  parameter Real UPolarPhase0 = 0 "Start value of voltage module at ACPower PCC connection in pu (base UNom)";
  parameter Real theta0 = 0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Real PFilter0Pu = 0 "Active Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real QFilter0Pu = 0 "Reactive Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Real idConv0Pu = 0 "d-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Real iqConv0Pu = 0.06 "q-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Real udConv0Pu = 0.98 "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  parameter Real uqConv0Pu = 0 "The q-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  /*VoltageFilterControl*/
  parameter Real idConvRef0Pu = 0.01 "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Real iqConvRef0Pu = 0.06 "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Real udFilterRef0Pu = 1 "Start value of the d-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
  parameter Real uqFilterRef0Pu = 0 "Start value of the q-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
  /*VoltageFilterReference*/
  parameter Real DeltaVVId0 = 0 "d-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Real DeltaVVIq0 = 0 "q-axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Real QMesure0Pu = 0 "start-value of the reactive power mesured (base UNom, SNom) (generator convention)";
  //VirtualImpedance
  parameter Real RVI0 = 0.02 "Start value of virtual resistance in pu (base UNom, SNom)";
  parameter Real XVI0 = 0.21 "Start value of virtual reactance in pu (base UNom, SNom)";
  //CurrentSaturation
  parameter Real CurrentModule0 = 0.06 "start value of the Module of the current in dq representation idConvPu,iqConvPu";
  parameter Real CurrentAngle0 = 1.57 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
  parameter Real idConvSatRef0Pu = 0 "start value of the satured-value of id";
  parameter Real iqConvSatRef0Pu = 0.06 "start value of the satured-value of iq";
  /*CurrentFilterLoop*/
  parameter Real udConvRef0Pu = 0.98 "d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
  parameter Real uqConvRef0Pu = 0 "q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
  //Droop Controls
  parameter Real omegaPLL0Pu = 1 "start value of PLL Frequency  in pu (base omegaNom)";
  parameter Real omegaRef0Pu = 1 "start value of frequency system reference in pu (base omegaNom)";
  parameter Real PMesure0Pu = 0 "start value of the active power mesured, base (SRef, UNom) ";
  parameter Real omegaSetSelected0Pu = 1 "start value of the angular frequency selected";
  //final parameter Types.VoltageModule Ubase1 = 320 "Base voltage kV";
  final parameter Types.Frequency fNom = 50 "System AC frequency Hz";
  final parameter Types.AngularVelocity Wn = 2 * pi * fNom "nominal angular frequency rad/s";
  final parameter Types.ApparentPowerModule Sbase2 = 100 "Base apparent power of the network grid MVA equal to Snref";
  //Parameters regarding SCR ini and SCR final
 parameter Real SCRini = 2;
  parameter Real SCRfinal = 10;
  //First Z1//Z2 and then only Z1 is connected
  final parameter Real Z1 = 1 / SCRini "Inductance in pu base Sbase of VSC";
  final parameter Real Z2 = Z1*(SCRini/(SCRfinal-SCRini)) "Inductance in pu base Sbase of VSC";
  //final parameter Types.VoltageModule Ubase2 = 400 "Base voltage kV";
  final parameter Types.PerUnit Lconnection1 = Z1*Sbase2/Sbase1 "Inductance in pu base Sbase of VSC";
  final parameter Types.PerUnit Rconnection1 = Lconnection1 / 10 "Resistance in pu base Sbase of VSC";
  final parameter Types.PerUnit Lconnection2 = Z2*Sbase2/Sbase1 "Inductance in pu base Snref ";
  final parameter Types.PerUnit Rconnection2 = Lconnection2 / 10 "Resistance in pu base Snref";
  Boolean Line2_NotConnect "Boolean to define a line not connected";
  Dynawo.Electrical.Lines.Line Z2_line(BPu = 0, GPu = 0, RPu = Rconnection2, XPu = Lconnection2) annotation(
    Placement(visible = true, transformation(origin = {90, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Buses.InfiniteBusWithVariations BusInfinite(U0Pu = 0.99, UEvtPu = 1.05, UPhase = 0, omega0Pu = 1, omegaEvtPu = 3.5, tOmegaEvtEnd = tOmegaEvtEnd, tOmegaEvtStart = tOmegaEvtStart, tUEvtEnd = tMagnitudeEvtEnd, tUEvtStart = tMagnitudeEvtstart) annotation(
    Placement(visible = true, transformation(origin = {-6, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

Z1_line.switchOffSignal1.value = false;
Z1_line.switchOffSignal2.value = false;
Z2_line.switchOffSignal1.value = Line2_NotConnect;
Z2_line.switchOffSignal2.value = Line2_NotConnect;
  Line2_NotConnect = if time > 5 and time < 10 then true else false;
  gFM_VSM_cc.switchOffSignal1.value = false;
  gFM_VSM_cc.switchOffSignal2.value = false;
  gFM_VSM_cc.switchOffSignal3.value = false;



//Voltage Calculation:
//====================
// Uinv - Park's transformations dq-currents in generator convention, -> generation convention for terminal
  UconvRe = cos(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.udConvPu - sin(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.uqConvPu;
  UconvIm = sin(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.udConvPu + cos(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.uqConvPu;
// Udut - Park's transformations dq-currents in generator convention, -> generation convention for terminal
  UfilterRe = cos(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.udFilterPu - sin(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.uqFilterPu;
  UfilterIm = sin(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.udFilterPu + cos(gFM_VSM_cc.virtualSynchroMachine.theta) * gFM_VSM_cc.VSC.uqFilterPu;
  Ufilter = Modelica.ComplexMath.'abs'(Complex(UfilterRe, UfilterIm));
// Magnitude is calculated in Re, Im base
  Uconv = Modelica.ComplexMath.'abs'(Complex(UconvRe, UconvIm));
// Magnitude is calculated in Re, Im base
  Upcc = gFM_VSM_cc.measurementPcc.UPolarPu;
//Magnitude is calculated in Re, Im base
  Ugrid = BusInfinite.UPu;
//Angle calculation in degrees
//====================
  AngleConv = Modelica.ComplexMath.arg(Complex(UconvRe, UconvIm)) * 180 / pi;
// Angles are calculated in Re, Im base
  AngleFilter = Modelica.ComplexMath.arg(Complex(UfilterRe, UfilterIm)) * 180 / pi;
// Angles are calculated in Re, Im base
  AnglePcc = gFM_VSM_cc.measurementPcc.UPolarPhase * 180 / pi;
// Angles are calculated in Re, Im base
  AngleGrid = (BusInfinite.UPhase - BusInfinite.UPhaseOffs) * 180 / pi;
//Angle is calculated in Degrees
  AngleDroop = gFM_VSM_cc.virtualSynchroMachine.theta * 180 / pi;
//Delta Angle calculation
//====================
// Angle is calculated in Re,Im base
  DeltaAngleConv_Filter = AngleConv - AngleFilter;
// Angles are calculated in Re, Im
  DeltaAnglePcc_Grid = AnglePcc - AngleGrid;
// angles are calculated in Re, Im (alfa and betha transform)
  DeltaAngleFilter_Grid = AngleFilter - AngleGrid;
// angles are calculated in Re, Im (alfa and betha transform)
  DeltaAngleConv_Pcc = AngleConv - AnglePcc;
// angles are calculated in Re, Im (alfa and betha transform)
  DeltaAngleConv_Grid = AngleConv - AngleGrid;
// angles are calculated in Re, Im (alfa and betha transform)
  DeltaAngleFilter_Pcc = AngleFilter - AnglePcc;

  connect(Qref.y, gFM_VSM_cc.QrefPu) annotation(
    Line(points = {{-123, 72}, {-89, 72}, {-89, 66}, {-44, 66}}, color = {0, 0, 127}));
  connect(Uref.y, gFM_VSM_cc.UFilterRefPu) annotation(
    Line(points = {{-123, 40}, {-94, 40}, {-94, 51}, {-44, 51}}, color = {0, 0, 127}));
  connect(Pref.y, gFM_VSM_cc.PrefPu) annotation(
    Line(points = {{-123, 6}, {-94, 6}, {-94, 35}, {-43, 35}}, color = {0, 0, 127}));
  connect(omegaRef.y, gFM_VSM_cc.OmegaRefPu) annotation(
    Line(points = {{-123, -28}, {-80, -28}, {-80, 18}, {-43, 18}}, color = {0, 0, 127}));
connect(gFM_VSM_cc.PCC, Z1_line.terminal2) annotation(
    Line(points = {{41, 39}, {132, 39}, {132, -32}, {94, -32}}, color = {0, 0, 255}));
connect(Z1_line.terminal2, Z2_line.terminal2) annotation(
    Line(points = {{94, -32}, {100, -32}, {100, -62}, {128, -62}, {128, -68}, {100, -68}}, color = {0, 0, 255}));
connect(Z2_line.terminal1, Z1_line.terminal1) annotation(
    Line(points = {{80, -68}, {74, -68}, {74, -32}}, color = {0, 0, 255}));
connect(BusInfinite.terminal, Z1_line.terminal1) annotation(
    Line(points = {{-6, -52}, {25, -52}, {25, -32}, {74, -32}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-160, 100}, {200, -80}})),
    experiment(StartTime = 0, StopTime = 30, Tolerance = 1e-06, Interval = 0.001),
  Documentation(info = "<html><head></head><body><div>GFM envelopes was tested here by using the converter GFM! ccGFM and the powersynchronisation used was the clasic one from migrate WP3 D3.2</div>First Z1 // Z2<div>Then , only Z1 is connected</div></body></html>"));
end VSM_CC_SCRJump;
