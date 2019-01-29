//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libxml, a library to handle XML files parsing.
//

#include <xml/sax/parser/PathTree.h>

#include <xml/sax/parser/Path.h>

#include <gtest/gtest.h>

#include "type_trait_test.hpp"
#include "sequence.hpp"

#include <boost/lexical_cast.hpp>
#include <boost/optional.hpp>
#include <boost/optional/optional_io.hpp>
#include <boost/assign/list_of.hpp>

namespace p = xml::sax::parser;

using test_helpers::sequence;

template <typename T>
class TestPathTree : public testing::Test {
protected:
  typedef p::path_tree<std::string, T> tree_type;
  typedef typename tree_type::key_type key_type;
  typedef typename p::path<key_type> path_type;
  
  path_type const root;
  path_type const base;
  path_type const leaf1;
  path_type const leaf2;
  
  TestPathTree():
    root("root"), base(root+"base"), leaf1(base+"1"), leaf2(base+"2")
  {}
};

typedef testing::Types< int, std::string > MyTypes;
TYPED_TEST_CASE(TestPathTree, MyTypes);

TYPED_TEST(TestPathTree, Type) {
  typedef TestPathTree<TypeParam> this_type;
  typedef typename this_type::tree_type tree_type;
  typedef typename this_type::key_type key_type;

  sequence<TypeParam> data(6);
  
  tree_type tree;
  EXPECT_EQ(tree.find(this->root), boost::none);
  
  EXPECT_NO_THROW( tree.insert(this->root, data[0]) );
  EXPECT_NO_THROW( tree.insert(this->base, data[1]) );
  EXPECT_NO_THROW( tree.insert(this->leaf1, data[2]) );
  
  // reassignation shall not throw
  EXPECT_NO_THROW( tree.insert(this->leaf2, data[1]) );
  EXPECT_NO_THROW( tree.insert(this->leaf2, data[3]) );
  
  EXPECT_EQ( *tree.find(this->root), data[0] );
  EXPECT_EQ( *tree.find(this->base), data[1] );
  EXPECT_EQ( *tree.find(this->leaf1), data[2] );
  EXPECT_EQ( *tree.find(this->leaf2), data[3] );
  
  key_type keys[3] = {"A", "B", "C"};
  std::vector<key_type> other_path = boost::assign::list_of("A")("B")("C");
  
  EXPECT_EQ( tree.find(other_path), boost::none );
  
  EXPECT_NO_THROW( tree.insert(other_path, data[4]) );
  EXPECT_EQ( *tree.find(other_path), data[4] );
  
  EXPECT_NO_THROW( tree.insert(keys, keys+sizeof(keys)/sizeof(keys[0]), data[5]) );
  EXPECT_EQ( *tree.find(keys, keys+sizeof(keys)/sizeof(keys[0])), data[5] );

  EXPECT_EQ( tree.find(other_path), tree.find(keys, keys+sizeof(keys)/sizeof(keys[0])) );
}
