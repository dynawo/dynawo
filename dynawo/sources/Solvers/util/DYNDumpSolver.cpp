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
 * @file  DYNDumpSolver.cpp
 *
 * @brief Util : parameters dump of a solver
 *
 */
#include <algorithm>
#include <iostream>
#include <fstream>
#include <string>

#include <boost/algorithm/string.hpp>
#include <boost/program_options.hpp>
#include <boost/shared_ptr.hpp>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNParameterSolver.h"
#include "DYNSolverCommon.h"
#include "DYNSolver.h"
#include "DYNSolverImpl.h"
#include "DYNSolverFactory.h"
#include "DYNFileSystemUtils.h"
#include "DYNInitXml.h"


using std::string;
using std::map;
using std::endl;
using std::cerr;
using std::cout;

namespace po = boost::program_options;

using xml::sax::formatter::AttributeList;
using xml::sax::formatter::Formatter;
using xml::sax::formatter::FormatterPtr;

/**
 * @brief clear and fill a list of attributes to describe a given parameter
 * @param parameter the parameter for which to fill the description
 * @param solverName the solver name (for error messages)
 * @param parametersAttributes a map between (lower case) parameter name and XML attributes
 */
static int
fillParameterDescription(const DYN::ParameterSolver& parameter, const std::string& solverName, std::map<std::string, AttributeList>& parametersAttributes) {
  AttributeList attributes;
  attributes.clear();
  attributes.add("name", parameter.getName());
  attributes.add("valueType", typeVarC2Str(parameter.getValueType()));
  attributes.add("cardinality", 1);  // default value 1 for solver parameters

  if (parameter.hasValue()) {
    switch (parameter.getValueType()) {
      case DYN::VAR_TYPE_DOUBLE: {
        attributes.add("defaultValue", parameter.getValue<double>());
        break;
      }
      case DYN::VAR_TYPE_INT: {
        attributes.add("defaultValue", parameter.getValue<int>());
        break;
      }
      case DYN::VAR_TYPE_BOOL: {
        attributes.add("defaultValue", parameter.getValue<bool>());
        break;
      }
      case DYN::VAR_TYPE_STRING: {
        attributes.add("defaultValue", parameter.getValue<std::string>());
        break;
      }
      default:
      {
        cout << "bad parameter for model " << solverName << " : " << parameter.getName() << " has a bad type" << endl;
        return 1;
      }
    }
  }

  // store parameters based on lower case alphabetical order
  string parameterNameLC = parameter.getName();
  boost::algorithm::to_lower(parameterNameLC);
  if (parametersAttributes.find(parameterNameLC) != parametersAttributes.end()) {
    cout << "duplicate initial parameter attribute with lowercase name " << parameterNameLC << " for solver " << solverName
         << " : the solver description will not be fully relevant" << endl;
    return 1;
  }
  parametersAttributes[parameterNameLC] = attributes;
  return 0;
}

/**
 * @brief main for dump solver
 */
int main(int argc, char ** argv) {
  cout << " Solver dump main" << endl;
  string inputFileName = "";
  string outputFileName = "";
  po::options_description desc;
  desc.add_options()
          ("help,h", " produce help message")
          ("solver-file,m", po::value<string>(&inputFileName), "REQUIRED: set solver file (path)")
          ("output-file,o", po::value<string>(&outputFileName), "set output file (path)");

  po::positional_options_description positionalOptions;
  positionalOptions.add("solver-file", 1);
  positionalOptions.add("output-file", 1);

  po::variables_map vm;
  // parse regular options
  po::store(po::command_line_parser(argc, argv).options(desc)
          .positional(positionalOptions).run(),
          vm);
  po::notify(vm);

  if (vm.count("help")) {
    cout << desc << endl;
    return 0;
  } else if (inputFileName == "") {
    cout << " Solver file is required" << endl;
    cout << desc << endl;
    return 1;
  }

  if (outputFileName == "") {
    cout << " Default output file used : ./dumpSolver.desc.xml" << endl;
    cout << desc << endl;
    outputFileName = "dumpSolver.desc.xml";
  }

  // Getting data from Solver
  if (!exists(inputFileName)) {
    cout << inputFileName << " does not exist " << endl;
    return 1;
  }
  DYN::InitXerces xerces;

  const DYN::SolverFactory::SolverPtr solver = DYN::SolverFactory::createSolverFromLib(inputFileName);
  solver->defineParameters();
  const map<string, DYN::ParameterSolver>& parameters = solver->getParametersMap();
  map<string, AttributeList> parametersAttributes;  // map between parameter name and attributes (alphabetically sort parameters)

  std::fstream file;
  file.open(outputFileName.c_str(), std::fstream::out);
  FormatterPtr formatter = Formatter::createFormatter(file, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("solver", attrs);

  attrs.clear();
  formatter->startElement("name", attrs);
  formatter->characters(solver->solverType());
  formatter->endElement();   // name

  attrs.clear();
  formatter->startElement("elements", attrs);

  attrs.clear();
  formatter->startElement("parameters", attrs);

  // add initial parameters
  for (map<string, DYN::ParameterSolver>::const_iterator parameterIterator=parameters.begin(); parameterIterator != parameters.end(); ++parameterIterator) {
    const DYN::ParameterSolver& parameter = (*parameterIterator).second;
    if (solver->hasParameter(parameter.getName()) && fillParameterDescription(parameter, solver->solverType(), parametersAttributes) != 0) {
      return 1;
    }
  }

  for (std::map<std::string, AttributeList>::const_iterator itAttributes = parametersAttributes.begin();
       itAttributes != parametersAttributes.end(); ++itAttributes) {
    formatter->startElement("parameter", itAttributes->second);
    formatter->endElement();   // parameter
  }

  formatter->endElement();   // parameters
  formatter->endElement();   // elements
  formatter->endElement();   // model
  formatter->endDocument();
  file.close();
}
