within Dynawo.Examples.TwoConverters;

model Test_GFL_variable_infinitebus
  extends Icons.Example;
    Real E (start=0); // Energie dans la batterie en pu
Real qPcc(start = 0);
Real uPcc(start = 1);
Real uFilter(start = 1);
Real uConv(start = 1);
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFL GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 1.9, Kid = 50, Kiq = 10, Kp = 2, Kpc = 0.2, Kpd = 0.11, Kpq = 0.11, LFilterPu = 0.15, LTransformerPu = 0.06, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 0, Q0Pu = -0.21, RFilterPu = 0.015, RTransformerPu = 0.0000002, SNom = 80, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 0.01, tQFilt = 0.01, tVSC = 0.0004) annotation(
    Placement(visible = true, transformation(origin = {28, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Types.VoltageModulePu U1Pu;
  Dynawo.Types.Angle UPhase1;
  //Dynawo.Types.VoltageModulePu U2Pu;
  //Dynawo.Types.Angle UPhase2;
  Dynawo.Electrical.Buses.InfiniteBusFromTable infiniteBusFromTable(OmegaRef0Pu = 1, OmegaRefPuTableName = "tab3", TableFile = "put here the path to the file PMU_data.txt", U0Pu = 1, UPhase0 = 0, UPhaseTableName = "tab2", UPuTableName = "tab1") annotation(
    Placement(visible = true, transformation(origin = {94, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynLine dynLine(LPu =  0.1875 + 0 *0.06, P01Pu = 0, P02Pu = 0, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.01875 / 3 + 0 * 0.006, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {60, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step stepP(height = 0, offset = 0, startTime = 1000) annotation(
    Placement(visible = true, transformation(origin = {-64, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = 1)  annotation(
    Placement(visible = true, transformation(origin = {-18, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 5, k = -1 / 0.004 * 0)  annotation(
    Placement(visible = true, transformation(origin = {-50, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {-114, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-80, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k1 = 1 / 0.05, k2 = 0) annotation(
    Placement(visible = true, transformation(origin = {-68, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = 2, k = -1 * 0) annotation(
    Placement(visible = true, transformation(origin = {-38, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// No switch-off of the dynLines
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;
//dynLine1.switchOffSignal1.value = false;
//dynLine1.switchOffSignal2.value = false;
//  dynLine2.switchOffSignal1.value = false;
//  dynLine2.switchOffSignal2.value = false;
// No modifications in GFL set points
// der(GFL1.PFilterRefPu) = 0;
  connect(add.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{-7, 52}, {7.5, 52}, {7.5, 16}, {18, 16}}, color = {0, 0, 127}));
    //connect(step.y, GFL1.QFilterRefPu);
// der(GFL1.QFilterRefPu) = 0;
  der(GFL1.omegaRefPu) = 0;
//  der(GFL2.PFilterRefPu) = 0;
//  der(GFL2.QFilterRefPu) = 0;
//  der(GFL2.omegaRefPu) = 0;
// OmegaRef = 1
  dynLine.omegaPu.value = 1;
// dynLine1.omegaPu.value = 1;
  //dynLine2.omegaPu.value = 1;
  U1Pu = Modelica.ComplexMath.'abs'(GFL1.terminal.V);
//U2Pu = Modelica.ComplexMath.'abs'(GFL2.terminal.V);
  UPhase1 = Modelica.ComplexMath.arg(GFL1.terminal.V);
//UPhase2 = Modelica.ComplexMath.arg(GFL2.terminal.V);
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{39, 8}, {39, 3}, {49, 3}, {49, 6}}, color = {0, 0, 255}));
  connect(dynLine.terminal2, infiniteBusFromTable.terminal) annotation(
    Line(points = {{70, 6}, {94, 6}, {94, -14}}, color = {0, 0, 255}));
  connect(add.u1, firstOrder.y) annotation(
    Line(points = {{-30, 58}, {-39, 58}}, color = {0, 0, 127}));
  connect(firstOrder.u, add1.y) annotation(
    Line(points = {{-62, 58}, {-63, 58}, {-63, 56}, {-68, 56}}, color = {0, 0, 127}));
  connect(add1.u2, const.y) annotation(
    Line(points = {{-92, 50}, {-98, 50}, {-98, 38}, {-102, 38}}, color = {0, 0, 127}));
    add1.u1=GFL1.Control.PLL.omegaPLLPu;
    //add2.u2=GFL1.Measurements.QFilterPu;
    add2.u2=GFL1.Measurements.uqPccPu * GFL1.Measurements.idPccPu - GFL1.Measurements.udPccPu * GFL1.Measurements.iqPccPu;
    add2.u1=sqrt(GFL1.Converter.udPccPu^2+GFL1.Converter.uqPccPu^2)-1.05;
      qPcc = GFL1.Measurements.uqPccPu * GFL1.Measurements.idPccPu - GFL1.Measurements.udPccPu * GFL1.Measurements.iqPccPu;
      uPcc = sqrt(GFL1.Converter.udPccPu^2+GFL1.Converter.uqPccPu^2);
      uFilter = sqrt(GFL1.Converter.udFilterPu^2+GFL1.Converter.uqFilterPu^2);
      uConv = sqrt(GFL1.Converter.VSC.udConvPu^2+GFL1.Converter.VSC.uqConvPu^2);
    der(E)= (GFL1.Control.PFilterPu-stepP.y)/7200;
  connect(add2.y, firstOrder1.u) annotation(
    Line(points = {{-57, -30}, {-51, -30}}, color = {0, 0, 127}));
  connect(add.y, GFL1.PFilterRefPu) annotation(
    Line(points = {{6, 4}, {8, 4}, {8, 16}, {18, 16}}, color = {0, 0, 127}));
  connect(GFL1.QFilterRefPu, firstOrder1.y) annotation(
    Line(points = {{18, 4}, {15.5, 4}, {15.5, -30}, {-27, -30}}, color = {0, 0, 127}));
  connect(add.u2, stepP.y) annotation(
    Line(points = {{-30, 46}, {-40, 46}, {-40, 24}, {-52, 24}}, color = {0, 0, 127}));
annotation(
    experiment(StartTime = 0, StopTime = 900, Tolerance = 1e-6, Interval = 0.01),
    Diagram(graphics = {Text(origin = {95, -30}, extent = {{-33, 34}, {33, -34}}, textString = "To use this, you need
to open the infinite bus
and update the path to
the data_PMU.txt file"), Text(origin = {-36, -57}, extent = {{-42, 25}, {42, -25}}, textString = "To activate voltage control
open the first order block above
replace * 0 by * 1"), Text(origin = {-46, 89}, extent = {{-42, 25}, {42, -25}}, textString = "To activate frequency control
open the first order block below
replace * 0 by * 1")}));
end Test_GFL_variable_infinitebus;
