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
 * @file Common/Test.cpp
 * @brief Unit tests for Common lib
 *
 */

#include "gtest_dynawo.h"
#include "DYNGraph.h"
#include "DYNParameter.h"

using std::vector;
using std::string;
using std::unordered_set;

namespace DYN {

TEST(CommonTest, testBuildSimpleGraph1) {
  // declare vertices before adding edge
  Graph graph;
  graph.addVertex(1);
  graph.addVertex(2);
  graph.addEdge(1, 2, "1-2");
  ASSERT_THROW_DYNAWO(graph.addEdge(1, 2, "1-2"), DYN::Error::GENERAL, DYN::KeyError_t::AlreadyDefinedEdge);  // edge named "0-1" is already defined
}

TEST(CommonTest, testBuildSimpleGraph2) {
  // declare edge without declaring vertices
  Graph graph;
  graph.addVertex(0);
  ASSERT_THROW_DYNAWO(graph.addEdge(0, 1, "0-1"), DYN::Error::GENERAL, DYN::KeyError_t::UnknownVertex);  // vertex 1 is unknown
  ASSERT_THROW_DYNAWO(graph.addEdge(1, 0, "1-0"), DYN::Error::GENERAL, DYN::KeyError_t::UnknownVertex);  // vertex 1 is unknown
}

/*
 * Used graphs in following tests
 *
 *              0
 *              |
 *     ---------------------
 *     |    |      |       |
 *     1    2      3    -------
 *     |    |      |    |     |
 *     ------      |    6     7
 *        |        |    |     |
 *        4        |    -------
 *        |        |       |
 *       -----------       |
 *             |           |
 *             5           8
 *             |           |
 *             -------------
 *                 |
 *                 9
 */

static Graph defineGraph() {
  Graph graph;
  for (unsigned int i = 0; i < 10; ++i)
    graph.addVertex(i);
  graph.addEdge(0, 1, "0-1");
  graph.addEdge(0, 2, "0-2");
  graph.addEdge(0, 3, "0-3");
  graph.addEdge(0, 6, "0-6");
  graph.addEdge(0, 7, "0-7");
  graph.addEdge(1, 4, "1-4");
  graph.addEdge(2, 4, "2-4");
  graph.addEdge(4, 5, "4-5");
  graph.addEdge(3, 5, "3-5");
  graph.addEdge(6, 8, "6-8");
  graph.addEdge(7, 8, "7-8");
  graph.addEdge(5, 9, "5-9");
  graph.addEdge(8, 9, "8-9");

  return graph;
}

TEST(CommonTest, testPathExistGraph) {
  Graph graph = defineGraph();

  // add additional vertex
  graph.addVertex(10);

  // use all edge : weights equals to 1
  unordered_set<string> edges = graph.getAllEdges();

  ASSERT_EQ(graph.pathExist(1, 1, edges), true);
  ASSERT_EQ(graph.pathExist(1, 5, edges), true);
  ASSERT_EQ(graph.pathExist(1, 10, edges), false);
  ASSERT_THROW_DYNAWO(graph.pathExist(11, 12, edges), DYN::Error::GENERAL, DYN::KeyError_t::UnknownVertex);  // vertices not declared for this graph
}

TEST(CommonTest, testshortestPathGraph) {
  Graph graph = defineGraph();

  // add additional vertex
  graph.addVertex(10);

  // use all edge : weights equals to 1
  unordered_set<string> edges = graph.getAllEdges();
  ASSERT_EQ(edges.size(), 13);

  // shortest path between 0 -0 : empty path
  vector<string> path0 = graph.shortestPath(0, 0, edges);
  ASSERT_EQ(path0.empty(), true);

  // shortest path between 0-5 : 0->3->5
  vector<string> path1 = graph.shortestPath(0, 5, edges);
  ASSERT_EQ(path1.size(), 2);
  ASSERT_EQ(path1[0], "0-3");
  ASSERT_EQ(path1[1], "3-5");

  // shortest path between 0-3 : 0->3
  path1 = graph.shortestPath(0, 3, edges);
  ASSERT_EQ(path1.size(), 1);
  ASSERT_EQ(path1[0], "0-3");

  // open edge between 0-3; shortest path between 0-5 : 0->1/2->4->5
  edges.erase("0-3");
  path1 = graph.shortestPath(0, 5, edges);
  ASSERT_EQ(path1.size(), 3);
  ASSERT_EQ(path1[2], "4-5");

  // open edge between 4-5; shortest path between 0-5 : 0->6/7->8->9->5
  edges.erase("4-5");
  path1 = graph.shortestPath(0, 5, edges);
  ASSERT_EQ(path1.size(), 4);
  ASSERT_EQ(path1[2], "8-9");
  ASSERT_EQ(path1[3], "5-9");

  // restore edges
  edges.insert("0-3");
  edges.insert("4-5");

  // shortest path between 0 and 10 : empty path
  vector<string> path2 = graph.shortestPath(0, 10, edges);
  ASSERT_EQ(path2.empty(), true);
}

TEST(CommonTest, testComponentGraph) {
  Graph graph = defineGraph();
  // use all edges
  unordered_set<string> edges = graph.getAllEdges();
  int nbComponents;
  std::map<int, int> verticesComponent = graph.calculateComponents(edges, &nbComponents);
  ASSERT_EQ(nbComponents, 1);

  // open edge to have 2 components : 4-5, 3-5, 8-9
  edges.erase("3-5");
  edges.erase("8-9");
  edges.erase("4-5");
  verticesComponent = graph.calculateComponents(edges, &nbComponents);
  ASSERT_EQ(nbComponents, 2);
  ASSERT_EQ(verticesComponent[0], verticesComponent[3]);
  ASSERT_EQ(verticesComponent[5], verticesComponent[9]);
  ASSERT_NE(verticesComponent[0], verticesComponent[9]);
}

/*
 *          6
 *          |
 *          0
 *          |
 *   --------------------
 *   |      |           |
 *   1      2           |
 *   |      |           |
 *   --------           3
 *      |               |
 *      4               |
 *      |               |
 *   --------------------
 *            |
 *            5
 */


TEST(CommonTest, testGraphWithLoop) {
  Graph graph;
  for (unsigned int i = 0; i < 12; ++i)
    graph.addVertex(i);

  graph.addEdge(0, 1, "0-1");
  graph.addEdge(0, 2, "0-2");
  graph.addEdge(0, 3, "0-3");
  graph.addEdge(1, 4, "1-4");
  graph.addEdge(2, 4, "2-4");
  graph.addEdge(4, 5, "4-5");
  graph.addEdge(3, 5, "3-5");
  graph.addEdge(6, 0, "6-0");

  vector<string> path = graph.shortestPath(4, 6, graph.getAllEdges());
  ASSERT_EQ(path.size(), 3);  // edges : "1-4" "0-1" 6-0"
  ASSERT_EQ(path[0], "1-4");
  ASSERT_EQ(path[1], "0-1");
  ASSERT_EQ(path[2], "6-0");
}
}  // namespace DYN
