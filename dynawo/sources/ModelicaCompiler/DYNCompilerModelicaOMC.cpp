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

// ------------------------------------------------------------------------------
//  Projet        : Modeles
//  Sous-ensemble : Dynawo
// ------------------------------------------------------------------------------
//  (c) RTE 2013
// ------------------------------------------------------------------------------
//  Description :
//    Compile modelica files
// ------------------------------------------------------------------------------
#include <string>
#include <vector>
#include <iomanip>
#include <iostream>
#include <fstream>
#include <dlfcn.h>

#include <boost/program_options.hpp>

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
using std::ios;
using DYN::Trace;

namespace po = boost::program_options;

static void modelicaCompile(const string& modelName, const string& outputDir, const vector<string>& initFiles,
                            const vector<string>& moFiles,
                            bool& withInitFile);  ///< Convert the whole (INIT when relevant + standard) Modelica model into a C++ model
static void compileLib(const string& modelName, const string& libName, const string& outputDir);  ///< Compile the C++ model
static string executeCommand(const string& command, const bool printLogs);  ///< Run a given command and return logs
static void compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                               const string& outputDir);  ///< Convert one (INIT or standard) Modelica model into C code
static void compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs,
                                 const string& outputDir);  ///< Generate the .xml file describing the model parameters and variables
static void generateModelFile(const string& modelName, const string& outputDir,
                              bool& withInitFile,
                              const string& additionalHeaderList);  ///< Rewrite parts of one whole Modelica model C/C++ code to fit Dynawo C/C++ requirements
static void removeTemporaryFiles(const string& modelName, const string& outputDir, bool rmModels);  ///< remove temporary compilation files
static bool verifySharedObject(const string& library);  ///< Ensure that the generated compiled library can actually run

static void mosAddHeader(const string& mosFilePath, const string& runOptions, ofstream& mosFile);  ///< Add a header to the .mos file
static void mosAddFilesImport(const bool importModelicaPackage, const vector<string>& filesToImport,
                              ofstream& mosFile);  ///< Add files import commands to a .mos file
static void mosRunFile(const string& mosFilePath, const string& runOptions);  ///< Run a given .mos file

int main(int argc, char ** argv) {
  Trace::init();

  string libName = "";
  string modelName = "";
  string outputDir = ".";
  string inputDir = "";
  string additionalHeaderList;
  po::options_description desc;
  vector<string> moFiles;
  vector<string> initFiles;
  bool rmModels = true;

  desc.add_options()
          ("help,h", "produce help message")
          ("model", po::value<string>(&modelName), "set the model name of the file to compile (model.mo needs to be in output-dir)")
          ("input-dir", po::value<string>(&inputDir), "set input directory (default : output directory)")
          ("output-dir", po::value<string>(&outputDir), "set output directory (default : current directory)")
          ("moFiles", po::value< vector<string> >(&moFiles)->multitoken(), "modelica files to use for expansion")
          ("initFiles", po::value< vector<string> >(&initFiles)->multitoken(), "init files to use for expansion")
          ("lib", po::value<string>(&libName), "set the name of the output lib")
          ("remove-model-files", po::value<bool>(&rmModels), "if true the .mo input files will be deleted (default : true)")
          ("additionalHeaderList", po::value< string >(&additionalHeaderList),
              "list of headers that should be included in the dynamic model files");

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
  int size = string("compilerModelicaOMC").size();
  fullPathBin.erase(fullPathBin.end() - size, fullPathBin.end());  // erase the name of the binary file
  string installDir = prettyPath(fullPathBin + "/../");  // the binary is in the sbin directory, so the install dir is in sbin/../
  if (!is_directory(outputDir))
    create_directory(outputDir);
  string outputDir1 = prettyPath(outputDir);
  if (!is_directory(inputDir))
    throw DYNError(DYN::Error::MODELER, MissingModelicaFile, absolute(modelName + ".mo", inputDir));
  string inputDir1 = prettyPath(inputDir);
  string inputMoFile = absolute(modelName + ".mo", inputDir1);
  string inputExtVarFile = absolute(modelName + ".xml", inputDir1);
  string inputInitFile = absolute(modelName + "_INIT.mo", inputDir1);
  string outputMoFile = absolute(modelName + ".mo", outputDir1);
  string outputExtVarFile = absolute(modelName + ".xml", outputDir1);
  string outputInitFile = absolute(modelName + "_INIT.mo", outputDir1);
  if (exists(inputMoFile) && inputMoFile != outputMoFile) {
    if (exists(outputMoFile))
      remove(outputMoFile);
    copy(inputMoFile, outputMoFile);
  }
  // Force file deletion if input folder is not output folder to avoid having the model copy in the output folder.
  // Otherwise follows user instruction
  if (inputMoFile != outputMoFile)
    rmModels = true;
  if (exists(inputExtVarFile) && inputExtVarFile != outputExtVarFile) {
    if (exists(outputExtVarFile))
      remove(outputExtVarFile);
    copy(inputExtVarFile, outputExtVarFile);
  }
  if (exists(inputInitFile) && inputInitFile != outputInitFile) {
    if (exists(outputInitFile))
      remove(outputInitFile);
    copy(inputInitFile, outputInitFile);
  }

  // Launch the compile of the model
  try {
    boost::shared_ptr<DYN::IoDicos> dicos = DYN::IoDicos::getInstance();
    dicos->addPath(getEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos->addDicos(getEnvVar("DYNAWO_DICTIONARIES"));

    // Create .c, .h and .xml files from .mo
    bool withInitFile = false;
    modelicaCompile(modelName, outputDir1, initFiles, moFiles, withInitFile);

    // generate the .cpp file from the previous files
    generateModelFile(modelName, outputDir1, withInitFile, additionalHeaderList);

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
        removeTemporaryFiles(modelName, outputDir1, rmModels);
        bool valid = verifySharedObject(lib);
        if (!valid)
          throw DYNError(DYN::Error::MODELER, FileGenerationFailed, lib);
      }
    }

    std::cout << " Compilation of " << modelName << " succeeded " << std::endl;
  } catch (const string& s) {
    std::cerr << " Compilation of " << modelName << " failed :" << s << std::endl;
  } catch (const char *s) {
    std::cerr << " Compilation of " << modelName << " failed :" << s << std::endl;
  } catch (const DYN::Error& e) {
    std::cerr << " Compilation of " << modelName << " failed :" << e << std::endl;
  } catch (...) {
    std::cerr << " Compilation of " << modelName << " failed : Unexpected exception " << std::endl;
  }
}

void
modelicaCompile(const string& modelName, const string& outputDir,
        const vector<string>&  initFiles, const vector<string>& moFiles, bool& withInitFile) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");

  // input FILES
  string moFile = absolute(modelName + ".mo", outputDir1);
  string extVarFile = absolute(modelName + ".xml", outputDir1);
  string initFile = absolute(modelName + "_INIT.mo", outputDir1);
  string modelTmpFile = absolute(modelName + "-tmp.mo", outputDir1);   // output file of varExt.py script in mode --pre
  string cFile = absolute(modelName + ".c", outputDir1);
  string cInitFile = absolute(modelName + "_INIT.c", outputDir1);

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
  compileModelicaToC(modelName, modelTmpFile, libs, outputDir);
  if (!exists(cFile))
    throw DYNError(DYN::Error::MODELER, FileGenerationFailed, cFile);

  // generate C/CPP files for INIT file
  withInitFile = exists(initFile);
  if (withInitFile) {
    vector<string> libs1 = libs;
    for (unsigned int i = 0; i < initFiles.size(); ++i)
      libs1.push_back(initFiles[i]);  // some libs for .mo can be used for _INIT.mo

    compileModelicaToC(modelName + "_INIT", initFile, libs1, outputDir);

    if (!exists(cInitFile))
      throw DYNError(DYN::Error::MODELER, FileGenerationFailed, cInitFile);
  }

  // we generate the XML file for structuring the model
  compileModelicaToXML(modelName, modelTmpFile, libs, outputDir);

  current_path(currentPath);
}


///< Add a header to a .mos file

void mosAddHeader(const string& mosFilePath, const string& runOptions, ofstream& mosFile) {
  mosFile << "// File automatically generated by Dynawo (private RTE software)" << std::endl;
  mosFile << "// In order to run this file, run the following command" << std::endl;
  mosFile << "// (PATH_TO)omcDynawo " << mosFilePath;
  if ((!runOptions.empty())&& (runOptions.length() > 0)) {
    mosFile << " " << runOptions;
  }
  mosFile << std::endl;
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

void mosRunFile(const string& mosFilePath, const string& runOptions) {
  stringstream modelicaCommand;
  modelicaCommand << "omcDynawo ";
  if ((!runOptions.empty())&& (runOptions.length() > 0)) {
    modelicaCommand << runOptions << " ";
  }
  modelicaCommand << mosFilePath;
  string command = modelicaCommand.str();

  bool doPrintLogs = true;
  string result = executeCommand(command, doPrintLogs);
}

void
compileModelicaToC(const string& modelName, const string& fileToCompile, const vector<string>& libs, const string& /*outputDir*/) {
  // Create a .mos file
  string mosFileName = "compileModelicaToC-" + modelName + ".mos";
  ofstream mosFile(mosFileName.c_str(), ios::out | ios::trunc);

  // add header
  string runOptions("+simCodeTarget=C +showErrorMessages +g=Modelica +d=initialization +d=disableSingleFlowEq +d=failtrace --numProcs=1");
  // runOptions += " --initOptModules-=calculateStrongComponentJacobians";
  // runOptions += " --preOptModules-=comSubExp --preOptModules-=clockPartitioning";
  // runOptions += " --postOptModules-=detectJacobianSparsePattern --disableLinearTearing --removeSimpleEquations=none";
  // runOptions += " --postOptModules-=removeSimpleEquations --indexReductionMethod=uode --tearingMethod=omcTearing";
  const string noOptions("");
  mosAddHeader(mosFileName, noOptions, mosFile);

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  // add Modelica transcription
  mosFile << "// Translate model from Modelica to C/C++" << std::endl;
  mosFile << "setCommandLineOptions(\"" << runOptions << "\");" << std::endl;
  mosFile << "instantiateModel(" << modelName << "); getErrorString();" << std::endl;
  mosFile << "translateModel(" << modelName << "); getErrorString();" << std::endl;

  mosFile.close();

  // run the generated .mos file
  mosRunFile(mosFileName, noOptions);
}

void
compileModelicaToXML(const string& modelName, const string& fileToCompile, const vector<string>& libs, const string& /*outputDir*/) {
  // Create a .mos file
  string mosFileName = "createStructure-" + modelName + ".mos";
  ofstream mosFile(mosFileName.c_str(), ios::out | ios::trunc);

  // add header
  string runOptions("");
  mosAddHeader(mosFileName, runOptions, mosFile);

  // add Modelica and library files import
  bool importModelicaPackage = true;
  vector <string> allFilesToImport = libs;
  allFilesToImport.push_back(fileToCompile);
  mosAddFilesImport(importModelicaPackage, allFilesToImport, mosFile);

  mosFile << "// .. Generate the specific information file" << std::endl;
  mosFile << "createXML2RTE(" << modelName << ",\"\");" << std::endl;

  mosFile.close();

  // run the .mos file (without run options) to generate the .xml file
  mosRunFile(mosFileName, runOptions);
}

void
generateModelFile(const string& modelName, const string& outputDir, bool& withInitFile, const string& additionalHeaderList) {
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");
  string varExtCommand = "python " + scriptsDir1 + "/writeModel.py -m " + modelName + " -i " + outputDir + " -o " + outputDir;
  if (!additionalHeaderList.empty())
    varExtCommand += " -a " + additionalHeaderList;
  if (withInitFile)
    varExtCommand += " --init";

  bool doPrintLogs = true;
  string result = executeCommand(varExtCommand, doPrintLogs);
}

void
compileLib(const string& modelName, const string& libName, const string& outputDir) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");

  string compileLibCommand = scriptsDir1 + "/compileLibModelicaOMC --model-name=" + modelName + " --directory=" + outputDir1 + " --lib-name=" + libName;

#ifdef _DEBUG_
  compileLibCommand += " --debug";
#endif

  bool doPrintLogs = true;
  string result = executeCommand(compileLibCommand, doPrintLogs);

  return;
}

void
removeTemporaryFiles(const string& modelName, const string& outputDir, bool rmModels) {
  string outputDir1 = prettyPath(outputDir);
  string scriptsDir1 = getEnvVar("DYNAWO_SCRIPTS_DIR");
  string commandRemove = scriptsDir1 + "/cleanCompilerModelicaOMC --model=" + modelName + " --directory=" + outputDir1;
  if (!rmModels)
    commandRemove += " --do-not-remove-model-files";
#ifdef _DEBUG_
  commandRemove += " --debug";
#endif

  bool doPrintLogs = true;
  string result = executeCommand(commandRemove, doPrintLogs);
}

bool verifySharedObject(const string& library) {
  // dlopen include <dlfcn.h>: to see if a shared object file
  const char* filename = library.c_str();
  void *handle;
  handle = dlopen(filename, RTLD_LAZY);
  if (!handle) {
    fprintf(stderr, "%s\n", dlerror());
    printf(" Could not open .so by dlopen. ");
    return false;
  }
  dlclose(handle);

  // verify links.
  string command = "ldd -r " + library;
  bool doPrintLogs = true;
  string result = executeCommand(command, doPrintLogs);
  bool valid = result.find("undefined symbol") == string::npos;

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
