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
#include <sstream>
#include <fstream>
#include <dlfcn.h>

#include <boost/program_options.hpp>
#include <boost/algorithm/string/replace.hpp>

#include "DYNIoDico.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"

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

static void modelicaCompile(const string& modelName, const string& outputDir, const vector<string>& initFiles,
                            const vector<string>& moFiles,
                            bool& withInitFile,
                            const string& packageName,
                            bool noInit);  ///< Convert the whole (INIT when relevant + standard) Modelica model into a C++ model
static void compileLib(const string& modelName, const string& libName, const string& outputDir);  ///< Compile the C++ model
static string executeCommand(const string& command, const bool printLogs);  ///< Run a given command and return logs
static string compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                               const string& outputDir, const string& packageName);  ///< Convert one (INIT or standard) Modelica model into C code
static string runOptions();  ///< Return modelica run options
static void compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                                 const string& outputDir,
                                 const string& packageName);  ///< Generate the .xml file describing the model parameters and variables
static void generateModelFile(const string& modelName, const string& outputDir,
                              bool& withInitFile,
                              const string& additionalHeaderList,
                              const string& packageName);  ///< Rewrite parts of one whole Modelica model C/C++ code to fit Dynawo C/C++ requirements
static void removeTemporaryFiles(const string& modelName, const string& outputDir, bool rmModels,
                                const string& packageName);  ///< remove temporary compilation files
static bool verifySharedObject(const string& library);  ///< Ensure that the generated compiled library can actually run

static void mosAddHeader(const string& mosFilePath, ofstream& mosFile);  ///< Add a header to the .mos file
static void mosAddFilesImport(const bool importModelicaPackage, const vector<string>& filesToImport,
                              ofstream& mosFile);  ///< Add files import commands to a .mos file
static string mosRunFile(const string& mosFilePath);  ///< Run a given .mos file
static bool copyInputFile(const string& fileName,
    const string& inputDir, const string& outputDir);  ///< copy input file into the output folder, return true if the input file is equal to the output file
int main(int argc, char ** argv) {
  Trace::init();

  string libName = "";
  string modelName = "";
  string outputDir = ".";
  string inputDir = "";
  string additionalHeaderList;
  string packageName = "";
  po::options_description desc;
  vector<string> moFiles;
  vector<string> initFiles;
  bool rmModels = false;
  bool noInit = false;

  desc.add_options()
          ("help,h", "produce help message")
          ("model", po::value<string>(&modelName), "set the model name of the file to compile (model.mo needs to be in output-dir)")
          ("input-dir", po::value<string>(&inputDir), "set input directory (default: output directory)")
          ("output-dir", po::value<string>(&outputDir), "set output directory (default: current directory)")
          ("moFiles", po::value< vector<string> >(&moFiles)->multitoken(), "modelica files to use for expansion")
          ("initFiles", po::value< vector<string> >(&initFiles)->multitoken(), "init files to use for expansion")
          ("lib", po::value<string>(&libName), "set the name of the output lib")
          ("remove-model-files", po::value<bool>(&rmModels), "if true the .mo input files will be deleted (default: false)")
          ("additionalHeaderList", po::value< string >(&additionalHeaderList),
              "list of headers that should be included in the dynamic model files")
          ("package-name", po::value<string>(&packageName), "set the model name package")
          ("no-init", po::value<bool>(&noInit)->implicit_value(true), "avoid building init problem for model");

  po::variables_map vm;
  // parse regular options
  po::store(po::parse_command_line(argc, argv, desc), vm);
  po::notify(vm);
  if (vm.count("help")) {
    cout << desc << endl;
    return 0;
  } else if (modelName == "") {
    cout << " Model name is required " << endl;
    cout << desc << endl;
    return 1;
  }
  if (inputDir == "") {
    inputDir = outputDir;
  }

  // find the current installDir
  string currentPath = prettyPath(current_path());
  string argvs = prettyPath(string(argv[0]));
  string fullPathBin = "";
  if (argvs.substr(0, 1) == "/") {  // fullPath
    fullPathBin = argvs;
  } else {
    fullPathBin = prettyPath(currentPath + "/" + argvs);  // construct the full path of the binary
  }
  int size = string("compileModelicaModel").size();
  fullPathBin.erase(fullPathBin.end() - size, fullPathBin.end());  // erase the name of the binary file
  string installDir = prettyPath(fullPathBin + "/../");  // the binary is in the sbin directory, so the install dir is in sbin/../

  // Prepare workspace
  if (!is_directory(outputDir))
    create_directory(outputDir);
  if (!is_directory(inputDir))
    throw DYNError(DYN::Error::MODELER, MissingModelicaInputFolder, inputDir);
  bool moFilesEqual = copyInputFile(modelName + ".mo", inputDir, outputDir);
  copyInputFile(modelName + ".extvar", inputDir, outputDir);
  copyInputFile(modelName + "_INIT.mo", inputDir, outputDir);
  // Force file deletion if input folder is not output folder to avoid having the model copy in the output folder.
  // Otherwise follows user instruction
  if (!moFilesEqual)
    rmModels = true;

  string outputDir1 = prettyPath(outputDir);

  // Launch the compile of the model
  try {
    boost::shared_ptr<DYN::IoDicos> dicos = DYN::IoDicos::getInstance();
    dicos->addPath(getEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos->addDicos(getEnvVar("DYNAWO_DICTIONARIES"));

    // Create .c, .h and .xml files from .mo
    bool withInitFile = false;
    modelicaCompile(modelName, outputDir1, initFiles, moFiles, withInitFile, packageName, noInit);

    // generate the .cpp file from the previous files
    generateModelFile(modelName, outputDir1, withInitFile, additionalHeaderList, packageName);

    // Creation of the lib .so
    if (libName != "") {
      // 1) on efface la lib a generer
      string lib = outputDir1 + "/" + libName;
      remove(lib);
      // 2) attempt to generate the lib
      compileLib(modelName, libName, outputDir1);
      // 3) if lib does not exist, we raise an error
      if (!exists(lib)) {
        throw DYNError(DYN::Error::MODELER, FileGenerationFailed, lib);
      } else {
        removeTemporaryFiles(modelName, outputDir1, rmModels, packageName);
        bool valid = verifySharedObject(lib);
        if (!valid)
          throw DYNError(DYN::Error::MODELER, FileGenerationFailed, lib);
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
copyInputFile(const string& fileName, const string& inputDir, const string& outputDir) {
  string outputDir1 = prettyPath(outputDir);
  string inputDir1 = prettyPath(inputDir);
  string inputFile = absolute(fileName, inputDir1);
  string outputFile = absolute(fileName, outputDir1);
  if (exists(inputFile) && inputFile != outputFile) {
    if (exists(outputFile))
      remove(outputFile);
    copy(inputFile, outputFile);
  }
  return inputFile == outputFile;
}

void
modelicaCompile(const string& modelName, const string& outputDir,
        const vector<string>&  initFiles, const vector<string>& moFiles, bool& withInitFile, const string& packageName, bool noInit) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");

  // input FILES
  string moFile = absolute(modelName + ".mo", outputDir1);
  string extVarFile = absolute(modelName + ".extvar", outputDir1);
  string initFile = absolute(modelName + "_INIT.mo", outputDir1);
  string modelTmpFile = absolute(modelName + "-tmp.mo", outputDir1);   // output file of varExt.py script in mode --pre
  string cFile = absolute(packageName + modelName + ".c", outputDir1);
  string cInitFile = absolute(packageName + modelName + "_INIT.c", outputDir1);

  if (!exists(moFile))
    throw DYNError(DYN::Error::MODELER, MissingModelicaFile, moFile);

  // We pass the scriptVarExt.py on the .mo compilation
  std::cout << " Creation of " << moFile << " file with external variables" << std::endl;
  string varExtCommand = "python " + scriptsDir1 + "/scriptVarExt.py --fileVarExt=\"" + extVarFile + "\" --file=\"" + moFile + "\" --pre";

  bool doPrintLogs = true;
  string result = executeCommand(varExtCommand, doPrintLogs);

  // OMC generates sources where it runs ... :(
  // WARNING : not thread-safe
  // @TODO : modify OMC to allow thread-safe modelica compilation
  string currentPath = current_path();

  current_path(outputDir);
  std::cout << "output dir : " << outputDir << std::endl;

  // generate C/CPP files
  vector<string> libs(moFiles);
  string error = compileModelicaToC(modelName, modelTmpFile, libs, outputDir, packageName);
  if (!exists(cFile))
    throw DYNError(DYN::Error::MODELER, OMCompilationFailed, modelName, error);

  if (!noInit) {
    // generate C/CPP files for INIT file
    withInitFile = exists(initFile);
    if (withInitFile) {
      vector<string> libs1 = libs;
      for (unsigned int i = 0; i < initFiles.size(); ++i)
        libs1.push_back(initFiles[i]);  // some libs for .mo can be used for _INIT.mo

      error = compileModelicaToC(modelName + "_INIT", initFile, libs1, outputDir, packageName);

      if (!exists(cInitFile))
        throw DYNError(DYN::Error::MODELER, OMCompilationFailed, modelName+ "_INIT", error);
    }
  }

  // we generate the XML file for structuring the model
  compileModelicaToXML(modelName, modelTmpFile, libs, outputDir, packageName);

  current_path(currentPath);
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
      mosFile << "loadFile(\"" << *itFile << "\"); getErrorString();" << std::endl;
    }
  }
  mosFile << std::endl;
}


///< Run a given .mos file

string
mosRunFile(const string& mosFilePath) {
  stringstream modelicaCommand;
  modelicaCommand << "omcDynawo ";
  modelicaCommand << mosFilePath;
  string command = modelicaCommand.str();

  bool doPrintLogs = true;
  string result = executeCommand(command, doPrintLogs);

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
runOptions() {
  if (getEnvVar("DYNAWO_OPENMODELICA_VERSION") == "1_9_4")
    return "+simCodeTarget=C +showErrorMessages +g=Modelica +d=initialization +d=disableSingleFlowEq +d=failtrace --numProcs=1";
  return "simCodeTarget=C +showErrorMessages -g=Modelica "
      "-d=visxml,infoXmlOperations,initialization,disableSingleFlowEq,failtrace,dumpSimCode +numProcs=1 +daeMode";
}

string
compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs, const string& /*outputDir*/, const string& packageName) {
  // Create a .mos file
  string mosFileName = "compileModelicaToC-" + modelName + ".mos";
  ofstream mosFile(mosFileName.c_str(), ios::out | ios::trunc);

  // add header
  mosAddHeader(mosFileName, mosFile);

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  // add Modelica transcription
  mosFile << "// Translate model from Modelica to C/C++" << std::endl;
  mosFile << "setCommandLineOptions(\"" << runOptions() << "\");" << std::endl;
  mosFile << "instantiateModel(" << packageName << modelName << "); getErrorString();" << std::endl;
  mosFile << "translateModel(" << packageName << modelName << "); getErrorString();" << std::endl;

  mosFile.close();

  // run the generated .mos file
  return mosRunFile(mosFileName);
}

void
compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs, const string& /*outputDir*/,
        const string& packageName) {
  // Create a .mos file
  string mosFileName = "createStructure-" + modelName + ".mos";
  ofstream mosFile(mosFileName.c_str(), ios::out | ios::trunc);

  // add header
  mosAddHeader(mosFileName, mosFile);
  mosFile << "setCommandLineOptions(\"" << runOptions() << "\");" << std::endl;

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  mosFile << "// .. Generate the specific information file" << std::endl;
  mosFile << "createXML2RTE(" << packageName << modelName << ",\"\");" << std::endl;

  mosFile.close();

  // run the .mos file (without run options) to generate the .xml file
  mosRunFile(mosFileName);
}

void
generateModelFile(const string& modelName, const string& outputDir, bool& withInitFile, const string& additionalHeaderList, const string& packageName) {
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");
  string varExtCommand = "python " + scriptsDir1 + "/writeModel.py -m " + packageName + modelName + " -i " + outputDir + " -o " + outputDir;
  if (!additionalHeaderList.empty())
    varExtCommand += " -a " + additionalHeaderList;
  if (withInitFile)
    varExtCommand += " --init";
  if (packageName != "")
    varExtCommand += " --package-name " + packageName;

  bool doPrintLogs = true;
  string result = executeCommand(varExtCommand, doPrintLogs);
}

void
compileLib(const string& modelName, const string& libName, const string& outputDir) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");

  string compileLibCommand = scriptsDir1 + "/compileCppModelicaModelInDynamicLib --model-name=" + modelName
    + " --directory=" + outputDir1 + " --lib-name=" + libName;

#ifdef _DEBUG_
  compileLibCommand += " --debug";
#endif

  bool doPrintLogs = true;
  string result = executeCommand(compileLibCommand, doPrintLogs);

  return;
}

void
removeTemporaryFiles(const string& modelName, const string& outputDir, bool rmModels, const string& packageName) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");
  string commandRemove = scriptsDir1 + "/cleanCompileModelicaModel --model=" + modelName + " --directory=" + outputDir1;
  if (rmModels)
    commandRemove += " --remove-model-files";
#ifdef _DEBUG_
  commandRemove += " --debug";
#endif
  if (packageName != "")
    commandRemove += " --package-name=" + packageName;

  bool doPrintLogs = true;
  string result = executeCommand(commandRemove, doPrintLogs);
}

bool verifySharedObject(const string& library) {
  // dlopen include <dlfcn.h>: to see if a shared object file
  const char* filename = library.c_str();
  void *handle;
  handle = dlopen(filename, RTLD_NOW);
  if (!handle) {
    fprintf(stderr, "%s\n", dlerror());
    printf(" DYNCompileModelicaModel: could not open .so by dlopen.");
    return false;
  }
  dlclose(handle);

  // verify links.
  string command1 = "ldd -r " + library + " | c++filt";
  bool doPrintLogs = true;
  string result = executeCommand(command1, doPrintLogs);
  // In case of static compilation it is expected that symbols about Timer are missing.
  boost::replace_all(result, "'", "\"");
  string command2 = "echo \"" + result + "\" | grep 'undefined' | c++filt | grep -v 'DYN::Timer::~Timer()' | grep -v \"DYN::Timer::Timer([^)]*)\"";
  int returnCode = system(command2.c_str());
  bool valid = (returnCode != 0);
  return valid;
}

string executeCommand(const string& command, const bool printLogs) {
  stringstream ss;
  executeCommand(command, ss);
  if (printLogs) {
    std::cout << ss.str() << std::endl;
  }

  return ss.str();
}
