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
 * @file  DYNGraph.cpp
 *
 * @brief Encapsulation of boost::graph.
 *
 */
#include <iostream>
#include <sstream>
#include "DYNGraph.h"
#include "DYNMacrosMessage.h"

using std::string;
using std::vector;
using std::map;
using std::pair;
using std::list;
using boost::add_vertex;
using boost::put;
using boost::edge;
using boost::add_edge;

bool path_length_is_shorter(const PathDescription& path1, const PathDescription& path2) {
  return (path1.size() < path2.size());
}

namespace DYN {

Graph::Graph() {
}

Graph::~Graph() {
}

void
Graph::addVertex(unsigned indexVertex) {
  vertices_[indexVertex] = add_vertex(internalGraph_);
}

void
Graph::addEdge(const unsigned int& indexVertex1, const unsigned int& indexVertex2, const string& id) {
  if (!hasVertex(indexVertex1))
    throw DYNError(DYN::Error::GENERAL, UnknownVertex, indexVertex1);
  if (!hasVertex(indexVertex2))
    throw DYNError(DYN::Error::GENERAL, UnknownVertex, indexVertex2);

  if (edges_.find(id) != edges_.end())
    throw DYNError(DYN::Error::GENERAL, AlreadyDefinedEdge, id);

  std::pair<Edge, bool> edgePair = add_edge(vertices_[indexVertex1], vertices_[indexVertex2], internalGraph_);
  put(boost::edge_name_t(), internalGraph_, edgePair.first, id);
  edges_[id] = edgePair.first;
}

void
Graph::setEdgesWeight(const boost::unordered_map<string, float>& edgeWeights) {
  for (boost::unordered_map<string, float>::const_iterator iter = edgeWeights.begin(); iter != edgeWeights.end(); ++iter) {
    Edge edge = edges_[iter->first];
    put(boost::edge_weight_t(), internalGraph_, edge, iter->second);
  }
}

bool
Graph::pathExist(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity, const boost::unordered_map<string, float> & edgeWeights) {
  if (vertexOrigin == vertexExtremity)
    return true;
  std::list<PathDescription> paths;
  findAllPaths(vertexOrigin, vertexExtremity, edgeWeights, paths, true);
  return (!paths.empty());
}

void
Graph::findAllPaths(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity, const boost::unordered_map<string, float> & edgeWeights,
    std::list<PathDescription>& paths, bool stopWhenExtremityReached) {
  if (vertexOrigin == vertexExtremity)
    return;

  setEdgesWeight(edgeWeights);
  positive_edge_weight<EdgeWeightMap> filter(get(boost::edge_weight_t(), internalGraph_));
  FilteredBoostGraph filteredGraph = FilteredBoostGraph(internalGraph_, filter);
  if (hasVertex(vertexOrigin) && hasVertex(vertexExtremity)) {
    // explore graph thanks to AdjacentVertices
    adjacency_iterator_filtered neighbourIt;
    adjacency_iterator_filtered neighbourEnd;
    boost::tie(neighbourIt, neighbourEnd) = boost::adjacent_vertices(vertices_[vertexOrigin], filteredGraph);
    for (; neighbourIt != neighbourEnd; ++neighbourIt) {
      const unsigned int neighbour = static_cast<unsigned int>(*neighbourIt);
      vector<bool> encountered = vector<bool>(boost::num_vertices(filteredGraph), false);
      encountered[vertexOrigin] = true;
      encountered[neighbour] = true;

      std::pair<Edge, bool> edgePair = edge(vertices_[vertexOrigin], vertices_[neighbour], filteredGraph);
      string edgeId = boost::get(boost::edge_name, filteredGraph, edgePair.first);
      PathDescription currentPath;
      currentPath.push_back(edgeId);

      if (*neighbourIt != vertexExtremity) {
        if (findAllPaths(neighbour, vertexExtremity, currentPath, encountered, paths, filteredGraph, stopWhenExtremityReached) && stopWhenExtremityReached)
          break;
      } else {  // vertexExtremity found
        paths.push_back(currentPath);
        if (stopWhenExtremityReached)
          break;
      }
    }
  }
  paths.sort(path_length_is_shorter);
}

bool
Graph::findAllPaths(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity,
        PathDescription& currentPath, vector<bool> &encountered, list<PathDescription> &paths, FilteredBoostGraph & filteredGraph,
        bool stopWhenExtremityReached) {
  adjacency_iterator_filtered neighbourIt;
  adjacency_iterator_filtered neighbourEnd;
  boost::tie(neighbourIt, neighbourEnd) = boost::adjacent_vertices(vertices_[vertexOrigin], filteredGraph);
  for (; neighbourIt != neighbourEnd; ++neighbourIt) {
    const unsigned int neighbour = static_cast<unsigned int>(*neighbourIt);
    if (encountered[neighbour])
      continue;

    std::pair<Edge, bool> edgePair = edge(vertices_[vertexOrigin], vertices_[neighbour], filteredGraph);
    string edgeId = boost::get(boost::edge_name, filteredGraph, edgePair.first);

    PathDescription currentPath2 = currentPath;
    if (findAllPaths(edgeId, neighbour, vertexExtremity, currentPath2, encountered, paths, filteredGraph, stopWhenExtremityReached)) {
      currentPath.insert(currentPath.end(), currentPath2.begin(), currentPath2.end());
      if (stopWhenExtremityReached)
        return true;
    }
  }
  return false;
}

bool
Graph::findAllPaths(const string& edgeId, const unsigned int& vertex, const unsigned int& vertexExtremity,
                    PathDescription& currentPath, vector<bool> &encountered, list<PathDescription> &paths, FilteredBoostGraph & filteredGraph,
                    bool stopWhenExtremityReached) {
  encountered[vertex] = true;

  currentPath.push_back(edgeId);

  if (vertex == vertexExtremity) {  // vertexExtremity found
    paths.push_back(currentPath);
    return true;
  } else {
    if (findAllPaths(vertex, vertexExtremity, currentPath, encountered, paths, filteredGraph, stopWhenExtremityReached))
      return true;
  }
  return false;
}

void
Graph::shortestPath(const unsigned int& vertexOrigin, const unsigned int& vertexExtremity,
    const boost::unordered_map<string, float> & edgeWeights, PathDescription& path) {
  if (vertexOrigin == vertexExtremity)
    return;

  list<PathDescription> allPaths;
  findAllPaths(vertexOrigin, vertexExtremity, edgeWeights, allPaths);

  // case of no paths
  if (allPaths.empty())
    return;

  // paths sorted by size
  path = *allPaths.begin();
}

std::pair<unsigned int, vector<unsigned int> >
Graph::calculateComponents(const boost::unordered_map<string, float>& edgeWeights) {
  setEdgesWeight(edgeWeights);
  positive_edge_weight<EdgeWeightMap> filter(get(boost::edge_weight_t(), internalGraph_));
  FilteredBoostGraph filteredGraph = FilteredBoostGraph(internalGraph_, filter);

  vector<unsigned int> component(boost::num_vertices(filteredGraph));
  int nbComponents = boost::connected_components(filteredGraph, &component[0]);
  return std::pair<unsigned int, vector<unsigned int> >(nbComponents, component);
}

bool
Graph::hasVertex(unsigned int index) {
  return (vertices_.find(index) != vertices_.end());
}

}  // namespace DYN
