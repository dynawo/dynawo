within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsAcVoltageControl "Parameters of AC voltage control"
  extends ParamsQRefLim;
  extends ParamsQRefQU;

  parameter String IqModTableName "Name of the table in the text file for additional current as a function of voltage";
  parameter String TablesFile "Text file that contains the tables for the functions";
  parameter Types.Time tQ "Time constant of the first order filter for the AC voltage control in s";

  annotation(preferredView = "text");
end ParamsAcVoltageControl;
