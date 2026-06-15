within Dynawo.Electrical.Controls.Basics;
model BooleanTable "Generates a Boolean output signal based on a table stored in a .txt file (column 1 : time instants, column 2 : 0 or 1)"

  parameter Modelica.Blocks.Types.Extrapolation Extrapolation "Extrapolation of data outside the definition range";
  parameter String FileName = "NoName" "File where vector is stored" annotation(
    Dialog(enable = TableOnFile,
    loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)",
    caption = "Open file in which table is present")));
  parameter String TableName = "NoName" "Table name on file or in function usertab (see docu)";

  Modelica.Blocks.Interfaces.BooleanOutput source "Output value";

  Modelica.Blocks.Sources.BooleanTable booleanTable(
    combiTimeTable(
    tableName                = TableName,
    tableOnFile                = true,
    fileName                = FileName),
    extrapolation = Extrapolation,
    shiftTime = 0,
    startTime = -Modelica.Constants.inf) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  source = booleanTable.y;

  annotation(preferredView = "text");
end BooleanTable;
