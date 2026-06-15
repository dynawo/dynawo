within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.BlockingFunction;
model BlockingFunction "Undervoltage blocking function for one side of an HVDC link"
  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsBlockingFunction;

  //Input variable
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) "Voltage module in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.BooleanOutput blocked(start = false) "If true, converter is blocked" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";

protected
  Types.Time tMaintainBlock(start = Modelica.Constants.inf) "Timer to maintain the blocking for a duration of at least TBlock";
  Types.Time tPrepareBlock(start = Modelica.Constants.inf) "Timer to prepare the blocking";
  Types.Time tPrepareDeblock(start = Modelica.Constants.inf) "Timer to prepare the deactivation of the blocking";
  Types.Time tStartBlock(start = Modelica.Constants.inf) "Timer to start the blocking";
  Types.VoltageModulePu UFilteredPu(start = U0Pu) "Filtered voltage module in pu (base UNom)";

equation
  UFilteredPu + tMeasureUBlock * der(UFilteredPu) = UPu;

  when UFilteredPu < UBlockUnderVPu then
    tPrepareBlock = time;
  elsewhen UFilteredPu > UBlockUnderVPu then
    tPrepareBlock = Modelica.Constants.inf;
  end when;

  when time - tPrepareBlock > tBlockUnderV then
    tStartBlock = time;
  elsewhen time - tPrepareBlock < tBlockUnderV then
    tStartBlock = Modelica.Constants.inf;
  end when;

  when blocked == true and UFilteredPu < UMaxDbPu and UFilteredPu > UMinDbPu then
    tPrepareDeblock = time;
  elsewhen blocked == false or UFilteredPu > UMaxDbPu or UFilteredPu < UMinDbPu then
    tPrepareDeblock = Modelica.Constants.inf;
  end when;

  when time - tStartBlock > 0 then
    blocked = true;
    tMaintainBlock = time;
  elsewhen time - tStartBlock < 0 and time > pre(tMaintainBlock) + tBlock and time > pre(tPrepareDeblock) + tUnblock + tBlock then
    blocked = false;
    tMaintainBlock = Modelica.Constants.inf;
  end when;

  annotation(preferredView = "text");
end BlockingFunction;
