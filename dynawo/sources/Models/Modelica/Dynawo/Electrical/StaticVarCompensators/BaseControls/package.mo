within Dynawo.Electrical.StaticVarCompensators;
package BaseControls "Models of base controls for static var compensator"
  extends Icons.Package;

    type Mode = enumeration(OFF "No regulation", STANDBY "Standby mode", RUNNING_V "Voltage control");

end BaseControls;
