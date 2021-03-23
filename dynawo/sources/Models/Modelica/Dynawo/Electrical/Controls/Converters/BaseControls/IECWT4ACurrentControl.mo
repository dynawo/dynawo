within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWT4ACurrentControl

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*Electrical Parameters*/
  parameter Types.PerUnit Rfilter "Converter filter resistance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Lfilter "Converter filter inductance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Cfilter "Converter filter capacitance in pu (base UNom, SNom)" annotation(
    Dialog(group = "group", tab = "Electrical"));

  /*CurrentControl*/
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";

  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/

  parameter Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";

  parameter Types.PerUnit IpConv0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";

  parameter Types.PerUnit UqCmd0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UpCmd0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency" annotation(
 Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, -1}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uGspPu(start = UGsp0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
 Placement(visible = true, transformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uGsqPu(start = UGsq0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
 Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu*SystemBase.SnRef / (SNom * U0Pu)) "d-axis current reference in the converter" annotation(
 Placement(visible = true, transformation(origin = {-160, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu*SystemBase.SnRef / (SNom * U0Pu)) "q-axis current reference in the converter" annotation(
 Placement(visible = true, transformation(origin = {-160, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput ipConvPu(start = IpConv0Pu) "q-axis current reference in the converter" annotation(
 Placement(visible = true, transformation(origin = {31, -161}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {100, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter" annotation(
 Placement(visible = true, transformation(origin = {100, -160}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {40, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput upCmdPu(start = UpCmd0Pu) "d-axis modulation voltage reference" annotation(
 Placement(visible = true, transformation(origin = {160, 37}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {150, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqCmdPu(start = UqCmd0Pu) "q-axis modulation voltage reference" annotation(
 Placement(visible = true, transformation(origin = {160, -35}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {150, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoop currentLoop(IdConv0Pu = IpConv0Pu, IqConv0Pu = IqConv0Pu,Kic = Kic, Kpc = Kpc, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UpCmd0Pu, UdFilter0Pu = UGsp0Pu, UqConv0Pu = UqCmd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {40, 1}, extent = {{-40, -40}, {40, 40}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-100, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-100, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = +1)  annotation(
    Placement(visible = true, transformation(origin = {-34, -35}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-34, 37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain(k = Cfilter)  annotation(
    Placement(visible = true, transformation(origin = {-69, 28}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain1(k = Cfilter) annotation(
    Placement(visible = true, transformation(origin = {-69, -26}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
  connect(currentLoop.udConvRefPu, upCmdPu) annotation(
    Line(points = {{84, 37}, {160, 37}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, uqCmdPu) annotation(
    Line(points = {{84, -35}, {160, -35}}, color = {0, 0, 127}));
  connect(omegaPu, product1.u1) annotation(
    Line(points = {{-160, 0}, {-120, 0}, {-120, -20}, {-112, -20}}, color = {0, 0, 127}));
  connect(omegaPu, product.u2) annotation(
    Line(points = {{-160, 0}, {-120, 0}, {-120, 22}, {-112, 22}}, color = {0, 0, 127}));
  connect(omegaPu, currentLoop.omegaPu) annotation(
    Line(points = {{-160, 0}, {-4, 0}, {-4, 1}, {-4, 1}}, color = {0, 0, 127}));
  connect(add1.y, currentLoop.idConvRefPu) annotation(
    Line(points = {{-23, 37}, {-4, 37}}, color = {0, 0, 127}));
  connect(add.y, currentLoop.iqConvRefPu) annotation(
    Line(points = {{-23, -35}, {-4, -35}}, color = {0, 0, 127}));
  connect(gain.y, add1.u2) annotation(
    Line(points = {{-60, 28}, {-56, 28}, {-56, 31}, {-46, 31}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{-89, 28}, {-79, 28}}, color = {0, 0, 127}));
  connect(product1.y, gain1.u) annotation(
    Line(points = {{-89, -26}, {-79, -26}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{-60, -26}, {-58, -26}, {-58, -29}, {-46, -29}}, color = {0, 0, 127}));
  connect(uGsqPu, product.u1) annotation(
    Line(points = {{-160, 60}, {-120, 60}, {-120, 34}, {-112, 34}, {-112, 34}}, color = {0, 0, 127}));
  connect(uGsqPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{-160, 60}, {-15, 60}, {-15, -70}, {24, -70}, {24, -43}, {24, -43}}, color = {0, 0, 127}));
  connect(uGspPu, product1.u2) annotation(
    Line(points = {{-160, -60}, {-120, -60}, {-120, -32}, {-112, -32}, {-112, -32}}, color = {0, 0, 127}));
  connect(uGspPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-160, -60}, {8, -60}, {8, -43}, {8, -43}}, color = {0, 0, 127}));
  connect(iqCmdPu, add.u2) annotation(
    Line(points = {{-160, -120}, {-50, -120}, {-50, -41}, {-46, -41}, {-46, -41}}, color = {0, 0, 127}));
  connect(ipCmdPu, add1.u1) annotation(
    Line(points = {{-160, 120}, {-50, 120}, {-50, 43}, {-46, 43}, {-46, 43}}, color = {0, 0, 127}));
 connect(ipConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{31, -161}, {30, -161}, {30, -90}, {56, -90}, {56, -43}, {56, -43}}, color = {0, 0, 127}));
 connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{100, -160}, {100, -160}, {100, -90}, {72, -90}, {72, -43}, {72, -43}}, color = {0, 0, 127}));
  annotation(
 Icon(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}}, initialScale = 0.1), graphics = {Rectangle(origin = {-0.5, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-139.5, 140}, {140.5, -140}}), Text(origin = {26.5, 7}, extent = {{-149.5, 138}, {97.5, -72}}, textString = "Current"),  Text(origin = {-22.5, -22}, extent = {{-53.5, 30}, {97.5, -72}}, textString = "Loop")}),
 preferredView = "diagram",
 Diagram(coordinateSystem(grid = {1, 1}, extent = {{-140, -140}, {140, 140}})));


end IECWT4ACurrentControl;
