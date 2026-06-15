within Dynawo.Electrical.Transformers.BaseClasses_INIT;
function IdealTransformerTapEstimation "Function that estimates the initial tap of an ideal transformer"
  extends Icons.Function;

  /*
  It is done using the voltage value on side 1 and the set point value for the voltage module on side 2.
  The tap is determined as the closest value to an estimated tap based on the minimum and maximum tap values.
  */

  input Types.PerUnit rTfoMinPu "Minimum transformation ratio in pu: U2/U1 in no load conditions";
  input Types.PerUnit rTfoMaxPu "Maximum transformation ratio in pu: U2/U1 in no load conditions";
  input Integer NbTap "Number of taps";
  input Types.ComplexVoltagePu u10Pu "Start value of complex voltage at terminal 1 in pu (base UNom)";
  input Types.VoltageModulePu Uc20Pu "Voltage set-point on side 2 in pu (base U2Nom)";

  output Integer Tap0 "Estimated tap";

protected
  Types.PerUnit rcTfo0Pu "Ratio value corresponding to the voltage set point on side 2 in pu: U2/U1 in no load conditions";
  Real tapEstimation "Intermediate real value corresponding to the tap estimation based on the minimum and maximum tap values";

algorithm
  // Handling the one tap case
  if (NbTap == 1) then
    Tap0 := 0;
    return;
  end if;

  // Handling zero voltage case
  if (Modelica.ComplexMath.abs(u10Pu) == 0) then
    Tap0 := 0;
    return;
  end if;

  // Initial ratio calculation
  rcTfo0Pu :=Uc20Pu/Modelica.ComplexMath.abs(u10Pu);

  // Finding the tap position closest to the ratio calculated (rounded to an integer)
  tapEstimation := ((rcTfo0Pu - rTfoMinPu) / (rTfoMaxPu - rTfoMinPu)) * (NbTap - 1);
  if tapEstimation <= 0 then
    Tap0 := 0;
  elseif tapEstimation >= (NbTap -1) then
    Tap0 := NbTap - 1;
  elseif (tapEstimation - floor(tapEstimation)) < (ceil(tapEstimation) - tapEstimation) then
   Tap0 := integer(floor(tapEstimation));
  else
    Tap0 := integer(ceil(tapEstimation));
  end if;

  annotation(preferredView = "text");
end IdealTransformerTapEstimation;
