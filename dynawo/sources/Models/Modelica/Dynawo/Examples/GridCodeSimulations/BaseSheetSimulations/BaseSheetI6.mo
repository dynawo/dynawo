within Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations;
model BaseSheetI6
  extends BaseParameters;

  Electrical.Buses.InfiniteBusFromTable infiniteBusFromTable(TableOnFile = false, OmegaRefPuTable = [0, 1; 10, 1], UPuTable = [0, 1; 2, 1; 2, 0; 2.15, 0; 3.5, 0.9; 7.5, 0.9; 7.5, 1; 20, 1], UPhaseTable = [0, 0; 2, 0], U0Pu = 1, UPhase0 = 0, OmegaRef0Pu = 1) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

  annotation(preferredView = "diagram");
end BaseSheetI6;
