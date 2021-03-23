within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWP4APControl

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_PControl;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /* QControl Parameters*/
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit Kwppref "Active power reference gain" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit pWPHookPu "WP hook active power" annotation(
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
  parameter Types.PerUnit dpWPRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpWPRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMax "Maximum posite ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));
  parameter Types.PerUnit dpRefMin "Minimum negative ramp rate for WP power reference" annotation(
    Dialog(group = "group", tab = "PControlWP"));

  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.BooleanInput Fwpfrt(start = true)  annotation(
    Placement(visible = true, transformation(origin = {-160, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWPRefComPu(start = -P0Pu * SystemBase.SnRef / SNom ) "WP reference active power" annotation(
    Placement(visible = true, transformation(origin = {-160, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "WP filtered frequency measurement communicated to WP (fn)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWPfiltComPu(start = -P0Pu * SystemBase.SnRef / SNom )"WP filtered frequency measurement communicated to WP (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-160, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput pPDRefPu(start = -P0Pu * SystemBase.SnRef / SNom ) "PD active power reference communicated to PD (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {160, -1.22125e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {151, -1}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-60, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {-96, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-64, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpwpp)  annotation(
    Placement(visible = true, transformation(origin = {4, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = pRefMax, uMin = pRefMin)  annotation(
    Placement(visible = true, transformation(origin = {118, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = pErrMax, uMin = pErrMin) annotation(
    Placement(visible = true, transformation(origin = {-40, -1.55431e-15}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {88, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kwppref) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = pWPHookPu)  annotation(
    Placement(visible = true, transformation(origin = {-130, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tablePwpbiasFwpfiltCom) annotation(
    Placement(visible = true, transformation(origin = {-126, -6}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter4(limitsAtInit = true, uMax = pKIWPpMax, uMin = pKIWPpMin) annotation(
    Placement(visible = true, transformation(origin = {24, -30}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kiwpp, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {0, -30}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-46, -30}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-84, -24}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {70, -90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5(k1 = -100)  annotation(
    Placement(visible = true, transformation(origin = {-30, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(limitsAtInit = true, uMax = dpRefMax, uMin = dpRefMin) annotation(
    Placement(visible = true, transformation(origin = {-24, -30}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRamp firstOrderRamp(DuMax = dpWPRefMax, DuMin = dpWPRefMin, T = 0.001, y_start = -P0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Add add6(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {38, -60}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Add add7 annotation(
    Placement(visible = true, transformation(origin = {8, -60}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
equation
  connect(limiter1.y, pPDRefPu) annotation(
    Line(points = {{129, 0}, {160, 0}}, color = {0, 0, 127}));
  connect(add1.y, feedback.u1) annotation(
    Line(points = {{-85, 0}, {-70, 0}}, color = {0, 0, 127}));
  connect(feedback.y, limiter2.u) annotation(
    Line(points = {{-57, 0}, {-47, 0}}, color = {0, 0, 127}));
  connect(add.y, add1.u1) annotation(
    Line(points = {{-49, 74}, {-44, 74}, {-44, 20}, {-114, 20}, {-114, 6}, {-108, 6}}, color = {0, 0, 127}));
  connect(limiter2.y, gain.u) annotation(
    Line(points = {{-33, 0}, {-28, 0}, {-28, 28}, {-8, 28}}, color = {0, 0, 127}));
  connect(add2.y, add3.u2) annotation(
    Line(points = {{61, 0}, {68, 0}, {68, -6}, {76, -6}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u1) annotation(
    Line(points = {{21, 60}, {68, 60}, {68, 6}, {76, 6}}, color = {0, 0, 127}));
  connect(add3.y, limiter1.u) annotation(
    Line(points = {{99, 0}, {106, 0}}, color = {0, 0, 127}));
  connect(pWPfiltComPu, feedback.u2) annotation(
    Line(points = {{-160, -40}, {-64, -40}, {-64, -6}}, color = {0, 0, 127}));
  connect(add1.y, gain1.u) annotation(
    Line(points = {{-85, 0}, {-78, 0}, {-78, 14}, {-34, 14}, {-34, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(const.y, add.u1) annotation(
    Line(points = {{-118, 80}, {-72, 80}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], add1.u2) annotation(
    Line(points = {{-119, -6}, {-108, -6}}, color = {0, 0, 127}));
  connect(omegaRefPu, combiTable1D.u[1]) annotation(
    Line(points = {{-160, 0}, {-140, 0}, {-140, -6}, {-133, -6}}, color = {0, 0, 127}));
  connect(gain.y, add2.u1) annotation(
    Line(points = {{15, 28}, {34, 28}, {34, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(limiter4.y, add2.u2) annotation(
    Line(points = {{33, -30}, {34, -30}, {34, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(integrator.y, limiter4.u) annotation(
    Line(points = {{9, -30}, {14, -30}}, color = {0, 0, 127}));
  connect(const1.y, switch1.u1) annotation(
    Line(points = {{-77, -24}, {-56, -24}}, color = {0, 0, 127}));
  connect(Fwpfrt, switch1.u2) annotation(
    Line(points = {{-160, -80}, {-62, -80}, {-62, -30}, {-56, -30}}, color = {255, 0, 255}));
  connect(limiter1.y, add4.u2) annotation(
    Line(points = {{129, 0}, {134, 0}, {134, -96}, {82, -96}}, color = {0, 0, 127}));
  connect(add3.y, add4.u1) annotation(
    Line(points = {{100, 0}, {100, -84}, {82, -84}}, color = {0, 0, 127}));
  connect(limiter2.y, add5.u2) annotation(
    Line(points = {{-34, 0}, {-28, 0}, {-28, -14}, {-60, -14}, {-60, -92}, {0, -92}, {0, -76}, {-18, -76}}, color = {0, 0, 127}));
  connect(add5.y, switch1.u3) annotation(
    Line(points = {{-41, -70}, {-58, -70}, {-58, -36}, {-56, -36}}, color = {0, 0, 127}));
  connect(limiter3.y, integrator.u) annotation(
    Line(points = {{-15, -30}, {-10, -30}}, color = {0, 0, 127}));
  connect(switch1.y, limiter3.u) annotation(
    Line(points = {{-37, -30}, {-34, -30}}, color = {0, 0, 127}));
  connect(pWPRefComPu, firstOrderRamp.y) annotation(
    Line(points = {{-160, 40}, {-100, 40}, {-100, 40}, {-98, 40}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, add.u2) annotation(
    Line(points = {{-98, 40}, {-90, 40}, {-90, 68}, {-72, 68}, {-72, 68}}, color = {0, 0, 127}));
  connect(limiter4.y, add6.u2) annotation(
    Line(points = {{32, -30}, {70, -30}, {70, -65}, {48, -65}}, color = {0, 0, 127}));
  connect(integrator.y, add6.u1) annotation(
    Line(points = {{8, -30}, {12, -30}, {12, -46}, {60, -46}, {60, -56}, {48, -56}, {48, -55}}, color = {0, 0, 127}));
  connect(add6.y, add7.u1) annotation(
    Line(points = {{30, -60}, {26, -60}, {26, -54}, {18, -54}, {18, -56}}, color = {0, 0, 127}));
  connect(add4.y, add7.u2) annotation(
    Line(points = {{60, -90}, {26, -90}, {26, -64}, {18, -64}, {18, -64}}, color = {0, 0, 127}));
  connect(add7.y, add5.u1) annotation(
    Line(points = {{0, -60}, {-8, -60}, {-8, -64}, {-18, -64}, {-18, -64}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(extent = {{-140, -100}, {140, 100}}, initialScale = 0.1), graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-141, 101}, {139, -99}}), Text(origin = {44, 24}, extent = {{-86, 52}, {-2, 6}}, textString = "WP"), Text(origin = {-10, 0}, extent = {{-94, 60}, {116, -54}}, textString = "P Control"), Text(origin = {22, -92}, extent = {{-94, 60}, {48, 12}}, textString = "module")}));

end IECWP4APControl;
