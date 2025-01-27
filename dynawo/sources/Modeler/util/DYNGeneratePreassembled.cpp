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

/**
 * @file DYNGeneratePreassembled.cpp
 * @brief compile a list of model modelica and verifiy .so linking stats
 */

#include <string>
#include <vector>
#include <iostream>
#include <boost/program_options.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/dll.hpp>
#include <boost/filesystem.hpp>

#include "DYNDynamicData.h"

#include "DYNCommon.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNIoDico.h"
#include "DYNFileSystemUtils.h"
#include "DYNCompiler.h"
#include "DYNExecUtils.h"
#include "DYNInitXml.h"

using std::string;
using std::exception;
using std::endl;
using std::cerr;
using std::cout;
using std::vector;
using DYN::Trace;

using DYN::Compiler;
using DYN::DydAnalyser;
using boost::shared_ptr;

namespace po = boost::program_options;
namespace fs = boost::filesystem;

bool verifySharedObject(string modelname);
std::string verifyModelListFile(const string & modelList, const string & outputPath);
std::string executeCommand1(const string & command);

/**
 *
 * @brief main for dyd lib generator
 *
 */
int main(int argc, char ** argv) {
  string modelList = "";   // model list file
  bool useStandardPrecompiledModels = true;
  string recursivePrecompiledModelsDir = "";   // BDD
  string nonRecursivePrecompiledModelsDir = "";
  string precompiledModelsExtension = DYN::sharedLibraryExtension();
  bool useStandardModelicaModels = true;
  string recursiveModelicaModelsDir = "";
  string nonRecursiveModelicaModelsDir = "";
  string modelicaModelsExtension = "";
  string outputDir = ".";   // output dir
  vector<string> additionalHeaderFiles;   // list of headers that should be included in the dynamic model files
  bool rmModels = false;

  po::options_description desc;

  desc.add_options()
          ("help,h", "produce help message")
          ("model-list", po::value<string>(&modelList), "set model list file (required)")
          ("use-standard-precompiled-models", po::value<bool>(&useStandardPrecompiledModels), "use standard precompiled models (default true)")
          ("recursive-precompiled-models-dir", po::value<string>(&recursivePrecompiledModelsDir), "set precompiled models directory (default DYNAWO_DDB_DIR)")
          ("non-recursive-precompiled-models-dir", po::value<string>(&nonRecursivePrecompiledModelsDir),
              "set precompiled models directory (default DYNAWO_DDB_DIR)")
          ("use-standard-modelica-models", po::value<bool>(&useStandardModelicaModels), "use standard Modelica models (default true)")
          ("recursive-modelica-models-dir", po::value<string>(&recursiveModelicaModelsDir), "set Modelica models directory (default DYNAWO_DDB_DIR)")
          ("non-recursive-modelica-models-dir", po::value<string>(&nonRecursiveModelicaModelsDir), "set Modelica models directory (default DYNAWO_DDB_DIR)")
          ("modelica-models-extension", po::value<string>(&modelicaModelsExtension), "set Modelica models file extension (default .mo)")
          ("output-dir", po::value<string>(&outputDir), "set output directory (default: current directory)")
          ("remove-model-files", po::value<bool>(&rmModels), "if true the .mo input files will be deleted (default: false)")
          ("additional-header-files", po::value< vector<string> >(&additionalHeaderFiles)->multitoken(),
              "list of headers that should be included in the dynamic model files");

  po::variables_map vm;
  // parse regular options
  po::store(po::parse_command_line(argc, argv, desc), vm);
  po::notify(vm);

  if (vm.count("help")) {
    cout << desc << endl;
    return 0;
  } else if ((recursivePrecompiledModelsDir == "" && nonRecursivePrecompiledModelsDir == "")
              || (recursiveModelicaModelsDir == "" && nonRecursiveModelicaModelsDir == "")) {
    cout << " Default BDD Models Directory is used. " << endl;
  }

  if (modelList == "") {
    cout << "You need to give a model list." << endl;
    cout << desc << endl;
    return 1;
  }

  if (modelicaModelsExtension == "") {
    modelicaModelsExtension = ".mo";
  }
  DYN::InitXerces xerces;

  string currentPath = prettyPath(current_path());

  // output directory (default: current directory)
  string absOutputDir = createAbsolutePath(outputDir, currentPath);
  if (!exists(absOutputDir))
    create_directory(absOutputDir);

  string dydFileName = "";
  try {
    dydFileName = verifyModelListFile(modelList, absOutputDir);   // verify the model list file

    // Initializes logs, parsers & dictionnaries for Dynawo
    Trace::init();
    DYN::IoDicos& dicos = DYN::IoDicos::instance();
    dicos.addPath(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos.addDicos(getMandatoryEnvVar("DYNAWO_DICTIONARIES"));

    // Dynamic data import
    shared_ptr<DYN::DynamicData> dyd(new DYN::DynamicData());
    vector<std::string> dydFile;
    dydFile.push_back(dydFileName);
    dyd->setRootDirectory(remove_file_name(dydFileName));
    dyd->initFromDydFiles(dydFile);

    // Compilation
    std::vector <UserDefinedDirectory> precompiledModelsDirs;

    if (recursivePrecompiledModelsDir != "") {
      UserDefinedDirectory dir;
      dir.path = recursivePrecompiledModelsDir;
      dir.isRecursive = true;
      precompiledModelsDirs.push_back(dir);
    }

    if (nonRecursivePrecompiledModelsDir != "") {
      UserDefinedDirectory dir;
      dir.path = nonRecursivePrecompiledModelsDir;
      dir.isRecursive = false;
      precompiledModelsDirs.push_back(dir);
    }

    std::vector <UserDefinedDirectory> modelicaModelsDirs;

    if (recursiveModelicaModelsDir != "") {
      UserDefinedDirectory dir;
      dir.path = recursiveModelicaModelsDir;
      dir.isRecursive = true;
      modelicaModelsDirs.push_back(dir);
    }

    if (nonRecursiveModelicaModelsDir != "") {
      UserDefinedDirectory dir;
      dir.path = nonRecursiveModelicaModelsDir;
      dir.isRecursive = false;
      modelicaModelsDirs.push_back(dir);
    }
    const std::unordered_set<fs::path, PathHash> pathsToIgnore;

    Compiler cf = Compiler(dyd, useStandardPrecompiledModels, precompiledModelsDirs, precompiledModelsExtension,
            useStandardModelicaModels, modelicaModelsDirs, modelicaModelsExtension, pathsToIgnore, additionalHeaderFiles, rmModels, outputDir);
    cf.compile();

    fs::remove(dydFileName);
    vector<string > solist = cf.getCompiledLib();  // get all .so
    vector<string > notValidsolist;

     // verification linking status of shared object
    bool libValid = true;
    for (vector<string >::iterator it = solist.begin(); it != solist.end(); ++it) {
      bool valid = verifySharedObject(*it);  // verification .so
      if (!valid) {
        libValid = false;
        notValidsolist.push_back(*it);
        Trace::info(Trace::compile()) << DYNLog(InvalidModel, *it) << Trace::endline;
      } else {
        Trace::info(Trace::compile()) << DYNLog(ValidatedModel, *it) << Trace::endline;
      }
    }

    if (libValid) {
      Trace::info(Trace::compile()) << DYNLog(PreassembledModelGenerated, solist.size()) << Trace::endline;
    } else {
      Trace::info(Trace::compile()) << DYNLog(InvalidSharedObjects, notValidsolist.size()) << Trace::endline;
      string libList;
      for (vector<string >::iterator it = notValidsolist.begin(); it != notValidsolist.end(); ++it) {
        Trace::info(Trace::compile()) << *it << Trace::endline;
        libList += *it;
      }
      throw DYNError(DYN::Error::MODELER, FileGenerationFailed, libList.c_str());
    }
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    return e.type();
  } catch (const std::exception& exp) {
    Trace::error() << exp.what() << Trace::endline;
    return -1;
  }
  return 0;
}

/**
 * @brief Verify linking status of model .so
 * 1st step: Dlopen --> if a .so file
 * 2nd step: ldd -r --> if exists undefinded symbol
 */

bool verifySharedObject(string modelname) {
  try {
    boost::dll::shared_library lib(modelname);
    static_cast<void>(lib);
    // we don't use the lib as we check that the library is loadable, which is done in
    // constructor
  }
  catch(const std::exception& e) {
    std::cerr << e.what() << '\n';
    printf(" GeneratePreassembled: could not open .so by boost dll.");
    return false;
  }


  // verify links.
#ifdef __linux__
  string command = "ldd -r " + modelname;
  string result = executeCommand1(command);
  bool valid = true;
  if (result.find("undefinded symbol") != std::string::npos)
    valid = false;
#else
  bool valid = true;
#endif
  return valid;
}

/**
 * @brief Verify model list format
 * use script python: scriptVerifyModelList.py
 */
std::string verifyModelListFile(const string & modelList, const string & outputPath) {
  string dydFileName = absolute(replace_extension(file_name(modelList), "dyd"), outputPath);
  string scriptsDir1 = getMandatoryEnvVar("DYNAWO_SCRIPTS_DIR");
  string pythonCmd = "python";
  if (hasEnvVar("DYNAWO_PYTHON_COMMAND"))
    pythonCmd = getEnvVar("DYNAWO_PYTHON_COMMAND");

  // scriptVerifyModelList.py
  std::cout << "Create file: " << dydFileName << std::endl;
  string verifymodellistcommand = pythonCmd + " " + scriptsDir1 + "/scriptVerifyModelList.py --dyd=" + dydFileName + " --model='" + modelList + "'";
  executeCommand1(verifymodellistcommand);
  return dydFileName;
}

/**
 * @brief execute a command
 */
std::string executeCommand1(const std::string & command) {
  std::stringstream ss;
  executeCommand(command, ss);
  std::cout << ss.str() << std::endl;
  return ss.str();
}
