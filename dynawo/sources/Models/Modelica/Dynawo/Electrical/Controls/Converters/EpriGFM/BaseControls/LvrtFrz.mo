within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;
model LvrtFrz "Low voltage ride through freeze function of EPRI Grid Forming model"

  parameter Types.PerUnit UDipPu "Freeze voltage in pu (base UNom), example value = 0.85" annotation(
  Dialog(tab = "VoltageControl"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput UPu(start = sqrt(UdFilter0Pu^2 + UqFilter0Pu^2)) "Voltage magnitude in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.BooleanOutput Frz(start = false) "Boolean low voltage freeze signal" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's terminal in pu (base UNom)" annotation(
  Dialog(tab = "Initial"));

equation
  Frz = if UPu < UDipPu then true else false;

  annotation(
  preferredView = "text");
end LvrtFrz;
