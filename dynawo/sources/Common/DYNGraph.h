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
#include <map>
#include <unordered_map>
#include <unordered_set>

namespace DYN {
/**
 * @class Graph
 * @brief Utility class implementing basic search functions in a graph
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

  /**
   * @brief add a named edge to the graph structure
   * @param nodeId1 index of the first vertex
   * @param nodeId2 index of the second vertex
   * @param name the name of the edge, for further reference
   */
  void addEdge(int nodeId1, int nodeId2, const std::string & name);

  /**
   * @brief list all the predefined edges in the graph by their given names
   * @return the list of edges names
   */
  std::unordered_set<std::string> getAllEdges() const;

  /**
   * @brief check if a path exist between two vertices
   * @param nodeId1 index of the first vertex
   * @param nodeId2 index of the second vertex
   * @param closedEdges the list of the edges considered active (closed), by name
   * @return @b true if a path exists, @b false otherwise
   */
  bool pathExist(int nodeId1, int nodeId2, const std::unordered_set<std::string> & closedEdges) const;

  /**
   * @brief find the shortest path between two vertices
   * @param nodeIdStart index of the first vertex
   * @param nodeIdEnd index of the second vertex
   * @param closedEdges the list of the edges considered active (closed)
   * @return list of edge's id encountered between origin and extremity of the path
   * this list is empty if there is no path or if the vertexOrigin and extremity are the same
   */
  std::vector<std::string> shortestPath(int nodeIdStart, int nodeIdEnd, const std::unordered_set<std::string> & closedEdges) const;

  /**
   * @brief partitions the graph in indexed connex components
   * @param closedEdges list of edges IDs considered active (closed)
   * @param nbComponents the number of components in the resulting partition (optional result value)
   * @return the resulting partition, with a component ID associated to each node ID
   */
  std::map<int, int> calculateComponents(const std::unordered_set<std::string> & closedEdges, int * nbComponents = nullptr) const;

 private :
   /**
   * @brief check if a vertex exists, throws if it does not
   * @param nodeId id of the vertex to check
   */
  void checkVertex(int nodeId) const;

  /**
   * @brief builds an adjacency map from the given list of edges, which associates to each node the list of its neighbors
   * @param edges the list of textual IDs of the edges considered active (valid) in the predefined graph
   * @return the adjacency map, which associates to each node ID the list of its neighbors
   */
  std::unordered_map<int, std::unordered_set<int>> buildNeighboringMap(const std::unordered_set<std::string> & edges) const;

   /**
   * @brief builds a path from a node mapping to wrap up the shortest path algorithm
   * @param nodeIdEnd the node ID corresponding to the end of the path
   * @param predecessors a structure defining for each node ID the ID of its predecessor in the path
   * @return the path, constituted from an ordered list of switch names from start to end
   */
  std::vector<std::string> buildStringPath(int nodeIdEnd, const std::unordered_map<int, int> & predecessors) const;

 private:
  std::unordered_set<int> vertices_;  ///< all node IDs already declared
  std::unordered_map<std::string, std::pair<int, int>> edges_;  ///< all edges already defined, with edges names as keys and connected node IDs as values
  std::unordered_map<int, std::string> edgesNames_;  ///< reverse edges mapping, with composite IDs from the 2 node IDs as keys and edges names as values
};

}  // namespace DYN

#endif  // COMMON_DYNGRAPH_H_
