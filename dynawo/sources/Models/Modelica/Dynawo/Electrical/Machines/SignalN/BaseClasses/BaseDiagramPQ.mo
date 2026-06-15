within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseDiagramPQ "Base dynamic model for a PQ diagram"

  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";

  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";

  Modelica.Blocks.Tables.CombiTable1Dv tableQMax(
    tableOnFile=true,
    tableName=QMaxTableName,
    fileName=QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1Dv tableQMin(
    tableOnFile=true,
    tableName=QMinTableName,
    fileName=QMinTableFile) "Table to get QMinPu from PGenPu";

  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";

equation
  QMaxPu = tableQMax.y[1];
  QMinPu = tableQMin.y[1];

  annotation(preferredView = "text");
end BaseDiagramPQ;
