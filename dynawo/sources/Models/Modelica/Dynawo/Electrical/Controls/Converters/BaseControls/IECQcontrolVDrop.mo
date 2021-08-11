within Dynawo.Electrical.Controls.Converters.BaseControls;

block IECQcontrolVDrop

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Rdrop "Resistive component of voltage drop impedance";
  parameter Types.PerUnit Xdrop "Inductive component of voltage drop impedance";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" ;
  final parameter Types.PerUnit uWTC0Pu = sqrt(u0Pu.re * u0Pu.re + u0Pu.im * u0Pu.im) "Initial value of the WT terminal voltage in p.u (Ubase)";
  final parameter Types.PerUnit uPcc0 = sqrt((uWTC0Pu + Rdrop* P0Pu * SystemBase.SnRef /(uWTC0Pu * SNom) + Xdrop* Q0Pu * SystemBase.SnRef/(uWTC0Pu * SNom))^2 + (Xdrop* P0Pu * SystemBase.SnRef /(uWTC0Pu * SNom) - Rdrop* Q0Pu * SystemBase.SnRef /(uWTC0Pu * SNom))^2) "Initial value of the WT terminal voltage in p.u (Ubase)";

  Modelica.Blocks.Interfaces.RealInput pWTCfiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered WTT active power (SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWTCfiltPu(start = -Q0Pu * SystemBase.SnRef/SNom) "Filtered WTT reactive power (SNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWTCfiltPu(start = sqrt(u0Pu.re^2 + u0Pu.im^2)) "Filtered WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, -70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput uWTCfiltDropPu(start = uPcc0) "Filtered WTT voltage droop in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {120, 4.44089e-16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation

  uWTCfiltDropPu = sqrt((uWTCfiltPu - Rdrop*pWTCfiltPu/uWTCfiltPu - Xdrop*qWTCfiltPu/uWTCfiltPu)^2 + (Xdrop*pWTCfiltPu/uWTCfiltPu - Rdrop*qWTCfiltPu/uWTCfiltPu)^2);

annotation(
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-23, 23}, extent = {{-61, 49}, {107, -91}}, textString = "Voltage Droop")}));

end IECQcontrolVDrop;
