within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsQRefLim "Parameters of reactive power limits calculation"
  parameter Types.ReactivePowerPu QOpMaxPu "Maximum operator value of the reactive power in pu (base SNom) (DC to AC)";
  parameter Types.ReactivePowerPu QOpMinPu "Minimum operator value of the reactive power in pu (base SNom) (DC to AC)";
  parameter String QPMaxTableName "Name of the table in the text file for upper reactive power limit as a function of active power";
  parameter String QPMinTableName "Name of the table in the text file for lower reactive power limit as a function of active power";
  parameter String QUMaxTableName "Name of the table in the text file for upper reactive power limit as a function of voltage";
  parameter String QUMinTableName "Name of the table in the text file for lower reactive power limit as a function of voltage";
  parameter String TablesFile "Text file that contains the table for the function calculating the reactive power limits";
  parameter Types.Time tMeasure "Time constant of the measurement filters in s";

  annotation(preferredView = "text");
end ParamsQRefLim;
