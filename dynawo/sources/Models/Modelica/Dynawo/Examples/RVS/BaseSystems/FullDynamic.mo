within Dynawo.Examples.RVS.BaseSystems;

model FullDynamic
  import Modelica.SIunits.Conversions.from_deg;
  import Dynawo;
  import Dynawo.Electrical.SystemBase.SnRef;
  
  extends NetworkWithTrfRestorative;

  final parameter Types.VoltageModule UNom_upper = 230;
  final parameter Types.VoltageModule UNom_lower = 138 "Nominal Voltage of the lower part of the network in kV";
  final parameter Types.VoltageModule UNom_gen = 18 "Nominal Voltage of the generator busses in kV";
  final parameter Types.VoltageModule URef0_bus_101 = 1.0342 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_102 = 1.0358 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_106 = 1.0025 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_107 = 1.0286 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_110 = 1.0088 * UNom_lower;
  final parameter Types.VoltageModule URef0_bus_113 = 1.02 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_115 = 1.0113 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_116 = 1.0164 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_118 = 1.0432 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_122 = 1.05 * UNom_upper;
  final parameter Types.VoltageModule URef0_bus_123 = 1.0499 * UNom_upper;

// SVarCs and shunts
  final parameter Types.ActivePowerPu P0Pu_sVarC_10106_ALBER_SVC = 2.7755575615628914e-17;
  final parameter Types.ReactivePowerPu Q0Pu_sVarC_10106_ALBER_SVC = -0.6166248646621484;
  final parameter Types.VoltageModulePu U0Pu_sVarC_10106_ALBER_SVC = 1.0501387458426712;
  final parameter Types.Angle UPhase0_sVarC_10106_ALBER_SVC = -0.4170848001910952;
  final parameter Types.ComplexApparentPowerPu s0Pu_sVarC_10106_ALBER_SVC = Complex(P0Pu_sVarC_10106_ALBER_SVC, Q0Pu_sVarC_10106_ALBER_SVC);
  final parameter Types.ComplexVoltagePu u0Pu_sVarC_10106_ALBER_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10106_ALBER_SVC, UPhase0_sVarC_10106_ALBER_SVC);
  final parameter Types.ComplexCurrentPu i0Pu_sVarC_10106_ALBER_SVC = ComplexMath.conj(s0Pu_sVarC_10106_ALBER_SVC / u0Pu_sVarC_10106_ALBER_SVC);
  final parameter Types.PerUnit B0Pu_sVarC_10106_ALBER_SVC = Q0Pu_sVarC_10106_ALBER_SVC / U0Pu_sVarC_10106_ALBER_SVC ^ 2;
  final parameter Types.ActivePowerPu P0Pu_sVarC_10114_ARNOLD_SVC = 3.608224830031759e-16;
  final parameter Types.ReactivePowerPu Q0Pu_sVarC_10114_ARNOLD_SVC = -1.2553257648648188;
  final parameter Types.VoltageModulePu U0Pu_sVarC_10114_ARNOLD_SVC = 1.0502357643893847;
  final parameter Types.Angle UPhase0_sVarC_10114_ARNOLD_SVC = -0.17178747808431338;
  final parameter Types.ComplexApparentPowerPu s0Pu_sVarC_10114_ARNOLD_SVC = Complex(P0Pu_sVarC_10114_ARNOLD_SVC, Q0Pu_sVarC_10114_ARNOLD_SVC);
  final parameter Types.ComplexVoltagePu u0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.fromPolar(U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0_sVarC_10114_ARNOLD_SVC);
  final parameter Types.ComplexCurrentPu i0Pu_sVarC_10114_ARNOLD_SVC = ComplexMath.conj(s0Pu_sVarC_10114_ARNOLD_SVC / u0Pu_sVarC_10114_ARNOLD_SVC);
  final parameter Types.PerUnit B0Pu_sVarC_10114_ARNOLD_SVC = Q0Pu_sVarC_10114_ARNOLD_SVC / U0Pu_sVarC_10114_ARNOLD_SVC ^ 2;

// Generators
  final parameter Types.ActivePowerPu P0Pu_gen_10101_ABEL_G1 = -0.10000170902518633;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10101_ABEL_G1 = -0.07463738673753835;
  final parameter Types.VoltageModulePu U0Pu_gen_10101_ABEL_G1 = 1.029661911627507;
  final parameter Types.Angle UPhase0_gen_10101_ABEL_G1 = -0.26529436852615723;
  final parameter Types.ActivePowerPu P0Pu_gen_10102_ADAMS_G1 = -0.10000267882748673;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10102_ADAMS_G1 = -0.10288237170296508;
  final parameter Types.VoltageModulePu U0Pu_gen_10102_ADAMS_G1 = 1.0473447961894775;
  final parameter Types.Angle UPhase0_gen_10102_ADAMS_G1 = -0.26873999610458754;
  final parameter Types.ActivePowerPu P0Pu_gen_10107_ALDER_G1 = -0.8000113946759735;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10107_ALDER_G1 = -0.510470140779808;
  final parameter Types.VoltageModulePu U0Pu_gen_10107_ALDER_G1 = 1.0392628953561647;
  final parameter Types.Angle UPhase0_gen_10107_ALDER_G1 = -0.29100655463068587;
  final parameter Types.ActivePowerPu P0Pu_gen_10113_ARNE_G1 = -1.6252016971492638;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10113_ARNE_G1 = -0.03744148165217718;
  final parameter Types.VoltageModulePu U0Pu_gen_10113_ARNE_G1 = 0.9700623629170779;
  final parameter Types.Angle UPhase0_gen_10113_ARNE_G1 = 0.004063101705113998;
  final parameter Types.ActivePowerPu P0Pu_gen_10115_ARTHUR_G1 = -0.12004267219906452;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10115_ARTHUR_G1 = -0.06372046082810473;
  final parameter Types.VoltageModulePu U0Pu_gen_10115_ARTHUR_G1 = 1.0239354737639141;
  final parameter Types.Angle UPhase0_gen_10115_ARTHUR_G1 = 0.14579794090055784;
  final parameter Types.ActivePowerPu P0Pu_gen_10116_ASSER_G1 = -1.550375537809362;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10116_ASSER_G1 = -0.5353576734456856;
  final parameter Types.VoltageModulePu U0Pu_gen_10116_ASSER_G1 = 1.005915169618327;
  final parameter Types.Angle UPhase0_gen_10116_ASSER_G1 = 0.13717360859034713;
  final parameter Types.ActivePowerPu P0Pu_gen_10118_ASTOR_G1 = -4.002787708347474;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10118_ASTOR_G1 = -2.026222216165695;
  final parameter Types.VoltageModulePu U0Pu_gen_10118_ASTOR_G1 = 1.0497198655086195;
  final parameter Types.Angle UPhase0_gen_10118_ASTOR_G1 = 0.2190751304774622;
  final parameter Types.ActivePowerPu P0Pu_gen_10121_ATTLEE_G1 = -3.989963901878102;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10121_ATTLEE_G1 = -1.8506772444406197;
  final parameter Types.VoltageModulePu U0Pu_gen_10121_ATTLEE_G1 = 1.0476992558075342;
  final parameter Types.Angle UPhase0_gen_10121_ATTLEE_G1 = 0.23352360344387743;
  final parameter Types.ActivePowerPu P0Pu_gen_10122_AUBREY_G1 = -0.5002825477727121;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10122_AUBREY_G1 = -0.0361017208663168;
  final parameter Types.VoltageModulePu U0Pu_gen_10122_AUBREY_G1 = 1.0027900390974074;
  final parameter Types.Angle UPhase0_gen_10122_AUBREY_G1 = 0.35394074422814453;
  final parameter Types.ActivePowerPu P0Pu_gen_10123_AUSTEN_G1 = -1.5503546648638473;
  final parameter Types.ReactivePowerPu Q0Pu_gen_10123_AUSTEN_G1 = -0.7080594520949355;
  final parameter Types.VoltageModulePu U0Pu_gen_10123_AUSTEN_G1 = 1.0505907242179788;
  final parameter Types.Angle UPhase0_gen_10123_AUSTEN_G1 = 0.15212726031281443;
  final parameter Types.ActivePowerPu P0Pu_gen_20101_ABEL_G2 = -0.10000170902542241;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20101_ABEL_G2 = -0.07463738673737683;
  final parameter Types.VoltageModulePu U0Pu_gen_20101_ABEL_G2 = 1.0296619116274104;
  final parameter Types.Angle UPhase0_gen_20101_ABEL_G2 = -0.26529436852600385;
  final parameter Types.ActivePowerPu P0Pu_gen_20102_ADAMS_G2 = -0.10000267962586748;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20102_ADAMS_G2 = -0.10288237371103835;
  final parameter Types.VoltageModulePu U0Pu_gen_20102_ADAMS_G2 = 1.0473447973073726;
  final parameter Types.Angle UPhase0_gen_20102_ADAMS_G2 = -0.26873999570846346;
  final parameter Types.ActivePowerPu P0Pu_gen_20107_ALDER_G2 = -0.8000113999167939;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20107_ALDER_G2 = -0.510507968355422;
  final parameter Types.VoltageModulePu U0Pu_gen_20107_ALDER_G2 = 1.0392672990779772;
  final parameter Types.Angle UPhase0_gen_20107_ALDER_G2 = -0.29100706880019167;
  final parameter Types.ActivePowerPu P0Pu_gen_20113_ARNE_G2 = -1.6251446815801212;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20113_ARNE_G2 = -1.2002693692011623;
  final parameter Types.VoltageModulePu U0Pu_gen_20113_ARNE_G2 = 1.0428008207520445;
  final parameter Types.Angle UPhase0_gen_20113_ARNE_G2 = -0.005252315008873509;
  final parameter Types.ActivePowerPu P0Pu_gen_20115_ARTHUR_G2 = -0.1200426721994965;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20115_ARTHUR_G2 = -0.06372046082808214;
  final parameter Types.VoltageModulePu U0Pu_gen_20115_ARTHUR_G2 = 1.0239354737638617;
  final parameter Types.Angle UPhase0_gen_20115_ARTHUR_G2 = 0.1457979409010357;
  final parameter Types.ActivePowerPu P0Pu_gen_20122_AUBREY_G2 = -0.5002825505167889;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20122_AUBREY_G2 = -0.036101724081010006;
  final parameter Types.VoltageModulePu U0Pu_gen_20122_AUBREY_G2 = 1.0027900399182372;
  final parameter Types.Angle UPhase0_gen_20122_AUBREY_G2 = 0.3539407448756743;
  final parameter Types.ActivePowerPu P0Pu_gen_20123_AUSTEN_G2 = -1.5503546648653956;
  final parameter Types.ReactivePowerPu Q0Pu_gen_20123_AUSTEN_G2 = -0.7080594520957589;
  final parameter Types.VoltageModulePu U0Pu_gen_20123_AUSTEN_G2 = 1.0505907242180323;
  final parameter Types.Angle UPhase0_gen_20123_AUSTEN_G2 = 0.1521272603129318;
  final parameter Types.ActivePowerPu P0Pu_gen_30101_ABEL_G3 = -0.7600318306167205;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30101_ABEL_G3 = -0.2215465054000413;
  final parameter Types.VoltageModulePu U0Pu_gen_30101_ABEL_G3 = 1.0162199013393984;
  final parameter Types.Angle UPhase0_gen_30101_ABEL_G3 = -0.19846408289902295;
  final parameter Types.ActivePowerPu P0Pu_gen_30102_ADAMS_G3 = -0.7600311587688413;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30102_ADAMS_G3 = -0.18628208326536677;
  final parameter Types.VoltageModulePu U0Pu_gen_30102_ADAMS_G3 = 1.0119710228446477;
  final parameter Types.Angle UPhase0_gen_30102_ADAMS_G3 = -0.19998965954913572;
  final parameter Types.ActivePowerPu P0Pu_gen_30107_ALDER_G3 = -0.8000113991417376;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30107_ALDER_G3 = -0.5104701471856811;
  final parameter Types.VoltageModulePu U0Pu_gen_30107_ALDER_G3 = 1.03926289606088;
  final parameter Types.Angle UPhase0_gen_30107_ALDER_G3 = -0.29100655415363913;
  final parameter Types.ActivePowerPu P0Pu_gen_30113_ARNE_G3 = -1.6251446832636383;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30113_ARNE_G3 = -1.2003438841536882;
  final parameter Types.VoltageModulePu U0Pu_gen_30113_ARNE_G3 = 1.042805173762897;
  final parameter Types.Angle UPhase0_gen_30113_ARNE_G3 = -0.005252839337438169;
  final parameter Types.ActivePowerPu P0Pu_gen_30115_ARTHUR_G3 = -0.12004267219967438;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30115_ARTHUR_G3 = -0.06372046082809547;
  final parameter Types.VoltageModulePu U0Pu_gen_30115_ARTHUR_G3 = 1.0239354737638549;
  final parameter Types.Angle UPhase0_gen_30115_ARTHUR_G3 = 0.14579794090123124;
  final parameter Types.ActivePowerPu P0Pu_gen_30122_AUBREY_G3 = -0.5002825505168513;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30122_AUBREY_G3 = -0.0361017240809722;
  final parameter Types.VoltageModulePu U0Pu_gen_30122_AUBREY_G3 = 1.0027900399182232;
  final parameter Types.Angle UPhase0_gen_30122_AUBREY_G3 = 0.3539407448756949;
  final parameter Types.ActivePowerPu P0Pu_gen_30123_AUSTEN_G3 = -3.5005627646003825;
  final parameter Types.ReactivePowerPu Q0Pu_gen_30123_AUSTEN_G3 = -1.3295180033290142;
  final parameter Types.VoltageModulePu U0Pu_gen_30123_AUSTEN_G3 = 1.041424695344612;
  final parameter Types.Angle UPhase0_gen_30123_AUSTEN_G3 = 0.15307035214363016;
  final parameter Types.ActivePowerPu P0Pu_gen_40101_ABEL_G4 = -0.760031830637285;
  final parameter Types.ReactivePowerPu Q0Pu_gen_40101_ABEL_G4 = -0.22152302348057534;
  final parameter Types.VoltageModulePu U0Pu_gen_40101_ABEL_G4 = 1.0162160839853456;
  final parameter Types.Angle UPhase0_gen_40101_ABEL_G4 = -0.1984635213235154;
  final parameter Types.ActivePowerPu P0Pu_gen_40102_ADAMS_G4 = -0.7600311641567928;
  final parameter Types.ReactivePowerPu Q0Pu_gen_40102_ADAMS_G4 = -0.18628208903587293;
  final parameter Types.VoltageModulePu U0Pu_gen_40102_ADAMS_G4 = 1.0119710236960113;
  final parameter Types.Angle UPhase0_gen_40102_ADAMS_G4 = -0.1999896587599516;
  final parameter Types.ActivePowerPu P0Pu_gen_40115_ARTHUR_G4 = -0.12004267255472191;
  final parameter Types.ReactivePowerPu Q0Pu_gen_40115_ARTHUR_G4 = -0.06373003819941167;
  final parameter Types.VoltageModulePu U0Pu_gen_40115_ARTHUR_G4 = 1.0239450267416212;
  final parameter Types.Angle UPhase0_gen_40115_ARTHUR_G4 = 0.1457965169521473;
  final parameter Types.ActivePowerPu P0Pu_gen_40122_AUBREY_G4 = -0.5002825505168311;
  final parameter Types.ReactivePowerPu Q0Pu_gen_40122_AUBREY_G4 = -0.03610172408108825;
  final parameter Types.VoltageModulePu U0Pu_gen_40122_AUBREY_G4 = 1.0027900399182568;
  final parameter Types.Angle UPhase0_gen_40122_AUBREY_G4 = 0.35394074487568367;
  final parameter Types.ActivePowerPu P0Pu_gen_50115_ARTHUR_G5 = -0.12004267219903511;
  final parameter Types.ReactivePowerPu Q0Pu_gen_50115_ARTHUR_G5 = -0.06372046082775724;
  final parameter Types.VoltageModulePu U0Pu_gen_50115_ARTHUR_G5 = 1.0239354737635733;
  final parameter Types.Angle UPhase0_gen_50115_ARTHUR_G5 = 0.14579794090057563;
  final parameter Types.ActivePowerPu P0Pu_gen_50122_AUBREY_G5 = -0.5002825505168171;
  final parameter Types.ReactivePowerPu Q0Pu_gen_50122_AUBREY_G5 = -0.036101724080947056;
  final parameter Types.VoltageModulePu U0Pu_gen_50122_AUBREY_G5 = 1.0027900399182197;
  final parameter Types.Angle UPhase0_gen_50122_AUBREY_G5 = 0.35394074487568766;
  final parameter Types.ActivePowerPu P0Pu_gen_60115_ARTHUR_G6 = -1.5504009058773105;
  final parameter Types.ReactivePowerPu Q0Pu_gen_60115_ARTHUR_G6 = -0.8593452847587904;
  final parameter Types.VoltageModulePu U0Pu_gen_60115_ARTHUR_G6 = 1.0263917766320754;
  final parameter Types.Angle UPhase0_gen_60115_ARTHUR_G6 = 0.14458043651417646;
  final parameter Types.ActivePowerPu P0Pu_gen_60122_AUBREY_G6 = -0.5002825505168207;
  final parameter Types.ReactivePowerPu Q0Pu_gen_60122_AUBREY_G6 = -0.036101724080958214;
  final parameter Types.VoltageModulePu U0Pu_gen_60122_AUBREY_G6 = 1.002790039918221;
  final parameter Types.Angle UPhase0_gen_60122_AUBREY_G6 = 0.35394074487568894;
  
  Components.GeneratorWithControl.SteamEXACFrame gen_40101_ABEL_G4(P0Pu = P0Pu_gen_40101_ABEL_G4, Q0Pu = Q0Pu_gen_40101_ABEL_G4, U0Pu = U0Pu_gen_40101_ABEL_G4, UPhase0 = UPhase0_gen_40101_ABEL_G4, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40101) annotation(
    Placement(visible = true, transformation(origin = {-128, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_30101_ABEL_G3(P0Pu = P0Pu_gen_30101_ABEL_G3, Q0Pu = Q0Pu_gen_30101_ABEL_G3, U0Pu = U0Pu_gen_30101_ABEL_G3, UPhase0 = UPhase0_gen_30101_ABEL_G3, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30101) annotation(
    Placement(visible = true, transformation(origin = {-168, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10101_ABEL_G1(P0Pu = P0Pu_gen_10101_ABEL_G1, Q0Pu = Q0Pu_gen_10101_ABEL_G1, U0Pu = U0Pu_gen_10101_ABEL_G1, UPhase0 = UPhase0_gen_10101_ABEL_G1, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10101) annotation(
    Placement(visible = true, transformation(origin = {-248, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_20101_ABEL_G2(P0Pu = P0Pu_gen_20101_ABEL_G2, Q0Pu = Q0Pu_gen_20101_ABEL_G2, U0Pu = U0Pu_gen_20101_ABEL_G2, UPhase0 = UPhase0_gen_20101_ABEL_G2, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20101, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20101, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20101, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20101) annotation(
    Placement(visible = true, transformation(origin = {-208, -266}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_20102_ADAMS_G2(P0Pu = P0Pu_gen_20102_ADAMS_G2, Q0Pu = Q0Pu_gen_20102_ADAMS_G2, U0Pu = U0Pu_gen_20102_ADAMS_G2, UPhase0 = UPhase0_gen_20102_ADAMS_G2, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g20102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20102) annotation(
    Placement(visible = true, transformation(origin = {-4, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_40102_ADAMS_G4(P0Pu = P0Pu_gen_40102_ADAMS_G4, Q0Pu = Q0Pu_gen_40102_ADAMS_G4, U0Pu = U0Pu_gen_40102_ADAMS_G4, UPhase0 = UPhase0_gen_40102_ADAMS_G4, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g40102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40102) annotation(
    Placement(visible = true, transformation(origin = {76, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamEXACFrame gen_10102_ADAMS_G1(P0Pu = P0Pu_gen_10102_ADAMS_G1, Q0Pu = Q0Pu_gen_10102_ADAMS_G1, U0Pu = U0Pu_gen_10102_ADAMS_G1, UPhase0 = UPhase0_gen_10102_ADAMS_G1, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g10102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10102) annotation(
    Placement(visible = true, transformation(origin = {-44, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamEXACFrame gen_30102_ADAMS_G3(P0Pu = P0Pu_gen_30102_ADAMS_G3, Q0Pu = Q0Pu_gen_30102_ADAMS_G3, U0Pu = U0Pu_gen_30102_ADAMS_G3, UPhase0 = UPhase0_gen_30102_ADAMS_G3, exac1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersEXAC.genFramePreset.g30102, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30102, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30102, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30102) annotation(
    Placement(visible = true, transformation(origin = {36, -306}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30107_ALDER_G3(P0Pu = P0Pu_gen_30107_ALDER_G3, Q0Pu = Q0Pu_gen_30107_ALDER_G3, U0Pu = U0Pu_gen_30107_ALDER_G3, UPhase0 = UPhase0_gen_30107_ALDER_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30107) annotation(
    Placement(visible = true, transformation(origin = {296, -214}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10107_ALDER_G1(P0Pu = P0Pu_gen_10107_ALDER_G1, Q0Pu = Q0Pu_gen_10107_ALDER_G1, U0Pu = U0Pu_gen_10107_ALDER_G1, UPhase0 = UPhase0_gen_10107_ALDER_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10107) annotation(
    Placement(visible = true, transformation(origin = {296, -134}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20107_ALDER_G2(P0Pu = P0Pu_gen_20107_ALDER_G2, Q0Pu = Q0Pu_gen_20107_ALDER_G2, U0Pu = U0Pu_gen_20107_ALDER_G2, UPhase0 = UPhase0_gen_20107_ALDER_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20107, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20107, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20107, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20107) annotation(
    Placement(visible = true, transformation(origin = {296, -174}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20113_ARNE_G2(P0Pu = P0Pu_gen_20113_ARNE_G2, Q0Pu = Q0Pu_gen_20113_ARNE_G2, U0Pu = U0Pu_gen_20113_ARNE_G2, UPhase0 = UPhase0_gen_20113_ARNE_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20113) annotation(
    Placement(visible = true, transformation(origin = {186, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_30113_ARNE_G3(P0Pu = P0Pu_gen_30113_ARNE_G3, Q0Pu = Q0Pu_gen_30113_ARNE_G3, U0Pu = U0Pu_gen_30113_ARNE_G3, UPhase0 = UPhase0_gen_30113_ARNE_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30113) annotation(
    Placement(visible = true, transformation(origin = {186, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10113_ARNE_G1(P0Pu = P0Pu_gen_10113_ARNE_G1, Q0Pu = Q0Pu_gen_10113_ARNE_G1, U0Pu = U0Pu_gen_10113_ARNE_G1, UPhase0 = UPhase0_gen_10113_ARNE_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10113, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10113, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10113, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10113) annotation(
    Placement(visible = true, transformation(origin = {186, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_20123_AUSTEN_G2(P0Pu = P0Pu_gen_20123_AUSTEN_G2, Q0Pu = Q0Pu_gen_20123_AUSTEN_G2, U0Pu = U0Pu_gen_20123_AUSTEN_G2, UPhase0 = UPhase0_gen_20123_AUSTEN_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20123) annotation(
    Placement(visible = true, transformation(origin = {296, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10123_AUSTEN_G1(P0Pu = P0Pu_gen_10123_AUSTEN_G1, Q0Pu = Q0Pu_gen_10123_AUSTEN_G1, U0Pu = U0Pu_gen_10123_AUSTEN_G1, UPhase0 = UPhase0_gen_10123_AUSTEN_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10123) annotation(
    Placement(visible = true, transformation(origin = {296, 146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_30123_AUSTEN_G3(P0Pu = P0Pu_gen_30123_AUSTEN_G3, Q0Pu = Q0Pu_gen_30123_AUSTEN_G3, U0Pu = U0Pu_gen_30123_AUSTEN_G3, UPhase0 = UPhase0_gen_30123_AUSTEN_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30123, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30123, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30123, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30123) annotation(
    Placement(visible = true, transformation(origin = {296, 66}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_50115_ARTHUR_G5(P0Pu = P0Pu_gen_50115_ARTHUR_G5, Q0Pu = Q0Pu_gen_50115_ARTHUR_G5, U0Pu = U0Pu_gen_50115_ARTHUR_G5, UPhase0 = UPhase0_gen_50115_ARTHUR_G5, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g50115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g50115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g50115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g50115) annotation(
    Placement(visible = true, transformation(origin = {-264, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_60115_ARTHUR_G6(P0Pu = P0Pu_gen_60115_ARTHUR_G6, Q0Pu = Q0Pu_gen_60115_ARTHUR_G6, U0Pu = U0Pu_gen_60115_ARTHUR_G6, UPhase0 = UPhase0_gen_60115_ARTHUR_G6, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g60115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g60115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g60115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g60115) annotation(
    Placement(visible = true, transformation(origin = {-264, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10115_ARTHUR_G1(P0Pu = P0Pu_gen_10115_ARTHUR_G1, Q0Pu = Q0Pu_gen_10115_ARTHUR_G1, U0Pu = U0Pu_gen_10115_ARTHUR_G1, UPhase0 = UPhase0_gen_10115_ARTHUR_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10115) annotation(
    Placement(visible = true, transformation(origin = {-264, 292}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_40115_ARTHUR_G4(P0Pu = P0Pu_gen_40115_ARTHUR_G4, Q0Pu = Q0Pu_gen_40115_ARTHUR_G4, U0Pu = U0Pu_gen_40115_ARTHUR_G4, UPhase0 = UPhase0_gen_40115_ARTHUR_G4, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g40115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g40115) annotation(
    Placement(visible = true, transformation(origin = {-264, 172}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_30115_ARTHUR_G3(P0Pu = P0Pu_gen_30115_ARTHUR_G3, Q0Pu = Q0Pu_gen_30115_ARTHUR_G3, U0Pu = U0Pu_gen_30115_ARTHUR_G3, UPhase0 = UPhase0_gen_30115_ARTHUR_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g30115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30115) annotation(
    Placement(visible = true, transformation(origin = {-264, 212}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamSCRXFrame gen_20115_ARTHUR_G2(P0Pu = P0Pu_gen_20115_ARTHUR_G2, Q0Pu = Q0Pu_gen_20115_ARTHUR_G2, U0Pu = U0Pu_gen_20115_ARTHUR_G2, UPhase0 = UPhase0_gen_20115_ARTHUR_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20115, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g20115, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20115, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20115) annotation(
    Placement(visible = true, transformation(origin = {-264, 252}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamSCRXFrame gen_10116_ASSER_G1(P0Pu = P0Pu_gen_10116_ASSER_G1, Q0Pu = Q0Pu_gen_10116_ASSER_G1, U0Pu = U0Pu_gen_10116_ASSER_G1, UPhase0 = UPhase0_gen_10116_ASSER_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10116, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10116, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10116, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10116) annotation(
    Placement(visible = true, transformation(origin = {-146, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.SteamIEEET1Frame gen_10118_ASTOR_G1(P0Pu = P0Pu_gen_10118_ASTOR_G1, Q0Pu = Q0Pu_gen_10118_ASTOR_G1, U0Pu = U0Pu_gen_10118_ASTOR_G1, UPhase0 = UPhase0_gen_10118_ASTOR_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10118, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10118, ieeet1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEET1.genFramePreset.g10118, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10118) annotation(
    Placement(visible = true, transformation(origin = {-54, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_30122_AUBREY_G3(GovInService = true, P0Pu = P0Pu_gen_30122_AUBREY_G3, Q0Pu = Q0Pu_gen_30122_AUBREY_G3, U0Pu = U0Pu_gen_30122_AUBREY_G3, UPhase0 = UPhase0_gen_30122_AUBREY_G3, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g30122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g30122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g30122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g30122) annotation(
    Placement(visible = true, transformation(origin = {294, 308}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_10122_AUBREY_G1(GovInService = true, P0Pu = P0Pu_gen_10122_AUBREY_G1, Q0Pu = Q0Pu_gen_10122_AUBREY_G1, U0Pu = U0Pu_gen_10122_AUBREY_G1, UPhase0 = UPhase0_gen_10122_AUBREY_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g10122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g10122) annotation(
    Placement(visible = true, transformation(origin = {162, 278}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_50122_AUBREY_G5(GovInService = true, P0Pu = P0Pu_gen_50122_AUBREY_G5, Q0Pu = Q0Pu_gen_50122_AUBREY_G5, U0Pu = U0Pu_gen_50122_AUBREY_G5, UPhase0 = UPhase0_gen_50122_AUBREY_G5, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g50122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g50122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g50122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g50122) annotation(
    Placement(visible = true, transformation(origin = {294, 228}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_60122_AUBREY_G6(GovInService = true, P0Pu = P0Pu_gen_60122_AUBREY_G6, Q0Pu = Q0Pu_gen_60122_AUBREY_G6, U0Pu = U0Pu_gen_60122_AUBREY_G6, UPhase0 = UPhase0_gen_60122_AUBREY_G6, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g60122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g60122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g60122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g60122) annotation(
    Placement(visible = true, transformation(origin = {294, 188}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Components.GeneratorWithControl.HydroFrame gen_20122_AUBREY_G2(GovInService = true, P0Pu = P0Pu_gen_20122_AUBREY_G2, Q0Pu = Q0Pu_gen_20122_AUBREY_G2, U0Pu = U0Pu_gen_20122_AUBREY_G2, UPhase0 = UPhase0_gen_20122_AUBREY_G2, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g20122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g20122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g20122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g20122) annotation(
    Placement(visible = true, transformation(origin = {162, 238}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Components.GeneratorWithControl.HydroFrame gen_40122_AUBREY_G4(GovInService = true, P0Pu = P0Pu_gen_40122_AUBREY_G4, Q0Pu = Q0Pu_gen_40122_AUBREY_G4, U0Pu = U0Pu_gen_40122_AUBREY_G4, UPhase0 = UPhase0_gen_40122_AUBREY_G4, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g40122, hygovPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersHYGOV.genFramePreset.g40122, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g40122, scrxPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersSCRX.genFramePreset.g40122) annotation(
    Placement(visible = true, transformation(origin = {294, 268}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.SVarCRVS sVarC_10106_ALBER_SVC(K = 150 * 150, Q0Pu = Q0Pu_sVarC_10106_ALBER_SVC, SBase = 100, U0Pu = U0Pu_sVarC_10106_ALBER_SVC, UPhase0 = UPhase0_sVarC_10106_ALBER_SVC, URef0Pu = U0Pu_sVarC_10106_ALBER_SVC, svcPreset = Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.ParametersSVC.svcFramePreset.sVarC_10106) annotation(
    Placement(visible = true, transformation(origin = {176, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.SVarCRVS sVarC_10114_ARNOLD_SVC(K = 150 * 250, Q0Pu = Q0Pu_sVarC_10114_ARNOLD_SVC, SBase = 100, U0Pu = U0Pu_sVarC_10114_ARNOLD_SVC, UPhase0 = UPhase0_sVarC_10114_ARNOLD_SVC, URef0Pu = U0Pu_sVarC_10114_ARNOLD_SVC, svcPreset = Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.ParametersSVC.svcFramePreset.sVarC_10114) annotation(
    Placement(visible = true, transformation(origin = {16, 124}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.SteamIEEET1Frame gen_10121_ATTLEE_G1(P0Pu = P0Pu_gen_10121_ATTLEE_G1, Q0Pu = Q0Pu_gen_10121_ATTLEE_G1, U0Pu = U0Pu_gen_10121_ATTLEE_G1, UPhase0 = UPhase0_gen_10121_ATTLEE_G1, gen = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersGenerators.genFramePreset.g10121, ieeeg1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEEG1.genFramePreset.g10121, ieeet1Preset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersIEEET1.genFramePreset.g10121, oelPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersOEL.oelFramePreset.all, pss2bPreset = Dynawo.Examples.RVS.Components.GeneratorWithControl.Util.ParametersPSS2B.genFramePreset.g10121) annotation(
    Placement(visible = true, transformation(origin = {-154, 282}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10101_ABEL_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20101_ABEL_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30101_ABEL_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40101_ABEL_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10102_ADAMS_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20102_ADAMS_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30102_ADAMS_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40102_ADAMS_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10107_ALDER_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20107_ALDER_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30107_ALDER_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10113_ARNE_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20113_ARNE_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30113_ARNE_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10118_ASTOR_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10115_ARTHUR_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20115_ARTHUR_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30115_ARTHUR_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40115_ARTHUR_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal1.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal2.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.switchOffSignal3.value = false;
  gen_50115_ARTHUR_G5.generatorSynchronous.omegaRefPu.value = 1;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal1.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal2.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.switchOffSignal3.value = false;
  gen_60115_ARTHUR_G6.generatorSynchronous.omegaRefPu.value = 1;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10121_ATTLEE_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10122_AUBREY_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20122_AUBREY_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30122_AUBREY_G3.generatorSynchronous.omegaRefPu.value = 1;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal1.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal2.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.switchOffSignal3.value = false;
  gen_40122_AUBREY_G4.generatorSynchronous.omegaRefPu.value = 1;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal1.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal2.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.switchOffSignal3.value = false;
  gen_50122_AUBREY_G5.generatorSynchronous.omegaRefPu.value = 1;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal1.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal2.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.switchOffSignal3.value = false;
  gen_60122_AUBREY_G6.generatorSynchronous.omegaRefPu.value = 1;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10116_ASSER_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal1.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal2.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.switchOffSignal3.value = false;
  gen_10123_AUSTEN_G1.generatorSynchronous.omegaRefPu.value = 1;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal1.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal2.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.switchOffSignal3.value = false;
  gen_20123_AUSTEN_G2.generatorSynchronous.omegaRefPu.value = 1;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal1.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal2.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.switchOffSignal3.value = false;
  gen_30123_AUSTEN_G3.generatorSynchronous.omegaRefPu.value = 1;
  sVarC_10114_ARNOLD_SVC.sVarCVPropInterface.switchOffSignal1.value = false;
  sVarC_10114_ARNOLD_SVC.sVarCVPropInterface.switchOffSignal2.value = false;
  sVarC_10114_ARNOLD_SVC.URefPu = U0Pu_sVarC_10114_ARNOLD_SVC;
  sVarC_10106_ALBER_SVC.sVarCVPropInterface.switchOffSignal1.value = false;
  sVarC_10106_ALBER_SVC.sVarCVPropInterface.switchOffSignal2.value = false;
  sVarC_10106_ALBER_SVC.URefPu = U0Pu_sVarC_10106_ALBER_SVC;
  connect(gen_10101_ABEL_G1.terminal, bus_10101_ABEL_G1.terminal) annotation(
    Line(points = {{-248, -266}, {-248, -246}}, color = {0, 0, 255}));
  connect(gen_20101_ABEL_G2.terminal, bus_20101_ABEL_G2.terminal) annotation(
    Line(points = {{-208, -266}, {-208, -246}}, color = {0, 0, 255}));
  connect(gen_30101_ABEL_G3.terminal, bus_30101_ABEL_G3.terminal) annotation(
    Line(points = {{-168, -266}, {-168, -246}}, color = {0, 0, 255}));
  connect(gen_40101_ABEL_G4.terminal, bus_40101_ABEL_G4.terminal) annotation(
    Line(points = {{-128, -266}, {-128, -246}}, color = {0, 0, 255}));
  connect(gen_10102_ADAMS_G1.terminal, bus_10102_ADAMS_G1.terminal) annotation(
    Line(points = {{-44, -306}, {-44, -286}}, color = {0, 0, 255}));
  connect(gen_20102_ADAMS_G2.terminal, bus_20102_ADAMS_G2.terminal) annotation(
    Line(points = {{-4, -306}, {-4, -286}}, color = {0, 0, 255}));
  connect(gen_30102_ADAMS_G3.terminal, bus_30102_ADAMS_G3.terminal) annotation(
    Line(points = {{36, -306}, {36, -286}}, color = {0, 0, 255}));
  connect(gen_40102_ADAMS_G4.terminal, bus_40102_ADAMS_G4.terminal) annotation(
    Line(points = {{76, -306}, {76, -286}}, color = {0, 0, 255}));
  connect(gen_10107_ALDER_G1.terminal, bus_10107_ALDER_G1.terminal) annotation(
    Line(points = {{296, -134}, {276, -134}}, color = {0, 0, 255}));
  connect(gen_20107_ALDER_G2.terminal, bus_20107_ALDER_G2.terminal) annotation(
    Line(points = {{296, -174}, {276, -174}}, color = {0, 0, 255}));
  connect(gen_30107_ALDER_G3.terminal, bus_30107_ALDER_G3.terminal) annotation(
    Line(points = {{296, -214}, {276, -214}}, color = {0, 0, 255}));
  connect(gen_10113_ARNE_G1.terminal, bus_10113_ARNE_G1.terminal) annotation(
    Line(points = {{186, 46}, {166, 46}}, color = {0, 0, 255}));
  connect(gen_20113_ARNE_G2.terminal, bus_20113_ARNE_G2.terminal) annotation(
    Line(points = {{186, 6}, {166, 6}}, color = {0, 0, 255}));
  connect(gen_30113_ARNE_G3.terminal, bus_30113_ARNE_G3.terminal) annotation(
    Line(points = {{186, -34}, {166, -34}}, color = {0, 0, 255}));
  connect(gen_10123_AUSTEN_G1.terminal, bus_10123_AUSTEN_G1.terminal) annotation(
    Line(points = {{296, 146}, {266, 146}}, color = {0, 0, 255}));
  connect(gen_20123_AUSTEN_G2.terminal, bus_20123_AUSTEN_G2.terminal) annotation(
    Line(points = {{296, 106}, {266, 106}}, color = {0, 0, 255}));
  connect(gen_30123_AUSTEN_G3.terminal, bus_30123_AUSTEN_G3.terminal) annotation(
    Line(points = {{296, 66}, {266, 66}}, color = {0, 0, 255}));
  connect(gen_10115_ARTHUR_G1.terminal, bus_10115_ARTHUR_G1.terminal) annotation(
    Line(points = {{-264, 292}, {-244, 292}}, color = {0, 0, 255}));
  connect(gen_20115_ARTHUR_G2.terminal, bus_20115_ARTHUR_G2.terminal) annotation(
    Line(points = {{-264, 252}, {-244, 252}}, color = {0, 0, 255}));
  connect(gen_30115_ARTHUR_G3.terminal, bus_30115_ARTHUR_G3.terminal) annotation(
    Line(points = {{-264, 212}, {-244, 212}}, color = {0, 0, 255}));
  connect(gen_40115_ARTHUR_G4.terminal, bus_40115_ARTHUR_G4.terminal) annotation(
    Line(points = {{-264, 172}, {-244, 172}}, color = {0, 0, 255}));
  connect(gen_50115_ARTHUR_G5.terminal, bus_50115_ARTHUR_G5.terminal) annotation(
    Line(points = {{-264, 132}, {-244, 132}}, color = {0, 0, 255}));
  connect(gen_60115_ARTHUR_G6.terminal, bus_60115_ARTHUR_G6.terminal) annotation(
    Line(points = {{-264, 92}, {-244, 92}}, color = {0, 0, 255}));
  connect(gen_10116_ASSER_G1.terminal, bus_10116_ASSER_G1.terminal) annotation(
    Line(points = {{-146, 144}, {-124, 144}}, color = {0, 0, 255}));
  connect(gen_10118_ASTOR_G1.terminal, bus_10118_ASTOR_G1.terminal) annotation(
    Line(points = {{-54, 200}, {-34, 200}}, color = {0, 0, 255}));
  connect(gen_30122_AUBREY_G3.terminal, bus_30122_AUBREY_G3.terminal) annotation(
    Line(points = {{294, 308}, {266, 308}}, color = {0, 0, 255}));
  connect(gen_40122_AUBREY_G4.terminal, bus_40122_AUBREY_G4.terminal) annotation(
    Line(points = {{294, 268}, {266, 268}}, color = {0, 0, 255}));
  connect(gen_50122_AUBREY_G5.terminal, bus_50122_AUBREY_G5.terminal) annotation(
    Line(points = {{294, 228}, {266, 228}}, color = {0, 0, 255}));
  connect(gen_60122_AUBREY_G6.terminal, bus_60122_AUBREY_G6.terminal) annotation(
    Line(points = {{294, 188}, {266, 188}}, color = {0, 0, 255}));
  connect(gen_10122_AUBREY_G1.terminal, bus_10122_AUBREY_G1.terminal) annotation(
    Line(points = {{162, 278}, {186, 278}}, color = {0, 0, 255}));
  connect(gen_20122_AUBREY_G2.terminal, bus_20122_AUBREY_G2.terminal) annotation(
    Line(points = {{162, 238}, {186, 238}}, color = {0, 0, 255}));
  connect(sVarC_10114_ARNOLD_SVC.terminal, bus_10114_ARNOLD_SVC.terminal) annotation(
    Line(points = {{16, 124}, {-6, 124}}, color = {0, 0, 255}));
  connect(sVarC_10106_ALBER_SVC.terminal, bus_10106_ALBER_SVC.terminal) annotation(
    Line(points = {{176, -226}, {152, -226}}, color = {0, 0, 255}));
  connect(gen_10121_ATTLEE_G1.terminal, bus_10121_ATTLEE_G1.terminal) annotation(
    Line(points = {{-154, 282}, {-134, 282}}, color = {0, 0, 255}));

  annotation(
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-03, Interval = 0.1),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian --daeMode",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida"),
    Diagram(coordinateSystem(extent = {{-320, -340}, {320, 340}})),
    Icon(coordinateSystem(extent = {{-200, -300}, {200, 300}})));
end FullDynamic;
