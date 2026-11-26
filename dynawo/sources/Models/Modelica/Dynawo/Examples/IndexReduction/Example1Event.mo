within Dynawo.Examples.IndexReduction;

model Example1Event "Example1 avec une marche sur l'entrée de f4 : teste la restauration algébrique après un changement de mode"
  // A tEvent, der(v2) saute de -uStepPu / (1 - k) : la dérivée mémorisée devient fausse et la restauration doit la corriger.
  // Typage généré (f1'' DIFFERENTIAL -> der(v2), f4 ALGEBRAIC -> der(v1)) : la restauration itérée multiplie
  // l'erreur sur der(v2) par 1/k à chaque passe. Elle converge si |k| > 1 (k = 2 comme dans l'article)
  // et diverge si |k| < 1 (k = 0.5). k = 1 rend le système singulier.

  parameter Real k "Coefficient de der(v1) dans f4 (2 dans l'article)";
  parameter Real tEvent  "Instant de la marche, en s";
  parameter Real uStepPu "Amplitude de la marche sur l'entrée de f4";

  // Inconnues
  Real x1;
  Real x2;
  Real x3;
  Real x4;
  // Variables auxiliaires pour les dérivées secondes (der(der(x)) interdit en Modelica)
  Real v1;
  Real v2;
  Real v3;
  // Entrée de f4, avec la marche (le if reste hors des équations qui contiennent des dérivées, comme u1 dans TestIndexEvent)
  Real u4;

equation
  x1 + x2 + sin(time) = 0.0;
  x3 + cos(time) - sin(time) = 0.0; // f2 - f1, comme dans Example1
  x1 + der(x3) + x4 + sin(2 * time) = 0.0;
  v1 = der(x1);
  v2 = der(x2);
  v3 = der(x3);
  // marche sur l'entrée de f4 : f4 n'est pas dérivée par Pantelides, OMC n'a pas à dériver le if
  u4 = if time < tEvent then cos(2 * time) else cos(2 * time) + uStepPu;
  k * der(v1) + der(v2) + der(v3) + der(x4) + u4 = 0.0;

end Example1Event;
