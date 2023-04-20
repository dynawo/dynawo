within Dynawo.Examples.RVS.Components.StaticVarCompensators;

model SVarCRVS
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Examples.RVS.Components.StaticVarCompensators;
  import svcPar = Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.ParametersSVC;
  
  parameter svcPar.svcFramePreset svcPreset; 
  parameter Types.ReactivePowerPu Q0Pu;
  parameter Types.VoltageModulePu URef0Pu;
  parameter Types.VoltageModulePu U0Pu;
  parameter Types.Angle UPhase0;
  parameter Types.PerUnit K;
  parameter Real SBase;
  parameter Boolean ControlInService = true;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start=URef0Pu) annotation(
    Placement(visible = true, transformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {120, 0}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));

  Dynawo.Electrical.StaticVarCompensators.SVarCPV_INIT sVarCPV_INIT(P0Pu = 0, Q0Pu = Q0Pu, U0Pu = U0Pu, UPhase0 = UPhase0)  annotation(
    Placement(visible = true, transformation(origin = {-70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.SVarCVPropInterface sVarCVPropInterface(
    B0Pu(fixed=false), BShuntPu = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.BShuntPu],
    u0Pu(re(fixed=false), im(fixed=false)),
    i0Pu(re(fixed=false), im(fixed=false)),
    U0Pu = U0Pu,
    UNom = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.UNom]
  ) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.StaticVarCompensators.Controls.CSSCST csscst(
    BVar0Pu(fixed=false),
    URef0Pu = URef0Pu,
    SBase = SBase,
    UovPu = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.UovPu],
    BMin = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.BMin],
    BMax = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.BMax],
    VMin = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.VMin],
    VMax = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.VMax],
    K = K,
    T1 = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.T1],
    T2 = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.T2],
    T3 = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.T3],
    T4 = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.T4],
    T5 = svcPar.svcParamValues[svcPreset, svcPar.svcParamNames.T5]
  ) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant otherSignalsConst(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {90, -76}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant BRefPuConst(k = csscst.BRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -44}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-42, 0}, extent = {{-6, 6}, {6, -6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = sVarCVPropInterface.B0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 14}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
initial algorithm
  sVarCVPropInterface.B0Pu := sVarCPV_INIT.B0Pu;
  sVarCVPropInterface.u0Pu.re := sVarCPV_INIT.u0Pu.re;
  sVarCVPropInterface.u0Pu.im := sVarCPV_INIT.u0Pu.im;
  sVarCVPropInterface.i0Pu.re := sVarCPV_INIT.i0Pu.re;
  sVarCVPropInterface.i0Pu.im := sVarCPV_INIT.i0Pu.im;
  csscst.BVar0Pu := sVarCPV_INIT.B0Pu;

equation
  switch.u2 = ControlInService;
  connect(terminal, sVarCVPropInterface.terminal) annotation(
    Line(points = {{0, 100}, {0, 0}}));
  connect(sVarCVPropInterface.UPu_out, csscst.UPu) annotation(
    Line(points = {{22, 0}, {52, 0}, {52, -64}, {24, -64}}, color = {0, 0, 127}));
  connect(otherSignalsConst.y, csscst.others) annotation(
    Line(points = {{80, -76}, {24, -76}}, color = {0, 0, 127}));
  connect(BRefPuConst.y, csscst.BRefPu) annotation(
    Line(points = {{79, -44}, {24, -44}}, color = {0, 0, 127}));
  connect(URefPu, csscst.URefPu) annotation(
    Line(points = {{120, 0}, {68, 0}, {68, -54}, {24, -54}}, color = {0, 0, 127}));
  connect(csscst.BVarPu, switch.u1) annotation(
    Line(points = {{-22, -60}, {-54, -60}, {-54, -5}, {-49, -5}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u3) annotation(
    Line(points = {{-64, 14}, {-54, 14}, {-54, 5}, {-49, 5}}, color = {0, 0, 127}));
  connect(switch.y, sVarCVPropInterface.BVarPu_in) annotation(
    Line(points = {{-36, 0}, {-24, 0}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(origin = {-20, -18}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {49.6216, 39.4941}, points = {{0, -10}, {0, 10}}, thickness = 1), Line(origin = {-0.0916367, -80.3386}, points = {{-40, 0}, {40, 0}}), Line(origin = {0, -21}, points = {{0, 81}, {0, -59}}), Line(origin = {39.2032, 49.0758}, points = {{-10, 0}, {10, 0}}, thickness = 1), Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Line(origin = {-2.83665, -2.96415}, points = {{-44, -44}, {52, 52}}, thickness = 1), Rectangle(origin = {0, 18}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}})}));
end SVarCRVS;
