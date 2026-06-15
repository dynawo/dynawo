within Dynawo.Electrical.Controls.Basics;
model SineWave "Parameterizable sine wave model"

  Dynawo.Connectors.ImPin source(value(start = Offset));

  parameter Real K "Amplitude of the sine wave";
  parameter Real Offset "Average value of the sine wave";
  parameter Types.AngularVelocity Omega "Pulsation of the sine wave in rad/s";
  parameter Types.Angle Phi "Phase of the sine wave in rad";

equation
  source.value = Offset + K * sin(Omega * time + Phi);

  annotation(preferredView = "text");
end SineWave;
