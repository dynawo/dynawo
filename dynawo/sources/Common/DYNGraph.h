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
  void addVertex(int nodeId);

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
  std::unordered_set<std::string> getAllEdges() const {return edgesNames_;}

  /**
   * @brief check if a path exist between two vertices
   * @param nodeId1 index of the first vertex
   * @param nodeId2 index of the second vertex
   * @param closedEdges the list of the edges considered active (closed). All edges are considered active if empty.
   * @return @b true if a path exists, @b false otherwise
   */
  bool pathExist(int nodeId1, int nodeId2, const std::unordered_set<std::string> & closedEdges = std::unordered_set<std::string>());

  /**
   * @brief find the shortest path between two vertices
   * @param nodeIdStart index of the first vertex
   * @param nodeIdEnd index of the second vertex
   * @param closedEdges the list of the edges considered active (closed). All edges are considered active if empty.
   * @return list of edge's id encountered between origin and extremity of the path
   * this list is empty if there is no path or if the vertexOrigin and extremity are the same
   */
  std::vector<std::string>
  shortestPath(int nodeIdStart, int nodeIdEnd, const std::unordered_set<std::string> & closedEdges = std::unordered_set<std::string>());

  /**
   * @brief partitions the graph in indexed connex components
   * @param closedEdges list of edges IDs considered active (closed)
   * @return the resulting partition, with a component ID corresponding to each valid node index, and the number of components in last element
   */
  std::vector<int> calculateComponents(const std::unordered_set<std::string> & closedEdges);

 private :
  /**
   * @brief check if a vertex exists, throws if it does not
   * @param nodeId id of the vertex to check
   */
  inline void checkVertex(int nodeId) const;

  /** @brief check if neighbors_ has been initialized, do it if that is not the case */
  inline void checkNeighbors();

  /**
   * @brief check that both nodeIds are valid, and that neighbors_ has been initialized
   * @param nodeId1 first id of the vertex to check
   * @param nodeId2 second id of the vertex to check
   */
  inline void checkNodes(int nodeId1, int nodeId2);

   /**
   * @brief builds a path from a node mapping to wrap up the shortest path algorithm
   * @param nodeIdEnd the node ID corresponding to the end of the path
   * @param predecessors a structure defining for each node ID the ID of its predecessor in the path
   * @return the path, constituted from an ordered list of switch names from start to end
   */
  std::vector<std::string> buildStringPath(int nodeIdEnd, const std::vector<int> & predecessors) const;

 private:
  std::unordered_set<int> vertices_;  ///< all node IDs already declared
  std::unordered_set<std::string> edgesNames_;  ///< all edges already defined
  std::unordered_map<int, std::string> edgesByNodes_;  ///< nodes to edges mapping, with composite IDs from the 2 node IDs as keys and edges names as values
  std::vector<std::vector<int>> neighbors_;  ///< sparse connexity matrix : for each node, the list of its neighbors
  std::unordered_set<int> missingNodes_;  ///< the list of absent nodes between 0 and nodeIdMax_
  int nodeIdMax_ = 0;  ///< maximum nodeId included in vertices_
};

}  // namespace DYN

#endif  // COMMON_DYNGRAPH_H_
