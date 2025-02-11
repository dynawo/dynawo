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
#include <iostream>

#include <boost/program_options.hpp>

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
#include "DYNInitXml.h"
#include "DYNTimer.h"

using std::string;
using std::endl;
using std::cout;

using DYN::Trace;

namespace po = boost::program_options;

static void usage(const po::options_description& desc) {
  cout << "Usage: dynawo <jobs-file>" << std::endl << std::endl;
  cout << desc << endl;
}

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

  // declarations of supported options
  // -----------------------------------

  po::options_description desc;
  desc.add_options()
    ("help,h", "produce help message")
    ("version,v", "print dynawo version");

  po::options_description hidden("Hidden options");
  hidden.add_options() ("jobs-file", po::value<string>(&jobsFileName), "set job file");

  po::positional_options_description positionalOptions;
  positionalOptions.add("jobs-file", 1);

  po::options_description cmdlineOptions;
  cmdlineOptions.add(desc).add(hidden);

  try {
    po::variables_map vm;
    // parse regular options
    po::store(po::command_line_parser(argc, argv).options(cmdlineOptions)
            .positional(positionalOptions).run(),
            vm);
    po::notify(vm);

    if (vm.count("help")) {
      usage(desc);
      return 0;
    }

    if (vm.count("version")) {
      cout << DYNAWO_VERSION_STRING << " (rev:" << DYNAWO_GIT_BRANCH << "-" << DYNAWO_GIT_HASH << ")" << endl;
      return 0;
    }

    // launch simulation
    if (jobsFileName == "") {
      cout << "Error: a jobs file name is required." << endl;
      usage(desc);
      return 1;
    }

    if (!exists(jobsFileName)) {
      cout << " failed to locate jobs file (" << jobsFileName << ")" << endl;
      usage(desc);
      return 1;
    }

    DYN::InitXerces xerces;
    DYN::InitLibXml2 libxml2;
    DYN::IoDicos& dicos = DYN::IoDicos::instance();
    dicos.addPath(getMandatoryEnvVar("DYNAWO_RESOURCES_DIR"));
    dicos.addDicos(getMandatoryEnvVar("DYNAWO_DICTIONARIES"));
    if (getEnvVar("DYNAWO_USE_XSD_VALIDATION") != "true")
      cout << "[INFO] xsd validation will not be used" << endl;

    launchSimu(jobsFileName);
  } catch (const DYN::Error& e) {
    std::cerr << "DYN Error: " << e.what() << std::endl;
    return e.type();
  } catch (const po::error&) {
    usage(desc);
    return -1;
  } catch (const char* s) {
    std::cerr << "Throws string: '" << s << "'" << std::endl;
    return -1;
  } catch (const string& s) {
    std::cerr << "Throws string: '" << s << "'" << std::endl;
    return -1;
  } catch (const xml::sax::parser::ParserException& exp) {
    std::cerr << DYNLog(XmlParsingError, jobsFileName, exp.what()) << std::endl;
    Trace::error() << DYNLog(XmlParsingError, jobsFileName, exp.what()) << Trace::endline;
    return -1;
  } catch (std::exception& e) {
    std::cerr << "Exception: " << e.what() << std::endl;
    return -1;
  } catch (...) {
    std::cerr << DYNLog(UnexpectedError) << std::endl;
    Trace::error() << __FILE__ << " " << __LINE__ << " " << DYNLog(UnexpectedError) << Trace::endline;
    return -1;
  }
  return 0;
}
