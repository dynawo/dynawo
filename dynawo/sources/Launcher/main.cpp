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
 * @file  main.cpp
 *
 * @brief main program of dynawo
 *
 */
#include <string>
#include <fstream>
#include <iostream>

#include <boost/program_options.hpp>
#include <boost/shared_ptr.hpp>

#include <xml/sax/parser/ParserException.h>

#include "config.h"
#include "gitversion.h"

#include "DYNMacrosMessage.h"
#include "DYNSimulationLauncher.h"
#include "DYNError.h"
#include "DYNIoDico.h"
#include "DYNTrace.h"
#include "DYNFileSystemUtils.h"
#include "DYNExecUtils.h"
#define DYNTIMERS_INSTANCE  // this should be defined only once in main source before header inclusion
#include "DYNTimer.h"

using std::string;
using std::exception;
using std::endl;
using std::cerr;
using std::cout;
using std::vector;

using DYN::Error;
using DYN::Trace;
using DYN::IoDico;

namespace po = boost::program_options;

using boost::shared_ptr;

/**
 * @brief main function for dynawo
 *
 *
 * @param argc number of arguments passed to the program
 * @param argv pointer to the first element of an array of pointers to arguments
 *
 * @return @b 0 if everything works fine, other value else
 */
int main(int argc, char ** argv) {
  string jobsFileName = "";

  try {
    // declarations of supported options
    // -----------------------------------

    po::options_description desc;
    desc.add_options()
            ("help,h", " produce help message")
            ("jobs-file", po::value<string>(&jobsFileName), "set job file")
            ("version,v", " print dynawo version");

    po::positional_options_description positionalOptions;
    positionalOptions.add("jobs-file", 1);

    po::variables_map vm;
    // parse regular options
    po::store(po::command_line_parser(argc, argv).options(desc)
            .positional(positionalOptions).run(),
            vm);
    po::notify(vm);

    if (vm.count("help")) {
      cout << desc << endl;
      return 0;
    }

    if (vm.count("version")) {
      cout << DYNAWO_VERSION_STRING << " (rev:" << DYNAWO_GIT_BRANCH << "-" << DYNAWO_GIT_HASH << ")" << endl;
      return 0;
    }

    // launch simulation
    if (jobsFileName == "") {
      cout << " job file name is required" << endl;
      cout << desc << endl;
      return 1;
    }

    if (!exists(jobsFileName)) {
      cout << " failed to locate jobs file (" << jobsFileName << ")" << endl;
      cout << desc << endl;
      return 1;
    }

    boost::shared_ptr<DYN::IoDicos> dicos = DYN::IoDicos::getInstance();
    dicos->addPath(getEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos->addDicos(getEnvVar("DYNAWO_DICTIONARIES"));
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") != "true")
      cout << "[INFO] xsd validation will not be used" << endl;

    launchSimu(jobsFileName);
  } catch (const DYN::Error& e) {
    Trace::error() << e.what() << Trace::endline;
    return e.type();
  } catch (const char *s) {
    Trace::error() << s << Trace::endline;
    return -1;
  } catch (const string & Msg) {
    Trace::error() << Msg << Trace::endline;
    return -1;
  } catch (const xml::sax::parser::ParserException& exp) {
    Trace::error() << DYNLog(XmlParsingError, jobsFileName, exp.what()) << Trace::endline;
    return -1;
  } catch (std::exception & exc) {
    Trace::error() << exc.what() << Trace::endline;
    return -1;
  } catch (...) {
    Trace::error() << __FILE__ << " " << __LINE__ << " " << DYNLog(UnexpectedError) << Trace::endline;
    return -1;
  }
  return 0;
}
