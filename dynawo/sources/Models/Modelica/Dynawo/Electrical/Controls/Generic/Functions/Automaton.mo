within Dynawo.Electrical.Controls.Generic.Functions;
function Automaton "Function to call external automaton"
  import Dynawo.Electrical.Controls.Generic.GenericAutomatonConstants;

  extends Icons.Function;

  input String command "Command to be called";
  input Types.Time timeActivation "Automaton activation time";
  input Real inputs[GenericAutomatonConstants.inputsMaxSize] "Inputs data for the automaton";
  input String inputsName[GenericAutomatonConstants.inputsMaxSize] "Inputs data name for the automaton";
  input Integer nbInputs "Number of inputs to provide to the automaton";
  input Integer nbMaxInputs "Maximum number of inputs";
  input String outputsName[GenericAutomatonConstants.outputsMaxSize] "Discrete real outputs data name for the automaton";
  input Integer nbOutputs "Number of discrete real outputs to provide to the automaton";
  input Integer nbMaxOuputs "Maximum number of discrete real outputs";
  input String intOutputsName[GenericAutomatonConstants.outputsMaxSize] "Integer outputs data name for the automaton";
  input Integer nbIntOutputs "Number of integer outputs to provide to the automaton";
  input Integer nbMaxIntOuputs "Maximum number of intger outputs";
  output Real outputs[GenericAutomatonConstants.outputsMaxSize] "Discrete real outputs data provided by the automaton";
  output Integer intOutputs[GenericAutomatonConstants.outputsMaxSize] "Integer outputs data provided by the automaton";

  external "C" callExternalAutomaton(command, timeActivation, inputs, inputsName, nbInputs, nbMaxInputs, outputs, outputsName, nbOutputs, nbMaxOuputs, intOutputs, intOutputsName, nbIntOutputs, nbMaxIntOuputs);

  annotation(preferredView = "text");
end Automaton;
