//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

#include <string>
#include <vector>
#include <iomanip>
#include <iostream>
#include <fstream>

#include <boost/program_options.hpp>
#include <boost/algorithm/string/replace.hpp>
#include <boost/dll.hpp>

#include "DYNIoDico.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"
#include "DYNInitXml.h"

using std::string;
using std::vector;
using std::ofstream;
using std::cout;
using std::endl;
using std::stringstream;
using std::istringstream;
using std::ios;
using DYN::Trace;

namespace po = boost::program_options;

static void modelicaCompile(const string& modelName, const string& compilationDir, const vector<string>& initFiles,
                            const vector<string>& moFiles,
                            bool& withInitFile,
                            const string& packageName,
                            bool noInit, bool useAliasing);  ///< Convert the whole (INIT when relevant + standard) Modelica model into a C++ model
static void compileLib(const string& modelName, const string& compilationDir);  ///< Compile the C++ model
static string executeCommand(const string& command, const bool printLogs, const string& start_dir = "");  ///< Run a given command and return logs
static string compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                               const string& compilationDir,
                               const string& packageName, bool useAliasing);  ///< Convert one (INIT or standard) Modelica model into C code
static string runOptions(bool useAliasing);  ///< Return modelica run options
static void compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                                 const string& compilationDir,
                                 const string& packageName, bool useAliasing);  ///< Generate the .xml file describing the model parameters and variables
static void generateModelFile(const string& modelName, const string& compilationDir,
                              bool& withInitFile,
                              const string& additionalHeaderList,
                              const string& packageName,
                              bool genCalcVars);  ///< Rewrite parts of one whole Modelica model C/C++ code to fit Dynawo C/C++ requirements
static void generateEvalJFile(const string& modelName, const string& compilationDir,
                              bool withInitFile);  ///< Rewrite parts of one whole Modelica model C/C++ code to fit Dynawo C/C++ requirements
static bool verifySharedObject(const string& library);  ///< Ensure that the generated compiled library can actually run

static void mosAddHeader(const string& mosFilePath, ofstream& mosFile);  ///< Add a header to the .mos file
static void mosAddFilesImport(const bool importModelicaPackage, const vector<string>& filesToImport,
                              ofstream& mosFile);  ///< Add files import commands to a .mos file
static string mosRunFile(const string& mosFilePath, const string& path);  ///< Run a given .mos file
static bool copyFile(const string& fileName,
    const string& modelDir,
    const string& compilationDir);  ///< copy file from input folder into output folder, return true if input file is equal to output file
int main(int argc, char ** argv) {
  DYN::InitXerces xerces;
  Trace::init();

  string libName = "";
  string modelName = "";
  string compilationDir = "";
  string modelDir = "";
  string additionalHeaderList;
  string packageName = "";
  po::options_description desc;
  vector<string> moFiles;
  vector<string> initFiles;
  bool noInit = false;
  bool useAliasing = true;
  bool genCalcVars = true;

  desc.add_options()
          ("help,h", "produce help message")
          ("model", po::value<string>(&modelName), "set the model name of the file to compile (model.mo needs to be in model-dir)")
          ("model-dir", po::value<string>(&modelDir), "set model directory (default: current directory)")
          ("compilation-dir", po::value<string>(&compilationDir), "set compilation directory (default: model subdirectory in model directory)")
          ("moFiles", po::value< vector<string> >(&moFiles)->multitoken(), "modelica files to use for expansion")
          ("initFiles", po::value< vector<string> >(&initFiles)->multitoken(), "init files to use for expansion")
          ("lib", po::value<string>(&libName), "set the name of the output lib")
          ("additionalHeaderList", po::value< string >(&additionalHeaderList),
              "list of headers that should be included in the dynamic model files")
          ("package-name", po::value<string>(&packageName), "set the model name package")
          ("no-init", po::value<bool>(&noInit)->implicit_value(true), "avoid building init problem for model")
          ("useAliasing", po::value<bool>(&useAliasing), "use aliasing")
          ("generateCalculatedVariables", po::value<bool>(&genCalcVars), "use automatic generation of calculated variables");

  po::variables_map vm;
  // parse regular options
  po::store(po::parse_command_line(argc, argv, desc), vm);
  po::notify(vm);
  if (vm.count("help")) {
    cout << desc << endl;
    return 0;
  } else if (modelName.empty()) {
    cout << " Model name is required " << endl;
    cout << desc << endl;
    return 1;
  }
  if (modelDir.empty()) {
    modelDir = ".";
  }
  if (compilationDir.empty()) {
    compilationDir = absolute(modelName, modelDir);
  }

  if (!packageName.empty() && strcmp(&packageName.at(packageName.length() - 1), ".")) {
    packageName += ".";
  }
  if (!useAliasing) {
    std::cout << " [INFO] Aliasing and automatic generation of calculated variables are disabled for " << modelName <<  std::endl;
    genCalcVars = false;
  } else if (!genCalcVars) {
    std::cout << " [INFO] Automatic generation of calculated variables is disabled for " << modelName <<  std::endl;
  }

  // Prepare workspace
  if (!is_directory(modelDir))
    throw DYNError(DYN::Error::MODELER, MissingModelicaInputFolder, modelDir);
#ifndef _DEBUG_
  remove_all_in_directory(compilationDir);
#endif
  if (!is_directory(compilationDir))
    create_directory(compilationDir);
  string compilationDir1 = prettyPath(compilationDir);

  copyFile(modelName + ".mo", modelDir, compilationDir);
  copyFile(modelName + ".extvar", modelDir, compilationDir);
  copyFile(modelName + "_INIT.mo", modelDir, compilationDir);

  // Launch the compile of the model
  try {
    DYN::IoDicos& dicos = DYN::IoDicos::instance();
    dicos.addPath(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos.addDicos(getMandatoryEnvVar("DYNAWO_DICTIONARIES"));

    // Create .c, .h and .xml files from .mo
    bool withInitFile = false;
    modelicaCompile(modelName, compilationDir1, initFiles, moFiles, withInitFile, packageName, noInit, useAliasing);

    // generate the .cpp file from the previous files
    generateModelFile(modelName, compilationDir1, withInitFile, additionalHeaderList, packageName, genCalcVars);
    if (!exists(absolute(modelName + "_Dyn.cpp", compilationDir1)))
      throw DYNError(DYN::Error::MODELER, ModelCompilationFailed, modelName);

    generateEvalJFile(modelName, compilationDir1, withInitFile);
    if (!exists(absolute(modelName + "_Dyn_evalJ.cpp", compilationDir1)))
      throw DYNError(DYN::Error::MODELER, ModelCompilationFailed, modelName);

    // Creation of the lib .so
    if (!libName.empty()) {
      // 1) on efface la lib a generer
      string lib = absolute(libName, compilationDir1);
      remove(lib);
      // 2) attempt to generate the lib
      compileLib(modelName, compilationDir1);
      // 3) if lib does not exist, we raise an error
      if (!exists(lib)) {
        throw DYNError(DYN::Error::MODELER, FileGenerationFailed, lib);
      } else {
        bool valid = verifySharedObject(lib);
        if (!valid)
          throw DYNError(DYN::Error::MODELER, FileGenerationFailed, lib);
        copyFile(libName, compilationDir, modelDir);
#ifndef _DEBUG_
        // remove_all_in_directory(compilationDir1);
#endif
      }
    }

    std::cout << " Compilation of " << modelName << " succeeded " << std::endl;
  } catch (const string& s) {
    std::cerr << " Compilation of " << modelName << " failed :" << s << std::endl;
    return -1;
  } catch (const char *s) {
    std::cerr << " Compilation of " << modelName << " failed :" << s << std::endl;
    return -1;
  } catch (const DYN::Error& e) {
    std::cerr << " Compilation of " << modelName << " failed :" << e << std::endl;
    return -1;
  } catch (...) {
    std::cerr << " Compilation of " << modelName << " failed : Unexpected exception " << std::endl;
    return -1;
  }
  return 0;
}


bool
copyFile(const string& fileName, const string& modelDir, const string& compilationDir) {
  string compilationDir1 = prettyPath(compilationDir);
  string modelDir1 = prettyPath(modelDir);
  string inputFile = absolute(fileName, modelDir1);
  string outputFile = absolute(fileName, compilationDir1);
  if (exists(inputFile) && inputFile != outputFile) {
    if (exists(outputFile))
      remove(outputFile);
    copy(inputFile, outputFile);
  }
  return inputFile == outputFile;
}

void
modelicaCompile(const string& modelName, const string& compilationDir,
        const vector<string>&  initFiles, const vector<string>& moFiles, bool& withInitFile, const string& packageName, bool noInit, bool useAliasing) {
  string compilationDir1 = prettyPath(compilationDir);
  string scriptsDir1 = getMandatoryEnvVar("DYNAWO_SCRIPTS_DIR");
  string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");

  // input FILES
  string moFile = absolute(modelName + ".mo", compilationDir1);
  string extVarFile = absolute(modelName + ".extvar", compilationDir1);
  string initFile = absolute(modelName + "_INIT.mo", compilationDir1);
  string modelTmpFile = absolute(modelName + "-tmp.mo", compilationDir1);   // output file of varExt.py script in mode --pre
  string cFile = absolute(packageName + modelName + ".c", compilationDir1);
  string cInitFile = absolute(packageName + modelName + "_INIT.c", compilationDir1);

  if (!exists(moFile))
    throw DYNError(DYN::Error::MODELER, MissingModelicaFile, moFile);

  // We pass the scriptVarExt.py on the .mo compilation
  std::cout << " Creation of " << moFile << " file with external variables" << std::endl;
  string varExtCommand = pythonCmd + " " + scriptsDir1 + "/scriptVarExt.py --fileVarExt=" + extVarFile + " --file=" + moFile + " --pre";

  bool doPrintLogs = true;
  string result = executeCommand(varExtCommand, doPrintLogs);
  if (!exists(absolute(modelName + "-tmp.mo", compilationDir1)))
    throw DYNError(DYN::Error::MODELER, ModelCompilationFailed, modelName);

  std::cout << "output dir : " << compilationDir << std::endl;

  // generate C/CPP files
  vector<string> libs(moFiles);
  string error = compileModelicaToC(modelName, modelTmpFile, libs, compilationDir, packageName, useAliasing);
  if (!exists(cFile))
    throw DYNError(DYN::Error::MODELER, OMCompilationFailed, modelName, error);

  if (!noInit) {
    // generate C/CPP files for INIT file
    withInitFile = exists(initFile);
    if (withInitFile) {
      vector<string> libs1 = libs;
      for (unsigned int i = 0; i < initFiles.size(); ++i)
        libs1.push_back(initFiles[i]);  // some libs for .mo can be used for _INIT.mo

      error = compileModelicaToC(modelName + "_INIT", initFile, libs1, compilationDir, packageName, useAliasing);

      if (!exists(cInitFile))
        throw DYNError(DYN::Error::MODELER, OMCompilationFailed, modelName+ "_INIT", error);
    }
  }

  // we generate the XML file for structuring the model
  compileModelicaToXML(modelName, modelTmpFile, libs, compilationDir, packageName, useAliasing);
}


///< Add a header to a .mos file

void mosAddHeader(const string& mosFilePath, ofstream& mosFile) {
  mosFile << "// File automatically generated by Dynawo (private RTE software)" << std::endl;
  mosFile << "// In order to run this file, run the following command" << std::endl;
  mosFile << "// (PATH_TO)omcDynawo " << mosFilePath;
  mosFile << "// WARNING : the generated code will be located in the current (command line) directory" << std::endl;

  mosFile << std::endl;
}


///< Add files import to a .mos file

void mosAddFilesImport(const bool importModelicaPackage, const vector<string>& filesToImport, ofstream& mosFile) {
  if (importModelicaPackage) {
    mosFile << "// .. Load Modelica package" << std::endl;
    mosFile << "loadModel(Modelica); getErrorString();" << std::endl;
    mosFile << std::endl;
  }

  if (filesToImport.size() > 0) {
    mosFile << "// .. Load custom files" << std::endl;
    for (vector<string>::const_iterator itFile = filesToImport.begin(); itFile != filesToImport.end(); ++itFile) {
      mosFile << "loadFile(\"" << boost::replace_all_copy(*itFile, "\\", "/") << "\"); getErrorString();" << std::endl;
    }
  }
  mosFile << std::endl;
}


///< Run a given .mos file

string
mosRunFile(const string& mosFilePath, const string& path) {
  // OMC generates sources where it runs ... :(
  stringstream modelicaCommand;
  modelicaCommand << "omcDynawo " << mosFilePath;
  string command = modelicaCommand.str();

  bool doPrintLogs = true;
  string result = executeCommand(command, doPrintLogs, path);

  string error = "\n";
  istringstream stream(result);
  string line;
  while (std::getline(stream, line)) {
    if (line.find("{\"Error: ")!= string::npos || (line.find("Error:") != string::npos && line.find(".mo") != string::npos &&
        line.find("Function parameter im was not given by the function call") == string::npos))
      error += line + "\n";
  }
  return error;
}

string
runOptions(bool useAliasing) {
  return string("simCodeTarget=C +showErrorMessages -g=Modelica "
      "-d=visxml,infoXmlOperations,initialization,disableSingleFlowEq,failtrace,dumpSimCode --postOptmodules-=wrapFunctionCalls")
      + (useAliasing?string():string(" --preOptModules-=comSubExp,removeSimpleEquations")) +string(" +numProcs=1 +daeMode ");
}

string
compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs,
    const string& compilationDir, const string& packageName, bool useAliasing) {
  // Create a .mos file
  string mosFileName = "compileModelicaToC-" + modelName + ".mos";
  ofstream mosFile(absolute(mosFileName, compilationDir).c_str(), ios::out | ios::trunc);

  // add header
  mosAddHeader(mosFileName, mosFile);

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  // add Modelica transcription
  mosFile << "// Translate model from Modelica to C/C++" << std::endl;
  mosFile << "setCommandLineOptions(\"" << runOptions(useAliasing) << "\");" << std::endl;
  mosFile << "instantiateModel(" << packageName << modelName << "); getErrorString();" << std::endl;
  mosFile << "translateModel(" << packageName << modelName << "); getErrorString();" << std::endl;

  mosFile.close();

  // run the generated .mos file
  return mosRunFile(mosFileName, prettyPath(compilationDir));
}

void
compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs, const string& compilationDir,
        const string& packageName, bool useAliasing) {
  // Create a .mos file
  string mosFileName = "createStructure-" + modelName + ".mos";
  ofstream mosFile(absolute(mosFileName, compilationDir).c_str(), ios::out | ios::trunc);

  // add header
  mosAddHeader(mosFileName, mosFile);
  mosFile << "setCommandLineOptions(\"" << runOptions(useAliasing) << "\");" << std::endl;

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  mosFile << "// .. Generate the specific information file" << std::endl;
  mosFile << "createXML2RTE(" << packageName << modelName << ",\"\");" << std::endl;

  mosFile.close();

  // run the .mos file (without run options) to generate the .xml file
  mosRunFile(mosFileName, prettyPath(compilationDir));
}

void
generateModelFile(const string& modelName, const string& compilationDir, bool& withInitFile,
    const string& additionalHeaderList, const string& packageName, bool genCalcVars) {
  string scriptsDir1 = getMandatoryEnvVar("DYNAWO_SCRIPTS_DIR");
  string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");
  string varExtCommand = pythonCmd + " " + scriptsDir1 + "/writeModel.py -m " + packageName + modelName + " -i " + compilationDir + " -o " + compilationDir;
  if (!genCalcVars)
    varExtCommand+=" -c";
  if (!additionalHeaderList.empty())
    varExtCommand += " -a " + additionalHeaderList;
  if (withInitFile)
    varExtCommand += " --init";
  if (!packageName.empty())
    varExtCommand += " --package-name " + packageName;

  bool doPrintLogs = true;
  string result = executeCommand(varExtCommand, doPrintLogs);
}

void
generateEvalJFile(const string& modelName, const string& compilationDir, bool withInitFile) {
  string scriptsDir1 = getMandatoryEnvVar("DYNAWO_SCRIPTS_DIR");
  string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");
  // string varExtCommand = pythonCmd + " " + scriptsDir1 + "/writeModel.py -m " + packageName + modelName + " -i " + compilationDir + " -o " + compilationDir;

  string varExtCommand = "/home/bureaugau/Projects/TestGPT/generateEvalJ.sh " + compilationDir + " " + modelName + " " + "Model" + modelName;
  if (withInitFile)
    varExtCommand += " true";
  else
    varExtCommand += " false";

  bool doPrintLogs = true;

  string result = executeCommand(varExtCommand, doPrintLogs);
}

void
compileLib(const string& modelName, const string& compilationDir) {
  string scriptsDir = prettyPath(getMandatoryEnvVar("DYNAWO_SCRIPTS_DIR"));

  // Check some environment variables that are mandatory for CMake compilation
  vector<string> envVariableToCheck;
  envVariableToCheck.push_back("DYNAWO_INSTALL_DIR");
  envVariableToCheck.push_back("DYNAWO_ADEPT_INSTALL_DIR");
  envVariableToCheck.push_back("DYNAWO_SUITESPARSE_INSTALL_DIR");
  envVariableToCheck.push_back("DYNAWO_SUNDIALS_INSTALL_DIR");
  envVariableToCheck.push_back("DYNAWO_INSTALL_OPENMODELICA");
  envVariableToCheck.push_back("DYNAWO_XERCESC_INSTALL_DIR");
  envVariableToCheck.push_back("DYNAWO_LIBXML_HOME");
  for (size_t i = 0, iEnd = envVariableToCheck.size(); i < iEnd; ++i) {
    if (!hasEnvVar(envVariableToCheck[i]))
      throw DYNError(DYN::Error::GENERAL, MissingEnvironmentVariable, envVariableToCheck[i]);
  }

  ofstream cmakeFile(absolute("CMakeLists.txt", compilationDir).c_str(), ios::out | ios::trunc);

  cmakeFile << "cmake_minimum_required(VERSION 3.9.6)" << std::endl;
  cmakeFile << "PROJECT(model CXX)" << std::endl;
  cmakeFile << "include(" << boost::replace_all_copy(absolute("compileCppModelicaModelInDynamicLib.cmake", scriptsDir), "\\", "/") << ")" << std::endl;

  cmakeFile.close();

  string compileLibCommand = "cmake -B" + compilationDir + " -H" + compilationDir + " -C" + absolute("PreloadCache.cmake", scriptsDir)
#if __linux__
                           + " -DMODEL_NAME=" + modelName + " -DCMAKE_SKIP_BUILD_RPATH=True && { cmake --build " + compilationDir + " || cmake --build " + compilationDir + " > /dev/null; }";
#else
                           + " -DMODEL_NAME=" + modelName + " && cmake --build " + compilationDir;
#endif
  bool doPrintLogs = true;
  string result = executeCommand(compileLibCommand, doPrintLogs);

  return;
}

bool verifySharedObject(const string& library) {
  try {
    boost::dll::shared_library lib(library);
    static_cast<void>(lib);
    // we don't use the lib as we check that the library is loadable, which is done in
    // constructor
  }
  catch(const std::exception& e) {
    std::cerr << e.what() << std::endl;
    std::cout << " DYNCompileModelicaModel: could not open " << library << " by boost dll." << std::endl;
    return false;
  }

  // verify links.
#ifdef __linux__
  string command = "ldd -r " + library;
  bool doPrintLogs = true;
  string result = executeCommand(command, doPrintLogs);
  bool valid = result.find("undefined symbol") == string::npos;
#else
  bool valid = true;
#endif
  return valid;
}

string executeCommand(const string& command, const bool printLogs, const string& start_dir) {
  stringstream ss;
  executeCommand(command, ss, start_dir);
  if (printLogs) {
    std::cout << ss.str() << std::endl;
  }

  return ss.str();
}
