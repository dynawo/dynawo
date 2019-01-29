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

#include <iostream>
#include <string>


namespace parser = xml::sax::parser;

using parser::path;
using parser::path_tree;

using std::cout;
using std::cerr;
using std::endl;

typedef path<std::string> spath;
typedef path_tree<std::string, std::string> stree;

std::ostream& operator << (std::ostream& stream, spath const& p) {
  for (spath::const_iterator it = p.begin(); it!=p.end(); ++it) {
    stream << '/' << *it;
  }
  return stream;
}


void look_at(stree const& tree, spath const& path) {
  boost::optional<std::string const&> searched = tree.find(path);
  cout << "searched value for "<< path << ": " << (searched ? *searched: "missing") << endl;
}

void down_hand(stree const& tree, spath const& path) {
  spath p;
  for (spath::const_iterator it = path.begin(); it!=path.end(); ++it) {
    p+=*it;
    
    boost::optional<std::string const&> searched = tree.find(p);

    if (searched) {
      cout << "downing with " << *searched << endl;
    }
  }
}

// void down_iter(stree const& tree, spath const& path) {
  // for (stree::down_path_const_iterator it = tree.cdown(path); it!=tree.cdown_end(); ++it) {
    // cout << "downing with " << *it << endl;
  // }
// }

int main() {

  spath p1 = spath("a")+"b";
  spath p2 = spath("a")+"b"+"c";
  cout << "p1 = " << p1 << endl;
  cout << "p2 = " << p2 << endl;
  
  stree tree1;
  
  tree1.insert(p1, "value1");
  tree1.insert(p2, "value2");

  look_at(tree1, p1);
  look_at(tree1, p2);
  
  
  stree tree2 = tree1;
  
  tree1.insert(p1,"coin coin");
  
  stree tree3;
  tree3.insert(spath("a"), "erreur");
  
  tree3 = tree2;
  tree3.insert(spath("a"), "correction");
  
  cout << "tree1 = " << endl;
  down_hand(tree1, p2);
  cout << "tree2 = " << endl;
  down_hand(tree2, p2);
  cout << "tree3 = " << endl;
  down_hand(tree3, p2);
  
  cout << "------------------------" << endl;
  
  return 0;
}
