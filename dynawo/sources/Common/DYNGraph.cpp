//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNGraph.cpp
 *
 * @brief Encapsulation of boost::graph.
 *
 */
#include <iostream>
#include <sstream>
#include "DYNGraph.h"
#include "DYNMacrosMessage.h"
#include <boost/graph/dijkstra_shortest_paths.hpp>

using std::string;
using std::vector;
using std::map;
using std::pair;
using std::list;
using boost::add_vertex;
using boost::put;
using boost::edge;
using boost::add_edge;

namespace DYN {

Graph::Graph() {
}

void
Graph::addVertex(const unsigned vertexId) {
  vertices_[vertexId] = add_vertex(internalGraph_);
  put(boost::vertex_name_t(), internalGraph_, vertices_[vertexId], vertexId);
}

void
Graph::addEdge(const unsigned indexVertex1, const unsigned indexVertex2, const string& id) {
  if (!hasVertex(indexVertex1))
    throw DYNError(DYN::Error::GENERAL, UnknownVertex, indexVertex1);
  if (!hasVertex(indexVertex2))
    throw DYNError(DYN::Error::GENERAL, UnknownVertex, indexVertex2);

  if (edges_.find(id) != edges_.end())
    throw DYNError(DYN::Error::GENERAL, AlreadyDefinedEdge, id);

  const std::pair<Edge, bool> edgePair = add_edge(vertices_[indexVertex1], vertices_[indexVertex2], internalGraph_);
  put(boost::edge_name_t(), internalGraph_, edgePair.first, id);
  edges_[id] = edgePair.first;
}

void
Graph::setEdgesWeight(const std::unordered_map<string, float>& edgeWeights) {
  auto edgeIterators = boost::edges(internalGraph_);
  for (auto it = edgeIterators.first, itEnd = edgeIterators.second; it != itEnd; ++it) {
    const auto& edgeName = boost::get(boost::edge_name, internalGraph_, *it);
    const auto& it2 = edgeWeights.find(edgeName);
    if (it2 != edgeWeights.end())
      put(boost::edge_weight_t(), internalGraph_, *it, it2->second);
  }
}

void
Graph::dijkstra(const unsigned vertexOrigin, const unsigned vertexExtremity,
    const std::unordered_map<std::string, float>& edgeWeights,
    PathDescription& path) {
  if (vertexOrigin == vertexExtremity)
    return;

  setEdgesWeight(edgeWeights);
  if (hasVertex(vertexOrigin) && hasVertex(vertexExtremity)) {
    positive_edge_weight<EdgeWeightMap> filter(get(boost::edge_weight_t(), internalGraph_));
    FilteredBoostGraph filteredGraph = FilteredBoostGraph(internalGraph_, filter);

    std::unordered_map<unsigned int, Vertex> filteredVertices;
    auto vs = boost::vertices(filteredGraph);
    for (auto it = vs.first; it != vs.second; ++it) {
      filteredVertices[boost::get(boost::vertex_name, filteredGraph, *it)] = *it;
    }

    Vertex start = filteredVertices[vertexOrigin];
    std::vector<Vertex> predecessor(boost::num_vertices(filteredGraph));
    std::vector<int> distance(boost::num_vertices(filteredGraph));
    dijkstra_shortest_paths(filteredGraph, start, boost::predecessor_map(&predecessor[0]).distance_map(&distance[0]) );

    Vertex node = filteredVertices[vertexExtremity];
    if (distance[node] == std::numeric_limits<int>::max())
      return;
    while (node != start) {
      Vertex prec = predecessor[node];
      auto edgeIterators = boost::edges(filteredGraph);
      for (auto it = edgeIterators.first, itEnd = edgeIterators.second; it != itEnd; ++it) {
        const auto& source = boost::source(*it, filteredGraph);
        const auto& target = boost::target(*it, filteredGraph);
        if ((source == node && target == prec) || (source == prec && target == node)) {
          string edgeId = boost::get(boost::edge_name, filteredGraph, *it);
          path.insert(path.begin(), edgeId);
          break;
        }
      }
      node = prec;
    }
  }
}

bool
Graph::pathExist(const unsigned vertexOrigin, const unsigned vertexExtremity, const std::unordered_map<string, float> & edgeWeights) {
  if (vertexOrigin == vertexExtremity)
    return true;
  PathDescription path;

  setEdgesWeight(edgeWeights);
  const positive_edge_weight<EdgeWeightMap> filter(get(boost::edge_weight_t(), internalGraph_));
  const FilteredBoostGraph filteredGraph = FilteredBoostGraph(internalGraph_, filter);
  if (hasVertex(vertexOrigin) && hasVertex(vertexExtremity)) {
    const Vertex start = vertices_[vertexOrigin];
    std::vector<Vertex> predecessor(boost::num_vertices(filteredGraph));
    std::vector<int> distance(boost::num_vertices(filteredGraph));
    dijkstra_shortest_paths(filteredGraph, start, boost::predecessor_map(&predecessor[0]).distance_map(&distance[0]) );
    return distance[vertices_[vertexExtremity]] != std::numeric_limits<int>::max();
  }
  return false;
}

void
Graph::shortestPath(const unsigned vertexOrigin, const unsigned vertexExtremity,
    const std::unordered_map<string, float> & edgeWeights, PathDescription& path) {
  if (vertexOrigin == vertexExtremity)
    return;

  dijkstra(vertexOrigin, vertexExtremity, edgeWeights, path);
}

std::pair<unsigned int, vector<unsigned int> >
Graph::calculateComponents(const std::unordered_map<string, float>& edgeWeights) {
  setEdgesWeight(edgeWeights);
  const positive_edge_weight<EdgeWeightMap> filter(get(boost::edge_weight_t(), internalGraph_));
  const FilteredBoostGraph filteredGraph = FilteredBoostGraph(internalGraph_, filter);

  vector<unsigned int> component(boost::num_vertices(filteredGraph));
  int nbComponents = boost::connected_components(filteredGraph, &component[0]);
  return std::pair<unsigned int, vector<unsigned int> >(nbComponents, component);
}

bool
Graph::hasVertex(unsigned int id) {
  return (vertices_.find(id) != vertices_.end());
}

}  // namespace DYN
