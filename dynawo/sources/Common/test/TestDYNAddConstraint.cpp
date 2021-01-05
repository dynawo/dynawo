//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
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
 * @file Common/DYNAddConstraint.cpp
 * @brief Unit tests for the DYNAddEvent() macro
 *
 */

#include "CSTRConstraint.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraintsCollectionFactory.h"
#include "DYNConstraint_keys.h"
#include "DYNMacrosMessage.h"

#include "gtest_dynawo.h"

#include <boost/shared_ptr.hpp>

#include <string>

class Xiny {
 public:
  inline Xiny() : time_(6.666666) {}

  inline bool
  hasConstraints() const {
    return constraints_.use_count() != 0;
  }

  inline const boost::shared_ptr<constraints::ConstraintsCollection>&
  getConstraints() const {
    return constraints_;
  }

  void
  setConstraints(const boost::shared_ptr<constraints::ConstraintsCollection>& constraints) {
    constraints_ = constraints;
  }

  inline double
  getCurrentTime() const {
    return time_;
  }

 private:
  boost::shared_ptr<constraints::ConstraintsCollection> constraints_;
  double time_;
};

TEST(CommonTest, DYNAddConstraint) {
  Xiny X;
  ASSERT_FALSE(X.hasConstraints());
  ASSERT_EQ(X.getConstraints().get(), nullptr);
  ASSERT_DOUBLE_EQ(X.getCurrentTime(), 6.666666);

  Xiny* px(&X);
  boost::shared_ptr<constraints::ConstraintsCollection> constraints = constraints::ConstraintsCollectionFactory::newInstance("My constraints");
  X.setConstraints(constraints);
  ASSERT_TRUE(px->hasConstraints());
  ASSERT_EQ(X.getConstraints().get(), constraints.get());

  // will be 2nd in the std::map of constraints. For now is 1st and unique constraint
  DYNAddConstraint(px, "2-componentName", true, "modelType", DYN::KeyConstraint_t::OverloadUp);
  {
    std::string s(DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::OverloadUp));
    constraints::ConstraintsCollection::const_iterator it(constraints->cbegin());
    ASSERT_EQ(it->get()->getModelName(), "2-componentName");
    ASSERT_EQ(it->get()->getModelType(), "modelType");
    ASSERT_EQ(it->get()->getDescription(), s);
    ASSERT_EQ(it->get()->getType(), constraints::CONSTRAINT_BEGIN);
  }

  // the new first constraint
  DYNAddConstraint(px, "1-id", false, "modelType", DYN::KeyConstraint_t::OverloadOpen);
  {
    std::string s(DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::OverloadOpen));
    constraints::ConstraintsCollection::const_iterator it(constraints->cbegin());
    ASSERT_EQ(it->get()->getType(), constraints::CONSTRAINT_END);
    ASSERT_EQ(it->get()->getDescription(), s);
  }

  DYNAddConstraint(px, "3-Name", true, "Type", DYN::KeyConstraint_t::UsMax, 1, 2, 3, 44, 5.55, "this is a sentence", 'A');
  {
    std::string s(DYN::KeyConstraint_t::names(DYN::KeyConstraint_t::UsMax));
    s += " 1 2 3 44 5.55 this is a sentence A";
    constraints::ConstraintsCollection::const_iterator it(constraints->cend());
    ASSERT_EQ((--it)->get()->getType(), constraints::CONSTRAINT_BEGIN);
    ASSERT_EQ(it->get()->getDescription(), s);
  }
}
