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
 * @file  DYNDumpModel.cpp
 *
 * @brief Utility for the dump of pins, parameters, variables, output of a model
 *
 */
#include <iostream>
#include <fstream>
#include <string>

#include <boost/program_options.hpp>
#include <boost/shared_ptr.hpp>

#include <xml/sax/formatter/AttributeList.h>
#include <xml/sax/formatter/Formatter.h>

#include "DYNParameterModeler.h"
#include "DYNEnumUtils.h"
#include "DYNSubModel.h"
#include "DYNSubModelFactory.h"
#include "DYNVariableAlias.h"
#include "DYNFileSystemUtils.h"
#include "DYNInitXml.h"

using std::string;
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
 * @param modelName the model name (for error messages)
 * @param parametersAttributes a map between (lower case) parameter name and XML attributes
 */
static int
fillParameterDescription(const DYN::ParameterModeler& parameter, const std::string& modelName, std::map<std::string, AttributeList>& parametersAttributes) {
  AttributeList attributes;
  attributes.clear();
  attributes.add("name", parameter.getName());
  attributes.add("valueType", typeVarC2Str(parameter.getValueType()));
  attributes.add("cardinality", parameter.getCardinality());
  attributes.add("readOnly", parameter.isFullyInternal());

  if ((parameter.isUnitary()) && (parameter.hasValue())) {
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
        cout << "bad parameter for model " << modelName << " : " << parameter.getName() << " has a bad type" << endl;
        return 1;
      }
    }
  }

  string parameterNameLC = parameter.getName();
  parametersAttributes[parameterNameLC] = attributes;
  return 0;
}

/**
 * @brief main for dump model
 */
int main(int argc, char** argv) {
  string inputFileName = "";
  string outputFileName = "";
  po::options_description desc;
  desc.add_options()
          ("help,h", " produce help message")
          ("model-file,m", po::value<string>(&inputFileName), "REQUIRED: set model file (path)")
          ("output-file,o", po::value<string>(&outputFileName), "set output file (path)");

  po::positional_options_description positionalOptions;
  positionalOptions.add("model-file", 1);
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
  } else if (inputFileName.empty()) {
    cout << " Model file is required" << endl;
    cout << desc << endl;
    return 1;
  }

  if (outputFileName.empty()) {
    cout << " Default output file used : ./dumpModel.desc.xml" << endl;
    cout << desc << endl;
    outputFileName = "dumpModel.desc.xml";
  }

  // Getting data from SubModel
  if (!exists(inputFileName)) {
    cout << inputFileName << " does not exist " << endl;
    return 1;
  }
  DYN::InitXerces xerces;

  boost::shared_ptr<DYN::SubModel> model = DYN::SubModelFactory::createSubModelFromLib(inputFileName);
  model->defineVariablesInit();
  model->defineParametersInit();
  model->defineNamesInit();
  model->setSharedParametersDefaultValuesInit();
  model->defineParameters();
  model->defineVariables();
  model->defineNames();
  model->setSharedParametersDefaultValues();
  const std::unordered_map<std::string, DYN::ParameterModeler>& parametersInit = model->getParametersInit();
  const std::unordered_map<std::string, DYN::ParameterModeler>& parametersDynamic = model->getParametersDynamic();
  std::map<std::string, AttributeList> parametersAttributes;  // map between parameter name and attributes (alphabetically sort parameters)
  const auto& mapVariable = model->getVariableByName();

  std::fstream file;
  file.open(outputFileName.c_str(), std::fstream::out);
  FormatterPtr formatter = Formatter::createFormatter(file, "http://www.rte-france.com/dynawo");

  formatter->startDocument();
  AttributeList attrs;
  formatter->startElement("model", attrs);

  attrs.clear();
  formatter->startElement("name", attrs);
  formatter->characters(model->modelType());
  formatter->endElement();   // name

  attrs.clear();
  formatter->startElement("elements", attrs);

  attrs.clear();
  formatter->startElement("parameters", attrs);

  // add initial parameters
  for (const auto& parameterInitPair : parametersInit) {
    const DYN::ParameterModeler& parameterInit = parameterInitPair.second;
    // only keep parameters
    // which can either be displayed or set
    if ((model->hasParameterDynamic(parameterInit.getName()) || !parameterInit.isFullyInternal()) &&
        fillParameterDescription(parameterInit, model->modelType(), parametersAttributes) != 0) {
      return 1;
    }
  }

  // add dynamic parameters
  for (const auto& parameterDynamicPair : parametersDynamic) {
    const DYN::ParameterModeler* parameterDynamic = &(parameterDynamicPair.second);
    const string parameterName = parameterDynamic->getName();

    // initial parameters have already been described => nothing to do
    if (model->hasParameterInit(parameterName))
      continue;

    // when the dynamic parameter is set through the init process, it should be considered as internal for the description file
    const DYN::ParameterModeler parameterInternal(parameterName, parameterDynamic->getValueType(),
                                                  DYN::INTERNAL_PARAMETER,
                                                  parameterDynamic->getCardinality());
    if ((!parameterDynamic->isFullyInternal()) && (model->hasVariableInit(parameterName))) {
      parameterDynamic = &parameterInternal;
    }

    if (fillParameterDescription(*parameterDynamic, model->modelType(), parametersAttributes) != 0) {
      return 1;
    }
  }

  for (const auto& parameterAttributes : parametersAttributes) {
    formatter->startElement("parameter", parameterAttributes.second);
    formatter->endElement();   // parameter
  }

  formatter->endElement();   // parameters

  attrs.clear();
  formatter->startElement("variables", attrs);
  std::set<std::string> sortedVars;
  for (const auto& varPair : mapVariable)
    sortedVars.insert(varPair.first);

  for (const auto& sortedVar : sortedVars) {
    const auto& variable = mapVariable.at(sortedVar);
    attrs.clear();
    attrs.add("name", variable->getName());
    attrs.add("valueType", typeVarC2Str(toCTypeVar(variable->getType())));
    formatter->startElement("variable", attrs);
    formatter->endElement();   // variable
  }
  formatter->endElement();   // variables
  formatter->endElement();   // elements
  formatter->endElement();   // model
  formatter->endDocument();
  file.close();
}
