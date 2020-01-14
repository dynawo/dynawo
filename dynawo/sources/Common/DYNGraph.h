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
 * @file  DYNGraph.h
 *
 * @brief Graph interface : encapsulation of boost::graph
 *
 */
#ifndef COMMON_DYNGRAPH_H_
#define COMMON_DYNGRAPH_H_

#include <utility>

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/adjacency_iterator.hpp>
#include <boost/graph/filtered_graph.hpp>
#include <boost/graph/graph_traits.hpp>
#include <boost/graph/connected_components.hpp>
#include <boost/property_map/property_map.hpp>
#include <boost/graph/iteration_macros.hpp>
#include <boost/graph/properties.hpp>
#include <boost/graph/connected_components.hpp>
#include <boost/unordered_map.hpp>


// definitions of typedef alias to hide boost types
typedef boost::property<boost::edge_weight_t, float, boost::property<boost::edge_name_t, std::string> > EdgeProperty;  ///< properties associated to an edge
typedef boost::property<boost::vertex_name_t, std::string> VertexProperty;  ///< property associated to a vertex
typedef boost::adjacency_list <boost::vecS, boost::vecS, boost::undirectedS, VertexProperty, EdgeProperty> BoostGraph;  ///< graph description
typedef boost::graph_traits < BoostGraph >::vertex_descriptor Vertex;  ///< vertex description
typedef BoostGraph::edge_descriptor Edge;  ///< edge description
typedef std::vector<std::string> PathDescription;  ///< path description
typedef boost::property_map<BoostGraph, boost::edge_weight_t>::type EdgeWeightMap;  ///< property map associated to the weight of each edge
typedef boost::graph_traits < BoostGraph >::adjacency_iterator adjacency_iterator;  ///< iterator on adjacency_list

/**
 * @brief edge predicate to filter edge contained in a boost graph
 */
template <typename EdgeWeightMap>
struct positive_edge_weight {
  /**
   * @brief default constructor
   */
  positive_edge_weight() { }

  /**
   * @brief copy constructor
   * @param weight weight to use for the predicate
   */
  explicit positive_edge_weight(EdgeWeightMap weight) : m_weight(weight) { }

  /**
   * @brief edge predicate to filter edge
   * @param e edge to filter
   * @return @b true if the weight of the edge is positive, @b false otherwise
   */
  template <typename Edge>
  bool operator()(const Edge& e) const {
    return 0 < get(m_weight, e);
  }
  EdgeWeightMap m_weight;  ///< Property map associated to the weight of each edge
};
typedef boost::filtered_graph <BoostGraph, positive_edge_weight<EdgeWeightMap> > FilteredBoostGraph;  ///< filtered graph description
typedef boost::graph_traits < FilteredBoostGraph >::adjacency_iterator adjacency_iterator_filtered;  ///< iterator on adjacency_list for filtered graph

namespace DYN {

/**
 * @class Graph
 * @brief Graph class to manipulate topology graph
 */
class Graph {
 public:
  /**
   * @brief default constructor
   */
  Graph();

  /**
   * @brief destructor
   */
  ~Graph();

  /**
   * @brief add a vertex to the graph structure
   *
   * @param indexVertex index of the vertex
   */
  void addVertex(unsigned int indexVertex);

  /**
   * @brief add an edge between two vertices
   *
   * @param indexVertex1 index of th first vertex
   * @param indexVertex2 index of the second vertex
   * @param id id of the edge
   */
  void addEdge(const unsigned int& indexVertex1, const unsigned int& indexVertex2, const std::string& id);

  /**
   * @brief check if a vertex exists
   *
   * @param index index of the vertex to check
   * @return @b true if the vertex exists, @b false otherwise
   */
  bool hasVertex(unsigned int index);

  /**
   * @brief check if a path exist between two vertices
   *
   * @param vertexOrigin index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @return @b true if a path exists, @b false otherwise
   */
  bool pathExist(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity, const boost::unordered_map<std::string, float>& edgeWeights);

  /**
   * @brief find the shortest path between two vertices
   *
   * @param vertexOrigin index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @param path a list of edge's id encountered between origin and extremity of the path
   * this list is empty if there is no path or if the vertexOrigin and extremity are the same
   */
  void shortestPath(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity,
      const boost::unordered_map<std::string, float>& edgeWeights, PathDescription& path);

  /**
   * @brief find all path between two vertices
   *
   * @param vertexOrigin index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @param paths resulting list of pathDescription
   * @param stopWhenExtremityReached : stop the research when the vertexExtremity is reached
   */
  void findAllPaths(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity,
      const boost::unordered_map<std::string, float>& edgeWeights,
      std::list<PathDescription>& paths, bool stopWhenExtremityReached = false);

  /**
   * @brief calculate connected components of a graph
   *
   * @param edgeWeights weights/masks of each edge to filter the graph
   * @return number of components and component per vertices
   */
  std::pair<unsigned int, std::vector<unsigned int> > calculateComponents(const boost::unordered_map<std::string, float>& edgeWeights);

 private:
  /**
   * @brief set the weight/mask of each edge
   *
   * @param weights weight to associate to each edge
   */
  void setEdgesWeight(const boost::unordered_map<std::string, float>& weights);
  /**
   * @brief find all path between two vertices
   *
   * @param vertexOrigin index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param currentPath current path
   * @param encountered indicates if a vertex was already encountered during the graph exploration
   * @param paths description of path already run through
   * @param stopWhenExtremityReached : stop the research when the vertexExtremity is reached
   * @param filteredGraph graph to explore
   *
   * @return @b true if the vertexExtremity is reached
   */
  bool findAllPaths(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity,
      PathDescription &currentPath, std::vector<bool> &encountered, std::list<PathDescription> &paths, FilteredBoostGraph & filteredGraph,
      bool stopWhenExtremityReached);

  /**
   * @brief find if the current edge reach the vertexExtremity
   *
   * @param edgeId current edge
   * @param vertex index of the first vertex
   * @param vertexExtremity index of the second vertex
   * @param currentPath current path
   * @param encountered indicates if a vertex was already encountered during the graph exploration
   * @param paths description of path already run through
   * @param filteredGraph graph to explore
   * @param stopWhenExtremityReached : stop the research when the vertexExtremity is reached
   *
   * @return @b true if the vertexExtremity is reached
   */
  bool findAllPaths(const std::string& edgeId, const unsigned int& vertex, const unsigned int& vertexExtremity,
      PathDescription &currentPath, std::vector<bool> &encountered, std::list<PathDescription> &paths, FilteredBoostGraph & filteredGraph,
      bool stopWhenExtremityReached);

 private:
  BoostGraph internalGraph_;  ///< graph description
  boost::unordered_map<unsigned, Vertex> vertices_;  ///< association between vertices and their index
  boost::unordered_map<std::string, Edge> edges_;  ///< association between edges and their id
};

}  // namespace DYN

#endif  // COMMON_DYNGRAPH_H_
