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

#ifndef COMMON_DYNGRAPH_H_
#define COMMON_DYNGRAPH_H_

#include <vector>
#include <string>
#include <set>
#include <map>
#include <unordered_set>
#include <unordered_map>
#include "DYNMacrosMessage.h"

namespace DYN {
/**
 * @class Graph
 * @brief Graph utility class implementing basic path functions
 */
class Graph {
 public:
  /** @brief default constructor */
  Graph() = default;

  /**
   * @brief add a vertex to the graph structure
   * @param nodeId id of the vertex
   */
  void addVertex(int nodeId) {vertices_.insert(nodeId);}

  void addEdge(int nodeId1, int nodeId2, const std::string & name);

  /**
   * @brief check if a path exist between two vertices
   * @param nodeId1 index of the first vertex
   * @param nodeId2 index of the second vertex
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @return @b true if a path exists, @b false otherwise
   */
  bool pathExist(int nodeId1, int nodeId2, const std::unordered_set<std::string> & closedEdges);

  /**
   * @brief find the shortest path between two vertices
   * @param vertexOrigin index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @param path a list of edge's id encountered between origin and extremity of the path
   * this list is empty if there is no path or if the vertexOrigin and extremity are the same
   */
  std::vector<std::string> shortestPath(int nodeIdStart, int nodeIdEnd, const std::unordered_set<std::string> & closedEdges);

  /**
   * @brief partitions the graph in indexed connex components
   * @param closedEdges list of edges IDs considered active (closed)
   * @param result the resulting partition, with a component ID associated to each node ID
   * @return the number of resulting partitions
   */
  int calculateComponents(const std::unordered_set<std::string> & closedEdges, std::map<int, int> & result);

 private:
   /**
   * @brief check if a vertex exists, throws if it does not
   * @param nodeId id of the vertex to check
   */
  void checkVertex(int nodeId) {if (vertices_.find(nodeId) == vertices_.end()) throw DYNError(DYN::Error::GENERAL, UnknownVertex, nodeId);}

  std::unordered_map<int, std::unordered_set<int>> buildNeighboringMap(const std::unordered_set<std::string> & edges);

  std::vector<std::string> buildStringPath(int nodeIdEnd, const std::unordered_map<int, int> & predecessors);

  inline int dualId(int nodeId1, int nodeId2);

 private:
  std::set<int> vertices_;
  std::unordered_map<std::string, std::pair<int, int>> edges_;
  std::unordered_map<int, std::string> edgesNames_;
};

}  // namespace DYN

#endif  // COMMON_DYNGRAPH_H_
