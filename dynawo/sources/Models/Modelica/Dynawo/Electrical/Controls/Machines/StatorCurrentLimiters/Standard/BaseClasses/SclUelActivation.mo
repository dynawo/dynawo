within Dynawo.Electrical.Controls.Machines.StatorCurrentLimiters.Standard.BaseClasses;
model SclUelActivation "IUelBias calculation for SCL2C"

  //Regulation parameters
  parameter Types.CurrentModulePu IInstUelPu "Underexcited region instantaneous stator current limit in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IResetPu "SCL UEL reset-reference, if inactive, in pu (base SnRef, UNom)";
  parameter Types.CurrentModulePu IThOffPu "SCL UEL reset threshold value in pu (base SnRef, UNom)";
  parameter Types.Time tEnUel "Underexcited activation delay time in s";
  parameter Types.Time tOff "SCL reset delay time in s";

  //Input variables
  Modelica.Blocks.Interfaces.RealInput IUelActPu(start = IUelRef0Pu) "SCL UEL actual current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IUelRefPu(start = IUelRef0Pu) "SCL UEL reference current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tErr(start = tErr0) "SCL timer error in s" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.RealOutput IUelBiasPu(start = 0) "Output current in pu (base SnRef, UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Logical.Timer timer;
  Modelica.Blocks.Logical.Timer timer1;

  //Initial parameters
  parameter Types.CurrentModulePu IUelRef0Pu "Initial reference current in pu (base SnRef, UNom)";
  parameter Types.Time tErr0 "Initial SCL timer error in s";

equation
  if tErr <= 0 or timer.y >= tEnUel or tEnUel == 0 then
    IUelBiasPu = 0;
  elseif IUelRefPu >= IInstUelPu and timer1.y > tOff then
    IUelBiasPu = IResetPu;
  else
    IUelBiasPu = 0;
  end if;

  timer.u = IUelActPu > IUelRefPu;
  timer1.u = IUelRefPu > IUelActPu + IThOffPu;

  annotation(preferredView = "text");
end SclUelActivation;
