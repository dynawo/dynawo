//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNIoDicos.cpp
 *
 * @brief IoDicos class implementation
 *
 */
#include <limits.h>
#include <stdlib.h>
#include <sstream>
#include <fstream>
#include <vector>
#include <boost/algorithm/string/trim.hpp>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string/predicate.hpp>

#include "DYNIoDico.h"
#include "DYNExecUtils.h"
#include "DYNMacrosMessage.h"
using std::string;
using std::ifstream;
using boost::shared_ptr;
using std::stringstream;
using std::vector;


namespace DYN {

IoDicos::IoDicos() {
}

IoDicos::~IoDicos() {
}

IoDicos& IoDicos::instance() {
  static IoDicos instance;
  return instance;
}

void IoDicos::addPath(const string& path) {
  instance().addPath_(path);
}

void IoDicos::addPath_(const string& path) {
  paths_.push_back(path);
}

bool IoDicos::hasIoDico(const string& dicoName) {
  return instance().hasIoDico_(dicoName);
}

bool IoDicos::hasIoDico_(const string& dicoName) {
  return (dicos_.find(dicoName) != dicos_.end());
}

boost::shared_ptr<IoDico> IoDicos::getIoDico(const string& dicoName) {
  return instance().getIoDico_(dicoName);
}

boost::shared_ptr<IoDico> IoDicos::getIoDico_(const string& dicoName) {
  if (hasIoDico_(dicoName)) {
    return dicos_[dicoName];
  } else {
    throw MessageError("Unknown dictionary '" + dicoName + "'");
  }
}

vector<std::string> IoDicos::findFiles(const string& fileName) {
  vector<std::string> res;
  if (fileName.empty())
    return res;

  // Research file in paths
  vector<string> allPaths;
  for (unsigned int i = 0; i < paths_.size(); ++i) {
    vector<string> paths;
    boost::algorithm::split(paths, paths_[i], boost::is_any_of(":"));
    allPaths.insert(allPaths.begin(), paths.begin(), paths.end());
  }

  for (vector<string>::const_iterator it = allPaths.begin();
          it != allPaths.end();
          ++it) {
    string fic = *it;

    if (fic.size() > 0 && fic[fic.size() - 1] != '/')
      fic += '/';
    fic += fileName;

    ifstream in;
    // Test if file exists
    in.open(fic.c_str());
    if (!in.fail()) {
      res.push_back(fic);
    }
  }

  return res;
}

void IoDicos::addDico(const string& name, const string& baseName, const string& locale) {
  instance().addDico_(name, baseName, locale);
}

void IoDicos::addDico_(const string& name, const string& baseName, const string& locale) {
  if (baseName.empty()) {
    throw MessageError("impossible to add the dictionary : empty name");
  }

  // build name of the file to search
  vector<string> files;
  string fileName;
  // To deal with a Priority dictionnary that does not have a locale.
  if (locale != "") {
    fileName = baseName + string("_") + locale + string(".dic");
    files = findFiles(fileName);
  } else {
    fileName = baseName + string(".dic");
    files = findFiles(fileName);
  }

  if (files.empty())
    throw MessageError("Impossible to find the dictionary : " + fileName);
  if (files.size() != 1) {
    throw MessageError("Multiple occurences of the dictionary : " + fileName);
  }
  string file = files[0];

  if (hasIoDico_(name)) {
    boost::shared_ptr<IoDico> dico = getIoDico_(name);
    dico->readFile(file);  // new key/sentence added to the existing dico
  } else {
    boost::shared_ptr<IoDico> dico(new IoDico(name));
    dico->readFile(file);
    dicos_[name] = dico;
  }
}

void IoDicos::addDicos(const string& dictionariesMappingFile, const string& locale) {
  instance().addDicos_(dictionariesMappingFile, locale);
}

void IoDicos::addDicos_(const string& dictionariesMappingFile, const string& locale) {
  if (dictionariesMappingFile.empty()) {
    throw MessageError("impossible to add the dictionary mapping file : empty name");
  }

  // build name of the file to search
  string fileName = dictionariesMappingFile + ".dic";
  const vector<string>& files = findFiles(fileName);

  if (files.empty())
    throw MessageError("Impossible to find the dictionary mapping file : " + fileName);

  boost::shared_ptr<IoDico> dico(new IoDico("MAPPING"));
  for (vector<string>::const_iterator it = files.begin(), itEnd = files.end(); it != itEnd; ++it) {
    dico->readFile(*it);
  }

  typedef std::map<string, string>::const_iterator DicoIter;
  for (DicoIter it = dico->begin(), itEnd = dico->end(); it != itEnd; ++it) {
    addDico(it->second, it->first, locale);
  }
}

}  // namespace DYN
