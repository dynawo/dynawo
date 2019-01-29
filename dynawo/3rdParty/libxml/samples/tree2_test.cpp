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

#include <xml/sax/parser/ElementName.h>

#include <iostream>
#include <string>

using std::cout;
using std::cerr;
using std::endl;


namespace parser = xml::sax::parser;

using parser::ElementName;
using parser::namespace_uri;
using parser::XmlPath;


typedef parser::path_tree<ElementName, std::string> XmlTtree;


void look_at(XmlTtree const& tree, XmlPath const& path) {
  boost::optional<std::string const&> searched = tree.find(path);
  cout << "searched value for "<< path << ": " << (searched ? *searched: "missing") << endl;
}

void down_hand(XmlTtree const& tree, XmlPath const& path) {
  XmlPath p;
  for (XmlPath::const_iterator it = path.begin(); it!=path.end(); ++it) {
    p+=*it;
    
    boost::optional<std::string const&> searched = tree.find(p);

    if (searched) {
      cout << '\t' << p << " = " << *searched << endl;
    }
  }
}

int main() {
  namespace_uri ns1("x");
  namespace_uri ns2("o");
  
  XmlPath p1 = ns1 ("a/b");
  XmlPath p2 = ns1 ("a/b/c");
  cout << "p1 = " << p1 << endl;
  cout << "p2 = " << p2 << endl;
  
  XmlTtree tree1;
  
  tree1.insert(p1, "value1");
  tree1.insert(p2, "value2");

  look_at(tree1, p1);
  look_at(tree1, p2);
  
  
  XmlTtree tree2 = tree1;
  
  tree1.insert(p1,"coin coin");
  
  XmlTtree tree3;
  tree3.insert(ns1("a"), "erreur");
  
  tree3 = tree2;
  tree3.insert(ns1("a"), "correction");
  
  
  tree3.insert(ns1("a")+ns2("b")+ns1("c"), "fatal");
  
  cout << "tree1 = " << endl;
  down_hand(tree1, p2);
  cout << "tree2 = " << endl;
  down_hand(tree2, p2);
  cout << "tree3 = " << endl;
  down_hand(tree3, p2);
  
  
  cout << "tree3 = " << endl;
  down_hand(tree3, namespace_uri("x")("a/b/c"));
  down_hand(tree3, ns1("a")+ns2("b")+ns1("c"));
  
  cout << "------------------------" << endl;
  
  return 0;
}
