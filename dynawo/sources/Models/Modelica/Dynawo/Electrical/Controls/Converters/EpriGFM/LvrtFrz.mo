within Dynawo.Electrical.Controls.Converters.EpriGFM;

model LvrtFrz
  extends Parameters.LvrtFrz;

  Modelica.Blocks.Interfaces.RealInput VPu(start = 1) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110,0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.BooleanOutput Frz(start = true) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110,0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


equation

  Frz = if VPu < VDipPu then false else true; 
 

end LvrtFrz;
