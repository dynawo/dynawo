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
using std::list;

namespace DYN {

TEST(CommonTest, testBuildSimpleGraph1) {
  // declare vertices before adding edge
  Graph graph;
  graph.addVertex(1);
  graph.addVertex(2);
  graph.addEdge(1, 2, "1-2");
  ASSERT_THROW_DYNAWO(graph.addEdge(1, 2, "1-2"), DYN::Error::GENERAL, DYN::KeyError_t::AlreadyDefinedEdge);  // edge named "0-1" is already defined
  ASSERT_EQ(graph.hasVertex(1), true);
  ASSERT_EQ(graph.hasVertex(2), true);
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

static boost::unordered_map<string, float> defineWeights() {
  boost::unordered_map<string, float> weights;
  weights["0-1"] = 1;
  weights["0-2"] = 1;
  weights["0-3"] = 1;
  weights["0-6"] = 1;
  weights["0-7"] = 1;
  weights["1-4"] = 1;
  weights["2-4"] = 1;
  weights["4-5"] = 1;
  weights["3-5"] = 1;
  weights["6-8"] = 1;
  weights["7-8"] = 1;
  weights["5-9"] = 1;
  weights["8-9"] = 1;

  return weights;
}

TEST(CommonTest, testPathExistGraph) {
  Graph graph = defineGraph();

  // add additional vertex
  graph.addVertex(10);

  // use all edge : weights equals to 1
  boost::unordered_map<string, float> weights = defineWeights();

  ASSERT_EQ(graph.pathExist(1, 1, weights), true);
  ASSERT_EQ(graph.pathExist(1, 5, weights), true);
  ASSERT_EQ(graph.pathExist(1, 10, weights), false);
  ASSERT_EQ(graph.pathExist(11, 12, weights), false);  // vertices not declared for this graph
}

TEST(CommonTest, testshortestPathGraph) {
  Graph graph = defineGraph();

  // add additional vertex
  graph.addVertex(10);

  // use all edge : weights equals to 1
  boost::unordered_map<string, float> weights = defineWeights();

  // shortest path between 0 -0 : empty path
  vector<string> path0;
  graph.shortestPath(0, 0, weights, path0);
  ASSERT_EQ(path0.empty(), true);

  // shortest path between 0-5 : 0->3->5
  vector<string> path1;
  graph.shortestPath(0, 5, weights, path1);
  ASSERT_EQ(path1.size(), 2);
  ASSERT_EQ(path1[0], "0-3");
  ASSERT_EQ(path1[1], "3-5");

  // shortest path between 0-3 : 0->3
  path1.clear();
  graph.shortestPath(0, 3, weights, path1);
  ASSERT_EQ(path1.size(), 1);
  ASSERT_EQ(path1[0], "0-3");

  // open edge between 0-3; shortest path between 0-5 : 0->1->4->5
  weights["0-3"] = 0;
  path1.clear();
  graph.shortestPath(0, 5, weights, path1);
  ASSERT_EQ(path1.size(), 3);
  ASSERT_EQ(path1[0], "0-1");
  ASSERT_EQ(path1[1], "1-4");
  ASSERT_EQ(path1[2], "4-5");

  // restore edge
  weights["0-3"] = 1;

  // shortest path between 0 and 10 : empty path
  vector<string> path2;
  graph.shortestPath(0, 10, weights, path2);
  ASSERT_EQ(path2.empty(), true);
}

TEST(CommonTest, testComponentGraph) {
  Graph graph = defineGraph();
  // use all edge : weights equals to 1
  boost::unordered_map<string, float> weights = defineWeights();

  std::pair<unsigned int, std::vector<unsigned int> > components = graph.calculateComponents(weights);
  ASSERT_EQ(components.first, 1);

  // open edge to have 2 components : 4-5, 3-5, 8-9
  weights["3-5"] = 0;
  weights["8-9"] = 0;
  weights["4-5"] = 0;
  components = graph.calculateComponents(weights);
  ASSERT_EQ(components.first, 2);
  vector<unsigned int> verticesComponent = components.second;
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

  boost::unordered_map<string, float> weights;
  weights["0-1"] = 1;
  weights["0-2"] = 1;
  weights["0-3"] = 1;
  weights["1-4"] = 1;
  weights["2-4"] = 1;
  weights["4-5"] = 1;
  weights["3-5"] = 1;
  weights["6-0"] = 1;


  vector<string> path;
  graph.shortestPath(4, 6, weights, path);
  ASSERT_EQ(path.size(), 3);  // edges : "1-4" "0-1" 6-0"
  ASSERT_EQ(path[0], "1-4");
  ASSERT_EQ(path[1], "0-1");
  ASSERT_EQ(path[2], "6-0");
}
}  // namespace DYN
