within Dynawo.Examples.RVS.BaseSystems;

model Loadflow
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.Controls.Basics.SetPoint;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.SystemBase.SnRef;
  import Dynawo.Electrical.Machines.OmegaRef.GeneratorPQ;
  import Dynawo.Electrical.Machines.SignalN.GeneratorPQProp;
  import Dynawo.Electrical.Transformers.TransformerFixedRatio;
  import Dynawo.Electrical.StaticVarCompensators.SVarCPVRemote;
  extends NetworkWithPQLoads;
  final parameter Types.VoltageModule UNom_upper = 230 "Nominal Voltage of the upper part of the network in kV";
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";
  final parameter Types.VoltageModule UNom_gen = 18 "Nominal Voltage of the generator busses in kV";
  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_102 = 1.0358 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_107 = 1.0286 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_113 = 1.02 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_115 = 1.0113 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_116 = 1.0164 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_118 = 1.0432 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_121 = 1.0468 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_122 = 1.05 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_123 = 1.0499 * UNom_upper;
  final parameter Types.VoltageModulePu URef0Pu_sVarC_10106 = 1.025;
  final parameter Types.VoltageModulePu URef0Pu_sVarC_10114 = 1.0033;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10101 = 7.3689 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20101 = 10 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20101 = 7.3689 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30101 = 76 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30101 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_40101 = 76 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40101 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10102 = 10 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10102 = 09.5355 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20102 = 10 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20102 = 09.5355 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30102 = 76 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30102 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_40102 = 76 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40102 = 21.7756 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10107 = 80 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10107 = 49.1462 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20107 = 80 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20107 = 49.1462 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30107 = 80 / SnRef; 
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30107 = 49.1462 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10113 = 162.5 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10113 = 82.7791 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20113 = 162.5 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20113 = 80 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30113 = 162.5 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30113 = 80 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10115 = 12 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10115 = 6 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20115 = 12 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20115 = 6 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30115 = 12 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30115 = 6 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_40115 = 12 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40115 = 6 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_50115 = 12 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_50115 = 6 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_60115 = 155 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_60115 = 80 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10116 = 155 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10116 = 65.9791 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10118 = 400 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10118 = 200 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10121 = 400 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10121 = 200 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_40122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_40122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_50122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_50122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_60122 = 50 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_60122 = 3.7514 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_10123 = 155 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_10123 = 68.8361 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_20123 = 155 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_20123 = 68.8361 / SnRef;
  final parameter Types.ActivePowerPu PRef0Pu_gen_30123 = 350 / SnRef;
  final parameter Types.ReactivePowerPu QRef0Pu_gen_30123 = 128.9053 / SnRef;
  SetPoint N(Value0 = 0);
  SetPoint URefPu_sVarC_10106(Value0 = URef0Pu_sVarC_10106);
  SetPoint URefPu_sVarC_10114(Value0 = URef0Pu_sVarC_10114);
  GeneratorPQProp gen_10101_ABEL_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10101, QMaxPu = 0.1, QMinPu = 0, QPercent=0.126, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_20101_ABEL_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20101, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20101, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.126, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-210, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_30101_ABEL_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-170, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_40101_ABEL_G4( KGover = 0, PGen0Pu = PRef0Pu_gen_40101, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40101, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.374, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-130, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_10102_ADAMS_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_10102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-40, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_20102_ADAMS_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20102, PMaxPu = 999, PMinPu = 0, PNom = 20, PRef0Pu = -PRef0Pu_gen_20102, QMaxPu = 0.1, QMinPu = 0, QPercent = 0.178, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {0, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_30102_ADAMS_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_30102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {40, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_40102_ADAMS_G4( KGover = 0, PGen0Pu = PRef0Pu_gen_40102, PMaxPu = 999, PMinPu = 0, PNom = 76, PRef0Pu = -PRef0Pu_gen_40102, QMaxPu = 0.3, QMinPu = -0.25, QPercent = 0.322, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {80, -270}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  GeneratorPQProp gen_10107_ALDER_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_10107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_20107_ALDER_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_20107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, -150}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_30107_ALDER_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30107, PMaxPu = 999, PMinPu = 0, PNom = 100, PRef0Pu = -PRef0Pu_gen_30107, QMaxPu = 0.6, QMinPu = 0, QPercent = 0.3333333, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_10113_ARNE_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_10113, QMaxPu = 0.827791, QMinPu = 0, QPercent = 0.01492537, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {190, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_20113_ARNE_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_20113, QMaxPu = 0.8, QMinPu = 0, QPercent = 0.4925373, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {190, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_30113_ARNE_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30113, PMaxPu = 999, PMinPu = 0, PNom = 197, PRef0Pu = -PRef0Pu_gen_30113, QMaxPu = 0.8, QMinPu = 0, QPercent = 0.4925373, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {190, -70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_10115_ARTHUR_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_10115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_20115_ARTHUR_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_20115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_30115_ARTHUR_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_30115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_40115_ARTHUR_G4( KGover = 0, PGen0Pu = PRef0Pu_gen_40115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_40115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_50115_ARTHUR_G5( KGover = 0, PGen0Pu = PRef0Pu_gen_50115, PMaxPu = 999, PMinPu = 0, PNom = 12, PRef0Pu = -PRef0Pu_gen_50115, QMaxPu = 0.06, QMinPu = 0, QPercent = 0.05410822, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_60115_ARTHUR_G6( KGover = 0, PGen0Pu = PRef0Pu_gen_60115, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_60115, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.7294589, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-250, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_10116_ASSER_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10116, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_10116, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 1, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-150, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_10118_ASTOR_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10118, PMaxPu = 999, PMinPu = 0, PNom = 400, PRef0Pu = -PRef0Pu_gen_10118, QMaxPu = 2, QMinPu = -0.5, QPercent = 1, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-30, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
/*  Dynawo.Electrical.Machines.SignalN.GeneratorPQProp gen_10121_ATTLEE_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10121, PMaxPu = 999, PMinPu = 0, PNom = 400, PRef0Pu = -PRef0Pu_gen_10121, QMaxPu = 2, QMinPu = -0.5, QPercent = 1, U0Pu = 1.0468, i0Pu = Complex(1, 0), u0Pu = Complex(1.0468, from_deg(13.4))) annotation(
        Placement(visible = true, transformation(origin = {-150, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
*/  GeneratorPQProp gen_10122_AUBREY_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_10122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {110, 230}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_20122_AUBREY_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_20122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {110, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  GeneratorPQProp gen_30122_AUBREY_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_30122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {230, 260}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_40122_AUBREY_G4( KGover = 0, PGen0Pu = PRef0Pu_gen_40122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_40122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {230, 220}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_50122_AUBREY_G5( KGover = 0, PGen0Pu = PRef0Pu_gen_50122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_50122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {230, 180}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_60122_AUBREY_G6( KGover = 0, PGen0Pu = PRef0Pu_gen_60122, PMaxPu = 999, PMinPu = 0, PNom = 50, PRef0Pu = -PRef0Pu_gen_60122, QMaxPu = 0.16, QMinPu = -0.1, QPercent = 0.1666667, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {230, 140}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_10123_AUSTEN_G1( KGover = 0, PGen0Pu = PRef0Pu_gen_10123, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_10123, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.258, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_20123_AUSTEN_G2( KGover = 0, PGen0Pu = PRef0Pu_gen_20123, PMaxPu = 999, PMinPu = 0, PNom = 155, PRef0Pu = -PRef0Pu_gen_20123, QMaxPu = 0.8, QMinPu = -0.5, QPercent = 0.258, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  GeneratorPQProp gen_30123_AUSTEN_G3( KGover = 0, PGen0Pu = PRef0Pu_gen_30123, PMaxPu = 999, PMinPu = 0, PNom = 350, PRef0Pu = -PRef0Pu_gen_30123, QMaxPu = 1.5, QMinPu = -0.5, QPercent = 0.484, U0Pu = 1, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {270, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_10101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-250, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_20101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_30101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-170, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_40101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-130, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_1101_101(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1/1.0415) annotation(
    Placement(visible = true, transformation(origin = {-230, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_10102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-40, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_20102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 24, XPu = 0.15 * 100 / 24, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {0, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_30102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {40, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_40102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 89, XPu = 0.15 * 100 / 89, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {80, -230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_1102_102(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1/0.9614) annotation(
    Placement(visible = true, transformation(origin = {-70, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_103_124(BPu = 0, GPu = 0, RPu = 0.002 * 100 / 400, XPu = 0.084 * 100 / 400, rTfoPu = 1/0.9125) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_1103_103(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9359) annotation(
    Placement(visible = true, transformation(origin = {-190, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1104_104(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1/0.9333) annotation(
    Placement(visible = true, transformation(origin = {-90, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1105_105(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1/0.9298) annotation(
    Placement(visible = true, transformation(origin = {0, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_10106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 100, XPu = 0.15 * 100 / 100, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {110, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1106_106(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1/0.9625) annotation(
    Placement(visible = true, transformation(origin = {110, -230}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_20107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_30107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 118, XPu = 0.15 * 100 / 118, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1107_107(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1/0.9561) annotation(
    Placement(visible = true, transformation(origin = {190, -190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_1108_108(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9438) annotation(
    Placement(visible = true, transformation(origin = {150, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_109_111(BPu = 0, GPu = 0, RPu = 0.002 * 100 / 400, XPu = 0.084 * 100 / 400, rTfoPu = 1/0.9217) annotation(
    Placement(visible = true, transformation(origin = {-80, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_109_112(BPu = 0, GPu = 0, RPu = 0.002 * 100 / 400, XPu = 0.084 * 100 / 400, rTfoPu = 1/0.9192) annotation(
    Placement(visible = true, transformation(origin = {-30, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1109_109(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9534) annotation(
    Placement(visible = true, transformation(origin = {-90, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_110_111(BPu = 0, GPu = 0, RPu = 0.002 * 100 / 400, XPu = 0.084 * 100 / 400, rTfoPu = 1/0.9798) annotation(
    Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_110_112(BPu = 0, GPu = 0, RPu = 0.002 * 100 / 400, XPu = 0.084 * 100 / 400, rTfoPu = 1/0.9755) annotation(
    Placement(visible = true, transformation(origin = {20, -40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_1110_110(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9315) annotation(
    Placement(visible = true, transformation(origin = {50, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {150, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_20113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {150, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_30113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 232, XPu = 0.15 * 100 / 232, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {150, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1113_113(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 350, XPu = 0.15 * 100 / 350, rTfoPu = 1/0.9448) annotation(
    Placement(visible = true, transformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  TransformerFixedRatio tfo_10114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-30, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1114_114(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9313) annotation(
    Placement(visible = true, transformation(origin = {-30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_20115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_30115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_40115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 130}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_50115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 14, XPu = 0.15 * 100 / 14, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_60115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-210, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1115_115(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 400, XPu = 0.15 * 100 / 400, rTfoPu = 1/0.9324) annotation(
    Placement(visible = true, transformation(origin = {-150, 152}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-110, 122}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1116_116(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 150, XPu = 0.15 * 100 / 150, rTfoPu = 1/0.9431) annotation(
    Placement(visible = true, transformation(origin = {-110, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_10118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {10, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_1118_118(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 450, XPu = 0.15 * 100 / 450, rTfoPu = 1/0.9640) annotation(
    Placement(visible = true, transformation(origin = {50, 210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1119_119(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 250, XPu = 0.15 * 100 / 250, rTfoPu = 1/0.9414) annotation(
    Placement(visible = true, transformation(origin = {50, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_1120_120(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 200, XPu = 0.15 * 100 / 200, rTfoPu = 1/0.9611) annotation(
    Placement(visible = true, transformation(origin = {130, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10121_121(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 471, XPu = 0.15 * 100 / 471, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {-90, 250}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_10122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {150, 230}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_20122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {150, 190}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  TransformerFixedRatio tfo_30122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {190, 260}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_40122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {190, 220}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_50122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {190, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_60122_122(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 53, XPu = 0.15 * 100 / 53, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {190, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_10123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_20123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 182, XPu = 0.15 * 100 / 182, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  TransformerFixedRatio tfo_30123_123(BPu = 0, GPu = 0, RPu = 0.003 * 100 / 412, XPu = 0.15 * 100 / 412, rTfoPu = 1/1.05) annotation(
    Placement(visible = true, transformation(origin = {230, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = from_deg(13.4), UPu = 1.0468) annotation(
    Placement(visible = true, transformation(origin = {-110, 290}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPVRemote sVarC_10114_ARNOLD_SVC(B0Pu = 0.1, BMaxPu = 0.5, BMinPu = -2, BShuntPu = 0.1, U0Pu = 1, UNomRemote = 230, URef0Pu = URef0Pu_sVarC_10114, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {10, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.StaticVarCompensators.SVarCPVRemote sVarC_10106_ALBER_SVC(B0Pu = 0.1,BMaxPu = 0.5, BMinPu = -1, BShuntPu = 0.1, U0Pu = 1, UNomRemote = 138, URef0Pu = URef0Pu_sVarC_10106, i0Pu = Complex(1, 0), u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {150, -190}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_101(Gain = 1, U0 = URef0_bus_101, URef0 = URef0_bus_101, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-270, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_102(Gain = 1, U0 = URef0_bus_102, URef0 = URef0_bus_102, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-102, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_107(Gain = 1, U0 = URef0_bus_107, URef0 = URef0_bus_107, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {210, -90}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_113(Gain = 1, U0 = URef0_bus_113, URef0 = URef0_bus_113, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {130, 48}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_115(Gain = 1, U0 = URef0_bus_115, URef0 = URef0_bus_115, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-190, 270}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_116(Gain = 1, U0 = URef0_bus_116, URef0 = URef0_bus_116, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-90, 144}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_118(Gain = 1, U0 = URef0_bus_118, URef0 = URef0_bus_118, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {28, 232}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
/*  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_121(Gain = 1, U0 = URef0_bus_121, URef0 = URef0_bus_121, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-70, 270}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
*/  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_122(Gain = 1, U0 = URef0_bus_122, URef0 = URef0_bus_122, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {170, 280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Voltage.VRRemote vRRemote_bus_123(Gain = 1, U0 = URef0_bus_123, URef0 = URef0_bus_123, tIntegral = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {210, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Shunts.ShuntB shuntB(BPu = 0.75, i0Pu = Complex(1, 0), s0Pu = Complex(1, 0), u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {30, -100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Shunts.ShuntB shuntB1(BPu = 0.75, i0Pu = Complex(1, 0), s0Pu = Complex(1, 0), u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {30, -120}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-250, -230}, {-250, -210}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-210, -230}, {-210, -210}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-170, -230}, {-170, -210}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-130, -230}, {-130, -210}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{270, -190}, {250, -190}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{270, -150}, {250, -150}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{270, -110}, {250, -110}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-250, 250}, {-230, 250}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-250, 210}, {-230, 210}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-250, 170}, {-230, 170}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-250, 130}, {-230, 130}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-250, 90}, {-230, 90}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-250, 50}, {-230, 50}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-150, 122}, {-130, 122}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-30, 150}, {-10, 150}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{110, 230}, {130, 230}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{110, 190}, {130, 190}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{230, 260}, {210, 260}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{230, 220}, {210, 220}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{230, 180}, {210, 180}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{230, 140}, {210, 140}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{190, -30}, {170, -30}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{190, -70}, {170, -70}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{270, 110}, {250, 110}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{270, 70}, {250, 70}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{270, 30}, {250, 30}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal2, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-220, 250}, {-230, 250}}, color = {0, 0, 255}));
  connect(tfo_10115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 250}, {-190, 250}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal2, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-220, 210}, {-230, 210}}, color = {0, 0, 255}));
  connect(tfo_20115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 210}, {-190, 210}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 170}, {-190, 170}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_30115_115.terminal2, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-220, 170}, {-230, 170}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 130}, {-190, 130}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_40115_115.terminal2, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-220, 130}, {-230, 130}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 90}, {-190, 90}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_50115_115.terminal2, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-220, 90}, {-230, 90}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-200, 50}, {-190, 50}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_60115_115.terminal2, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-220, 50}, {-230, 50}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal1, bus_121_ATTLEE.terminal) annotation(
    Line(points = {{-80, 250}, {-70, 250}, {-70, 220}}, color = {0, 0, 255}));
  connect(tfo_10121_121.terminal2, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-100, 250}, {-110, 250}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-100, 122}, {-90, 122}, {-90, 94}}, color = {0, 0, 255}));
  connect(tfo_10116_116.terminal2, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-120, 122}, {-130, 122}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{20, 150}, {28, 150}, {28, 180}}, color = {0, 0, 255}));
  connect(tfo_10118_118.terminal2, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{0, 150}, {-10, 150}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal1, bus_116_ASSER.terminal) annotation(
    Line(points = {{-100, 82}, {-90, 82}, {-90, 94}}, color = {0, 0, 255}));
  connect(tfo_1116_116.terminal2, bus_1116_ASSER.terminal) annotation(
    Line(points = {{-120, 82}, {-130, 82}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{160, 230}, {170, 230}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_10122_122.terminal2, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{140, 230}, {130, 230}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{160, 190}, {170, 190}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_20122_122.terminal2, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{140, 190}, {130, 190}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal1, bus_103_ADLER.terminal) annotation(
    Line(points = {{-180, -90}, {-170, -90}, {-170, -70}, {-160, -70}}, color = {0, 0, 255}));
  connect(tfo_1103_103.terminal2, bus_1103_ADLER.terminal) annotation(
    Line(points = {{-200, -90}, {-210, -90}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-220, -150}, {-210, -150}, {-210, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(tfo_1101_101.terminal2, bus_1101_ABEL.terminal) annotation(
    Line(points = {{-240, -150}, {-250, -150}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal1, bus_109_ALI.terminal) annotation(
    Line(points = {{-80, -90}, {-70, -90}, {-70, -70}}, color = {0, 0, 255}));
  connect(tfo_1109_109.terminal2, bus_1109_ALI.terminal) annotation(
    Line(points = {{-100, -90}, {-110, -90}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal1, bus_104_AGRICOLA.terminal) annotation(
    Line(points = {{-80, -130}, {-70, -130}, {-70, -110}, {-60, -110}}, color = {0, 0, 255}));
  connect(tfo_1104_104.terminal2, bus_1104_AGRICOLA.terminal) annotation(
    Line(points = {{-100, -130}, {-110, -130}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal1, bus_105_AIKEN.terminal) annotation(
    Line(points = {{10, -190}, {20, -190}, {20, -170}, {10, -170}}, color = {0, 0, 255}));
  connect(tfo_1105_105.terminal2, bus_1105_AIKEN.terminal) annotation(
    Line(points = {{-10, -190}, {-20, -190}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-40, -270}, {-40, -250}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{0, -270}, {0, -250}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{40, -270}, {40, -250}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{80, -270}, {80, -250}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal2, bus_1102_ADAMS.terminal) annotation(
    Line(points = {{-80, -230}, {-90, -230}}, color = {0, 0, 255}));
  connect(tfo_1102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-60, -230}, {-50, -230}, {-50, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-250, -180}, {-250, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(tfo_10101_101.terminal2, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-250, -200}, {-250, -210}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-210, -180}, {-210, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(tfo_20101_101.terminal2, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-210, -200}, {-210, -210}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-170, -180}, {-170, -170}}, color = {0, 0, 255}));
  connect(tfo_30101_101.terminal2, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-170, -200}, {-170, -210}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal1, bus_101_ABEL.terminal) annotation(
    Line(points = {{-130, -180}, {-130, -170}, {-170, -170}}, color = {0, 0, 255}));
  connect(tfo_40101_101.terminal2, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-130, -200}, {-130, -210}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{-40, -220}, {-40, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(tfo_10102_102.terminal2, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-40, -240}, {-40, -250}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{0, -220}, {0, -210}}, color = {0, 0, 255}));
  connect(tfo_20102_102.terminal2, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{0, -240}, {0, -250}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{40, -220}, {40, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(tfo_30102_102.terminal2, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{40, -240}, {40, -250}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal1, bus_102_ADAMS.terminal) annotation(
    Line(points = {{80, -220}, {80, -210}, {0, -210}}, color = {0, 0, 255}));
  connect(tfo_40102_102.terminal2, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{80, -240}, {80, -250}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{190, -180}, {190, -170}, {210, -170}, {210, -150}}, color = {0, 0, 255}));
  connect(tfo_1107_107.terminal2, bus_1107_ALDER.terminal) annotation(
    Line(points = {{190, -200}, {190, -210}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{110, -40}, {110, -30}, {130, -30}, {130, -20}}, color = {0, 0, 255}));
  connect(tfo_1113_113.terminal2, bus_1113_ARNE.terminal) annotation(
    Line(points = {{110, -60}, {110, -70}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{180, 260}, {170, 260}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_30122_122.terminal2, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{200, 260}, {210, 260}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{180, 220}, {170, 220}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_40122_122.terminal2, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{200, 220}, {210, 220}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{180, 180}, {170, 180}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_50122_122.terminal2, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{200, 180}, {210, 180}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal1, bus_122_AUBREY.terminal) annotation(
    Line(points = {{180, 140}, {170, 140}, {170, 200}}, color = {0, 0, 255}));
  connect(tfo_60122_122.terminal2, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{200, 140}, {210, 140}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal1, bus_118_ASTOR.terminal) annotation(
    Line(points = {{40, 210}, {28, 210}, {28, 180}}, color = {0, 0, 255}));
  connect(tfo_1118_118.terminal2, bus_1118_ASTOR.terminal) annotation(
    Line(points = {{60, 210}, {70, 210}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal1, bus_115_ARTHUR.terminal) annotation(
    Line(points = {{-160, 152}, {-190, 152}, {-190, 150}}, color = {0, 0, 255}));
  connect(tfo_1115_115.terminal2, bus_1115_ARTHUR.terminal) annotation(
    Line(points = {{-140, 152}, {-130, 152}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{220, 110}, {210, 110}, {210, 70}}, color = {0, 0, 255}));
  connect(tfo_10123_123.terminal2, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{240, 110}, {250, 110}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{220, 70}, {210, 70}}, color = {0, 0, 255}));
  connect(tfo_20123_123.terminal2, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{240, 70}, {250, 70}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal1, bus_123_AUSTEN.terminal) annotation(
    Line(points = {{220, 30}, {210, 30}, {210, 70}}, color = {0, 0, 255}));
  connect(tfo_30123_123.terminal2, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{240, 30}, {250, 30}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal1, bus_120_ATTILA.terminal) annotation(
    Line(points = {{120, 70}, {110, 70}, {110, 90}}, color = {0, 0, 255}));
  connect(tfo_1120_120.terminal2, bus_1120_ATTILA.terminal) annotation(
    Line(points = {{140, 70}, {150, 70}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal1, bus_119_ATTAR.terminal) annotation(
    Line(points = {{40, 70}, {30, 70}, {30, 90}}, color = {0, 0, 255}));
  connect(tfo_1119_119.terminal2, bus_1119_ATTAR.terminal) annotation(
    Line(points = {{60, 70}, {70, 70}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-40, 50}, {-50, 50}, {-50, 70}}, color = {0, 0, 255}));
  connect(tfo_1114_114.terminal2, bus_1114_ARNOLD.terminal) annotation(
    Line(points = {{-20, 50}, {-10, 50}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal1, bus_114_ARNOLD.terminal) annotation(
    Line(points = {{-40, 90}, {-50, 90}, {-50, 70}}, color = {0, 0, 255}));
  connect(tfo_10114_114.terminal2, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{-20, 90}, {-10, 90}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal2, bus_1110_ALLEN.terminal) annotation(
    Line(points = {{60, -30}, {70, -30}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{140, 10}, {130, 10}, {130, -20}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{190, 10}, {170, 10}}, color = {0, 0, 255}));
  connect(tfo_10113_113.terminal2, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{160, 10}, {170, 10}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{140, -30}, {130, -30}, {130, -20}}, color = {0, 0, 255}));
  connect(tfo_20113_113.terminal2, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{160, -30}, {170, -30}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal1, bus_113_ARNE.terminal) annotation(
    Line(points = {{140, -70}, {130, -70}, {130, -20}}, color = {0, 0, 255}));
  connect(tfo_30113_113.terminal2, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{160, -70}, {170, -70}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal1, bus_108_ALGER.terminal) annotation(
    Line(points = {{140, -150}, {130, -150}, {130, -130}}, color = {0, 0, 255}));
  connect(tfo_1108_108.terminal2, bus_1108_ALGER.terminal) annotation(
    Line(points = {{160, -150}, {170, -150}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{220, -110}, {210, -110}, {210, -150}}, color = {0, 0, 255}));
  connect(tfo_10107_107.terminal2, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{240, -110}, {250, -110}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{220, -150}, {210, -150}}, color = {0, 0, 255}));
  connect(tfo_20107_107.terminal2, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{240, -150}, {250, -150}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal1, bus_107_ALDER.terminal) annotation(
    Line(points = {{220, -190}, {210, -190}, {210, -150}}, color = {0, 0, 255}));
  connect(tfo_30107_107.terminal2, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{240, -190}, {250, -190}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{100, -190}, {100, -170}, {80, -170}}, color = {0, 0, 255}));
  connect(tfo_10106_106.terminal2, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{120, -190}, {130, -190}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal1, bus_106_ALBER.terminal) annotation(
    Line(points = {{100, -230}, {94, -230}, {94, -170}, {80, -170}}, color = {0, 0, 255}));
  connect(tfo_1106_106.terminal2, bus_1106_ALBER.terminal) annotation(
    Line(points = {{120, -230}, {130, -230}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal2, bus_103_ADLER.terminal) annotation(
    Line(points = {{-150, -50}, {-150, -70}, {-160, -70}}, color = {0, 0, 255}));
  connect(tfo_103_124.terminal1, bus_124_AVERY.terminal) annotation(
    Line(points = {{-150, -30}, {-150, -10}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-80, -50}, {-80, -70}, {-70, -70}}, color = {0, 0, 255}));
  connect(tfo_109_111.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{-80, -30}, {-80, -10}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{20, -50}, {20, -70}, {30, -70}}, color = {0, 0, 255}));
  connect(tfo_110_112.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{20, -30}, {20, -8}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal1, bus_111_ANNA.terminal) annotation(
    Line(points = {{-40, -20}, {-62, -20}, {-62, -10}, {-80, -10}}, color = {0, 0, 255}));
  connect(tfo_110_111.terminal2, bus_110_ALLEN.terminal) annotation(
    Line(points = {{-20, -20}, {-6, -20}, {-6, -70}, {30, -70}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal1, bus_112_ARCHER.terminal) annotation(
    Line(points = {{-20, -40}, {2, -40}, {2, -8}, {20, -8}}, color = {0, 0, 255}));
  connect(tfo_109_112.terminal2, bus_109_ALI.terminal) annotation(
    Line(points = {{-40, -40}, {-44, -40}, {-44, -70}, {-70, -70}}, color = {0, 0, 255}));
  connect(tfo_1110_110.terminal1, bus_110_ALLEN.terminal) annotation(
    Line(points = {{40, -30}, {30, -30}, {30, -70}}, color = {0, 0, 255}));
  vRRemote_bus_101.URegulated = ComplexMath.'abs'(bus_101_ABEL.terminal.V) * UNom_lower;
  gen_10101_ABEL_G1.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.N = N.setPoint.value;
  gen_10101_ABEL_G1.NQ = vRRemote_bus_101.NQ;
  gen_20101_ABEL_G2.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.N = N.setPoint.value;
  gen_20101_ABEL_G2.NQ = vRRemote_bus_101.NQ;
  gen_30101_ABEL_G3.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.N = N.setPoint.value;
  gen_30101_ABEL_G3.NQ = vRRemote_bus_101.NQ;
  gen_40101_ABEL_G4.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.N = N.setPoint.value;
  gen_40101_ABEL_G4.NQ = vRRemote_bus_101.NQ;
  vRRemote_bus_102.URegulated = ComplexMath.'abs'(bus_102_ADAMS.terminal.V) * UNom_lower;
  gen_10102_ADAMS_G1.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.switchOffSignal3.value = false;
  gen_10102_ADAMS_G1.N = N.setPoint.value;
  gen_10102_ADAMS_G1.NQ = vRRemote_bus_102.NQ;
  gen_20102_ADAMS_G2.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.N = N.setPoint.value;
  gen_20102_ADAMS_G2.NQ = vRRemote_bus_102.NQ;
  gen_30102_ADAMS_G3.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.N = N.setPoint.value;
  gen_30102_ADAMS_G3.NQ = vRRemote_bus_102.NQ;
  gen_40102_ADAMS_G4.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.N = N.setPoint.value;
  gen_40102_ADAMS_G4.NQ = vRRemote_bus_102.NQ;
  vRRemote_bus_107.URegulated = ComplexMath.'abs'(bus_107_ALDER.terminal.V) * UNom_lower;
  gen_10107_ALDER_G1.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.switchOffSignal3.value = false;
  gen_10107_ALDER_G1.N = N.setPoint.value;
  gen_10107_ALDER_G1.NQ = vRRemote_bus_107.NQ;
  gen_20107_ALDER_G2.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.N = N.setPoint.value;
  gen_20107_ALDER_G2.NQ = vRRemote_bus_107.NQ;
  gen_30107_ALDER_G3.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.N = N.setPoint.value;
  gen_30107_ALDER_G3.NQ = vRRemote_bus_107.NQ;
  vRRemote_bus_113.URegulated = ComplexMath.'abs'(bus_113_ARNE.terminal.V) * UNom_upper;
  gen_10113_ARNE_G1.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.switchOffSignal3.value = false;
  gen_10113_ARNE_G1.N = N.setPoint.value;
  gen_10113_ARNE_G1.NQ = vRRemote_bus_113.NQ;
  gen_20113_ARNE_G2.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.N = N.setPoint.value;
  gen_20113_ARNE_G2.NQ = vRRemote_bus_113.NQ;
  gen_30113_ARNE_G3.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.N = N.setPoint.value;
  gen_30113_ARNE_G3.NQ = vRRemote_bus_113.NQ;
  vRRemote_bus_115.URegulated = ComplexMath.'abs'(bus_115_ARTHUR.terminal.V) * UNom_upper;
  gen_10115_ARTHUR_G1.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.switchOffSignal3.value = false;
  gen_10115_ARTHUR_G1.N = N.setPoint.value;
  gen_10115_ARTHUR_G1.NQ = vRRemote_bus_115.NQ;
  gen_20115_ARTHUR_G2.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.N = N.setPoint.value;
  gen_20115_ARTHUR_G2.NQ = vRRemote_bus_115.NQ;
  gen_30115_ARTHUR_G3.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.N = N.setPoint.value;
  gen_30115_ARTHUR_G3.NQ = vRRemote_bus_115.NQ;
  gen_40115_ARTHUR_G4.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.N = N.setPoint.value;
  gen_40115_ARTHUR_G4.NQ = vRRemote_bus_115.NQ;
  gen_50115_ARTHUR_G5.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.N = N.setPoint.value;
  gen_50115_ARTHUR_G5.NQ = vRRemote_bus_115.NQ;
  gen_60115_ARTHUR_G6.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.N = N.setPoint.value;
  gen_60115_ARTHUR_G6.NQ = vRRemote_bus_115.NQ;
  vRRemote_bus_116.URegulated = ComplexMath.'abs'(bus_116_ASSER.terminal.V) * UNom_upper;
  gen_10116_ASSER_G1.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.switchOffSignal3.value = false;
  gen_10116_ASSER_G1.N = N.setPoint.value;
  gen_10116_ASSER_G1.NQ = vRRemote_bus_116.NQ;
  vRRemote_bus_118.URegulated = ComplexMath.'abs'(bus_118_ASTOR.terminal.V) * UNom_upper;
  gen_10118_ASTOR_G1.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.switchOffSignal3.value = false;
  gen_10118_ASTOR_G1.N = N.setPoint.value;
  gen_10118_ASTOR_G1.NQ = vRRemote_bus_118.NQ;

/*  vRRemote_bus_121.URegulated = ComplexMath.'abs'(bus_121_ATTLEE.terminal.V) * UNom_upper;
  gen_10121_ATTLEE_G1.switchOffSignal1.value = false;
  gen_10121_ATTLEE_G1.switchOffSignal2.value = false;
  gen_10121_ATTLEE_G1.switchOffSignal3.value = false;
  gen_10121_ATTLEE_G1.N = N.setPoint.value;
  gen_10121_ATTLEE_G1.NQ = vRRemote_bus_121.NQ;*/
  
  vRRemote_bus_122.URegulated = ComplexMath.'abs'(bus_122_AUBREY.terminal.V) * UNom_upper;
  gen_10122_AUBREY_G1.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.switchOffSignal3.value = false;
  gen_10122_AUBREY_G1.N = N.setPoint.value;
  gen_10122_AUBREY_G1.NQ = vRRemote_bus_122.NQ;
  gen_20122_AUBREY_G2.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.N = N.setPoint.value;
  gen_20122_AUBREY_G2.NQ = vRRemote_bus_122.NQ;
  gen_30122_AUBREY_G3.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.N = N.setPoint.value;
  gen_30122_AUBREY_G3.NQ = vRRemote_bus_122.NQ;
  gen_40122_AUBREY_G4.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.N = N.setPoint.value;
  gen_40122_AUBREY_G4.NQ = vRRemote_bus_122.NQ;
  gen_50122_AUBREY_G5.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.N = N.setPoint.value;
  gen_50122_AUBREY_G5.NQ = vRRemote_bus_122.NQ;
  gen_60122_AUBREY_G6.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.N = N.setPoint.value;
  gen_60122_AUBREY_G6.NQ = vRRemote_bus_122.NQ;
  gen_10123_AUSTEN_G1.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.switchOffSignal3.value = false;
  vRRemote_bus_123.URegulated = ComplexMath.'abs'(bus_123_AUSTEN.terminal.V) * UNom_upper;
  gen_10123_AUSTEN_G1.N = N.setPoint.value;
  gen_10123_AUSTEN_G1.NQ = vRRemote_bus_123.NQ;
  gen_20123_AUSTEN_G2.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.N = N.setPoint.value;
  gen_20123_AUSTEN_G2.NQ = vRRemote_bus_123.NQ;
  gen_30123_AUSTEN_G3.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.N = N.setPoint.value;
  gen_30123_AUSTEN_G3.NQ = vRRemote_bus_123.NQ;
  sVarC_10106_ALBER_SVC.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URegulatedPu = ComplexMath.'abs'(tfo_10106_106.terminal1.V);
  sVarC_10106_ALBER_SVC.URefPu = URefPu_sVarC_10106.setPoint.value;
  sVarC_10114_ARNOLD_SVC.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URegulatedPu = ComplexMath.'abs'(tfo_10114_114.terminal1.V);
  sVarC_10114_ARNOLD_SVC.URefPu = URefPu_sVarC_10114.setPoint.value;
  tfo_1101_101.switchOffSignal1.value = false;
  tfo_1101_101.switchOffSignal2.value = false;
  tfo_10101_101.switchOffSignal1.value = false;
  tfo_10101_101.switchOffSignal2.value = false;
  tfo_20101_101.switchOffSignal1.value = false;
  tfo_20101_101.switchOffSignal2.value = false;
  tfo_30101_101.switchOffSignal1.value = false;
  tfo_30101_101.switchOffSignal2.value = false;
  tfo_40101_101.switchOffSignal1.value = false;
  tfo_40101_101.switchOffSignal2.value = false;
  tfo_1102_102.switchOffSignal1.value = false;
  tfo_1102_102.switchOffSignal2.value = false;
  tfo_10102_102.switchOffSignal1.value = false;
  tfo_10102_102.switchOffSignal2.value = false;
  tfo_20102_102.switchOffSignal1.value = false;
  tfo_20102_102.switchOffSignal2.value = false;
  tfo_30102_102.switchOffSignal1.value = false;
  tfo_30102_102.switchOffSignal2.value = false;
  tfo_40102_102.switchOffSignal1.value = false;
  tfo_40102_102.switchOffSignal2.value = false;
  tfo_1103_103.switchOffSignal1.value = false;
  tfo_1103_103.switchOffSignal2.value = false;
  tfo_103_124.switchOffSignal1.value = false;
  tfo_103_124.switchOffSignal2.value = false;
  tfo_1104_104.switchOffSignal1.value = false;
  tfo_1104_104.switchOffSignal2.value = false;
  tfo_1105_105.switchOffSignal1.value = false;
  tfo_1105_105.switchOffSignal2.value = false;
  tfo_1106_106.switchOffSignal1.value = false;
  tfo_1106_106.switchOffSignal2.value = false;
  tfo_10106_106.switchOffSignal1.value = false;
  tfo_10106_106.switchOffSignal2.value = false;
  tfo_1107_107.switchOffSignal1.value = false;
  tfo_1107_107.switchOffSignal2.value = false;
  tfo_10107_107.switchOffSignal1.value = false;
  tfo_10107_107.switchOffSignal2.value = false;
  tfo_20107_107.switchOffSignal1.value = false;
  tfo_20107_107.switchOffSignal2.value = false;
  tfo_30107_107.switchOffSignal1.value = false;
  tfo_30107_107.switchOffSignal2.value = false;
  tfo_1108_108.switchOffSignal1.value = false;
  tfo_1108_108.switchOffSignal2.value = false;
  tfo_1109_109.switchOffSignal1.value = false;
  tfo_1109_109.switchOffSignal2.value = false;
  tfo_109_111.switchOffSignal1.value = false;
  tfo_109_111.switchOffSignal2.value = false;
  tfo_109_112.switchOffSignal1.value = false;
  tfo_109_112.switchOffSignal2.value = false;
  tfo_1110_110.switchOffSignal1.value = false;
  tfo_1110_110.switchOffSignal2.value = false;
  tfo_110_111.switchOffSignal1.value = false;
  tfo_110_111.switchOffSignal2.value = false;
  tfo_110_112.switchOffSignal1.value = false;
  tfo_110_112.switchOffSignal2.value = false;
  tfo_1113_113.switchOffSignal1.value = false;
  tfo_1113_113.switchOffSignal2.value = false;
  tfo_10113_113.switchOffSignal1.value = false;
  tfo_10113_113.switchOffSignal2.value = false;
  tfo_20113_113.switchOffSignal1.value = false;
  tfo_20113_113.switchOffSignal2.value = false;
  tfo_30113_113.switchOffSignal1.value = false;
  tfo_30113_113.switchOffSignal2.value = false;
  tfo_1114_114.switchOffSignal1.value = false;
  tfo_1114_114.switchOffSignal2.value = false;
  tfo_10114_114.switchOffSignal1.value = false;
  tfo_10114_114.switchOffSignal2.value = false;
  tfo_1115_115.switchOffSignal1.value = false;
  tfo_1115_115.switchOffSignal2.value = false;
  tfo_10115_115.switchOffSignal1.value = false;
  tfo_10115_115.switchOffSignal2.value = false;
  tfo_20115_115.switchOffSignal1.value = false;
  tfo_20115_115.switchOffSignal2.value = false;
  tfo_30115_115.switchOffSignal1.value = false;
  tfo_30115_115.switchOffSignal2.value = false;
  tfo_40115_115.switchOffSignal1.value = false;
  tfo_40115_115.switchOffSignal2.value = false;
  tfo_50115_115.switchOffSignal1.value = false;
  tfo_50115_115.switchOffSignal2.value = false;
  tfo_60115_115.switchOffSignal1.value = false;
  tfo_60115_115.switchOffSignal2.value = false;
  tfo_1116_116.switchOffSignal1.value = false;
  tfo_1116_116.switchOffSignal2.value = false;
  tfo_10116_116.switchOffSignal1.value = false;
  tfo_10116_116.switchOffSignal2.value = false;
  tfo_1118_118.switchOffSignal1.value = false;
  tfo_1118_118.switchOffSignal2.value = false;
  tfo_10118_118.switchOffSignal1.value = false;
  tfo_10118_118.switchOffSignal2.value = false;
  tfo_1119_119.switchOffSignal1.value = false;
  tfo_1119_119.switchOffSignal2.value = false;
  tfo_1120_120.switchOffSignal1.value = false;
  tfo_1120_120.switchOffSignal2.value = false;
  tfo_10121_121.switchOffSignal1.value = false;
  tfo_10121_121.switchOffSignal2.value = false;
  tfo_10122_122.switchOffSignal1.value = false;
  tfo_10122_122.switchOffSignal2.value = false;
  tfo_20122_122.switchOffSignal1.value = false;
  tfo_20122_122.switchOffSignal2.value = false;
  tfo_30122_122.switchOffSignal1.value = false;
  tfo_30122_122.switchOffSignal2.value = false;
  tfo_40122_122.switchOffSignal1.value = false;
  tfo_40122_122.switchOffSignal2.value = false;
  tfo_50122_122.switchOffSignal1.value = false;
  tfo_50122_122.switchOffSignal2.value = false;
  tfo_60122_122.switchOffSignal1.value = false;
  tfo_60122_122.switchOffSignal2.value = false;
  tfo_10123_123.switchOffSignal1.value = false;
  tfo_10123_123.switchOffSignal2.value = false;
  tfo_20123_123.switchOffSignal1.value = false;
  tfo_20123_123.switchOffSignal2.value = false;
  tfo_30123_123.switchOffSignal1.value = false;
  tfo_30123_123.switchOffSignal2.value = false;
  shuntB.switchOffSignal1.value = false;
  shuntB.switchOffSignal2.value = false;
  shuntB1.switchOffSignal1.value = false;
  shuntB1.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-110, 290}, {-110, 250}}, color = {0, 0, 255}));
  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{10, 90}, {-10, 90}}, color = {0, 0, 255}));
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{150, -190}, {130, -190}}, color = {0, 0, 255}));
  connect(shuntB.terminal, line_106_110.terminal2) annotation(
    Line(points = {{30, -100}, {54, -100}}, color = {0, 0, 255}));
  connect(shuntB1.terminal, line_106_110.terminal1) annotation(
    Line(points = {{30, -120}, {54, -120}}, color = {0, 0, 255}));
  annotation(
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=nonewInst --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
  experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end Loadflow;
