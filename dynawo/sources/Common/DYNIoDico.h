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
 * @file  DYNIoDico.h
 *
 * @brief IOdico header
 * IoDico read a dictionary file and return the message description
 * associated to a key
 */
#ifndef COMMON_DYNIODICO_H_
#define COMMON_DYNIODICO_H_

#include <map>
#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <boost/noncopyable.hpp>


namespace DYN {

/**
 * @class OppositeEventDico
 * @brief OppositeEventDico class description
 */
class OppositeEventDico {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the oppositeEventDico
   */
  explicit OppositeEventDico(const std::string& name);

  /**
   * @brief reads a file and extracts all pairs of <key,opposite keys>
   *
   * @param fileName  the full path name of the file to read
   */
  void readFile(const std::string& fileName);

  /**
   * @brief opposite event dictionary getter
   *
   * @return opposite event dictionary
   */
  const std::unordered_map<std::string, std::unordered_set<std::string>>& getOppositeEvents() const;

 private:
  std::unordered_map<std::string, std::unordered_set<std::string>> map_;  ///< map association between key and set of opposite keys
  std::string name_;  ///< name of the dictionary
};

/**
 * @class IoDico
 * @brief IoDico class description
 */
class IoDico {
 public:
  /**
   * @brief Constructor
   *
   * @param name name of the IoDico
   */
  explicit IoDico(const std::string& name);

  /**
   * @brief returns the message description associated to the key
   *
   * @param msgId id/key of the message to return
   *
   * @return message description of the message
   */
  std::string msg(const std::string& msgId);


  /**
   * @brief iteration over the key/msg map
   *
   * @return the begin iterator of the dictionary
   */
  std::map<std::string, std::string>::const_iterator begin() const;

  /**
   * @brief iteration over the key/msg map
   *
   * @return the end iterator of the dictionary
   */
  std::map<std::string, std::string>::const_iterator end() const;

  /**
   * @brief reads a file and extracts all pairs of <key,message description>
   *
   * @param fileName  the full path name of the file to read
   */
  void readFile(const std::string& fileName);

 private:
  std::map<std::string, std::string> map_;  ///< map association between key and message description
  std::string name_;  ///< name of the dictionary
};

/**
 * @class IoDicos
 * @brief IoDicos class description. IoDicos read all the dictionary
 * and give an access to a dictionary thanks to his name
 */
class IoDicos : public boost::noncopyable {
 public:
  /**
   * @brief add a dictionary to the IoDicos instance
   *
   * @param name name of the dictionary
   * @param baseName base name of the file to read to create the dictionary
   * @param locale locale of the dictionary
   *
   * @note the full name of the file is: @b basename+"_"+locale+".dic"
   */
  void addDico(const std::string& name, const std::string& baseName, const std::string& locale = "en_GB");

  /**
   * @brief add a list of dictionaries to the IoDicos instance
   *
   * @param dictionariesMappingFile name of the dictionaries mapping file (format baseName = name)
   * @param locale locale of the dictionary
   */
  void addDicos(const std::string& dictionariesMappingFile, const std::string& locale = "en_GB");

  /**
   * @brief try to find a dictionary with the name @b dicoName
   *
   * @param dicoName name of the dictionary to return
   *
   * @return return the dictionary with the desired name
   */
  static std::shared_ptr<IoDico> getIoDico(const std::string& dicoName);

  /**
   * @brief try to find a opposite event dictionary with the name @b dicoName
   *
   * @param dicoName name of the dictionary to return
   *
   * @return return the opposite event dictionary with the desired name
   */
  static std::shared_ptr<OppositeEventDico> getOppositeEventsDico(const std::string& dicoName);

  /**
   * @brief check if a dictionary exist thanks to its name
   * @param dicoName name of the dictionary to find
   * @return @b true if the dictionary exists, @b false else
   */
  static bool hasIoDico(const std::string& dicoName);

  /**
   * @brief check if a opposite event dictionary exist thanks to its name
   * @param dicoName name of the dictionary to find
   * @return @b true if the opposite event dictionary exists, @b false else
   */
  static bool hasOppositeEventsDico(const std::string& dicoName);

  /**
   * @brief Initialize the IoDicos single instance if there is no instance, otherwise return the instance
   *
   * @return the IoDicos instance created
   */
  static IoDicos& instance();

  /**
   * @brief add path to the paths where dictionaries are researched
   *
   * @param path path to add
   */
  void addPath(const std::string& path);

  /**
   * @brief merge all the opposite dictionaries into a single ddb
   *
   * @return associations between an event key and a set of keys that are opposed to it
   */
  std::unordered_map<std::string, std::unordered_set<std::string>> mergeOppositeEventsDicos() const;

 private:
  /**
   * @brief default constructor
   */
  IoDicos() { }

  /**
   * @brief find the @b fileName in all the paths
   *
   * @param fileName name of the file to find
   *
   * @return the set of all full path of all files with name found, @b empty vector if the filename is not found
   */
  std::vector<std::string> findFiles(const std::string& fileName);

 private:
  std::vector<std::string> paths_;  ///< path where dictionnaries are researched
  std::map<std::string, std::shared_ptr<IoDico> > dicos_;  ///< map association between dictionary and their name
  std::map<std::string, std::shared_ptr<OppositeEventDico> > oppositeEventsDicos_;  ///< map association between dictionary and their name
};

}  // namespace DYN
#endif  // COMMON_DYNIODICO_H_
