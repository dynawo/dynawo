within Dynawo.Electrical;
package SystemBase "Dynawo system base definition (for per unit purposes)"
  import Modelica.Constants;

  extends Icons.Package;

  final constant Types.ApparentPowerModule SnRef = 100 "System base";
  final constant Types.Frequency fNom = 50 "AC system frequency";
  final constant Types.AngularVelocity omegaNom = 2 * Constants.pi * fNom "System angular frequency";
  final constant Types.AngularVelocity omegaRef0Pu = 1 "Reference for system angular frequency (pu base omegaNom)";
  final constant Types.AngularVelocity omega0Pu = 1 "System angular frequency (pu base omegaNom)";

  annotation(preferredView = "text");
end SystemBase;
