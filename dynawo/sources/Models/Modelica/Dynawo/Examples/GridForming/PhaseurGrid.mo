within Dynawo.Examples.GridForming;

model PhaseurGrid


parameter Real UPhase0 "";
parameter Real U0Pu " ";
  parameter Real SNom "Apparent power of the AC grid ";
  parameter Types.Angle UPhase(start=UPhase0) "bus constant voltage angle";
  parameter Types.Angle UPu(start=U0Pu) "bus constant voltage amplitude";
  
  Types.ActivePowerPu PSnRefPu "bus constant voltage amplitude";
  Types.ReactivePowerPu QSnRefPu"bus constant voltage amplitude";

 // Types.VoltageModulePu UPCCPu(start=UPCC0Pu) "voltage module at bus terminal in pu (base UNom)";
//Types.VoltageModulePu UterminalPu2 (start=0) "voltage module at bus terminal in pu (base UNom)";

   Modelica.Blocks.Interfaces.RealInput UPhaseOffs annotation(
    Placement(visible = true, transformation(origin = {-120, -26}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {108, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PPu annotation(
    Placement(visible = true, transformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QPu annotation(
    Placement(visible = true, transformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu annotation(
    Placement(visible = true, transformation(origin = {110, -86}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

equation

 // Voltage bus equation
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * (UPhase+UPhaseOffs));

  /* Power Calculation in SNom base (terminal is in load convention) */
 PPu = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom;
 QPu = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i))*SystemBase.SnRef/SNom;
  

 
  /* Power Calculation in SNRef base (terminal is in load convention) */
  PSnRefPu = -ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QSnRefPu = -ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));
  
  

  omegaPu = der(UPhase+UPhaseOffs)+ SystemBase.omegaRef0Pu;
//  UterminalPu2= sqrt(ComplexMath.real(terminal.V)*ComplexMath.real(terminal.V)+ComplexMath.imag(terminal.V)*ComplexMath.imag(terminal.V));
  
annotation(
    Icon(graphics = {Text(origin = {-195, -30}, extent = {{-43, 26}, {43, -26}}, textString = "UPhaseOffs"), Text(origin = {158, 76}, extent = {{-28, 18}, {28, -18}}, textString = "PPu"), Text(origin = {158, -48}, extent = {{-28, 18}, {28, -18}}, textString = "QPu"), Text(origin = {158, 22}, extent = {{-28, 18}, {28, -18}}, textString = "terminal"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 5}, extent = {{-80, 39}, {80, -39}}, textString = "Phaseur"), Text(origin = {48, -125}, extent = {{-38, 23}, {38, -23}}, textString = "OmegaPu")}));
end PhaseurGrid;