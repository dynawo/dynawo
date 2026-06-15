within Dynawo.Electrical.Buses;
model InfiniteBusFromTable_INIT "Initial model for infinite bus with UPu, UPhase and omegaRefPu given by tables as functions of time"
  extends AdditionalIcons.Init;

  parameter String TableFile "Text file that contains the tables to get UPu, UPhase and omegaRefPu from time";
  parameter String OmegaRefPuTableName "Name of the table in the text file to get omegaRefPu from time";
  parameter String UPuTableName "Name of the table in the text file to get UPu from time";
  parameter String UPhaseTableName "Name of the table in the text file to get UPhase from time";

  Types.PerUnit U0Pu "Initial infinite bus voltage module in pu (base UNom)";
  Types.Angle UPhase0 "Initial infinite bus voltage angle in rad";
  Types.AngularVelocityPu OmegaRef0Pu "Initial infinite bus frequency in pu (base omegaNom)";

  Modelica.Blocks.Sources.CombiTimeTable tableOmegaRef0Pu(tableOnFile = true, tableName = OmegaRefPuTableName, fileName = TableFile) "Table to get omegaRefPu from time";
  Modelica.Blocks.Sources.CombiTimeTable tableU0Pu(tableOnFile = true, tableName = UPuTableName, fileName = TableFile) "Table to get UPu from time";
  Modelica.Blocks.Sources.CombiTimeTable tableUPhase0(tableOnFile = true, tableName = UPhaseTableName, fileName = TableFile) "Table to get UPhase from time";

equation
  U0Pu = tableU0Pu.y[1];
  UPhase0 = tableUPhase0.y[1];
  OmegaRef0Pu = tableOmegaRef0Pu.y[1];

  annotation(
    preferredView = "text");
end InfiniteBusFromTable_INIT;
