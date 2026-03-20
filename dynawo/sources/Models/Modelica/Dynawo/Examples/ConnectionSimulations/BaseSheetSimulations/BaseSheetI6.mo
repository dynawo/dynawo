within Dynawo.Examples.ConnectionSimulations.BaseSheetSimulations;

model BaseSheetI6
  extends Modelica.Icons.Example;
  extends BaseParameters;

  Electrical.Buses.InfiniteBusFromTable infiniteBusFromTable(TableFile = "/home/philinux/dynawo/dynawo/dynawo/sources/Models/Modelica/Dynawo/Examples/ConnectionSimulations/BaseSheetSimulations/TableVoltageDip.txt", OmegaRefPuTableName = "OmegaTable", UPuTableName = "VoltageTable", UPhaseTableName = "PhaseTable", U0Pu = 1, UPhase0 = 0, OmegaRef0Pu = 1)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
equation
end BaseSheetI6;
