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
 * @file  DYNModelManagerCommon.cpp
 *
 * @brief implementation of useful/utilitaries methods
 *
 */
#include <sstream>
#include <fstream>
#include <iomanip>
#include <stdio.h>
#include <string>
#include <map>
#include <cstdlib>
#include <boost/algorithm/string.hpp>

#include "DYNMacrosMessage.h"
#include "DYNSubModel.h"
#include "DYNModelManager.h"
#include "DYNModelManagerCommon.h"
#include "DYNTerminate.h"
#include "DYNTrace.h"
#include "DYNExecUtils.h"
#include "DYNFileSystemUtils.h"

namespace DYN {

static memoryManagerChars mmChars;  ///< instance of modelica chars manager : chars created and which should be deleted at the end of the execution

void printLogToStdOut_(ModelManager *model, const std::string & message) {
  SubModel * sub = dynamic_cast<SubModel*> (model);
  if (sub == NULL)
    throw DYNError(Error::GENERAL, WrongDynamicCast);
  std::cout << sub->name() << ":" << message << std::endl;
  Trace::debug() << sub->name() << ":" << message << Trace::endline;
}

void printLogExecution_(ModelManager * model, const std::string & message) {
  SubModel * sub = dynamic_cast<SubModel*> (model);
  if (sub == NULL)
    throw DYNError(Error::GENERAL, WrongDynamicCast);
  sub->addMessage(message);
}

void addLogEvent_(ModelManager* model, const MessageTimeline& messageTimeline) {
  model->addEvent(model->name(), messageTimeline);
}

void addLogEventRaw2_(ModelManager* model, const char* message1, const char* message2) {
  std::stringstream ss("");
  ss << message1 << message2;
  const std::string fullMessage = ss.str();

  addLogEvent_(model, (MessageTimeline("", fullMessage)));
}

void
addLogEventRaw3_(ModelManager* model, const char* message1, const char* message2,
        const char* message3) {
  std::stringstream ss("");
  ss << message1 << message2 << message3;
  const std::string fullMessage = ss.str();

  addLogEvent_(model, (MessageTimeline("", fullMessage)));
}

void addLogEventRaw4_(ModelManager* model, const char* message1, const char* message2,
        const char* message3, const char* message4) {
  std::stringstream ss("");
  ss << message1 << message2 << message3 << message4;
  const std::string fullMessage = ss.str();

  addLogEvent_(model, (MessageTimeline("", fullMessage)));
}

void addLogEventRaw5_(ModelManager* model, const char* message1, const char* message2,
        const char* message3, const char* message4, const char* message5) {
  std::stringstream ss("");
  ss << message1 << message2 << message3 << message4 << message5;
  const std::string fullMessage = ss.str();

  addLogEvent_(model, (MessageTimeline("", fullMessage)));
}

void addLogConstraintBegin_(ModelManager* model, const Message& message) {
  model->addConstraint(model->name(), true, message);
}

void addLogConstraintEnd_(ModelManager* model, const Message& message) {
  model->addConstraint(model->name(), false, message);
}

void assert_(ModelManager* model, const Message& message) {
  std::stringstream msg;
  msg << model->name() << " : " << message.str();
  throw(msg.str());
}

void throw_(ModelManager* model, const Message& message) {
  std::stringstream msg;
  msg << model->name() << " : " << message.str();
  throw(msg.str());
}

void terminate_(ModelManager* model, const MessageTimeline& messageTimeline) {
  model->addEvent(model->name(), messageTimeline);
  throw DYNTerminate(TerminateInModel, model->name(), messageTimeline.str());
}

const char* modelica_integer_to_modelica_string(modelica_integer i, modelica_integer /*minLen*/, modelica_boolean /*leftJustified*/) {
  // @todo warning: no thread safe
  std::stringstream ss("");
  ss << i;
  const std::string tmp = ss.str();

  mmChars.string2Keep_.push_back(tmp);

  return mmChars.string2Keep_.back().c_str();
}

const char* cat_modelica_string(modelica_string_const s1, modelica_string_const s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

const char* cat_modelica_string(std::string s1, modelica_string_const s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

const char* cat_modelica_string(modelica_string_const s1, std::string s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

const char* stringAppend(const modelica_string s1, const modelica_string s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

const char* stringAppend(const modelica_string s1, const std::string s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

const char* stringAppend(const std::string s1, const modelica_string s2) {
  std::stringstream ss("");
  ss << s1 << s2;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);
  return mmChars.string2Keep_.back().c_str();
}

std::string mmc_strings_len1(unsigned int size) {
  const std::string tmp(size, '\0');
  return tmp;
}

const char* modelica_real_to_modelica_string_format(modelica_real r, std::string /*format*/) {
  std::stringstream ss("");
  ss << std::setprecision(3) << std::fixed << r;
  const std::string tmp = ss.str();

  mmChars.string2Keep_.push_back(tmp);

  return mmChars.string2Keep_.back().c_str();
}

const char* modelica_integer_to_modelica_string_format(modelica_integer i, std::string /*format*/) {
  std::stringstream ss("");
  ss << i;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);

  return mmChars.string2Keep_.back().c_str();
}

const char* modelica_boolean_to_modelica_string_format(modelica_boolean b, std::string /*format*/) {
  std::stringstream ss("");
  ss << std::boolalpha << b;
  const std::string tmp = ss.str();
  mmChars.string2Keep_.push_back(tmp);

  return mmChars.string2Keep_.back().c_str();
}

const char * modelica_real_to_modelica_string(modelica_real r, modelica_integer /*minLen*/, modelica_boolean /*leftJustified*/,
                                              modelica_integer signDigits) {
  // @todo warning: no thread safe
  std::stringstream ss("");
  ss << std::setprecision(signDigits) << std::fixed << r;
  const std::string tmp = ss.str();

  mmChars.string2Keep_.push_back(tmp);

  return mmChars.string2Keep_.back().c_str();
}

const char * modelica_boolean_to_modelica_string(modelica_boolean b, modelica_integer /*minLen*/, modelica_boolean /*leftJustified*/) {
  if (b) {
    return "true";
  } else {
    return "false";
  }
}

bool compareString_(const std::string& x, const std::string& y) {
  return (x.compare(y) == 0);
}

const
modelica_integer* integerArrayElementAddress1_(const modelica_integer * source, int dim1) {
  return ( source + dim1 - 1);
}

modelica_string enumToModelicaString_(modelica_integer nr, const char *e[]) {
  return e[nr - 1];
}

modelica_integer sizeOffArray_(const modelica_integer array[]) {
  modelica_integer size;
  if (array == NULL) {
    size = 0;
  } else {
    size = (sizeof (*array) / sizeof (array[0])) + 1;  // + 1 added because otherwise the formula has an offset of -1
  }

  return size;
}

void
callExternalAutomatonModel(const std::string& modelName, const char* command, const double time, const double* inputs, const char** inputsName,
        const int nbInputs, double* outputs, const char** outputsName, const int nbOutputs, const std::string& workingDirectory) {
  static std::string separator = ";";
  std::string workingDir = workingDirectory + "/execution/" + modelName + "/";
  if (!exists(workingDir))
    create_directory(workingDir);

  std::string outputFile = workingDir + "file_in.csv";

  // write input file
  std::ofstream stream(outputFile.c_str(), std::ofstream::out);
  stream << "time" << separator << time << std::endl;
  for (int i=0; i< nbInputs; ++i)
    stream << inputsName[i] << separator << inputs[i] << std::endl;
  stream.close();

  // launch command
  std::stringstream ss;
  std::string commandStr(command);
  boost::replace_all(commandStr, "${AUTOMATON_WORKING_DIR}", workingDir);
  executeCommand(commandStr, ss);

  Trace::debug() << ss.str() << Trace::endline;

  std::string inputFile = workingDir + "file_out.csv";
  // read output file
  std::ifstream ifstream(inputFile.c_str(), std::ifstream::in);
  std::string line;
  std::map<std::string, double> values;
  while (std::getline(ifstream, line)) {
    std::size_t found = line.find_last_of(separator);
    std::string name = line.substr(0, found);
    double value = atof(line.substr(found+1).c_str());
    values[name] = value;
    line.clear();
  }

  // assign outputs thanks to name
  for (int i=0; i< nbOutputs; ++i) {
    std::map<std::string, double>::const_iterator iter = values.find(outputsName[i]);
    if (iter == values.end())
      throw DYNError(Error::GENERAL, UnknownAutomatonOutput, modelName, outputsName[i]);
    outputs[i] = iter->second;
  }
}

}  // namespace DYN
