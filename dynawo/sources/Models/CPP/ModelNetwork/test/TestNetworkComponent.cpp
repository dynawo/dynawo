//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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

#include "DYNNetworkComponentsBase.h"
#include "gtest_dynawo.h"

#include <boost/make_shared.hpp>

namespace DYN {

struct A {
  void evalF(propertyF_t) {
    counter++;
  }

  static size_t counter;
};
struct B {
  void evalF(propertyF_t) {
    counter++;
  }

  static size_t counter;
};
struct C {
  void evalF(propertyF_t) {
    counter++;
  }

  static size_t counter;
};
struct D {
  using NetworkComponentsTest2 = NetworkComponentsBase<A, B, C>;
  void evalF(propertyF_t type) {
    components.evalF(type);
  }

  NetworkComponentsTest2 components;
};

size_t A::counter = 0;
size_t B::counter = 0;
size_t C::counter = 0;

using NetworkComponentsTest = NetworkComponentsBase<A, B, C, D>;

static void clearCounters() {
  A::counter = 0;
  B::counter = 0;
  C::counter = 0;
}

TEST(NetworkComponents, base) {
  NetworkComponentsTest components;

  components.addModel(boost::make_shared<A>());
  components.addModel(boost::make_shared<A>());
  components.addModel(boost::make_shared<A>());

  components.addModel(boost::make_shared<B>());
  components.addModel(boost::make_shared<B>());

  components.addModel(boost::make_shared<C>());

  components.evalF(UNDEFINED_EQ);
  ASSERT_EQ(A::counter, 3);
  ASSERT_EQ(B::counter, 2);
  ASSERT_EQ(C::counter, 1);
}

TEST(NetworkComponents, subcomponent) {
  clearCounters();

  NetworkComponentsTest components;

  components.addModel(boost::make_shared<A>());
  components.addModel(boost::make_shared<A>());
  components.addModel(boost::make_shared<A>());

  components.addModel(boost::make_shared<B>());
  components.addModel(boost::make_shared<B>());

  components.addModel(boost::make_shared<C>());

  auto d = boost::make_shared<D>();
  d->components.addModel(boost::make_shared<A>());
  d->components.addModel(boost::make_shared<B>());
  d->components.addModel(boost::make_shared<C>());
  components.addModel(d);

  components.evalF(UNDEFINED_EQ);
  ASSERT_EQ(A::counter, 4);
  ASSERT_EQ(B::counter, 3);
  ASSERT_EQ(C::counter, 2);
}

}  // namespace DYN
