within Dynawo.Electrical.Controls.Basics;
model CombiTimeTable "Table look-up with respect to time and linear/periodic extrapolation methods (data from a two-column table in a .txt file) with one output"

  parameter Modelica.Blocks.Types.Extrapolation Extrapolation "Extrapolation of data outside the definition range";
  parameter String FileName = "NoName" "File where matrix is stored" annotation(
    Dialog(enable = TableOnFile,
    loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)",
    caption = "Open file in which table is present")));
  parameter Modelica.Blocks.Types.Smoothness Smoothness "Smoothness of table interpolation";
  parameter String TableName = "NoName" "Table name on file or in function usertab (see docu)";

  Dynawo.Connectors.ImPin source "Output connector";

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    extrapolation = Extrapolation,
    fileName = FileName,
    smoothness = Smoothness,
    tableName = TableName,
    tableOnFile = true) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  source.value = combiTimeTable.y[1];

  annotation(preferredView = "text");
end CombiTimeTable;
