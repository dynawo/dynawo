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
 * @file DYNDydLibGenerator.cpp
 * @brief compile a list of model modelica and verifiy .so linking stats
 */

#include <string>
#include <vector>
#include <iomanip>
#include <iostream>
#include <boost/program_options.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/shared_ptr.hpp>
#include <boost/filesystem.hpp>
#include <dlfcn.h>

#include <xml/sax/parser/ParserException.h>

#include "DYNDynamicData.h"

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNIoDico.h"
#include "DYNFileSystemUtils.h"
#include "DYNCompiler.h"
#include "DYNExecUtils.h"

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
std::string verifyModelListFile(std::string modelList);
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
  string precompiledModelsExtension = "";
  bool useStandardModelicaModels = true;
  string recursiveModelicaModelsDir = "";
  string nonRecursiveModelicaModelsDir = "";
  string modelicaModelsExtension = "";
  string outputDir = ".";   // output dir

  po::options_description desc;

  desc.add_options()
          ("help,h", "produce help message")
          ("model-list", po::value<string>(&modelList), "set model list file (required)")
          ("use-standard-precompiled-models", po::value<bool>(&useStandardPrecompiledModels), "use standard precompiled models (default true)")
          ("recursive-precompiled-models-dir", po::value<string>(&recursivePrecompiledModelsDir), "set precompiled models directory (default DDB_DIR)")
          ("non-recursive-precompiled-models-dir", po::value<string>(&nonRecursivePrecompiledModelsDir), "set precompiled models directory (default DDB_DIR)")
          ("precompiled-models-extension", po::value<string>(&precompiledModelsExtension), "set precompiled models file extension (default .so)")
          ("use-standard-modelica-models", po::value<bool>(&useStandardModelicaModels), "use standard Modelica models (default true)")
          ("recursive-modelica-models-dir", po::value<string>(&recursiveModelicaModelsDir), "set Modelica models directory (default DDB_DIR)")
          ("non-recursive-modelica-models-dir", po::value<string>(&nonRecursiveModelicaModelsDir), "set Modelica models directory (default DDB_DIR)")
          ("modelica-models-extension", po::value<string>(&modelicaModelsExtension), "set Modelica models file extension (default .mo)")
          ("output-dir", po::value<string>(&outputDir), "set output directory (default : current directory)");

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

  if (precompiledModelsExtension == "") {
    precompiledModelsExtension = ".so";
  }

  if (modelicaModelsExtension == "") {
    modelicaModelsExtension = ".mo";
  }

  string currentPath = prettyPath(current_path());

  // output directory (default: current directory)
  string dir = createAbsolutePath(outputDir, currentPath);
  if (!exists(dir))
    create_directory(dir);

  string dydFileName = "";
  try {
    dydFileName = verifyModelListFile(modelList);   // verify the model list file

    // Initializes logs, parsers & dictionnaries for Dynawo
    Trace::init();
    shared_ptr<DYN::IoDicos> dicos = DYN::IoDicos::getInstance();
    dicos->addPath(getEnvVar("RESOURCES_DIR"));
    dicos->addDico("ERROR", "DYNError", getEnvVar("DYNAWO_LOCALE"));
    dicos->addDico("TIMELINE", "DYNTimeline", getEnvVar("DYNAWO_LOCALE"));
    dicos->addDico("CONSTRAINT", "DYNConstraint", getEnvVar("DYNAWO_LOCALE"));
    dicos->addDico("LOG", "DYNLog", getEnvVar("DYNAWO_LOCALE"));

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

    Compiler cf = Compiler(dyd, useStandardPrecompiledModels, precompiledModelsDirs, precompiledModelsExtension,
            useStandardModelicaModels, modelicaModelsDirs, modelicaModelsExtension, outputDir);
    cf.compile();

    fs::remove(dydFileName);
    vector<string > solist = cf.getCompiledLib();   // get all .so
    vector<string > notValidsolist;

     // verification linking status of shared object
    bool libValid = true;
    for (vector<string >::iterator it = solist.begin(); it != solist.end(); ++it) {
      bool valid = verifySharedObject(*it);   // verification .so
      if (!valid) {
        libValid = false;
        notValidsolist.push_back(*it);
        Trace::info("COMPILE") << DYNLog(InvalidModel, *it) << Trace::endline;
      } else {
        Trace::info("COMPILE") << DYNLog(ValidatedModel, *it) << Trace::endline;
      }
    }

    if (libValid) {
      Trace::info("COMPILE") << DYNLog(DYDLibGenerated, solist.size()) << Trace::endline;
    } else {
      Trace::info("COMPILE") << DYNLog(InvalidSharedObjects, notValidsolist.size()) << Trace::endline;
      for (vector<string >::iterator it = notValidsolist.begin(); it != notValidsolist.end(); ++it) {
        Trace::info("COMPILE") << *it << Trace::endline;
      }
    }
  } catch (const xml::sax::parser::ParserException& exp) {
    Trace::error() << DYNLog(XmlParsingError, dydFileName, exp.what()) << Trace::endline;
    return -1;
  } catch (const DYN::Error & e) {
    Trace::error() << e.what() << Trace::endline;
    return e.type();
  } catch (const std::exception & exp) {
    Trace::error() << exp.what() << Trace::endline;
    return -1;
  } catch (const char *s) {
    Trace::error() << s << Trace::endline;
    return -1;
  } catch (const string& msg) {
    Trace::error() << msg << Trace::endline;
    return -1;
  } catch (...) {
    std::cerr << " Generation failed : Unexpected exception " << std::endl;
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
  // dlopen include <dlfcn.h>: to see if a shared object file
  const char* filename = modelname.c_str();
  void *handle;
  handle = dlopen(filename, RTLD_LAZY);
  if (!handle) {
    fprintf(stderr, "%s\n", dlerror());
    printf(" Could not open .so by dlopen. ");
    return false;
  }
  dlclose(handle);

  // verify links.
  string command = "ldd -r " + modelname;
  string result = executeCommand1(command);
  bool valid = true;
  if (result.find("undefinded symbol") != std::string::npos)
    valid = false;

  return valid;
}

/**
 * @brief Verify model list format
 * use script python: scriptVerifyModelList.py
 */
std::string verifyModelListFile(std::string modelList) {
  string dydFileName = "";
  dydFileName = modelList + "_bak";
  string scriptsDir1 = getEnvVar("SCRIPTS_DIR");

  // scriptVerifyModelList.py
  std::cout << "Create file: " << dydFileName << std::endl;
  string verifymodellistcommand = "python " + scriptsDir1 + "/scriptVerifyModelList.py --dyd=" + dydFileName + " --model=" + modelList;
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
