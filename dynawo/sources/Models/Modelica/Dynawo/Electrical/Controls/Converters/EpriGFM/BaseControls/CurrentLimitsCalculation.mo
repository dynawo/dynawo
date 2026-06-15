within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;
model CurrentLimitsCalculation "Current limit calculation in EPRI Grid Forming model"
  extends Parameters.OmegaFlag;

  parameter Types.PerUnit IMaxPu "Max current in pu (base UNom, SNom), example value = 1.05" annotation(
  Dialog(tab = "VoltageControl"));
  parameter Boolean PQFlag "Active or active power priority flag: false = P priority, true = Q priority" annotation(
  Dialog(tab = "VoltageControl"));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "d-axis command current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = (if OmegaFlag == 0 then -1 else 1) * IqConv0Pu) "q-axis command current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idMaxPu "d-axis maximum current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idMinPu "d-axis minimum current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu "q-axis maximum current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 62}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu "q-axis minimum current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // Initial parameters
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current of the converter in pu (base UNom, SNom) (generator convention)" annotation(Dialog(tab = "Initial"));

equation
  if PQFlag then
  /*----- Q Priority -----*/
    idMaxPu = noEvent(if IMaxPu ^ 2 > iqConvRefPu ^ 2 then sqrt(IMaxPu ^ 2 - iqConvRefPu ^ 2) else 0);
    iqMaxPu = IMaxPu;
  else
  /*----- P Priority -----*/
    idMaxPu = IMaxPu;
    iqMaxPu = noEvent(if IMaxPu ^ 2 > idConvRefPu ^ 2 then sqrt(IMaxPu ^ 2 - idConvRefPu ^ 2) else 0);
  end if;
    idMinPu = - idMaxPu;
    iqMinPu = - iqMaxPu;

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {4, 5}, extent = {{-76, 39}, {76, -39}}, textString = "Current Limiter")}));
end CurrentLimitsCalculation;
