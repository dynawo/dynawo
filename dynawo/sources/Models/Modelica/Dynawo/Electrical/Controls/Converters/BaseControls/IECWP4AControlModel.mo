within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWP4AControlModel

  import Modelica;
  import Dynawo.Types;
  import Dynawo;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Linear Communication Parameters*/
  parameter Types.PerUnit Tlead "Communication lead time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));
  parameter Types.PerUnit Tlag "Communication lag time constant" annotation(
    Dialog(group = "group", tab = "LinearCommunication"));

  /*WP PControl Parameters*/
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kwppref "Active power reference gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpWPRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpWPRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pRefMax "Maximum PD power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pRefMin "Minimum PD power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pErrMax "Maximum control error for power PI controller" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pErrMin "Minimum control error for power PI controller" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pKIWPpMax "Maximum active power reference from integration" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pKIWPpMin "Minimum active power reference from integration" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pWPHookPu "WP hook active power" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));

  /*WP QControl*/
  parameter Types.PerUnit RWPDrop "Resistive component of voltage drop impedance" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit XWPDrop "Inductive component of voltage drop impedance" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqdip "Voltage threshold for UVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqrise "Voltage threshold for OVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMax "Maximum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMin "Minimum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMax "Maximum WT reactive power/voltage reference  from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMin "Minimum WT reactive power/voltage reference from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmax "Maximum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmin "Minimum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMax "Maximum positive ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMin "Minimum negative ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Tuqfilt "Time constant for the UQ static mode" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power/voltage PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power/voltage PI controller integral gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqref "Reactive power reference gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Integer Mwpqmode "Reactive power/voltage control mode (0 reactive power reference, 1 power factor reference, 2 UQ static, 3 voltage control)" annotation(
    Dialog(group = "group", tab = "QControlWP"));

  /*Grid Measurement Parameters*/
  parameter Types.PerUnit Tpfilt "Time constant in active power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tqfilt "Time constant in reactive power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.PerUnit Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMax "Maximum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMin "Mmum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));

  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in rad";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit X0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit XWT0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";

  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput pWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "WP reference active power value" annotation(
    Placement(visible = true, transformation(origin = {-180, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput xWPRefPu(start = X0Pu) "WP reference reactive power value" annotation(
    Placement(visible = true, transformation(origin = {-180, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uWTRePu(start = u0Pu.re) "WTT active voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {180, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uWTImPu(start = u0Pu.im) "WTT reactive voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {180, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {-120, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iWTRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "WTT active current phasor in power system coordinates (Ubase)"annotation(
    Placement(visible = true, transformation(origin = {150, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {60, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iWTImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "WTT reactive current phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {180, -90}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Global power system grid frequency applied for frequency measurements because angles are calculated in the corresponding stationary reference frame" annotation(
    Placement(visible = true, transformation(origin = {180, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180), iconTransformation(origin = {120, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput pPDRefComPu(start = -P0Pu * SystemBase.SnRef / SNom) "WT reference active power value" annotation(
    Placement(visible = true, transformation(origin = {180, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-170, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput xPDRefComPu(start = XWT0Pu) "WT reference reactive power value" annotation(
    Placement(visible = true, transformation(origin = {180, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-170, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Blocks*/
  Dynawo.Electrical.Controls.Converters.BaseControls.IECWP4APControl iECWP4APControl(Kiwpp = Kiwpp, Kpwpp = Kpwpp, Kwppref = Kwppref, P0Pu = P0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, dpRefMax = dpRefMax, dpRefMin = dpRefMin, dpWPRefMax = dpWPRefMax, dpWPRefMin = dpWPRefMin, pErrMax = pErrMax, pErrMin = pErrMin, pKIWPpMax = pKIWPpMax, pKIWPpMin = pKIWPpMin, pRefMax = pRefMax, pRefMin = pRefMin, pWPHookPu = pWPHookPu) annotation(
    Placement(visible = true, transformation(origin = {-1, 59.2857}, extent = {{-29, -20.7143}, {29, 20.7143}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWP4AQControl iECWP4AQControl(Kiwpx = Kiwpx, Kpwpx = Kpwpx, Kwpqref = Kwpqref, Kwpqu = Kwpqu, Mwpqmode = Mwpqmode, P0Pu = P0Pu, Q0Pu = Q0Pu, RWPDrop = RWPDrop, SNom = SNom, Tuqfilt = Tuqfilt, U0Pu = U0Pu, X0Pu = X0Pu, XWPDrop = XWPDrop, XWT0Pu = XWT0Pu, dxRefMax = dxRefMax, dxRefMin = dxRefMin, uWPqdip = uWPqdip, uWPqrise = uWPqrise, xKIWPxMax = xKIWPxMax, xKIWPxMin = xKIWPxMin, xRefMax = xRefMax, xRefMin = xRefMin, xerrmax = xerrmax, xerrmin = xerrmin) annotation(
    Placement(visible = true, transformation(origin = {-0.888889, 0}, extent = {{-31.1111, -20}, {31.1111, 20}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWP4ALinearCommunicationWPRef iECWP4ALinearCommunicationWPRef(P0Pu = P0Pu, Q0Pu = Q0Pu,SNom = SNom, Tlag = Tlag, Tlead = Tlead, U0Pu = U0Pu, X0Pu = X0Pu) annotation(
    Placement(visible = true, transformation(origin = {-123, 1.9984e-15}, extent = {{-25, -20}, {25, 20}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWP4ALinearCommunicationPD iECWP4ALinearCommunicationPD(P0Pu = P0Pu, Q0Pu = Q0Pu,SNom = SNom, Tlag = Tlag, Tlead = Tlead, U0Pu = U0Pu, XWT0Pu = XWT0Pu) annotation(
    Placement(visible = true, transformation(origin = {91, 48}, extent = {{-30, -24}, {30, 24}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECWP4ALinearCommunicationWPM iECWP4ALinearCommunicationWPM(P0Pu = P0Pu, Q0Pu = Q0Pu,SNom = SNom, Tlag = Tlag, Tlead = Tlead, U0Pu = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-0.999998, -58.6}, extent = {{34.3334, -20.6}, {-34.3334, 20.6}}, rotation = 0)));
 Dynawo.Electrical.Controls.Converters.BaseControls.IECWT4AMeasures iECWT4AMeasures(P0Pu = P0Pu, Q0Pu = Q0Pu,SNom = SNom, Tffilt = Tffilt, Tpfilt = Tpfilt, Tqfilt = Tqfilt, Tufilt = Tufilt, U0Pu = U0Pu, UPhase0 = UPhase0, dfMax = dfMax, dfMin = dfMin, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {91, -62}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

equation

  connect(pWPRefPu, iECWP4ALinearCommunicationWPRef.pWPRefPu) annotation(
    Line(points = {{-180, 40}, {-152, 40}, {-152, 10}, {-150, 10}}, color = {0, 0, 127}));
  connect(xWPRefPu, iECWP4ALinearCommunicationWPRef.xWPRefPu) annotation(
    Line(points = {{-180, -40}, {-152, -40}, {-152, -10}, {-150, -10}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPRef.pWPRefComPu, iECWP4APControl.pWPRefComPu) annotation(
    Line(points = {{-96, 10}, {-90, 10}, {-90, 76}, {-32, 76}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPRef.xWPRefComPu, iECWP4AQControl.xWPRefComPu) annotation(
    Line(points = {{-96, -10}, {-80, -10}, {-80, 16}, {-34, 16}, {-34, 16}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPM.pWPfiltComPu, iECWP4APControl.pWPfiltComPu) annotation(
    Line(points = {{-38, -44}, {-70, -44}, {-70, 66}, {-32, 66}, {-32, 66}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPM.pWPfiltComPu, iECWP4AQControl.pWPfiltComPu) annotation(
    Line(points = {{-38, -44}, {-70, -44}, {-70, 6}, {-34, 6}, {-34, 6}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPM.qWPfiltComPu, iECWP4AQControl.qWPfiltComPu) annotation(
    Line(points = {{-38, -54}, {-60, -54}, {-60, -4}, {-34, -4}, {-34, -6}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationWPM.omegaRefFiltComPu, iECWP4APControl.omegaRefPu) annotation(
    Line(points = {{-38, -74}, {-42, -74}, {-42, 54}, {-32, 54}}, color = {0, 0, 127}));
  connect(iECWP4AQControl.Fwpfrt, iECWP4APControl.Fwpfrt) annotation(
    Line(points = {{32, 6}, {40, 6}, {40, 30}, {-34, 30}, {-34, 42}, {-32, 42}}, color = {255, 0, 255}));
  connect(iECWP4ALinearCommunicationWPM.uWPfiltComPu, iECWP4AQControl.uWPfiltComPu) annotation(
    Line(points = {{-38, -64}, {-50, -64}, {-50, -16}, {-34, -16}, {-34, -16}}, color = {0, 0, 127}));
  connect(iECWP4AQControl.xPDRef, iECWP4ALinearCommunicationPD.xPDRefPu) annotation(
    Line(points = {{32, -6}, {58, -6}, {58, 36}, {58, 36}}, color = {0, 0, 127}));
  connect(iECWP4APControl.pPDRefPu, iECWP4ALinearCommunicationPD.pPDRefPu) annotation(
    Line(points = {{30, 60}, {60, 60}, {60, 60}, {58, 60}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationPD.pPDRefComPu, pPDRefComPu) annotation(
    Line(points = {{124, 60}, {140, 60}, {140, 70}, {180, 70}, {180, 70}}, color = {0, 0, 127}));
  connect(iECWP4ALinearCommunicationPD.xPDRefComPu, xPDRefComPu) annotation(
    Line(points = {{124, 36}, {140, 36}, {140, 30}, {180, 30}, {180, 30}}, color = {0, 0, 127}));
  connect(omegaRefPu, iECWT4AMeasures.omegaRefPu) annotation(
    Line(points = {{180, 0}, {128, 0}, {128, -46}, {113, -46}}, color = {0, 0, 127}));
  connect(uWTImPu, iECWT4AMeasures.uWtImPu) annotation(
    Line(points = {{180, -30}, {140, -30}, {140, -54}, {113, -54}}, color = {0, 0, 127}));
  connect(uWTRePu, iECWT4AMeasures.uWtRePu) annotation(
    Line(points = {{180, -60}, {146.5, -60}, {146.5, -62}, {113, -62}}, color = {0, 0, 127}));
  connect(iWTImPu, iECWT4AMeasures.iWtImPu) annotation(
    Line(points = {{180, -90}, {140, -90}, {140, -70}, {113, -70}}, color = {0, 0, 127}));
  connect(iWTRePu, iECWT4AMeasures.iWtRePu) annotation(
    Line(points = {{150, -120}, {150, -98}, {130, -98}, {130, -78}, {113, -78}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.qWTCfiltPu, iECWP4ALinearCommunicationWPM.qWPfiltPu) annotation(
    Line(points = {{69, -44}, {36, -44}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.pWTCfiltPu, iECWP4ALinearCommunicationWPM.pWPfiltPu) annotation(
    Line(points = {{69, -50}, {60, -50}, {60, -54}, {36, -54}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.omegaRefFiltPu, iECWP4ALinearCommunicationWPM.omegaRefFiltPu) annotation(
    Line(points = {{69, -62}, {53, -62}, {53, -64}, {36, -64}}, color = {0, 0, 127}));
  connect(iECWT4AMeasures.uWTCfiltPu, iECWP4ALinearCommunicationWPM.uWPfiltfPu) annotation(
    Line(points = {{69, -68}, {60, -68}, {60, -74}, {36, -74}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-160, -100}, {160, 100}})),
    Icon(coordinateSystem(extent = {{-160, -100}, {160, 100}}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-160, 100}, {160, -100}}), Text(origin = {-89, 132}, extent = {{-47, 34}, {227, -172}}, textString = "WP control and"), Text(origin = {-89, 70}, extent = {{-47, 34}, {227, -172}}, textString = "communication"), Text(origin = {-25, -70}, extent = {{-47, 34}, {99, -8}}, textString = "module")}));

end IECWP4AControlModel;
