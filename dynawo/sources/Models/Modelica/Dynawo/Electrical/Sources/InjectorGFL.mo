within Dynawo.Electrical.Sources;

model InjectorGFL "Converter model for grid following applications"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffGenerator;
  /*
          Model Characteristics: this model is based on the stepss converter model
          - No DC control & DC dynamics
          - No RLC filter (MMC technology) 
          */
  /*
          Equivalent circuit and conventions: 
           __________
          |                 |IConvPu(idConvPu,iqConvPu)                                      1   r  IPccPu (idPccPu, iqPccPu)
          |                 |-->----------------------(R,L)----->--------------------------|   |---->---(PCC terminal)----
          |                 |                                                                                  |   |
          |  DC/AC      |  UConvPu                                                                   |   |       UPccPu                PGenPu =>
          |                 |(udConvPu, uqConvPu)                                                 |   | (udPccPu, uqPccPU)    QGenPu =>
          |                 |                                                                                  |   |
          |_________ |---------------------------------------------------------------------- |   |-------------------------------
          */
  import Modelica;
  import Dynawo;
  parameter Types.ApparentPowerModule SNom "Converter nominal apparent power in MVA";
  parameter Types.PerUnit R "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit L "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rc "resistance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit Xc "reactance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit ratioTr "Transformer ratio (base ...)";
  parameter Types.AngularVelocity omegaNom;
  parameter Types.PerUnit omegaPLL0Pu;
  parameter Types.Angle thetaPLL0Pu "Start value of voltage angle at injector terminal in rad";
  parameter Types.ComplexVoltagePu uConv0Pu;
  parameter Types.PerUnit UConv0Pu;
  parameter Types.PerUnit udConvRef0Pu;
  parameter Types.PerUnit uqConvRef0Pu;
  parameter Types.ActivePowerPu PGen0Pu "Start value of active power in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QGen0Pu "Start value of reactive power in pu (base SNom) (generator convention)";
  parameter Types.ComplexVoltagePu uPcc0Pu "Start value of complex voltage at pcc terminal in pu (base UNom)";
  parameter Types.ComplexCurrentPu iPcc0Pu "Start value of complex current at pcc terminal in pu (base UNom, SnRef) (generator convention)";
  parameter Types.ComplexCurrentPu iConv0Pu "Start value of complex current at converter terminal in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit udPcc0Pu "(base UNom, SNom) (generator convention)";
  parameter Types.PerUnit uqPcc0Pu "(base UNom, SNom) (generator convention)";
  parameter Types.PerUnit idPcc0Pu "(base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqPcc0Pu "(base UNom, SNom) (generator convention)";
  parameter Types.PerUnit idConv0Pu "(base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqConv0Pu "(base UNom, SNom) (generator convention)";
  // Inputs:
  // Terminal connection
  Dynawo.Connectors.ACPower terminal(V(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)), i(re(start = -iPcc0Pu.re), im(start = -iPcc0Pu.im))) "Connector used to connect the injector to the grid" annotation(
    Placement(visible = true, transformation(origin = {71, 0}, extent = {{7, -7}, {-7, 7}}, rotation = 0), iconTransformation(origin = {110, -1}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  // Inputs:
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = omegaPLL0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-60, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput thetaPLLPu(start = thetaPLL0Pu) "Converter's angle in rad" annotation(
    Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = udConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = uqConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Variables/outputs with start values:
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uPccPu(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)) "Complex inverter terminal voltage, used as complex connector instead of terminal connector, terminal only used for physical connection, in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {69, 25}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Types.PerUnit idPccPu(start = idPcc0Pu);
  Types.PerUnit iqPccPu(start = iqPcc0Pu);
  //   Types.ComplexVoltagePu uConvPu(re(start = uConv0Pu.re), im(start = uConv0Pu.im));
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = udPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {69, -15}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {31, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {69, -25}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = idConv0Pu) "d-current in converter terminal" annotation(
    Placement(visible = true, transformation(origin = {69, -35}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = iqConv0Pu) "q-current in converter terminal" annotation(
    Placement(visible = true, transformation(origin = {69, -44}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {-29, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput PGenPu(start = PGen0Pu) "Injected active power at the PCC in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {69, 52}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QGenPu(start = QGen0Pu) "Injected reactive power at the PCC in pu (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {69, 38}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UConvPu(start = UConv0Pu) "Voltage magnitude at converter
     terminal" annotation(
    Placement(visible = true, transformation(origin = {69, -55}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPccPu(start = ComplexMath.'abs'(uPcc0Pu)) "Voltage magnitude at PCC
       terminal" annotation(
    Placement(transformation(origin = {25, -58}, extent = {{-5, -5}, {5, 5}}), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}})));
initial equation
  der(idPccPu) = 0.0;
  der(iqPccPu) = 0.0;
equation
  uPccPu = terminal.V;
/* DQ voltages and currents at PCC */
  udPccPu = cos(thetaPLLPu)*uPccPu.re + sin(thetaPLLPu)*uPccPu.im;
  uqPccPu = -sin(thetaPLLPu)*uPccPu.re + cos(thetaPLLPu)*uPccPu.im;
/*Dynamics of current in Transformer in DQ reference frame*/
  L*der(idPccPu*ratioTr) = SystemBase.omegaNom*(udConvRefPu - udPccPu/ratioTr - R*idPccPu*ratioTr + omegaPLLPu*L*iqPccPu*ratioTr);
  L*der(iqPccPu*ratioTr) = SystemBase.omegaNom*(uqConvRefPu - uqPccPu/ratioTr - R*iqPccPu*ratioTr - omegaPLLPu*L*idPccPu*ratioTr);
/* Power Calculation */
  PGenPu = -1*ComplexMath.real(terminal.V*ComplexMath.conj(terminal.i))* SystemBase.SnRef / SNom;
  QGenPu = -1*ComplexMath.imag(terminal.V*ComplexMath.conj(terminal.i))* SystemBase.SnRef / SNom;
/* Controlled voltage source */
  idConvPu = idPccPu*ratioTr;
  iqConvPu = iqPccPu*ratioTr;
/* Setpoint of compensated voltage */
  UConvPu = ComplexMath.'abs'(terminal.V/ratioTr - terminal.i*ratioTr*Complex(R, Xc)* (SystemBase.SnRef/SNom));
  UPccPu = ComplexMath.'abs'(terminal.V);
  
  if running.value then
    terminal.i.re = -1*(cos(thetaPLLPu)*idPccPu - sin(thetaPLLPu)*iqPccPu)* SNom / SystemBase.SnRef;
    terminal.i.im = -1*(sin(thetaPLLPu)*idPccPu + cos(thetaPLLPu)*iqPccPu)* SNom / SystemBase.SnRef;
  else
    terminal.i = Complex(0);
  end if;
  annotation(
    Placement(visible = true, transformation(origin = {69, -12}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)),
    preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {5, 6}, extent = {{-95, 56}, {90, -68}}, textString = "InjectorGFL"), Text(origin = {-47, 88}, extent = {{-32, 12}, {24, -8}}, textString = "uPccPu", fontSize = 14), Text(origin = {-138, 92}, extent = {{-32, 12}, {24, -8}}, textString = "omegaPLLPu"), Text(origin = {-139, 43}, extent = {{-32, 12}, {24, -8}}, textString = "thetaPLLPu"), Text(origin = {-138, -18}, extent = {{-32, 12}, {24, -8}}, textString = "udConvRefPu"), Text(origin = {-134, -68}, extent = {{-32, 12}, {24, -8}}, textString = "uqConvRefPu"), Text(origin = {26, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "udPccPu", fontSize = 14), Text(origin = {66, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "uqPccPu", fontSize = 14), Text(origin = {-33, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "iqConvPu", fontSize = 14), Text(origin = {-74, -86}, rotation = 180, extent = {{-32, 12}, {24, -8}}, textString = "idConvPu", fontSize = 14), Text(origin = {82, 78}, extent = {{-32, 12}, {24, -8}}, textString = "PGenPu", fontSize = 14), Text(origin = {82, 39}, extent = {{-32, 12}, {24, -8}}, textString = "QGenPu", fontSize = 14), Text(origin = {82, -50}, extent = {{-32, 12}, {24, -8}}, textString = "UConvPu", fontSize = 14), Text(origin = {53, 88}, extent = {{-32, 12}, {24, -8}}, textString = "iPccPu", fontSize = 14)}));
end InjectorGFL;
