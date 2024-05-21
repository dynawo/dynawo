within Dynawo.Examples.GridForming;

model Converter_v2

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;


 /* Filter Input Udcref */
  parameter Real TrVSC  "Time Response of the VSC";
  
  
 /* RLC Filter */
  parameter Types.PerUnit LFilter "Filter inductance in pu (base Unom, SNom)";
  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit CFilter "Filter capacitance in pu (base UNom, SNom)";
  
  
  Modelica.Blocks.Interfaces.RealInput udConvRefPu (start=udConv0RefPu) "d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-100, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu (start=uqConv0RefPu) "q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)"  annotation(
    Placement(visible = true, transformation(origin = {-100, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu (start=idConv0Pu) "d-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {106, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu (start=iqConv0Pu) "q-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idPccPu (start=idPcc0Pu) "d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-86, 28}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu (start=iqPcc0Pu) "q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-50, -16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -76}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu (start = udFilter0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {102, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu (start = uqFilter0Pu) "q-axis voltage after the RLC filter in pu (base UNom, SNom) " annotation(
    Placement(visible = true, transformation(origin = {100, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu (start=omega0Pu) "angular frequency (omega) " annotation(
    Placement(visible = true, transformation(origin = {-198, -82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Types.PerUnit udConvPu(start = udConv0Pu) "The d-axis voltage at the inverter bridge output in pu (base UNom, SNom)";
  Types.PerUnit uqConvPu(start = uqConv0Pu) "The q-axis voltage at the inverter bridge output in pu (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active Power at the RLC filter point connection in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {102, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive Power at the RLC filter point connection in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {116, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit udConv0RefPu "Start value of the d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
  parameter Types.PerUnit uqConv0RefPu "Start value of the q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom)";
  parameter Types.PerUnit idConv0Pu "Start value of the d-axis currrent at the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqConv0Pu "Start value of the q-axis currrent at the inverter bridge output  in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit idPcc0Pu "Start value of the d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqPcc0Pu "Start value of the q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit omega0Pu = SystemBase.omegaRef0Pu "Start value of the angular reference frequency (omega) ";
  parameter Types.PerUnit udConv0Pu "Start value of the d-axis voltage at the inverter bridge output in pu (base UNom, SNom) ";
  parameter Types.PerUnit uqConv0Pu "Start value of the q-axis voltage at the inverter bridge output in pu (base UNom, SNom) ";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of the Active Power at the RLC filter point connection in pu (base UNom, SNom)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of the Reactive Power at the RLC point connection in pu (base UNom, SNom) ";
  
equation

// VSC behavior 
   der(udConvPu)*TrVSC+udConvPu=udConvRefPu;
   der(uqConvPu)*TrVSC+uqConvPu=uqConvRefPu;

 /* RLC Filter equations */
    LFilter / SystemBase.omegaNom * der(idConvPu) = udConvPu - RFilter * idConvPu + omegaPu * LFilter * iqConvPu - udFilterPu;
    LFilter / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - RFilter * iqConvPu - omegaPu * LFilter * idConvPu - uqFilterPu;
    CFilter / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * CFilter * uqFilterPu - idPccPu;
    CFilter / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * CFilter * udFilterPu - iqPccPu;
 //   IConvPu = sqrt (idConvPu * idConvPu + iqConvPu * iqConvPu);
  


    /* Power Calculation in base SNom, UNom (generator convetion)*/
    PFilterPu = udFilterPu * idPccPu + uqFilterPu * iqPccPu;
    QFilterPu = uqFilterPu * idPccPu - udFilterPu * iqPccPu;

annotation(
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-220, 80}, {140, -100}})),
  Icon(graphics = {Text(origin = {62, 209}, extent = {{-39, 21}, {39, -21}}, textString = "omegaPu"), Rectangle(extent = {{-100, 180}, {100, -180}}), Text(origin = {-181, 147}, lineColor = {192, 28, 40}, extent = {{-60, 17}, {60, -17}}, textString = "udConvRef"), Text(origin = {-179, 82}, lineColor = {192, 28, 40}, extent = {{-66, 14}, {66, -14}}, textString = "uqConvRef"), Text(origin = {-157, 3}, lineColor = {28, 113, 216}, extent = {{-44, 15}, {44, -15}}, textString = "idPcc"), Text(origin = {-154, -52}, lineColor = {28, 113, 216}, extent = {{-59, 16}, {59, -16}}, textString = "iqPcc"), Text(origin = {0, 1}, extent = {{-70, 57}, {70, -57}}, textString = "VSC"), Text(origin = {163, 169}, lineColor = {152, 106, 68}, lineThickness = 0.75, extent = {{-44, 15}, {44, -15}}, textString = "idConvPu"), Text(origin = {162, 117}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-43, 15}, {43, -15}}, textString = "iqConvPu"), Text(origin = {168, 22}, lineColor = {245, 194, 17}, extent = {{-49, 16}, {49, -16}}, textString = "udFilterPu"), Text(origin = {165, -18}, lineColor = {245, 194, 17}, extent = {{-46, 16}, {46, -16}}, textString = "uqFilterPu"), Text(origin = {167, -91}, extent = {{-44, 13}, {44, -13}}, textString = "PFilterPu"), Text(origin = {167, -133}, extent = {{-44, 11}, {44, -11}}, textString = "QFilterPu")}, coordinateSystem(extent = {{-100, -180}, {100, 180}})));
end Converter_v2;