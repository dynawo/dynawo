within Dynawo.Electrical.Controls.Basics;
model IntegerTable "Generate an Integer output signal based on a table stored in a .txt file (data from a two-column table in a .txt file)"

  parameter Modelica.Blocks.Types.Extrapolation Extrapolation "Extrapolation of data outside the definition range";
  parameter String FileName = "NoName" "File where vector is stored" annotation(
    Dialog(enable = TableOnFile,
    loadSelector(filter = "Text files (*.txt);;MATLAB MAT-files (*.mat)",
    caption = "Open file in which table is present")));
  parameter String TableName = "NoName" "Table name on file or in function usertab (see docu)";

  Dynawo.Connectors.IntPin source "Output value";

  Modelica.Blocks.Sources.IntegerTable integerTable(
    combiTimeTable(fileName = FileName, tableName = TableName, tableOnFile = true),
    extrapolation = Extrapolation,
    table = [0, 0]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  source.value = integerTable.y;

  annotation(preferredView = "text");
end IntegerTable;
