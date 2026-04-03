within Dynawo.Electrical.PEIR.Plants.Average;

model GFLModel

  GFLControl control_GFL_ annotation(
    Placement(transformation(origin = {-88, 38}, extent = {{-24, -24}, {24, 24}})));
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.VSC_with_pade_delay vsc_converter_delay_pade annotation(
    Placement(transformation(origin = {3, 81}, extent = {{-17, -17}, {17, 17}})));
 LCDynFilter lCFilter_RI annotation(
    Placement(transformation(origin = {64, 76}, extent = {{-20, -20}, {20, 20}})));
  RLDynTrafo rLTRansformer_RI annotation(
    Placement(transformation(origin = {137, 75}, extent = {{-22, -22}, {22, 22}})));
  Dynawo.Connectors.ACPower terminal(V(re(start = UrPcc0Pu), im(start = UiPcc0Pu)), i(re(start = IrPcc0Pu), im(start = IiPcc0Pu))) annotation(
    Placement(transformation(origin = {184, 84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}})));
  MeasurementBlock measurement_block1 annotation(
    Placement(transformation(origin = {-87, -39}, extent = {{-29, -29}, {29, 29}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput u_ref_conv annotation(
    Placement(transformation(origin = {-118, 96}, extent = {{-12, -12}, {12, 12}}, rotation = -90), iconTransformation(origin = {-180, 24}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput U_ref_pcc_pu annotation(
    Placement(transformation(origin = {-81, 95}, extent = {{-9, -9}, {9, 9}}, rotation = -90), iconTransformation(origin = {-184, 28}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu annotation(
    Placement(transformation(origin = {-54, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 180), iconTransformation(origin = {-234, 58}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PRefu annotation(
    Placement(transformation(origin = {-98, 92}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-254, 82}, extent = {{-20, -20}, {20, 20}})));
  parameter Real UrPcc0Pu;
  parameter Real UiPcc0Pu;
  parameter Real IrPcc0Pu;
  parameter Real IiPcc0Pu;
equation
  rLTRansformer_RI.urPccPu = terminal.V.re;
  rLTRansformer_RI.uiPccPu = terminal.V.im;
  terminal.i.re = -rLTRansformer_RI.irPccPu;
  terminal.i.im = -rLTRansformer_RI.iiPccPu;
  connect(control_GFL_.vm_re, vsc_converter_delay_pade.udConvRefPu) annotation(
    Line(points = {{-62, 50}, {-38.5, 50}, {-38.5, 88}, {-16, 88}}, color = {97, 53, 131}, thickness = 0.75));
  connect(control_GFL_.vm_im, vsc_converter_delay_pade.uqConvRefPu) annotation(
    Line(points = {{-62, 40}, {-27.5, 40}, {-27.5, 78}, {-16, 78}}, color = {97, 53, 131}, thickness = 0.75));
  connect(lCFilter_RI.urConvPu, vsc_converter_delay_pade.ureConvPu) annotation(
    Line(points = {{40, 88}, {22, 88}}, color = {97, 53, 131}, pattern = LinePattern.Dash));
  connect(vsc_converter_delay_pade.uimConvPu, lCFilter_RI.uiConvPu) annotation(
    Line(points = {{22, 78}, {40, 78}}, color = {97, 53, 131}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(control_GFL_.omega_pll_pu, lCFilter_RI.omegaPu) annotation(
    Line(points = {{-62, 31}, {51.5, 31}, {51.5, 52}, {52, 52}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(u_ref_conv, control_GFL_.U_ref_pu) annotation(
    Line(points = {{-118, 96}, {-118, 78}, {-102, 78}, {-102, 64}}, color = {97, 53, 131}, thickness = 0.75));
  connect(U_ref_pcc_pu, control_GFL_.U_ref_pcc_pu) annotation(
    Line(points = {{-80, 96}, {-80, 64}}, color = {38, 162, 105}, thickness = 0.75));
  connect(omegaRefPu, control_GFL_.omegaRefPU) annotation(
    Line(points = {{-54, 90}, {-70, 90}, {-70, 64}}, color = {38, 162, 105}, thickness = 0.75));
  connect(control_GFL_.P_ref_pu, PRefu) annotation(
    Line(points = {{-92, 64}, {-98, 64}, {-98, 92}}, color = {99, 69, 44}, thickness = 0.75));
  connect(lCFilter_RI.iPcc_rePu, rLTRansformer_RI.irPccPu) annotation(
    Line(points = {{88, 69}, {107.5, 69}, {107.5, 66}, {111, 66}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.uFilt_rePu, rLTRansformer_RI.urFilterPu) annotation(
    Line(points = {{88, 90}, {111, 90}, {111, 92}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.uFilt_imPu, rLTRansformer_RI.uiFilterPu) annotation(
    Line(points = {{88, 80}, {111, 80}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(lCFilter_RI.iPcc_imPu, rLTRansformer_RI.iiPccPu) annotation(
    Line(points = {{88, 60}, {111, 60}, {111, 57}}, color = {38, 162, 105}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(rLTRansformer_RI.omegaPu, control_GFL_.omega_pll_pu) annotation(
    Line(points = {{137, 49}, {137, 30}, {-62, 30}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(measurement_block1.U_pcc_pu_abs, control_GFL_.U_pu_plant_c) annotation(
    Line(points = {{-119, -19}, {-119, 22}, {-114, 22}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.U_pcc_q, control_GFL_.V_q_grid) annotation(
    Line(points = {{-119, -27}, {-128, -27}, {-128, 32}, {-114, 32}, {-114, 30}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.Q_plant, control_GFL_.Q_plant_pu) annotation(
    Line(points = {{-119, -34}, {-138, -34}, {-138, 41.875}, {-114, 41.875}, {-114, 40}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.P_plant, control_GFL_.P_plant_c) annotation(
    Line(points = {{-119, -42}, {-146, -42}, {-146, 50}, {-114, 50}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.theta_pll, control_GFL_.theta_pll) annotation(
    Line(points = {{-61, -7}, {-61, 20}, {-62, 20}, {-62, 22}}, color = {153, 193, 241}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(measurement_block1.P_conv, control_GFL_.P_meas) annotation(
    Line(points = {{-110, -7}, {-110, 3}, {-108, 3}, {-108, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.Q_conv, control_GFL_.Q_meas) annotation(
    Line(points = {{-101.5, -7}, {-101.5, 2.5}, {-100, 2.5}, {-100, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_q, control_GFL_.i_q_meas) annotation(
    Line(points = {{-93, -7}, {-93, 2.5}, {-90, 2.5}, {-90, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_d, control_GFL_.i_d_meas) annotation(
    Line(points = {{-86, -7}, {-86, 2.5}, {-84, 2.5}, {-84, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_d_conv, control_GFL_.V_d_meas) annotation(
    Line(points = {{-78, -7}, {-78, 2.5}, {-76, 2.5}, {-76, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.V_q_conv, control_GFL_.V_q_meas) annotation(
    Line(points = {{-70, -7}, {-70, 12}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_conv_re, lCFilter_RI.iConv_rePu) annotation(
    Line(points = {{-55, -13}, {32, -13}, {32, 69.5}, {40, 69.5}, {40, 70}}, color = {97, 53, 131}, thickness = 0.75));
  connect(lCFilter_RI.iConv_imPu, measurement_block1.I_conv_im) annotation(
    Line(points = {{40, 60}, {41, 60}, {41, -19}, {-55, -19}}, color = {97, 53, 131}, thickness = 0.75));
  connect(lCFilter_RI.uFilt_rePu, measurement_block1.u_filter_re) annotation(
    Line(points = {{88, 90}, {81.25, 90}, {81.25, -30}, {-55, -30}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.u_filter_im, lCFilter_RI.uFilt_imPu) annotation(
    Line(points = {{-55, -37}, {88, -37}, {88, 80}}, color = {97, 53, 131}, thickness = 0.75));
  connect(measurement_block1.I_pcc_re, lCFilter_RI.iPcc_rePu) annotation(
    Line(points = {{-55, -45}, {98, -45}, {98, 68}, {88, 68}, {88, 70}}, color = {38, 162, 105}, thickness = 0.75));
  connect(lCFilter_RI.iPcc_imPu, measurement_block1.I_pcc_im) annotation(
    Line(points = {{88, 60}, {91.125, 60}, {91.125, 50}, {106.5, 50}, {106.5, -52}, {-55, -52}}, color = {38, 162, 105}, thickness = 0.75));
  connect(measurement_block1.V_pcc_re, rLTRansformer_RI.urPccPu) annotation(
    Line(points = {{-55, -59}, {163, -59}, {163, 84}}, color = {38, 162, 105}, thickness = 0.75));
  connect(rLTRansformer_RI.uiPccPu, measurement_block1.V_pcc_im) annotation(
    Line(points = {{163, 67}, {163, 68.125}, {178, 68.125}, {178, -66}, {-55, -66}}, color = {38, 162, 105}, thickness = 0.75));
 annotation(
  Diagram(
    coordinateSystem(extent={{-200,-200},{200,200}}), // <-- qui ingrandisci l’area
    graphics = {
      Text(origin = {5, 133},
           extent = {{-117, 11}, {117, -11}},
           textString = "For the reference Power in PU a control on the DC dynamics will be implemented")
    }
  ),
  uses(Modelica(version = "3.2.3"))
,
  Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));


end GFLModel;