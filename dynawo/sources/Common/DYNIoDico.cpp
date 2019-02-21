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
 * @file  DYNIoDico.cpp
 *
 * @brief IoDico class implementation
 *
 */
#include <unistd.h>
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
using std::string;
using std::ifstream;
using boost::shared_ptr;
using std::stringstream;
using std::vector;


namespace DYN {

static bool readLine(string& line, string& key, string& phrase);

shared_ptr<IoDicos> IoDicos::getInstance() {
  static shared_ptr<IoDicos> instance;
  if (instance)
    return instance;

  instance.reset(new IoDicos());
  return instance;
}

void IoDicos::addPath(const string& path) {
  paths_.push_back(path);
}

bool IoDicos::hasIoDico(const string& dicoName) {
  return ( getInstance()->dicos_.find(dicoName) != getInstance()->dicos_.end());
}

boost::shared_ptr<IoDico> IoDicos::getIoDico(const string& dicoName) {
  if (hasIoDico(dicoName)) {
    return getInstance()->dicos_[dicoName];
  } else {
    stringstream msg;
    msg << " Unknown dictionary '" << dicoName << "'";
    throw(msg.str());
  }
}

vector<std::string> IoDicos::findFiles(const string& fileName) {
  vector<std::string> res;
  if (fileName.empty())
    return res;


  // Research file in paths
  vector<string> allPaths;
  for (unsigned int i = 0; i < getInstance()->paths_.size(); ++i) {
    vector<string> paths;
    boost::algorithm::split(paths, getInstance()->paths_[i], boost::is_any_of(":"));
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
  if (baseName.empty()) {
    static string msg = "Impossible to add the dictionary : empty name";
    throw(&msg);
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
    throw("Impossible to find the dictionary : " + fileName);
  if (files.size() != 1)
    throw("Multiple occurence of the dictionary : " + fileName);
  string file = files[0];

  if (hasIoDico(name)) {
    boost::shared_ptr<IoDico> dico = getIoDico(name);
    dico->readFile(file);  // new key/sentence added to the existing dico
  } else {
    boost::shared_ptr<IoDico> dico(new IoDico(name));
    dico->readFile(file);
    getInstance()->dicos_[name] = dico;
  }
}

void IoDicos::addDicos(const string& dictionariesMappingFile, const string& locale) {
  if (dictionariesMappingFile.empty()) {
    static string msg = "Impossible to add the dictionary mapping file : empty name";
    throw(&msg);
  }

  // build name of the file to search
  string fileName = dictionariesMappingFile + ".dic";
  const vector<string>& files = findFiles(fileName);

  if (files.empty())
    throw("Impossible to find the dictionary mapping file : " + fileName);

  boost::shared_ptr<IoDico> dico(new IoDico("MAPPING"));
  for (vector<string>::const_iterator it = files.begin(), itEnd = files.end(); it != itEnd; ++it) {
    dico->readFile(*it);
  }

  typedef std::map<string, string>::const_iterator DicoIter;
  for (DicoIter it = dico->begin(), itEnd = dico->end(); it != itEnd; ++it) {
    addDico(it->second, it->first, locale);
  }
}

IoDico::IoDico(const string& name) :
name_(name) {
}

IoDico::IoDico(const IoDico & d) {
  map_ = d.map_;
  name_ = d.name_;
}

void IoDico::readFile(const string& file) {
  // Open file
  ifstream in(file.c_str());

  // Try to read it
  if (in.bad()) {
    stringstream msg;
    msg << "Error when opening file : " << file;
    throw(msg.str());
  }

  string line;
  bool ok = true;
  string key;
  string phrase;
  if (in.is_open()) {
    while (getline(in, line) && ok) {
      ok = readLine(line, key, phrase);
      if (ok) {
        if (!key.empty()) {
          if (map_.find(key) != map_.end()) {
            stringstream msg;
            msg << " Reading of the dictionary " << file << " the key '" << key << "' is not unique";
            throw(msg.str());
          }
          map_[key] = phrase;
        }
      } else {
        stringstream msg;
        msg << "Error happened when reading the dictionary " << file;
        throw(msg.str());
      }
    }
    in.close();
  }
}

string IoDico::msg(const string& msgId) {
  string phrase = "";

  if (map_.find(msgId) != map_.end()) {
    phrase = map_[msgId];
  } else {
    stringstream msg;
    msg << "there is no key '" << msgId << "' in the dictionary";
    throw(msg.str());
  }
  return phrase;
}

std::map<string, string>::const_iterator IoDico::begin() const {
  return map_.begin();
}

std::map<string, string>::const_iterator IoDico::end() const {
  return map_.end();
}

/**
 * @brief reads a line in the dictionarry and tries to find the key and the
 * message description (separator used is @b = )
 *
 *
 * @param line  line to read
 * @param key   return key is succeeded to read a key  "" otherwise
 * @param value return value is succeded to read a description, "" otherwise
 *
 * @return @b true is succeeded to read, @b false otherwise
 */
bool
readLine(string& line, string& key, string& value) {
  key = "";
  value = "";
  // 1) erase any comment
  size_t found = line.find("//");
  string line1 = line.substr(0, found);

  boost::algorithm::trim(line1);
  if (line1.empty())  // line empty : it was a comment line
    return true;  // it's not an error

  // 2) cut the line in two parts : key and value with separator =
  found = line1.find("=");
  if (found != string::npos) {
    key = line1.substr(0, found);
    value = line1.substr(found + 1);
  } else {
    return false;
  }

  // erase all blanks at the beginning and at the end of the key
  boost::algorithm::trim(key);

  // same for value
  boost::algorithm::trim(value);

  return true;
}

}  // namespace DYN
