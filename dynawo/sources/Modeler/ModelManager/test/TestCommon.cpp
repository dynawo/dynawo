//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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


#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"
#include "DYNMacrosMessage.h"
#include "DYNModelManager.h"
#include "TLTimelineFactory.h"
#include "TLTimeline.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "DYNModelManagerCommon.h"

namespace DYN {

class MyEmptyModelManager : public ModelManager {
 public:
  MyEmptyModelManager() :
    ModelManager() {
  }

  virtual ~MyEmptyModelManager() = default;

 protected:
  bool hasInit() const {
    return false;
  }
};

TEST(TestModelManager, TestModelManagerCommonLogs) {
  MyEmptyModelManager mm;
  boost::shared_ptr<timeline::Timeline> timeline = timeline::TimelineFactory::newInstance("MyTimeline");
  mm.setTimeline(timeline);
  ASSERT_THROW_DYNAWO(printLogToStdOut_(NULL, "blah"), Error::GENERAL, KeyError_t::WrongDynamicCast);
  ASSERT_NO_THROW(printLogToStdOut_(&mm, "blah"));

  ASSERT_THROW_DYNAWO(printLogExecution_(NULL, "blah"), Error::GENERAL, KeyError_t::WrongDynamicCast);
  ASSERT_NO_THROW(printLogExecution_(&mm, "blah"));

  MessageTimeline mess("", "MyMessage");
  ASSERT_NO_THROW(addLogEvent_(&mm, mess));
  ASSERT_EQ(timeline->getSizeEvents(), 1);

  ASSERT_NO_THROW(addLogEventRaw2_(&mm, "blah.", "blah."));
  ASSERT_EQ(timeline->getSizeEvents(), 2);

  ASSERT_NO_THROW(addLogEventRaw3_(&mm, "blah.", "blah.", "blah."));
  ASSERT_EQ(timeline->getSizeEvents(), 3);

  ASSERT_NO_THROW(addLogEventRaw4_(&mm, "blah.", "blah.", "blah.", "blah."));
  ASSERT_EQ(timeline->getSizeEvents(), 4);

  ASSERT_NO_THROW(addLogEventRaw5_(&mm, "blah.", "blah.", "blah.", "blah.", "blah."));
  ASSERT_EQ(timeline->getSizeEvents(), 5);

  boost::shared_ptr<constraints::ConstraintsCollection> constraints = constraints::ConstraintsCollectionFactory::newInstance("MyConstraints");
  mm.setConstraints(constraints);
  constraints::ConstraintsCollection::const_iterator it = constraints->cbegin();
  assert(it == constraints->cend());
  ASSERT_NO_THROW(addLogConstraintBegin_(&mm, mess));
  it = constraints->cbegin();
  ++it;
  assert(it == constraints->cend());
  ASSERT_NO_THROW(addLogConstraintEnd_(&mm, mess));
  it = constraints->cbegin();
  assert(it == constraints->cend());

  ASSERT_THROW(assert_(&mm, mess), MessageError);
  ASSERT_THROW(throw_(&mm, mess), MessageError);
  ASSERT_THROW(terminate_(&mm, mess),  DYN::Terminate);
  ASSERT_EQ(timeline->getSizeEvents(), 6);
}

TEST(TestModelManager, TestModelManagerCommonStrings) {
  ASSERT_EQ(std::string(modelica_integer_to_modelica_string(2, 0, true)), "2");
  ASSERT_EQ(std::string(cat_modelica_string(std::string("hello").c_str(), std::string(" world").c_str())), "hello world");
  ASSERT_EQ(std::string(cat_modelica_string(std::string("hello").c_str(), std::string(" world"))), "hello world");
  ASSERT_EQ(std::string(cat_modelica_string(std::string("hello"), std::string(" world").c_str())), "hello world");
  ASSERT_EQ(std::string(stringAppend(std::string("hello").c_str(), std::string(" world").c_str())), "hello world");
  ASSERT_EQ(std::string(stringAppend(std::string("hello").c_str(), std::string(" world"))), "hello world");
  ASSERT_EQ(std::string(stringAppend(std::string("hello"),  std::string(" world").c_str())), "hello world");
  ASSERT_EQ(mmc_strings_len1(3), std::string(3, '\0'));
  ASSERT_EQ(std::string(modelica_real_to_modelica_string_format(1., "")), "1.000");
  ASSERT_EQ(std::string(modelica_integer_to_modelica_string_format(1, "")), "1");
  ASSERT_EQ(std::string(modelica_real_to_modelica_string(1., 0, true, 0)), "1");
  ASSERT_EQ(std::string(modelica_boolean_to_modelica_string(true, 0, false)), "true");
  ASSERT_TRUE(compareString_("blah.", "blah."));
  ASSERT_FALSE(compareString_("blah.", "blah"));

  int* table = new int[3];
  table[0] = 1;
  table[1] = 2;
  table[2] = 3;
  ASSERT_EQ(*integerArrayElementAddress1_(table, 2), 2);
  ASSERT_EQ(sizeOffArray_(NULL, 0), 0);
  ASSERT_EQ(sizeOffArray_(table, 1), 2);
  delete[] table;
  const char** ctable = new const char*[3];
  ctable[0] = "a";
  ctable[1] = "b";
  ctable[2] = "c";
  ASSERT_EQ(enumToModelicaString_(2, ctable), "b");
  delete[] ctable;
}

TEST(TestModelManager, TestModelManagerCommonAutomaton) {
  std::string command = "diff res/file_in_ref.csv ${AUTOMATON_WORKING_DIR}/file_in.csv; mv res/file_out.csv ${AUTOMATON_WORKING_DIR}/file_out.csv";
  double* inputs = new double[3];
  inputs[0] = 1.;
  inputs[1] = 2.;
  inputs[2] = 3.;
  const char** inputsName = new const char*[3];
  inputsName[0] = "a";
  inputsName[1] = "b";
  inputsName[2] = "c";
  double* outputs = new double[2];
  outputs[0] = 0.;
  outputs[1] = 0.;
  const char** outputsName = new const char*[2];
  outputsName[0] = "d";
  outputsName[1] = "e";

  int* intOutputs = new int[4];
  intOutputs[0] = 0.;
  intOutputs[1] = 0.;
  intOutputs[2] = 0.;
  intOutputs[3] = 0.;
  const char** intOutputsName = new const char*[4];
  intOutputsName[0] = "f";
  intOutputsName[1] = "g";
  intOutputsName[2] = "h";
  intOutputsName[3] = "i";

  ASSERT_THROW_DYNAWO(callExternalAutomatonModel("MyAutomaton", command.c_str(), 1., inputs, inputsName, 3, 2,
      outputs, outputsName, 2, 3, intOutputs, intOutputsName, 4, 5, "res"), Error::GENERAL, KeyError_t::AutomatonMaximumInputSizeReached);


  ASSERT_THROW_DYNAWO(callExternalAutomatonModel("MyAutomaton", command.c_str(), 1., inputs, inputsName, 3, 4,
      outputs, outputsName, 2, 2, intOutputs, intOutputsName, 4, 5, "res"), Error::GENERAL, KeyError_t::AutomatonMaximumOutputSizeReached);


  ASSERT_THROW_DYNAWO(callExternalAutomatonModel("MyAutomaton", command.c_str(), 1., inputs, inputsName, 3, 4,
      outputs, outputsName, 2, 2, intOutputs, intOutputsName, 6, 5, "res"), Error::GENERAL, KeyError_t::AutomatonMaximumOutputSizeReached);

  callExternalAutomatonModel("MyAutomaton", command.c_str(), 1., inputs, inputsName, 3, 4,
      outputs, outputsName, 2, 3, intOutputs, intOutputsName, 4, 5, "res");

  ASSERT_DOUBLE_EQUALS_DYNAWO(outputs[0], 4.);
  ASSERT_DOUBLE_EQUALS_DYNAWO(outputs[1], 5.);
  ASSERT_EQ(intOutputs[0], 6.);
  ASSERT_EQ(intOutputs[1], 7.);
  ASSERT_EQ(intOutputs[2], 8.);
  ASSERT_EQ(intOutputs[3], 9.);

  delete[] inputs;
  delete[] inputsName;
  delete[] outputs;
  delete[] outputsName;
  delete[] intOutputs;
  delete[] intOutputsName;
}

}  // namespace DYN
