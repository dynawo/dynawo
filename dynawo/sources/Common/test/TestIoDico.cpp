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
 * @file Common/TestIoDico.cpp
 * @brief Unit tests for Common lib Io Dicos
 *
 */

#include "gtest_dynawo.h"

#include "DYNIoDico.h"
#include "DYNMessage.h"
#include "DYNMessageTimeline.h"
#include "DYNMacrosMessage.h"
#include "DYNTerminate.h"


namespace DYN {

TEST(CommonIoDicoTest, testCommonIoDicosTest) {
  ASSERT_EQ(IoDicos::hasIoDico("MyIoDico"), false);
  ASSERT_THROW(IoDicos::getIoDico("MyIoDico"), std::string);

  boost::shared_ptr<IoDicos> dicos = IoDicos::getInstance();
  dicos->addPath("res");
  ASSERT_NO_THROW(dicos->addDico("MyIoDico", "dico", ""));
  ASSERT_THROW_DYNAWO(dicos->addDico("MyIoDico", "", ""), DYN::Error::API, DYN::KeyError_t::EmptyDictionaryName);
  ASSERT_THROW(dicos->addDico("MyIoDico", "MyDummyDico", ""), std::string);

  ASSERT_EQ(IoDicos::hasIoDico("MyIoDico"), true);
  assert(IoDicos::getIoDico("MyIoDico"));

  boost::shared_ptr<IoDico> dico = IoDicos::getIoDico("MyIoDico");
  assert(dico);
  ASSERT_EQ(dico->msg("MyEntry"), "My First Entry");
  ASSERT_EQ(dico->msg("MySecondEntry"), "My Second Entry %u");
  ASSERT_THROW(dico->msg("MyThirdEntry"), std::string);

  ASSERT_NO_THROW(dicos->addDico("MyIoDico", "dico", "2"));
  ASSERT_EQ(dico->msg("MyEntry"), "My First Entry");
  ASSERT_EQ(dico->msg("MySecondEntry"), "My Second Entry %u");
  ASSERT_EQ(dico->msg("MyThirdEntry"), "My Third Entry");
  ASSERT_EQ(dico->msg("MyFourthEntry"), "My Fourth Entry");

  ASSERT_THROW(dicos->addDico("MyIoDico", "dico", ""), std::string);
  boost::shared_ptr<IoDico> dico2 = boost::shared_ptr<IoDico>(new IoDico(*dico.get()));
  ASSERT_EQ(dico2->msg("MyEntry"), "My First Entry");
  ASSERT_EQ(dico2->msg("MySecondEntry"), "My Second Entry %u");
  ASSERT_EQ(dico2->msg("MyThirdEntry"), "My Third Entry");
  ASSERT_EQ(dico2->msg("MyFourthEntry"), "My Fourth Entry");

  Message mess("MyIoDico", "MySecondEntry");
  ASSERT_EQ((mess.operator ,(4)).str(), "My Second Entry 4");
  Message mess2(mess);
  ASSERT_EQ(mess2.str(), "My Second Entry 4");

  ASSERT_NO_THROW(dicos->addDico("TIMELINE", "TIMELINE", ""));
  ASSERT_NO_THROW(dicos->addDico("TIMELINE_PRIORITY", "TIMELINE_PRIORITY", ""));
  MessageTimeline tmess0("MyEntry");
  assert(tmess0.priority() == boost::none);

  MessageTimeline tmess("MySecondEntry");
  assert(tmess.priority() != boost::none);
  ASSERT_EQ(tmess.priority().get(), 1);
  ASSERT_EQ((tmess.operator ,(4)).str(), "My Second Entry 4");
  MessageTimeline tmess2(tmess);
  ASSERT_EQ(tmess2.str(), "My Second Entry 4");

  Terminate t(mess);
  ASSERT_EQ(std::string(t.what()), "My Second Entry 4");
  Terminate t2(t);
  ASSERT_EQ(std::string(t2.what()), "My Second Entry 4");
}

}  // namespace DYN
