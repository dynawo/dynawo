within Dynawo.Examples.IndexReduction;

model Example1

  // Inconnues
  Real x1;
  Real x2;
  Real x3;
  Real x4;
  // Variables auxiliaires pour les dérivées secondes (der(der(x)) interdit en Modelica)
  Real v1;
  Real v2;
  Real v3;

equation
  x1 + x2 + sin(time) = 0.0;
  x3 + cos(time)-sin(time) = 0.0; //Réécriture d'un système mathématiquement équivalent car sinon l'exemple de l'article ne passe pas : la matrice M choisie par OMC contient x1 et x2
  x1 + der(x3) + x4 + sin(2 * time) = 0.0;
  v1 = der(x1);
  v2 = der(x2);
  v3 = der(x3);
  2 * der(v1) + der(v2) + der(v3) + der(x4) + cos(2 * time) = 0.0;

end Example1;
