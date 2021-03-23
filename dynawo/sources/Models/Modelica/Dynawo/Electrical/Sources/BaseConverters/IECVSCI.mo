within Dynawo.Electrical.Sources.BaseConverters;

model IECVSCI

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
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

  /*Operational Parameters*/
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
    Dialog(group = "group", tab = "Operating point"));

  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (Ubase)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (Ubase, SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsRe0Pu "Starting value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)" annotation(
 Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsIm0Pu "Real component of the voltage at the converter's terminals (generator system) in pu (base UNom)"annotation(
 Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsRe0Pu "Initial value of the real component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit IGsIm0Pu "Initial value of the imaginary component of the current at the generator system module (converter) terminal in pu (Ubase, SNom) in generator convention" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.PerUnit UGsp0Pu "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UGsq0Pu "Start value of the q-axis voltage at the converter terminal (filter) in pu (base UNom)";
  parameter Types.PerUnit UpCdm0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention";
  parameter Types.PerUnit UqCmd0Pu "Start value q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention";
  parameter Types.PerUnit IGsp0Pu "Start value of the d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IGsq0Pu "Start value of the q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IpConv0Pu "Start value of the d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention";
  parameter Types.PerUnit IqConv0Pu "Start value of the q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
        Placement(visible = true, transformation(origin = {1, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in pu (base OmegaNom)" annotation(
        Placement(visible = true, transformation(origin = {0.5, -119.5}, extent = {{-20.5, -20.5}, {20.5, 20.5}}, rotation = 90), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput upCmdPu(start = UpCdm0Pu) "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqCmdPu(start = UqCmd0Pu) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uGsRePu(start = UGsRe0Pu) "Real component of the voltage at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-120, -31}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uGsImPu(start = UGsIm0Pu) "Imaginary component of the voltage at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput iGspPu(start = IGsp0Pu) "d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {121, 90}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iGsqPu(start = IGsq0Pu) "q-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {121, 18}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uGsqPu(start = UGsq0Pu) "q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {121, 50}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = { -30,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput uGspPu(start = UGsp0Pu) "d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {121, -20}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput ipConvPu(start = IpConv0Pu)  "d-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {121, -50}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis reference current at the generator system module (converter) terminal in pu (Ubase,SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {121, -90}, extent = {{-21, -21}, {21, 21}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));

equation

  /* DQ reference frame change from network reference to converter reference and pu base change */
  [uGspPu; uGsqPu] = [cos(theta), sin(theta); -sin(theta), cos(theta)] * [uGsRePu; uGsImPu];

  /* RLC Filter */
  Cfilter / SystemBase.omegaNom * der(uGspPu) = ipConvPu + omegaPu * Cfilter * uGsqPu - iGspPu;
  Cfilter / SystemBase.omegaNom * der(uGsqPu) = iqConvPu - omegaPu * Cfilter * uGspPu - iGsqPu;
  Lfilter / SystemBase.omegaNom * der(ipConvPu) = upCmdPu - Rfilter * ipConvPu + omegaPu * Lfilter * iqConvPu - uGspPu;
  Lfilter / SystemBase.omegaNom * der(iqConvPu) = uqCmdPu - Rfilter * iqConvPu - omegaPu * Lfilter * ipConvPu - uGsqPu;
/*
  0 = ipConvPu + omegaPu * Cfilter * uGsqPu - iGspPu;
  0 = iqConvPu - omegaPu * Cfilter * uGspPu - iGsqPu;
  Lfilter / SystemBase.omegaNom * der(ipConvPu) = upCmdPu - Rfilter * ipConvPu + omegaPu * Lfilter * iqConvPu - uGspPu;
  Lfilter / SystemBase.omegaNom * der(iqConvPu) = uqCmdPu - Rfilter * iqConvPu - omegaPu * Lfilter * ipConvPu - uGsqPu;
*/
annotation(
        Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-26, 23}, extent = {{-38, 51}, {92, -97}}, textString = "VSCI")}, coordinateSystem(initialScale = 0.1)),
    Diagram);

end IECVSCI;
